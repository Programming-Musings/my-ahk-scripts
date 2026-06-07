#Requires AutoHotkey v2.0
#SingleInstance Force

; === 自定义配置区 (Custom Configuration Zone) ===
global API_KEY := "*******************************"  ; 请在此处替换为您的实际 API Key
global ALT_T_TARGET_LANG := "English"                ; Alt+T 的目标语言 (Target language for Alt+T)
global ALT_E_TARGET_LANG := "Chinese"                ; Alt+E 的目标语言 (Target language for Alt+E)
; ================================================

; 热键 1：Alt + T 中译英，直接替换文本 (Hotkey 1: Alt + T for Ch-to-En, directly replaces text)
!t::
{
    TranslateSelectedText(ALT_T_TARGET_LANG, true)
}

; 热键 2：Alt + E 英译中，不替换原内容，弹窗展示并允许选中复制 (Hotkey 2: Alt + E for En-to-Ch, shows selectable text)
!e::
{
    TranslateSelectedText(ALT_E_TARGET_LANG, false)
}

; 核心翻译函数 (Core Translation Function)
TranslateSelectedText(targetLanguage, shouldReplace := true)
{
    ; 1. 备份并清空剪贴板 (Backup and clear clipboard)
    originalClipboard := ClipboardAll()
    A_Clipboard := "" 
    
    ; 2. 复制选中的文本 (Copy selected text)
    Send "^c" 
    if !ClipWait(1) {
        A_Clipboard := originalClipboard
        return
    }

    sourceText := Trim(A_Clipboard)
    if (sourceText == "") {
        A_Clipboard := originalClipboard
        return
    }

    ; 3. 构建 DeepSeek API 请求 (Construct DeepSeek API request)
    url := "https://api.deepseek.com/chat/completions"
    
    ; 转义文本中的特殊字符以匹配 JSON 格式 (Escape special characters for JSON format)
    escapedText := StrReplace(sourceText, "\", "\\")
    escapedText := StrReplace(escapedText, "`n", "\n")
    escapedText := StrReplace(escapedText, "`r", "\r")
    escapedText := StrReplace(escapedText, '"', '\"')
    escapedText := StrReplace(escapedText, "`t", "\t")

    ; 创建 JSON 载荷 (Create JSON payload)
    jsonPayload := '{'
        . '"model": "deepseek-chat",'
        . '"messages": ['
            . '{"role": "system", "content": "You are a professional translator. Translate the user text directly into ' targetLanguage '. Do not include any explanations, greetings, or extra words. Preserve the paragraph layout and symbols."},'
            . '{"role": "user", "content": "' escapedText '"}'
        . '],'
        . '"temperature": 0.3'
        . '}'

    ; 4. 发送 HTTP POST 请求 (Send HTTP POST request)
    whr := ComObject("WinHttp.WinHttpRequest.5.1")
    try {
        whr.Open("POST", url, true)
        whr.SetRequestHeader("Content-Type", "application/json")
        whr.SetRequestHeader("Authorization", "Bearer " . API_KEY)
        whr.Send(jsonPayload)
        whr.WaitForResponse()
        
        ; 读取原始二进制数据并手动转换为标准的 UTF-8 字符串
        response := GetUtf8String(whr.ResponseBody)
        
        ; 5. 解析 JSON 响应获取结果 (Parse JSON response to get the result)
        translatedText := ExtractContentFromJson(response)
        
        if (translatedText != "") {
            if (shouldReplace) {
                ; 中译英模式：将翻译结果粘贴覆盖原选中文本
                A_Clipboard := translatedText
                Sleep 100
                Send "^v"
                Sleep 300
            } else {
                ; 英译中模式：调用自定义可选中/复制的弹窗
                ShowSelectableResult(translatedText)
            }
        } else {
            MsgBox("翻译失败，请检查 API 返回。`n返回内容: " . response, "错误")
        }
    } catch Error as err {
        MsgBox("网络请求出错: " . err.Message, "错误")
    }

    ; 6. 恢复原始剪贴板数据 (Restore original clipboard data)
    Sleep 100
    A_Clipboard := originalClipboard
}

; 自定义弹窗函数：让翻译结果可以被鼠标自由选中和复制
ShowSelectableResult(text) {
    myGui := Gui("+AlwaysOnTop", "DeepSeek 英译中结果") ; 让窗口总在最前，方便查看
    myGui.SetFont("s11", "Microsoft YaHei")           ; 设置舒服的字体和字号
    
    ; 添加一个多行编辑框（Edit），它是天然支持鼠标选中、高亮和 Ctrl+C 复制的
    myGui.Add("Edit", "w500 h250 ReadOnly", text) 
    
    myGui.Show()
}

; 完善的正则提取函数 (Perfected Regex Extraction Function)
ExtractContentFromJson(jsonStr) {
    if RegExMatch(jsonStr, '"content"\s*:\s*"(.*?)"(?=\s*(,|\s*\}))', &match) {
        unescaped := match[1]
        ; 还原 JSON 里的转义字符 (Restore escaped characters from JSON)
        unescaped := StrReplace(unescaped, "\n", "`n")
        unescaped := StrReplace(unescaped, "\r", "`r")
        unescaped := StrReplace(unescaped, '\"', '"')
        unescaped := StrReplace(unescaped, "\\", "\")
        unescaped := StrReplace(unescaped, "\t", "`t")
        return unescaped
    }
    return ""
}

; 二进制流转换为 UTF-8 字符串的必备核心函数
GetUtf8String(responseBody) {
    try {
        adoStream := ComObject("ADODB.Stream")
        adoStream.Type := 1  ; adTypeBinary
        adoStream.Open()
        adoStream.Write(responseBody)
        adoStream.Position := 0
        adoStream.Type := 2  ; adTypeText
        adoStream.Charset := "utf-8"
        textResult := adoStream.ReadText()
        adoStream.Close()
        return textResult
    } catch {
        return ""
    }
}
