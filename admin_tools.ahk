#Requires AutoHotkey v2.0
#SingleInstance Force

; Restarts the script with Administrative privileges if not already elevated
if !A_IsAdmin
{
    try
    {
        Run('*RunAs "' . A_AhkPath . '" /restart "' . A_ScriptFullPath . '"')
    }
    ExitApp
}

#UseHook ; Forces the script to use the keyboard hook 
InstallKeybdHook() ; Ensures keys are caught even if focus is weird [cite: 4, 5]

; ==============================================================================
; ADMIN HOTKEYS
; ==============================================================================

; Win + W: Close Active Window (Now works for Task Manager, etc.) [cite: 4, 6]
#w:: {
    try {
        ; Use WinExist("A") to get the Active Window ID reliably 
        ActiveHWND := WinExist("A") 
        if ActiveHWND
            WinClose("ahk_id " ActiveHWND)
    } catch {
        return
    }
}

; ==============================================================================
; SCRIPT MANAGEMENT
; ==============================================================================

; Ctrl + Alt + Shift + R: Reload specifically the Admin script
^!+r::
{
    ToolTip("Reloading Admin Tools...")
    SetTimer () => ToolTip(), -1000
    Reload()

}
