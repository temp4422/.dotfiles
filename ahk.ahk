#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;*** MY CODE ***
;******************************************************************************
; Terminal Ctrl+Backspace match title
; RegEx or digits: 1 - title must start with the specified WinTitle, 2 - title can contain WinTitle anywhere inside it, 3 - title must exactly match WinTitle.
SetTitleMatchMode 2


; RUN AS ADMIN
;******************************************************************************
full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
;******************************************************************************


; BRIGHTNESS
;******************************************************************************
class BrightnessSetter {
  ; qwerty12 - 27/05/17
  ; https://github.com/qwerty12/AutoHotkeyScripts/tree/master/LaptopBrightnessSetter
  static _WM_POWERBROADCAST := 0x218, _osdHwnd := 0, hPowrprofMod := DllCall("LoadLibrary", "Str", "powrprof.dll", "Ptr")
  __New() {
    if (BrightnessSetter.IsOnAc(AC))
      this._AC := AC
    if ((this.pwrAcNotifyHandle := DllCall("RegisterPowerSettingNotification", "Ptr", A_ScriptHwnd, "Ptr", BrightnessSetter._GUID_ACDC_POWER_SOURCE(), "UInt", DEVICE_NOTIFY_WINDOW_HANDLE := 0x00000000, "Ptr"))) ; Sadly the callback passed to *PowerSettingRegister*Notification runs on a new threadl
      OnMessage(this._WM_POWERBROADCAST, ((this.pwrBroadcastFunc := ObjBindMethod(this, "_On_WM_POWERBROADCAST"))))
  }
  __Delete() {
    if (this.pwrAcNotifyHandle) {
      OnMessage(BrightnessSetter._WM_POWERBROADCAST, this.pwrBroadcastFunc, 0)
      ,DllCall("UnregisterPowerSettingNotification", "Ptr", this.pwrAcNotifyHandle)
      ,this.pwrAcNotifyHandle := 0
      ,this.pwrBroadcastFunc := ""
    }
  }
  SetBrightness(increment, jump := False, showOSD := True, autoDcOrAc := -1, ptrAnotherScheme := 0)
  {
    static PowerGetActiveScheme := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerGetActiveScheme", "Ptr")
        ,PowerSetActiveScheme := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerSetActiveScheme", "Ptr")
        ,PowerWriteACValueIndex := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerWriteACValueIndex", "Ptr")
        ,PowerWriteDCValueIndex := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerWriteDCValueIndex", "Ptr")
        ,PowerApplySettingChanges := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerApplySettingChanges", "Ptr")
    if (increment == 0 && !jump) {
      if (showOSD)
        BrightnessSetter._ShowBrightnessOSD()
      return
    }
    if (!ptrAnotherScheme ? DllCall(PowerGetActiveScheme, "Ptr", 0, "Ptr*", currSchemeGuid, "UInt") == 0 : DllCall("powrprof\PowerDuplicateScheme", "Ptr", 0, "Ptr", ptrAnotherScheme, "Ptr*", currSchemeGuid, "UInt") == 0) {
      if (autoDcOrAc == -1) {
        if (this != BrightnessSetter) {
          AC := this._AC
        } else {
          if (!BrightnessSetter.IsOnAc(AC)) {
            DllCall("LocalFree", "Ptr", currSchemeGuid, "Ptr")
            return
          }
        }
      } else {
        AC := !!autoDcOrAc
      }
      currBrightness := 0
      if (jump || BrightnessSetter._GetCurrentBrightness(currSchemeGuid, AC, currBrightness)) {
         maxBrightness := BrightnessSetter.GetMaxBrightness()
        ,minBrightness := BrightnessSetter.GetMinBrightness()
        if (jump || !((currBrightness == maxBrightness && increment > 0) || (currBrightness == minBrightness && increment < minBrightness))) {
          if (currBrightness + increment > maxBrightness)
            increment := maxBrightness
          else if (currBrightness + increment < minBrightness)
            increment := minBrightness
          else
            increment += currBrightness
          if (DllCall(AC ? PowerWriteACValueIndex : PowerWriteDCValueIndex, "Ptr", 0, "Ptr", currSchemeGuid, "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt", increment, "UInt") == 0) {
            ; PowerApplySettingChanges is undocumented and exists only in Windows 8+. Since both the Power control panel and the brightness slider use this, we'll do the same, but fallback to PowerSetActiveScheme if on Windows 7 or something
            if (!PowerApplySettingChanges || DllCall(PowerApplySettingChanges, "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt") != 0)
              DllCall(PowerSetActiveScheme, "Ptr", 0, "Ptr", currSchemeGuid, "UInt")
          }
        }
        if (showOSD)
          BrightnessSetter._ShowBrightnessOSD()
      }
      DllCall("LocalFree", "Ptr", currSchemeGuid, "Ptr")
    }
  }
  IsOnAc(ByRef acStatus)
  {
    static SystemPowerStatus
    if (!VarSetCapacity(SystemPowerStatus))
      VarSetCapacity(SystemPowerStatus, 12)
    if (DllCall("GetSystemPowerStatus", "Ptr", &SystemPowerStatus)) {
      acStatus := NumGet(SystemPowerStatus, 0, "UChar") == 1
      return True
    }
    return False
  }
  GetDefaultBrightnessIncrement()
  {
    static ret := 10
    DllCall("powrprof\PowerReadValueIncrement", "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt*", ret, "UInt")
    return ret
  }
  GetMinBrightness()
  {
    static ret := -1
    if (ret == -1)
      if (DllCall("powrprof\PowerReadValueMin", "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt*", ret, "UInt"))
        ret := 0
    return ret
  }
  GetMaxBrightness()
  {
    static ret := -1
    if (ret == -1)
      if (DllCall("powrprof\PowerReadValueMax", "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt*", ret, "UInt"))
        ret := 100
    return ret
  }
  _GetCurrentBrightness(schemeGuid, AC, ByRef currBrightness)
  {
    static PowerReadACValueIndex := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerReadACValueIndex", "Ptr")
        ,PowerReadDCValueIndex := DllCall("GetProcAddress", "Ptr", BrightnessSetter.hPowrprofMod, "AStr", "PowerReadDCValueIndex", "Ptr")
    return DllCall(AC ? PowerReadACValueIndex : PowerReadDCValueIndex, "Ptr", 0, "Ptr", schemeGuid, "Ptr", BrightnessSetter._GUID_VIDEO_SUBGROUP(), "Ptr", BrightnessSetter._GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS(), "UInt*", currBrightness, "UInt") == 0
  }
  _ShowBrightnessOSD()
  {
    static PostMessagePtr := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr"), "AStr", A_IsUnicode ? "PostMessageW" : "PostMessageA", "Ptr")
        ,WM_SHELLHOOK := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK", "UInt")
    if A_OSVersion in WIN_VISTA,WIN_7
      return
    BrightnessSetter._RealiseOSDWindowIfNeeded()
    ; Thanks to YashMaster @ https://github.com/YashMaster/Tweaky/blob/master/Tweaky/BrightnessHandler.h for realising this could be done:
    if (BrightnessSetter._osdHwnd)
      DllCall(PostMessagePtr, "Ptr", BrightnessSetter._osdHwnd, "UInt", WM_SHELLHOOK, "Ptr", 0x37, "Ptr", 0)
  }
  _RealiseOSDWindowIfNeeded()
  {
    static IsWindow := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr"), "AStr", "IsWindow", "Ptr")
    if (!DllCall(IsWindow, "Ptr", BrightnessSetter._osdHwnd) && !BrightnessSetter._FindAndSetOSDWindow()) {
      BrightnessSetter._osdHwnd := 0
      try if ((shellProvider := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}"))) {
        try if ((flyoutDisp := ComObjQuery(shellProvider, "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}", "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}"))) {
           DllCall(NumGet(NumGet(flyoutDisp+0)+3*A_PtrSize), "Ptr", flyoutDisp, "Int", 0, "UInt", 0)
          ,ObjRelease(flyoutDisp)
        }
        ObjRelease(shellProvider)
        if (BrightnessSetter._FindAndSetOSDWindow())
          return
      }
      ; who knows if the SID & IID above will work for future versions of Windows 10 (or Windows 8). Fall back to this if needs must
      Loop 2 {
        SendEvent {Volume_Mute 2}
        if (BrightnessSetter._FindAndSetOSDWindow())
          return
        Sleep 100
      }
    }
  }
  _FindAndSetOSDWindow()
  {
    static FindWindow := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr"), "AStr", A_IsUnicode ? "FindWindowW" : "FindWindowA", "Ptr")
    return !!((BrightnessSetter._osdHwnd := DllCall(FindWindow, "Str", "NativeHWNDHost", "Str", "", "Ptr")))
  }
  _On_WM_POWERBROADCAST(wParam, lParam)
  {
    ;OutputDebug % &this
    if (wParam == 0x8013 && lParam && NumGet(lParam+0, 0, "UInt") == NumGet(BrightnessSetter._GUID_ACDC_POWER_SOURCE()+0, 0, "UInt")) { ; PBT_POWERSETTINGCHANGE and a lazy comparison
      this._AC := NumGet(lParam+0, 20, "UChar") == 0
      return True
    }
  }
  _GUID_VIDEO_SUBGROUP()
  {
    static GUID_VIDEO_SUBGROUP__
    if (!VarSetCapacity(GUID_VIDEO_SUBGROUP__)) {
       VarSetCapacity(GUID_VIDEO_SUBGROUP__, 16)
      ,NumPut(0x7516B95F, GUID_VIDEO_SUBGROUP__, 0, "UInt"), NumPut(0x4464F776, GUID_VIDEO_SUBGROUP__, 4, "UInt")
      ,NumPut(0x1606538C, GUID_VIDEO_SUBGROUP__, 8, "UInt"), NumPut(0x99CC407F, GUID_VIDEO_SUBGROUP__, 12, "UInt")
    }
    return &GUID_VIDEO_SUBGROUP__
  }
  _GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS()
  {
    static GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__
    if (!VarSetCapacity(GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__)) {
       VarSetCapacity(GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__, 16)
      ,NumPut(0xADED5E82, GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__, 0, "UInt"), NumPut(0x4619B909, GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__, 4, "UInt")
      ,NumPut(0xD7F54999, GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__, 8, "UInt"), NumPut(0xCB0BAC1D, GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__, 12, "UInt")
    }
    return &GUID_DEVICE_POWER_POLICY_VIDEO_BRIGHTNESS__
  }
  _GUID_ACDC_POWER_SOURCE()
  {
    static GUID_ACDC_POWER_SOURCE_
    if (!VarSetCapacity(GUID_ACDC_POWER_SOURCE_)) {
       VarSetCapacity(GUID_ACDC_POWER_SOURCE_, 16)
      ,NumPut(0x5D3E9A59, GUID_ACDC_POWER_SOURCE_, 0, "UInt"), NumPut(0x4B00E9D5, GUID_ACDC_POWER_SOURCE_, 4, "UInt")
      ,NumPut(0x34FFBDA6, GUID_ACDC_POWER_SOURCE_, 8, "UInt"), NumPut(0x486551FF, GUID_ACDC_POWER_SOURCE_, 12, "UInt")
    }
    return &GUID_ACDC_POWER_SOURCE_
  }
}
BrightnessSetter_new() {
  return new BrightnessSetter()
}
BS := new BrightnessSetter()


