#Requires AutoHotkey v2.0

; Hotkey: Windows + W (#w)
#w::
{
    ; Get the handle (ID) of the currently active window
    activeHWnd := WinExist("A")
    
    if (activeHWnd) 
    {
        try 
        {
            ; Attempt to close the window
            WinClose("ahk_id " activeHWnd)
        }
        catch 
        {
            ; If the window is Admin and the script is not, 
            ; it will fail silently without an error message.
            return
        }
    }
}