#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;*** MY CODE ***
; Terminal Ctrl+Backspace match title
; RegEx or digits: 1 - title must start with the specified WinTitle, 2 - title can contain WinTitle anywhere inside it, 3 - title must exactly match WinTitle.
SetTitleMatchMode 2 


;JKL;+Ctrl,Shift,Alt,Win
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
	} 
else if altShift {
        Send, !+%key%
	}
else if ctrlShift {
        Send, ^+%key%
	} 
else if ctrlAlt {
	Send, ^!%key%
	}
else if control {
        Send, ^%key%
	}
else if shift {
        Send, +%key%
	}
else if alt {
        Send, !%key%
	}
else if win {
        Send, #%key%
	}
else {
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


;Volume
#F1::Volume_Down
#F2::Volume_Up


;Win+Tab to Alt+Tab
LCtrl & Tab::AltTab ;Alternative 'LWin & Tab::AltTab'
LWin & Tab::Send, {Ctrl Down}{Tab}{Ctrl Up}


;win+1,2,3...
^1::#1
^2::#2
^3::#3
^4::#4
^5::#5
#1::Send,{Ctrl Down}{1}{Ctrl Up}
#2::Send,{Ctrl Down}{2}{Ctrl Up}
#3::Send,{Ctrl Down}{3}{Ctrl Up}
#4::Send,{Ctrl Down}{4}{Ctrl Up}
#5::Send,{Ctrl Down}{5}{Ctrl Up}


;Maximize active window
#f::
WinGet MX, MinMax, A
   If MX
        WinRestore A
   Else WinMaximize A
Return


;Minimize active window Win+Esc
^Escape::
WinGet MX, MinMax, A
   If MX
        WinMinimize A
   Else WinMinimize A
Return


;Close active window Shift+Win+Esc(Alt+F4)
^CapsLock::Send {Alt down}{F4}{Alt up}


;File Explorer
^e::
if WinActive("ahk_class CabinetWClass") {
	WinMinimize A	
} else if WinExist("ahk_class CabinetWClass") {
	WinActivate, ahk_class CabinetWClass
} else {
	Run, explorer.exe
	WinWait, ahk_class CabinetWClass
	WinMove, ahk_class CabinetWClass,,-8,0,976,1038
	WinActivate, ahk_class CabinetWClass
}
Return
#e::
	Run, explorer.exe
	WinWait, ahk_class CabinetWClass
	WinMove, ahk_class CabinetWClass,,952,0,976,1038
	WinActivate, ahk_class CabinetWClass
Return


;ConEmu
^`::
#Enter::
if WinActive("ahk_class VirtualConsoleClass") {
	WinMinimize A	
} else if WinExist("ahk_class VirtualConsoleClass") {
	WinActivate, ahk_class VirtualConsoleClass
} else {
	Run, C:\Program Files\ConEmu\ConEmu64.exe -Dir C:\Users\user
	WinWait, ahk_class VirtualConsoleClass
	WinActivate, ahk_class VirtualConsoleClass
}
Return
;Windows Terminal
+^`::
+#Enter::
if WinActive("ahk_exe WindowsTerminal.exe") {
	WinMinimize A	
} else if WinExist("ahk_exe WindowsTerminal.exe") {
	WinActivate, ahk_exe WindowsTerminal.exe
} else {
	Run, wt.exe
	WinWait, ahk_exe WindowsTerminal.exe
	WinActivate, ahk_exe WindowsTerminal.exe
}
Return


;Terminal Ctrl+Backspace
#if WinActive("ahk_class VirtualConsoleClass","","powershell") ;Windows Terminal
	^BS::Send, {Alt Down}{BackSpace}{Alt Up}
Return
#if WinActive("ahk_exe WindowsTerminal.exe","","Windows PowerShell") ;Windows Terminal
	^BS::Send, {Alt Down}{BackSpace}{Alt Up}
Return


;File Explorer, file info, go back folder, go forward folder 
#if WinActive("ahk_class CabinetWClass")
Ctrl & Enter:: Send, {Alt Down}{Enter}{Alt Up}
Return
#if WinActive("ahk_class CabinetWClass")
	SC163 & J::
	GetKeyState, state, Control
	if state = D
		Send, {Alt Down}{Left}{Alt Up}
	else 
		Send, {Left}
Return
#if WinActive("ahk_class CabinetWClass")
	SC163 & `;::
	GetKeyState, state, Control
	if state = D
		Send, {Alt Down}{Right}{Alt Up}
	else 
		Send, {Right}
Return


;Far Manager replace Alt to Ctrl
#if WinActive("ahk_exe Far.exe")
	LCtrl::Alt
	LAlt::Ctrl
Return


