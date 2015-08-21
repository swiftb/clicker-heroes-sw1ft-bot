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
scriptVersion=1.21
minLibVersion=1.3

script := scriptName . " v" . scriptVersion

short := 21 ; ms
long := 2000 ; throttled delay

clickDelay := short

; -----------------------------------------------------------------------------------------

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

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift)
; -----------------------------------------------------------------------------------------

; Start clicker with Shift+F1
+F1::
	keepOnClicking := true
	monsterClicks := 0

	showSplash("Starting...")

	drStartTime := A_TickCount
	if (clickDuration > 0) {
		setTimer, stopClicking, % -clickDuration * 60 * 1000 ; run only once
	}
	setTimer, checkMouse, 1000

	while(keepOnClicking) {
		clickPos(xMonster, yMonster)
		monsterClicks++
	    sleep % clickDelay
	}

	setTimer, checkMouse, off

	elapsedTime := (A_TickCount - drStartTime) / 1000
	clicksPerSecond := round(monsterClicks / elapsedTime, 2)
	showSplash("Average CPS: " . clicksPerSecond, 5)
return

; Remote pause
+F2::
	critical
	if (keepOnClicking) {
		msgbox,,% script,Click safety pause engaged. Continue?
	}
return

; Stop clicker with Shift+Pause
+Pause::
	keepOnClicking := false
return

; Reload script with Shift+F5
+F5::
	showSplashAlways("Reloading clicker...", 1)
	Reload
return

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
