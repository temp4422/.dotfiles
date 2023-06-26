#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;*** MY CODE ***
;******************************************************************************
; SetTitleMatchMode: 1 - title must start with the specified WinTitle, 2 - title can contain WinTitle anywhere inside it, 3 - title must exactly match WinTitle.
SetTitleMatchMode 2

; RUN AS ADMIN
;******************************************************************************
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")) {
  try {
    if A_IsCompiled
      Run *RunAs "%A_ScriptFullPath%" /restart
    else
      Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
  }
  ExitApp
}

; Brightness and Volume
;******************************************************************************
ChangeBrightness(ByRef brightness, timeout = 1) {
  if (brightness > 0 && brightness < 100) {
    For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
      property.WmiSetBrightness(timeout, brightness)
  } else if (brightness >= 100) {
    brightness := 100
  } else if (brightness <= 0) {
    brightness := 0
  }
}
GetCurrentBrightNess() {
  For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness")
    currentBrightness := property.CurrentBrightness
  return currentBrightness
}
CurrentBrightness := GetCurrentBrightNess()
!F1::ChangeBrightness(CurrentBrightness -= 9) ;decrease
!F2::ChangeBrightness(CurrentBrightness += 9) ;increase
^F1::Volume_Down
^F2::Volume_Up

; JKL; + Ctrl, Shift, Alt, Win
; Remap arrow keys onto JKL; whenever holding down a certain modifier key
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

; Ctrl+Tab to Alt+Tab
LCtrl & Tab::AltTab
; Ctrl+Esc to Ctrl+Tab
LCtrl & Esc::Send {Ctrl Down}{Tab}{Ctrl Up}
; Close active window (Alt+F4)
+^w::Send {Alt down}{F4}{Alt up}
; Show Desktop Shift+Alt+D (default Win+D)
$+!d::
  Sleep 200
  Send {LWin Down}{d}{LWin Up}
return
; Change language Alt+Space
!Space::Send {LWin Down}{Space}{LWin Up}
; Reload ahk
SC163 & f8::reload
; Context menu Shift+F10 / AppsKey
SC163 & Enter::AppsKey

; Taskbar
F19::
SC163 & 1::
  Send {LWin Down}{1}
  Sleep 200
  Send {LWin Up}
return
F20::
SC163 & 2::
  Send {LWin Down}{2}
  Sleep 200
  Send {LWin Up}
return
F21::
SC163 & 3::
  Send {LWin Down}{3}
  Sleep 200
  Send {LWin Up}
return
F23::
SC163 & 4::
  Send {LWin Down}{4}
  Sleep 200
  Send {LWin Up}
return
;F24::
SC163 & 5::
  Send {LWin Down}{5}
  Sleep 200
  Send {LWin Up}
return
SC163 & 6::
  Send {LWin Down}{6}
  Sleep 200
  Send {LWin Up}
return
F17::
!q::
SC163 & q::
  Send {LWin Down}{6} ; Quick Notes
  Sleep 200
  Send {LWin Up}
return
F13::
!a::
SC163 & a::
  Send {LWin Down}{7} ; Terminal
  Sleep 200
  Send {LWin Up}
return
F14::
!s::
SC163 & s::
  Send {LWin Down}{8} ; Browser Search
  Sleep 200
  Send {LWin Up}
return
F15::
!d::
SC163 & d::
  Send {LWin Down}{9} ; CoDe Editor
  Sleep 200
  Send {LWin Up}
return
F18::
!e::
SC163 & e::
  Send {LWin Down}{0} ; File Explorer
  Sleep 200
  Send {LWin Up}
return

