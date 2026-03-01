#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; HOTKEYS
; ==============================================================================

; Win + B: Launch LibreWolf (New Window)
#b::
{
    Run('"C:\Program Files\LibreWolf\librewolf.exe" --new-window')
}

; Win + N: Launch Obsidian (All Users)
#n::
{
    Run("C:\Program Files\Obsidian\Obsidian.exe")
}

; Win + Enter: Launch WSL in Home Directory
#Enter::
{
    Run("wsl.exe ~")
}

; Win + M: Toggle Maximize/Restore Active Window
#m::
{
    ; Safety check: Don't mess with the Desktop or Taskbar
    activeClass := WinGetClass("A")
    if (activeClass == "WorkerW" or activeClass == "Progman" or activeClass == "Shell_TrayWnd")
        return

    ; Check the current window state
    ; 1 = Maximized, -1 = Minimized, 0 = Neither
    state := WinGetMinMax("A")

    if (state == 1) 
    {
        WinRestore("A")
    }
    else 
    {
        WinMaximize("A")
    }
}


; Win + F: Center the active floating window on the current monitor
#f::
{
    ; Safety check: Don't try to center the desktop 
    activeClass := WinGetClass("A")
    if (activeClass == "WorkerW" or activeClass == "Progman" or activeClass == "Shell_TrayWnd")
        return

    ; Get window ID 
    ActiveHWND := WinExist("A")
    if !ActiveHWND
        return

    ; Get window dimensions
    WinGetPos(&X, &Y, &W, &H, "ahk_id " . ActiveHWND)

    ; Get monitor info for the active window
    hMonitor := DllCall("MonitorFromWindow", "Ptr", ActiveHWND, "UInt", 0x2) ; 0x2 = MONITOR_DEFAULTTONEAREST
    
    NumPut("UInt", 40, (MonitorInfo := Buffer(40)))
    if DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", MonitorInfo)
    {
        ; Extract monitor coordinates (Working Area)
        ; This respects your Taskbar position
        monitorLeft   := NumGet(MonitorInfo, 20, "Int")
        monitorTop    := NumGet(MonitorInfo, 24, "Int")
        monitorRight  := NumGet(MonitorInfo, 28, "Int")
        monitorBottom := NumGet(MonitorInfo, 32, "Int")

        monitorWidth  := monitorRight - monitorLeft
        monitorHeight := monitorBottom - monitorTop

        ; Calculate center position
        newX := monitorLeft + (monitorWidth - W) / 2
        newY := monitorTop + (monitorHeight - H) / 2

        ; Move the window
        WinMove(newX, newY,,, "ahk_id " . ActiveHWND)
    }
}





; ==============================================================================
; SCRIPT MANAGEMENT
; ==============================================================================

; Ctrl + Alt + R: Reload this script
^!r::
{
    ToolTip("Reloading Master Script...")
    SetTimer () => ToolTip(), -1000
    Reload()
}  