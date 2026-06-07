#Requires AutoHotkey v2.0

!g::
{
    ; === 自定义配置区 ===
    myColor := " "       ; 在这里修改颜色！(例如: "red", "blue", "#2c3e50" 等)
    myFontSize := "20px"      ; 字体大小
    myLineHeight := "1.8"     ; 行高
    ; ===================

    A_Clipboard := "" 
    Send "^c" 
    
    if !ClipWait(1) {
        return
    }

    txt := A_Clipboard
    if (StrLen(txt) < 1)
        return

    ; 将 color: " . myColor . "; 加入到样式字符串中
    style := "style='font-family: `"方正楷体`", `"KaiTi`"; color: " . myColor . "; font-size: " . myFontSize . "; line-height: " . myLineHeight . "; text-indent: 2em; text-align: justify; margin-bottom: 10px;'"
    
    finalHTML := "<div style='margin: 0 auto; max-width: 85%;'>`n" 
    
    Loop Parse, txt, "`n", "`r" 
    {
        trimmedLine := Trim(A_LoopField) 
        if (trimmedLine != "") 
        {
            finalHTML .= "    <div " . style . ">" . trimmedLine . "</div>`n"
        }
    }
    
    finalHTML .= "</div>"
    
    A_Clipboard := finalHTML
    Sleep 500
    Send "^v"
    Sleep 500
}