; Listary (Windows Search/Run)
F16::
!f::
SC163 & f::Send {LCtrl Down}{f12}{LCtrl Up}
; Alias backward/forward
SC163 & h::Send {Alt Down}{Left}{Alt Up}
SC163 & '::Send {Alt Down}{Right}{Alt Up}
; VSCode console.log()
SC163 & i::Send {Ctrl Down}{Shift Down}{Alt Down}{i}{Alt Up}{Shift Up}{Ctrl Up}
SC163 & o::Send {Ctrl Down}{Shift Down}{Alt Down}{o}{Alt Up}{Shift Up}{Ctrl Up}
SC163 & `::Send {Ctrl Down}{Shift Down}{Alt Down}{``}{Alt Up}{Shift Up}{Ctrl Up}

; Google Translate
SC163 & u up::
  ;KeyWait, CapsLock
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
return
; Calculator
SC163 & n up::
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
return
; Snip & Sketch Screenshot
SC163 & y up::
Run, ms-screensketch:
  WinWait, ahk_exe ApplicationFrameHost.exe
  WinActivate, ahk_exe ApplicationFrameHost.exe
  if WinActive("ahk_exe ApplicationFrameHost.exe") {
    Send {Ctrl Down}{n}{Ctrl Up}
  } else {
    return
  }
return
; Maximize active window
; +!f::
; WinGet MX, MinMax, A
; if MX
;   WinRestore A
; else WinMaximize A
; return

; Fold/Unfold, Send different keys with single key RemNote, Obsidian, VSCode
variable1 = 0 ; Set variable
; SC163 & Space::
SC163 & \::
  ; Fold/Collapse
  if (variable1 == 1){
    Send {Ctrl Down}{Shift Down}{[}{Shift Up}{Ctrl Up}
    variable1 = 2
    return
  ; Unfold/Expand
  } else if (variable1 == 2){
    ; Special for Obsidian "toggle fold"
    if WinActive("ahk_exe Obsidian.exe") {
      Send {Ctrl Down}{Shift Down}{[}{Shift Up}{Ctrl Up}
    }
    Send {Ctrl Down}{Shift Down}{]}{Shift Up}{Ctrl Up}
    variable1 = 1
    return
  ; Initiate variable
  } else {
    variable1 = 1
    return
  }
return
;******************************************************************************


; #if WinActive("ahk_exe Listary.exe")
;   ^Enter::
;     Send +{Home}
;     Send ^{x}
;     Send g
;     Send {Space}
;     Send ^{v}
;     Sleep 300
;     Send {Enter}
;   return
;   +^Enter::
;     Send +{Home}
;     Send ^{x}
;     Send y
;     Send {Space}
;     Send ^{v}
;     Sleep 400
;     Send {Enter}
;   return
; #if

; Sublime open recent files
#if WinActive("ahk_exe sublime_text.exe")
  ^r::Send {Alt Down}{f}{Alt Up}{r}
#if

; Microsoft Edge or Google Chrome: Search Tab
#if (WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe chrome.exe"))
  +^f::Send {Ctrl Down}{Shift Down}{a}{Shift Up}{Ctrl Up}
  SC163 & i::Send {f7}
#if

; RemNote shortcuts (browser like)
variable2 = 0 ; Set variable
#if WinActive("ahk_exe RemNote.exe")
  ; Switch panes with ctrl+esc
  LCtrl & Esc::
  if (variable2 == 1){
    Send {Ctrl Down}{Shift Down}{t}{Shift Up}{Ctrl Up}
    variable2 = 2
  } else if (variable2 == 2){
    Send {Alt Down}{Shift Down}{t}{Shift Up}{Alt Up}
    variable2 = 1
  } else {
    variable2 = 1
  }
  return
  ; Zoom into rem
  ^Enter::Send {Ctrl Down}{`;}{Ctrl Up}
  ; Zoom into rem in new window
  +^Enter::Send {Ctrl Down}{Shift Down}{:}{Shift Up}{Ctrl Up}
#if


; Select world
;^d::Send {Ctrl Down}{Right}{Ctrl Up}{Ctrl Down}{Shift Down}{Left}{Shift UP}{Ctrl Up}
;#if WinActive("ahk_exe Code.exe")
;  ^d::Send {Ctrl Down}{D}{Ctrl Up}
;#if

