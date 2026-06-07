# AutoHotkey v2 DeepSeek Translator / AHK v2 DeepSeek 智能翻译工具

[Simplified Chinese](#simplified-chinese) | [English](#english)

---

## Simplified Chinese

这是一个基于 **AutoHotkey v2** 编写的轻量级桌面翻译脚本。它直接调用 **DeepSeek API**，为你提供快速、精准的文本翻译体验，并支持直接替换或弹窗显示。

### 核心功能
*   **中译英 (Alt + T)**：选中任意网页或文档中的中文，按下 `Alt + T`，脚本会自动将选中文本替换为翻译后的英文。
*   **英译中 (Alt + E)**：选中英文，按下 `Alt + E`，会弹出一个独立的置顶文本框显示中文翻译。该文本框**完全支持鼠标选中、高亮和复制 (Ctrl+C)**，绝不破坏你原有的选中文本。
*   **完美防乱码**：内置标准的二进制转 UTF-8 编码函数，彻底解决网络请求中常见的中文乱码和特殊符号丢失问题。

### 使用方法
1.  确保电脑已安装 [AutoHotkey v2](https://autohotkey.com)。
2.  如果没有安装的话，本仓库已上传该软件的windows版本，可供下载。
3.  下载或复制本仓库中的 `Translation_002.ahk` 文件。
4.  用文本编辑器（如 Notepad++、VS Code）打开文件，在顶部的 `global API_KEY := "*********************"` 处，将星号替换为你自己的 **DeepSeek API Key**。
5.  https://platform.deepseek.com/sign_in  可在该网页 申请 **DeepSeek API Key**
6.  双击运行脚本，即可在全系统通过快捷键随时翻译。

---

## English

A lightweight desktop translation script powered by **AutoHotkey v2** and the **DeepSeek API**. It provides fast, context-aware, and highly accurate translations with options to either replace text instantly or view it in a convenient pop-up window.

### Key Features
*   **Chinese to English (Alt + T)**: Select any Chinese text, press `Alt + T`, and the script will instantly overwrite the selection with its English translation.
*   **English to Chinese (Alt + E)**: Select any English text and press `Alt + E`. A dedicated, always-on-top window will display the Chinese translation. The text in this window is **fully selectable, highlightable, and copyable (Ctrl+C)**, ensuring your original text remains untouched.
*   **No Text Corruption**: Includes built-in binary-to-UTF-8 stream decoding to completely fix text corruption and character encoding issues commonly found in raw HTTP API responses.

### How to Use
1.  Make sure [AutoHotkey v2](https://autohotkey.com) is installed on your Windows system.
2.  Download or copy the `Translation_001.ahk` file from this repository.
3.  Open the file with a text editor (e.g., Notepad++, VS Code), locate `global API_KEY := "*********************"` at the top, and replace the asterisks with your actual **DeepSeek API Key**.
4.  Double-click the script to run it. You can now use the hotkeys anywhere across your system.
