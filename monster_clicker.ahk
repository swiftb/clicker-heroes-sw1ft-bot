; -----------------------------------------------------------------------------------------------------
; Clicker Heroes Monster Clicker
; by Sw1ftb

; Hotkeys:

; Shift+F1 to start
; Shift+Pause to stop
; Shift+F5 to reload the script

; Built in click speed throttle when moving mouse cursor inside the Clicker Heroes window.
; -----------------------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook
#SingleInstance force

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1
SetBatchLines, -1

scriptName=Monster Clicker
scriptVersion=1.3
minLibVersion=1.4

script := scriptName . " v" . scriptVersion

short := 21 ; ms
long := 2000 ; throttled delay

clickDelay := short
keepOnClicking := false

; -----------------------------------------------------------------------------------------

#Include system\wm_messages.ahk

; Load system default settings
#Include system\monster_clicker_default_settings.ahk

IfNotExist, monster_clicker_settings.ahk
{
	FileCopy, system\monster_clicker_default_settings.ahk, monster_clicker_settings.ahk
}

#Include *i monster_clicker_settings.ahk

if (libVersion < minLibVersion) {
	showWarningSplash("The bot lib version must be " . minLibVersion . " or higher!")
	ExitApp
}

clientCheck()

OnMessage(WM_CLICKER_START, "MsgMonitor")
OnMessage(WM_CLICKER_PAUSE, "MsgMonitor")
OnMessage(WM_CLICKER_STOP, "MsgMonitor")
OnMessage(WM_CLICKER_RELOAD, "MsgMonitor")
OnMessage(WM_CLICKER_INITIALIZE, "MsgMonitor")

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift)
; -----------------------------------------------------------------------------------------

+F1::
	clickerStart()
return

+F2::
	clickerPause()
return

+F3::
	clickerStop()
return

+F5::
	clickerReload()
return

+F6::
	clickerInitialize()
return

clickerStart() {
	global
	keepOnClicking := true

	local monsterClicks := 0
	local startTime := A_TickCount

	showSplash("Starting...")

	if (clickDuration > 0) {
		setTimer, stopClicking, % -clickDuration * 60 * 1000 ; run only once
	}
	setTimer, checkMouse, 250

	while(keepOnClicking) {
		clickPos(xMonster, yMonster)
		monsterClicks++
	    sleep % clickDelay
	}

	setTimer, checkMouse, off

	local elapsedTime := (A_TickCount - startTime) / 1000
	local clicksPerSecond := round(monsterClicks / elapsedTime, 2)
	showSplash("Average CPS: " . clicksPerSecond, 3)
}

clickerPause() {
	global
	critical
	if (keepOnClicking) {
		msgbox,,% script,Click safety pause engaged. Continue?
	}
}

clickerStop() {
	global
	keepOnClicking := false
}

clickerReload() {
	showSplashAlways("Reloading clicker...", 1)
	Reload
}

clickerInitialize() {
	clientCheck()
}

MsgMonitor(wParam, lParam, msg) {
	if (msg = WM_CLICKER_START) {
		clickerStart()
 	} else if (msg = WM_CLICKER_PAUSE) {
 		clickerPause()
	} else if (msg = WM_CLICKER_STOP) {
		clickerStop()
	} else if (msg = WM_CLICKER_RELOAD) {
		clickerReload()
	} else if (msg = WM_CLICKER_INITIALIZE) {
		clickerInitialize()
	}
}

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

checkMouse:
	MouseGetPos,,, window
	if (window = WinExist(winName)) {
		clickDelay := long
	} else {
		clickDelay := short
	}
return

stopClicking:
	keepOnClicking := false
return