; Info
;******************************************************************************
; This symbol "`" is used for escaping in AHK, for example `n is a new line character. You can escape it with itself (``) to display the symbol.
; Add simple mappings like "SC163 & n::Send {..}" above "#if WinActive()", because it breaks code.
; GetKeyState, state, space ; Check key state "D" = down, "U" = up, "P" = physical state, "T" = toggle

; SPACE KEY
;******************************************************************************
; Run Apps with Space key
; Goal: make reliable key combination to run apps faster without interruptions
; Task: Press "space+key" to open specific application
; Issue: While typing text, sometimes "space+key" is pressed accidentally and typing is being interrupted
; Ways to resolve:
; - use delay
; - use key combination blocking/suspend
; - send right sequence
; SOURCES:
; - https://www.autohotkey.com/boards/viewtopic.php?t=31113
; - https://www.autohotkey.com/boards/viewtopic.php?t=36437
; - KeyWait, Space, T0.1
; TODO: Send "space+key" without innterruption
; DOING: Send "space+key" only if "space" is down and "key" is up, no other keys should be able to be pressed in this combination otherwise they should interrupt combination
; RESULTS:
; if run with: "space+key up" (also require space:: send {space} to work) it causing small delays - what interrup typing.
; if run with: "#if GetKeyState("space", "P") key:: Send ..." delays are smaller, but still random interrupts occur, but "sapce + key up" must be in script to work properly.
; Current requirements to work with small interrupts:
; space::send {space}
; space + key up::send ...
; #if GetKeyState("space", "P") key::send ...
; Space up::Send {Space}
; Space::return
; Appropriate way to implement "sapce + key" functionality is through SpaceFN keyboard layout https://github.com/lydell/spacefn-win,
; TODO: CHECK $, ~, * functionality


; *** VARIANT ***
;Space & 1::#1
;Space & 2::#2
;Space & 3::#3
;Space & 4::#4
;Space & 5::#5
;Space & 6::#6
;Space & q::Send {LWin Down}{6}{LWin Up} ; Quick Notes
;Space & a::Send {LWin Down}{7}{LWin Up} ; Terminal
;Space & s::Send {LWin Down}{8}{LWin Up} ; Browser Search
;Space & d::Send {LWin Down}{9}{LWin Up} ; CoDe Editor
;Space & e::Send {LWin Down}{0}{LWin Up} ; File Explorer
;Space & f::Send {LCtrl Down}{f12}{LCtrl Up} ; File Explorer
;Space up::Send {Space}

; *** VARIANT ***
; Space up::Send {Space}
; #if GetKeyState("Space", "P")
;   1::#1
;   2::#2
;   3::#3
;   4::#4
;   5::#5
;   6::#6
;   q up::Send {LWin Down}{6}{LWin Up} ; Quick Notes
;   a up::Send {LWin Down}{7}{LWin Up} ; Terminal
;   s up::Send {LWin Down}{8}{LWin Up} ; Browser Search
;   d up::Send {LWin Down}{9}{LWin Up} ; CoDe Editor
;   e up::Send {LWin Down}{0}{LWin Up} ; File Explorer
;   f up::Send {LCtrl Down}{f12}{LCtrl Up} ; File Explorer
; return
; #if

; *** VARIANT ***
; variable3 = 0
; Space::
;   if (variable3 == 1){
;     Send {space}
;     variable3 = 2
;   } else if (variable3 == 2){
;     Send {Alt Down}{Shift Down}{t}{Shift Up}{Alt Up}
;     variable3 = 1
;   } else {
;     variable3 = 1
;   }
; return

; *** VARIANT ***
; Space up::Send {Space}
; ~a::
;   If (A_PriorKey = "Space")
;     Send {LWin Down}{7}{LWin Up} ; Terminal
; Return

; *** VARIANT ***
; Space::XB1:=True
; Space Up::XB1:=False
; #If XB1
; #if GetKeyState("Space", "")
;   ; Space up::Send {Space}
;   if (variable3 == 1){
;     Send {space}
;     variable3 = 2
;   } else if (variable3 == 2){
;     Send {Alt Down}{Shift Down}{t}{Shift Up}{Alt Up}
;     variable3 = 1
;   } else {
;     variable3 = 1
;   }
; return
; #if

; *** VARIANT ***
; Space up::Send {Space}
; $a::
; GetKeyState, state, Space
; if (state = "P")
;     Send {LWin Down}{7}{LWin Up} ; Terminal
; else
;     Send {a}
; return

; *** VARIANT ***
; $a::Send {a}
; Space::
; if GetKeyState("a", "P")
;   a::Send {LWin Down}{7}{LWin Up} ; Terminal
; return

; *** VARIANT ***
;SpaceFn https://github.com/OhYee/SpaceFn
;  #inputlevel,2
; $Space::
;     SetMouseDelay -1
;     Send {Blind}{F24 DownR}
;     KeyWait, Space
;     Send {Blind}{F24 up}
;     ; MsgBox, %A_ThisHotkey%-%A_TimeSinceThisHotkey%
;     ; if(A_ThisHotkey="$Space" and A_TimeSinceThisHotkey<300)
;     if(A_ThisHotkey="$Space")
;         Send {Blind}{Space DownR}
;     return
; #inputlevel,1
; F24 & i::Up
; F24 & k::Down
; F24 & j::Left
; F24 & l::Right
; F24 & u::Home
; F24 & o::End
; F24 & n::PgUp
; F24 & m::PgDn
; #inputlevel,2
; $Space::
;     SetMouseDelay -1
;     Send {Blind}{F24 DownR}
;     KeyWait, Space
;     Send {Blind}{F24 up}
;     ; MsgBox, %A_ThisHotkey%-%A_TimeSinceThisHotkey%
;     ; if(A_ThisHotkey="$Space" and A_TimeSinceThisHotkey<300)
;     if(A_ThisHotkey="$Space")
;         Send {Blind}{Space DownR}
;     return
; #inputlevel,1
; F24 & q::Send {LWin Down}{6}{LWin Up} ; Quick Notes
; F24 & a::Send {LWin Down}{7}{LWin Up} ; Terminal
; F24 & s::Send {LWin Down}{8}{LWin Up} ; Browser Search
; F24 & d::Send {LWin Down}{9}{LWin Up} ; CoDe Editor
; F24 & e::Send {LWin Down}{0}{LWin Up} ; File Explorer
; F24 & f::Send {LCtrl Down}{f12}{LCtrl Up} ; File Explorer
; return

; *** VARIANT ***
; spacefn-win mappings https://github.com/lydell/spacefn-win
; *a::dual.comboKey({F22: "F13"})
; *s::dual.comboKey({F22: "F14"})
; *d::dual.comboKey({F22: "F15"})
; *f::dual.comboKey({F22: "F16"})
; *q::dual.comboKey({F22: "F17"})
; *e::dual.comboKey({F22: "F18"})
; *1::dual.comboKey({F22: "F19"})
; *2::dual.comboKey({F22: "F20"})
; *3::dual.comboKey({F22: "F21"})
; *4::dual.comboKey({F22: "F23"})
; *5::dual.comboKey({F22: "F24"})