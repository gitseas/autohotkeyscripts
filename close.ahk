#Requires AutoHotkey v2.0

; --- Admin Auto-Elevation ---
if !A_IsAdmin {
    try {
        Run('*RunAs "' A_ScriptFullPath '"')
    }
    ExitApp()
}

; Shortcut: Windows + W
#w::
{
    activeHwnd := WinExist("A")
    
    if (activeHwnd)
    {
        activePid := WinGetPID("ahk_id " activeHwnd)
        
        if IsProcessElevated(activePid)
        {
            WinClose("ahk_id " activeHwnd)
        }
    }
}

/**
 * Checks if a process is running with Administrator privileges
 */
IsProcessElevated(pid) {
    ; PROCESS_QUERY_LIMITED_INFORMATION = 0x1000
    hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", false, "UInt", pid, "UPtr")
    if !hProcess
        return false

    hToken := 0
    ; TOKEN_QUERY = 0x0008
    ; Use "Ptr*" to output the handle directly to hToken without the & operator
    if !DllCall("Advapi32\OpenProcessToken", "UPtr", hProcess, "UInt", 0x0008, "Ptr*", &hToken) {
        DllCall("CloseHandle", "UPtr", hProcess)
        return false
    }

    elevation := Buffer(4)
    size := Buffer(4)
    isElevated := false
    
    ; TokenElevation class = 20
    if DllCall("Advapi32\GetTokenInformation", "UPtr", hToken, "Int", 20, "Ptr", elevation, "UInt", 4, "Ptr", size) {
        isElevated := NumGet(elevation, 0, "Int")
    }

    DllCall("CloseHandle", "UPtr", hToken)
    DllCall("CloseHandle", "UPtr", hProcess)
    
    return isElevated != 0
}