; Brightness
!F1::
SC163 & 7::BS.SetBrightness(-10)
!F2::
SC163 & 8::BS.SetBrightness(10)

;******************************************************************************

; Volume
^F1::
SC163 & 9::Volume_Down
^F2::
SC163 & 0::Volume_Up








; JKL; + Ctrl, Shift, Alt, Win
;*** Remap arrow keys onto JKLI whenever holding down a certain modifier key
;******************************************************************************
MoveCursor(key) {
  control := GetKeyState("CONTROL","P")
  shift := GetKeyState("SHIFT","P")
  alt := GetKeyState("ALT","P")
  win := GetKeyState("LWIN","P")
  ctrlShift := control && shift
  ctrlAlt := control && alt
  altShift := alt && shift
  ctrlAltShift := control && alt && shift
  if ctrlAltShift {
    Send, ^!+%key%
  } else if altShift {
    Send, !+%key%
  } else if ctrlShift {
    Send, ^+%key%
  } else if ctrlAlt {
    Send, ^!%key%
  } else if control {
    Send, ^%key%
  } else if shift {
    Send, +%key%
  } else if alt {
    Send, !%key%
  } else if win {
    Send, #%key%
  } else {
    Send, %key%
  }
}
SC163 & j::MoveCursor("{LEFT}")
SC163 & k::MoveCursor("{DOWN}")
SC163 & l::MoveCursor("{UP}")
SC163 & `;::MoveCursor("{RIGHT}")
SC163 & m::MoveCursor("{HOME}")
SC163 & ,::MoveCursor("{PGDN}")
SC163 & .::MoveCursor("{PGUP}")
SC163 & /::MoveCursor("{END}")
SC163 & BS::MoveCursor("{DEL}")
;******************************************************************************


; Taskbar
Space & 1::#1
Space & 2::#2
Space & 3::#3
Space & 4::#4
Space & 5::#5
Space & 6::#6

; Ctrl+Tab to Alt+Tab
LCtrl & Tab::AltTab
; Ctrl+Esc to Ctrl+Tab
LCtrl & Esc::Send, {Ctrl Down}{Tab}{Ctrl Up}
; Context menu Shift+F10 / AppsKey
SC163 & Enter::AppsKey
; Reload ahk
SC163 & CapsLock::reload

; Windows Search or PowerToys Run
; LCtrl & Space::Send, {LWin Down}{s}{LWin Up}
Space & c::Send, {LWin Down}{s}{LWin Up}
; Change language Alt+Space
!Space::Send, {LWin Down}{Space}{LWin Up}
; Close active window (Alt+F4)
+^w::Send {Alt down}{F4}{Alt up}
; Show Desktop Alt+D
!d::Send, {LWin Down}{d}{LWin Up}

; Maximize active window
SC163 & f::
WinGet MX, MinMax, A
  If MX
    WinRestore A
  Else WinMaximize A
Return


; Run Apps ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Windows Terminal wt.exe
;^`::
;Space & `::
Space & a::
if WinActive("ahk_exe WindowsTerminal.exe") {
  WinMinimize A
} else if WinExist("ahk_exe WindowsTerminal.exe") {
  WinActivate, ahk_exe WindowsTerminal.exe
} else {
  Run, "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.15.3466.0_x64__8wekyb3d8bbwe\wt.exe"
  Sleep, 750
  WinWait, ahk_exe WindowsTerminal.exe
  WinActivate, ahk_exe WindowsTerminal.exe
  ;WinMove, ahk_exe WindowsTerminal.exe,,-8,,,
}
Return
; Browser msedge.exe
Space & s::
if WinActive("ahk_exe msedge.exe") {
  WinMinimize A
} else if WinExist("ahk_exe msedge.exe") {
  WinActivate, ahk_exe msedge.exe
} else {
  Run, msedge.exe
  Sleep, 750
  WinWait, ahk_exe msedge.exe
  WinActivate, ahk_exe msedge.exe
  WinMove, ahk_exe msedge.exe,,-8,,,
}
Return
; CoDe sublime_text.exe
Space & d::
if WinActive("ahk_exe sublime_text.exe") {
  WinMinimize A
} else if WinExist("ahk_exe sublime_text.exe") {
  WinActivate, ahk_exe sublime_text.exe
} else {
  Run, sublime_text.exe
  Sleep, 750
  WinWait, ahk_exe sublime_text.exe
  WinActivate, ahk_exe sublime_text.exe
  WinMove, ahk_exe sublime_text.exe,,-8,,,
}
Return
; CoDe VSCode.exe
; Space & d::
; if WinActive("ahk_exe code.exe") {
;   WinMinimize A
; } else if WinExist("ahk_exe code.exe") {
;   WinActivate, ahk_exe code.exe
; } else {
;   Run, "C:\Users\user\AppData\Local\Programs\Microsoft VS Code\Code.exe"
;   Sleep, 750
;   WinWait, ahk_exe code.exe
;   WinActivate, ahk_exe code.exe
;   WinMove, ahk_exe code.exe,,-8,,,
; }
; Return
; Files Explorer.exe
Space & f::
if WinActive("ahk_class CabinetWClass") {
  WinMinimize A
} else if WinExist("ahk_class CabinetWClass") {
  WinActivate, ahk_class CabinetWClass
} else {
  Run, explorer.exe
  WinWait, ahk_class CabinetWClass
  ;WinMove, ahk_class CabinetWClass,,-8,0,976,1028
  WinActivate, ahk_class CabinetWClass
}
Return
; Notes RemNote.exe
Space & q::
if WinActive("ahk_exe RemNote.exe") {
  WinMinimize A
} else if WinExist("ahk_exe RemNote.exe") {
  WinActivate, ahk_exe RemNote.exe
} else {
  Run, "C:\Program Files\RemNote\RemNote.exe"
  Sleep, 750
  WinWait, ahk_exe RemNote.exe
  WinActivate, ahk_exe RemNote.exe
  WinMove, ahk_exe RemNote.exe,,-8,,,
}
Return
; Google Translate
Space & CapsLock::
SetTitleMatchMode 3
if WinActive("Google Translate") {
  WinMinimize A
} else if WinExist("Google Translate") {
  WinActivate, Google Translate
} else {
  Run, "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Google Translate.lnk"
  WinWait, Google Translate
  WinActivate, Google Translate
}
Return
; Calculator
;Space & n::
SC163 & n::
SetTitleMatchMode 3
if WinActive("Calculator") {
  WinMinimize A
} else if WinExist("Calculator") {
  WinActivate, Calculator
} else {
  Run, "C:\Windows\System32\calc.exe"
  WinWait, Calculator
  WinActivate, Calculator
}
Return
; Snip & Sketch
SC163 & s::
  Run, ms-screensketch:
  WinWait, ahk_exe ApplicationFrameHost.exe
  WinActivate, ahk_exe ApplicationFrameHost.exe
  if WinActive("ahk_exe ApplicationFrameHost.exe") {
    Send, {Ctrl Down}{n}{Ctrl Up}
  } else {
    Return
  }
Return


; VSCode console.log()
;SC163 & u::Send, {Shift Down}{Alt Down}{Left}{Alt Up}{Shift Up}
SC163 & i::Send, {Ctrl Down}{Shift Down}{Alt Down}{i}{Alt Up}{Shift Up}{Ctrl Up}
SC163 & o::Send, {Ctrl Down}{Shift Down}{Alt Down}{o}{Alt Up}{Shift Up}{Ctrl Up}
;SC163 & p::Send, {Shift Down}{Alt Down}{Right}{Alt Up}{Shift Up}

; VSCode smart select
SC163 & h::Send, {Alt Down}{Left}{Alt Up}
SC163 & '::Send, {Alt Down}{Right}{Alt Up}

; Fold/Unfold, Send different keys with single key RemNote, Obsidian, VSCode
variable1 = 0 ; Set variable
SC163 & Space::
;Ctrl & s::
If (variable1 == 1){
; Fold/Collapse
if WinActive("ahk_exe RemNote.exe") {
  ; RemNote collapse descendants of children
  if GetKeyState("Shift"){
    Send, {Ctrl Down}{Shift Down}{p}{Shift Up}{Ctrl Up}
    Sleep, 200
    Send, coll
    Sleep, 600
    Send, {Enter}
    Return
  }
}
Send, {Ctrl Down}{Shift Down}{[}{Shift Up}{Ctrl Up}
variable1 = 2
Return
} else if (variable1 == 2){
  ; Special for Obsidian "toggle fold"
  if WinActive("ahk_exe Obsidian.exe") {
    Send, {Ctrl Down}{Shift Down}{[}{Shift Up}{Ctrl Up}
  }
  ; Unfold/Expand
  Send, {Ctrl Down}{Shift Down}{]}{Shift Up}{Ctrl Up}
  variable1 = 1
  Return
} else {
  ; Initiate variable
  variable1 = 1
  Return
}
Return
; Use shift+space
; shiftSpaceSuper(key) {
;   shift := GetKeyState("SHIFT","P")
;   if shift {
;     Send, {Ctrl Down}{Shift Down}{up}{Shift Up}{Ctrl Up}
;   } else {
;     Send, {Ctrl Down}{Shift Down}{down}{Shift Up}{Ctrl Up}
;     Return
;   }
; }
; SC163 & Space::shiftSpaceSuper("{Space}")
; Return

;File Explorer
; shiftSpace(key) {
;   shift := GetKeyState("SHIFT","P")
;   if shift {
;     ; If ctrl+shift+space open new File Explorer or toggle existing
;     if WinActive("ahk_class CabinetWClass") {
;       WinMinimize A
;     } else if WinExist("ahk_class CabinetWClass") {
;       WinActivate, ahk_class CabinetWClass
;     } else {
;       Run, explorer.exe
;       WinWait, ahk_class CabinetWClass
;       ;WinMove, ahk_class CabinetWClass,,-8,0,976,1028
;       WinActivate, ahk_class CabinetWClass
;     }
;     Return
;     ; +!e::
;     ;   Run, explorer.exe
;     ;   WinWait, ahk_class CabinetWClass
;     ;   WinMove, ahk_class CabinetWClass,,952,0,976,1038
;     ;   WinActivate, ahk_class CabinetWClass
;     ; Return
;   } else {
;     ; If ctrl+space open Windows Search
;     Send, {LWin Down}{s}{LWin Up}
;     Return
;   }
; }
; LCtrl & Space::shiftSpace("{Space}")
;Return
; Send space alone, need to work with other space shortcuts
Space:: Send {Space}
;******************************************************************************


; Sublime open recent files
#if WinActive("ahk_exe sublime_text.exe")
^r::Send, {Alt Down}{f}{Alt Up}{r}
Return

; Microsoft Edge or Google Chrome: Search Tab
#if (WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe chrome.exe"))
+^f::Send, {Ctrl Down}{Shift Down}{a}{Shift Up}{Ctrl Up}
SC163 & i::Send, {f7}
Return

; Fman switch panes
#if WinActive("ahk_exe fman.exe")
LCtrl & Esc::Send, {Tab}
Return

; RemNote shortcuts (browser like)
variable2 = 0 ; Set variable
#if WinActive("ahk_exe RemNote.exe")
; Switch panes with ctrl+esc
LCtrl & Esc::
If (variable2 == 1){
  Send, {Ctrl Down}{Shift Down}{t}{Shift Up}{Ctrl Up}
  variable2 = 2
} else if (variable2 == 2){
  Send, {Alt Down}{Shift Down}{t}{Shift Up}{Alt Up}
  variable2 = 1
} else {
  variable2 = 1
}
Return
; Navigate to sibling above/below
; modKey1(key) {
;   control := GetKeyState("CONTROL","P")
; if control {
;   Send, {Ctrl Down}{l}{Ctrl Up}
; } else {
;   Send, %key%
; }}
; SC163 & l::modKey1("{Up}")
; modKey2(key) {
;   control := GetKeyState("CONTROL","P")
; if control {
;   Send, {Ctrl Down}{k}{Ctrl Up}
; } else {
;   Send, %key%
; }}
; SC163 & k::modKey2("{Down}")
;Zoom into rem
^Enter::Send, {Ctrl Down}{`;}{Ctrl Up}
+^Enter::Send, {Ctrl Down}{Shift Down}{:}{Shift Up}{Ctrl Up}
; ;Add child without splitting text
; ^Enter::Send, {Alt Down}{Enter}{Alt Up}
; ;Zoom out of rem
; LAlt & BackSpace::Send, {Ctrl Down}{j}{Ctrl Up}
Return


;;;;;; INFO ;;;;;;
;This symbol "`" is used for escaping in AHK, for example `n is a new line character. You can escape it with itself (``) to display the symbol.
;Add simple mappings like "SC163 & n::Send, {..}" above "#if WinActive()", because it breaks code.