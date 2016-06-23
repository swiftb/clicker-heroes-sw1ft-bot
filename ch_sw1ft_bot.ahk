; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb
; -----------------------------------------------------------------------------------------

; #Warn All
#Persistent
#NoEnv
#InstallKeybdHook

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1

scriptName=CH Sw1ft Bot
scriptVersion=4.1.0
minLibVersion=4.0

script := scriptName . " v" . scriptVersion

clickerScript := "monster_clicker.ahk"
clickerName := clickerScript . " - AutoHotkey"

scheduleReload := false
scheduleStop := false
manualProgression := false

; -----------------------------------------------------------------------------------------

#Include system\wm_messages.ahk

; Load system default settings
#Include system\ch_bot_default_settings.ahk

IfNotExist, ch_bot_settings.ahk
{
	FileCopy, system\ch_bot_default_settings.ahk, ch_bot_settings.ahk
}

; Load user settings
#Include *i ch_bot_settings.ahk

if (libVersion != minLibVersion) {
	showWarningSplash("The bot lib version must be " . minLibVersion . "!")
	ExitApp
}

SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79

logVariable("A_AhkVersion", A_AhkVersion)
logVariable("A_OSVersion", A_OSVersion)
logVariable("A_ScreenWidth", A_ScreenWidth)
logVariable("A_ScreenHeight", A_ScreenHeight)
if (VirtualScreenWidth > A_ScreenHeight) {
	logVariable("VirtualScreenWidth", VirtualScreenWidth)
	logVariable("VirtualScreenHeight", VirtualScreenHeight)
}
logVariable("A_ScreenDPI", A_ScreenDPI )
logVariable("script", script)

clientCheck()

Run, "%A_ScriptDir%\%clickerScript%",, UseErrorLevel
if (ErrorLevel != 0) {
	playWarningSound()
	msgbox,,% script,% "Failed to auto-start " . clickerScript . " (system error code = " . A_LastError . ")!"
}

handleAutorun()

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl, #=Win)
; -----------------------------------------------------------------------------------------

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox,,% script,% "Cursor position: x" xpos-leftMarginOffset " y" ypos-topMarginOffset
return

; Top margin calculation when clicking in the center of the ancient tab eye
^mbutton::
	mousegetpos, xpos, ypos
	msgbox,,% script,% "Set browserTopMargin to: " . ypos-102
return

; -- Main Hotkeys -------------------------------------------------------------------------

; Start a Vision Run loop with Ctrl+F1
^F1::
	loopVisionRun()
return

; Reload and restart Vision Run loop with Ctrl+F3
^F3::
	global scheduleReload := true
	handleScheduledReload("loopVisionRun")
return

; Pause/unpause the script
~Pause::Pause
return

; Abort any active run or initiated ascension with Alt+Pause
!Pause::
	showUserSplash("Aborting...")
	exitThread := true
return
Hotkey, !Pause, , P10

; Schedule a stop after finishing the current run with Shift+Pause
+Pause::
	toggleFlag("scheduleStop", scheduleStop)
return

; Reload the script (needed after configuration changes)
!F5::
	global scheduleReload := true
	handleScheduledReload()
return
Hotkey, !F5, , P10

; Schedule a script reload after finishing the current run, then restart it
+^F5::
	toggleFlag("scheduleReload", scheduleReload)
return

; Re-initialize coordinates (needed after moving or re-sizing the client window)
!F6::
	showUserSplash("Re-initialize coordinates... ")
	clientCheck()
	clickerInitialize()
return
Hotkey, !F6, , P10

; -- Supplementary Hotkeys ----------------------------------------------------------------

; Suspend/Unsuspend all other Hotkeys with Ctrl+Esc
~^Esc::Suspend, Toggle
return

; Autosave the game
^F11::
	save()
return
Hotkey, ^F11, , P5

; Raid once for free with Win+F6
#F6::
	raid()
return
Hotkey, #F6, , P5

; One paid raid
#F7::
	raid(1)
return
Hotkey, #F7, , P5

; Paid raids
#F8::
	raid(1, raidAttempts)
return
Hotkey, #F8, , P5

; Toggle boolean (true/false) flags with Shift+Ctrl+Fx

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F6::
	toggleFlag("playNotificationSounds", playNotificationSounds)
return
Hotkey, +^F6, , P5

+^F7::
	toggleFlag("playWarningSounds", playWarningSounds)
return

+^F11::
	toggleFlag("saveBeforeAscending", saveBeforeAscending)
return

; -- Test Hotkeys -------------------------------------------------------------------------

; Ctrl+Alt+F1 should scroll down to the bottom, then back up
^!F1::
	scrollToBottom()
	scrollToTop()
return

; Ctrl+Alt+F2 should switch between all used tabs
^!F2::
	switchToAncientTab()
	switchToRelicTab()
	switchToClanTab()
	switchToCombatTab()
return

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

getClickable(active:=1) {
	global
	local xPos, yPos
	if (active = 1) {
		clickPos(524, 487)
		clickPos(747, 431)
		clickPos(760, 380)
		clickPos(873, 512)
		clickPos(1005, 453)
		clickPos(1053, 443)
	} else {
		loop % clickableImageFiles.Length()
		{
			imgClickable.file := clickableImageFiles[A_Index]
			if (locateImage(imgClickable, xPos, yPos)) {
				clickPos(xPos, yPos, 1, 1) ; absolute pos
				break
			}
		}
	}
}

; Level up and upgrade all heroes
initRun(initMode:=0) {
	global
	local hasAscendButton := false
	local hasSkillBar := false
	local hasNoSkillLocked := false

	showDebugSplash("Init Run @ Lvl " . getCurrentZone())

	switchToCombatTab()
	scrollToTop()
	reFocus()

	local foundDK := false
	local xButton, yButton, xDK, yDK, x
	local clickCount := initMode = 1 ? 1 : 2

	locateImage(imgCoin, xButton, yButton) ; get a x coordinate for the hire/lvl up buttons

	loop 10 ; pages
	{
		if (locateImage(imgDK, xDK, yDK) or locateImage(imgDKG, xDK, yDK)) {
			foundDK := true
		}
		loop 5 ; attempts per page
		{
			if (locateImage(imgDimmedSkill, x, yButton)
					or locateImage(imgHire, x, yButton)) {
				if (foundDK and yButton > yDK) {
					; Don't level anything below Frostleaf
					continue
				}
				ctrlClick(xButton, yButton, clickCount, 1, 1)
			} else {
				break
			}
		}
		if (foundDK) {
			if (locateImage(imgAscend)) {
				hasAscendButton := true
			}
			break
		}
		scrollDown(5)
	}
	scrollToBottom()
	buyAvailableUpgrades()

	if (initMode = 0) {
		if (locateImage(imgSkillBar)) {
			hasSkillBar := true
		}
		if (!locateImage(imgSkillLocked)) {
			hasNoSkillLocked := true
		}
		logVariable("hasAscendButton", hasAscendButton, true, "TRACE")
		logVariable("hasSkillBar", hasSkillBar, true, "TRACE")
		logVariable("hasNoSkillLocked", hasNoSkillLocked, true, "TRACE")
	}

	return hasAscendButton and hasSkillBar and hasNoSkillLocked
}

getEndZone() {
	global
	return endLvlActive > endLvlIdle ? endLvlActive : endLvlIdle
}

getState() {
	global

	if (!WinExist(winName)) {
		return -2 ; no ch window
	}
	if (getCurrentZone() = 0) {
		return -1 ; vision, but not in browser
	}
	if (!locateImage(imgSmile)) {
		return 0 ; vision, but not finding anything
	}
	if (getCurrentZone() < getEndZone() and !readyToAscend) {
		return 1 ; ready for progression
	} else {
		return 2 ; ready to ascend
	}
}

loopVisionRun() {
	global
	readyToAscend := false

	local state := 0

	showUserSplash("Starting Vision Runs!")

	logVariable("browser", browser)
	logVariable("browserTopMargin", browserTopMargin)
	logVariable("gildedRanger", rangers[gildedRanger])
	logVariable("endLvlIdle", endLvlIdle)
	logVariable("endLvlActive", endLvlActive)
	logVariable("maxMonsterKillTime", maxMonsterKillTime)
	logVariable("chronos", chronos)
	logVariable("kumawakamaru", kumawakamaru)
	logVariable("vaagur", vaagur)
	if (endLvlActive > 0) {
		logArray("skillCombo", skillCombo)
	}
	logVariable("clickableHuntDelay", clickableHuntDelay)
	logVariable("saveBeforeAscending", saveBeforeAscending, true)
	logVariable("autoAscend", autoAscend, true)
	logVariable("levelSolomon", levelSolomon, true)

	loop
	{
		state := getState()
		if (state < 1) {
			showWarningSplash("Start failed (state = " . state . ")! Trying again...")
			clientCheck()
			clickerInitialize()
			continue
		}
		if (getState() = 1) {
			visionRun()
		}
		if (getState() = 2) {
			if (saveBeforeAscending) {
				save()
			}
			ascend(autoAscend)
			readyToAscend := false
			if (levelSolomon) {
				solomonLeveler(solomonLevels)
			}
			handleScheduledStop()
			handleScheduledReload("loopVisionRun")
		}
	}
}

visionRun() {
	global
	exitThread := false
	isResuming := false

	local startTime := A_TickCount
	
	local isInitiated := false
	local isClickerRunning := false
	local isComboActive := false
	local hasActivatedSkills := false
	local hasBomberBuff := gildedRanger = 12 ? true : false
	local hasGogBuff := gildedRanger = 13 ? true : false
	local foundTheHero := false

	local xBtn := 0, yBtn := 0, isNew := 0, startAt := 0
	local xSkill := 0, ySkill := 0, skillSearch := false

	local locateGildedDelay := gildedRanger ? 60 : 4
	local locateBuyUpgradesDelay := 20
	local progressCheckDelay := 10

	local t := 0
	local elapsedTime := 0

	local comboDelay := skillCombo[1]
	comboIndex := 2

	manualProgression := false
	switchToCombatTab()
	setProgressionMode()
	if (!locateImage(imgProgression)) {
		showTraceSplash("Manual progression: On")
		manualProgression := true
		SetTimer, nextZoneTimer, 500
	}

	local elapsedZoneTime := 0
	local zoneTimeIncrease := 0
	local previousZoneTime := 2.0 * (10.0 + kumawakamaru)
	local previousZone := 0

	local secPerMonster := 0
	local farmMonsterKillTime := 2.0 ; stop and farm before boss when exceeded

	farmTime := 60
	bossFightTimer := 30 + chronos + 1

	local startZone := getCurrentZone()
	local zone := startZone
	zoneTicks := {}
	local initiatedZone := 0
	local earliestAscendZone := 129 ; xx4/xx9
	local estimatedAscendLevel := gildedRanger ? abs(gildedRanger) * 250 - 75 : earliestAscendZone
	local initZone := 146
	local earlyGameZone := 175

	local tr1 := -1 ; Samurai
	local tr2 := ""

	if (gildedCheck(tr1, tr2, earlyGameZone)) {
		showSplash("Recommended transitional hero(es): " . rangers[tr1] . " > " . rangers[tr2])
	}

	local earlyGameMode := true
	gameMode := "INIT"

	showSplash("Starting Vision Run")

	showDebugSplash("Early game mode ends @ Lvl " . earlyGameZone)
	if (estimatedAscendLevel > earliestAscendZone) {
		showDebugSplash("Estimated ascension @ Lvl " . estimatedAscendLevel + 400 . " (idle), " . estimatedAscendLevel + 800 . " (active)")
	}

	startMonitoring()
	reFocus()

	SetTimer, zoneTickTimer, 500

	loop
	{
		if (exitThread) {
			zoneTicks := ""
			SetTimer, nextZoneTimer, off
			SetTimer, zoneTickTimer, off
			SetTimer, comboTimer, off
			clickerStop()
			stopMonitoring()
			showUserSplash("Vision Run aborted!")
			exit
		}

		; Gief moar rubies plox!
		if (mod(t, clickableHuntDelay) = 0) {
			getClickable(isClickerRunning)
		}

		; Active zone?
		if (isActiveZone(zone)) {
			if (!isClickerRunning) {
				; Yup, start hammering!
				clickerStart() ; ~38 CPS
				isClickerRunning := true
			}
			if (isInitiated and isClickerRunning and !isComboActive) {
				; Save combos till we have all skills
				Gosub, comboTimer
				SetTimer, comboTimer, % comboDelay * 1000 + 250
				isComboActive := true
			}
		} else if (isClickerRunning) {
			clickerStop()
			isClickerRunning := false
		}

		; Early progression
		if (zone < earlyGameZone) {
			if (manualProgression) {
				if (zone > 100) {
					showTraceSplash("Manual progression: Off")
					manualProgression := false
					SetTimer, nextZoneTimer, off
				}
			}
			if (mod(t, locateBuyUpgradesDelay) = 0 or isResuming) {
				; Scroll down when loosing track of the upgrades button
				if (!locateImage(imgBuyUpgrades)) {
					scrollToBottom()
					sleep % coinPickUpDelay * 1000
					buyAvailableUpgrades()
				}
				skillSearch := true
				isResuming := false
			}
			if (mod(t, lvlUpDelay) = 0) {
				; Level heroes bottom up
				if (locateImageUp(imgCoin, xBtn, yBtn)) {
					ctrlClick(xBtn, yBtn, 2, 1, 1)
				}
			}
			if (zone > 30 and zone > initiatedZone and mod(zone-6, 30) = 0 and zone < initZone) {
				; Lvl earlier heroes at zones 36, 66, 96 and 126
				initRun(1) ; x 100
				initiatedZone := zone
			}
		} else if (earlyGameMode) {
			showTraceSplash("Ending early game mode @ Lvl " . zone)
			earlyGameMode := false
		}

		if (!isInitiated and zone >= initZone) {
			; If enough gold, run init
			isInitiated := initRun()
			isResuming := true
		}

		; Normal progression
		if (!earlyGameMode and ((!foundTheHero and mod(t, locateGildedDelay) = 0) or isResuming)) {
			; Traverse bottom up till we find the first gilded hero/ranger we can lvl up
			if (locateGilded(xBtn, yBtn, isNew, startAt, !gildedRanger, foundTheHero)) {
				maxClick(xBtn, yBtn, 2, 1)
				if (!gildedRanger) {
					; "Power 5" mode, moving between gilded heroes
					startAt := yBtn + yWinPos - 56
				} else {
					if (isNew) {
						showDebugSplash("New gilded hero found @ Lvl " . zone)
						buyAvailableUpgrades()
					}
					skillSearch := true
				}
				isResuming := false
			} else {
				scrollToBottom()
				earlyGameZone := zone + 25
				earlyGameMode := true
				showTraceSplash("No gilded hero found yet! Early game mode extended to Lvl " . earlyGameZone)
			}
		}

		zone := getCurrentZone()

		; Ascend or keep farming?
		if (zone > 10 and zone > previousZone and mod(zone-4, 5) = 0 and gameMode = "PROGRESSING") {
			; Progressing @ zone before boss?
			elapsedZoneTime := timeBetweenZones(zone-1, zone)
			zoneTimeIncrease := (elapsedZoneTime - previousZoneTime) / previousZoneTime

			if (zoneTimeIncrease > 1.5) {
				logVariable("previousZoneTime", previousZoneTime,, "TRACE")
				logVariable("elapsedZoneTime", elapsedZoneTime,, "TRACE")
				showTraceSplash("zoneTimeIncrease = " . zoneTimeIncrease . " @ Lvl " . zone)
			}

			previousZone := zone
			previousZoneTime := elapsedZoneTime

			; Calculate average monster kill time for the previous zone
			secPerMonster := elapsedZoneTime / (10.0 + kumawakamaru)
			; Fast enough to kill next boss easily?
			if (secPerMonster >= farmMonsterKillTime and zoneTimeIncrease < 2.5) {
				showDebugSplash("Lvl " . zone-1 . " -> " . zone . " - Avg monster kill time: " . round(secPerMonster, 2))
				; No! Time to ascend?
				if (secPerMonster >= maxMonsterKillTime and zone >= estimatedAscendLevel) {
					; Yeah, we are done here
					triggerAscension("End of run")
					break
				}
				if (gameMode = "PROGRESSING") {
					; Farm a bit before next boss
					farmTime := ceil(secPerMonster * 25)
					startFarming()
				}
			}
		}

		; Progressing?
		if (mod(t, progressCheckDelay) = 0) {
			if (gameMode = "INIT" and isInitiated and t > bossFightTimer) {
				triggerAscension("Stuck in INIT mode")
				break
			}
			if (!locateImage(imgProgression) and gameMode != "FARMING") {
				if (zone > estimatedAscendLevel) {
					triggerAscension("Stuck at high level boss")
					break
				}
				; Unless we are farming, toggle progression back on
				setProgressionMode()
			}
		}

		; Level up...
		if (!earlyGameMode and mod(t, lvlUpDelay) = 0 and !isResuming) {
			if (matchPixelColor(blueColor, xBtn+xWinPos, yBtn+yWinPos)) {
				if (!foundTheHero) {
					; Get Bomber Max and Gog global gold and dps buffs when we can
					if (!hasBomberBuff and zone > 2930) {
						getBuff(imgMax, hasBomberBuff, skillSearch)
					} else if (!hasGogBuff and zone > 3210) {
						getBuff(imgGog, hasGogBuff, skillSearch)
					}
				}
				; ... when we can afford to do so
				ctrlClick(xBtn, yBtn, 2, 1, 1)
			} else if (gildedRanger and !matchPixelColor(goldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
				if (!matchPixelColor(brightGoldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
					; ... or not, lost sight of our gilded hero
					showTraceSplash("Trigger gilded hero locator")
					clickAwayImage(imgCombatTab)
					isResuming := true
				}
			}
		}

		if (skillSearch) {
			; Aquire possible new skills
			while (locateImage(imgSkill, xSkill, ySkill)) {
				clickPos(xSkill, ySkill, 1, 1)
				sleep 500
			}
			if (!locateImage(imgDimmedSkill)) {
				skillSearch := false
			}
		}

		zone := getCurrentZone()
		t += 1
		sleep 1000

	} until zone > getEndZone() or readyToAscend

	if (earlyGameMode) {
		maxLevels() ; get some extra souls from levels
	}

	SetTimer, nextZoneTimer, off
	SetTimer, zoneTickTimer, off

	if (useZoneDataLogger) {
		logZoneData(zdlStart, zone, zdlInterval)
	}
	zoneTicks := ""

	SetTimer, comboTimer, off
	clickerStop()
	stopMonitoring()

	elapsedTime := (A_TickCount - startTime) / 1000
	showSplash("Vision Run duration: " . formatSeconds(elapsedTime))
}

gildedCheck(byref tr1, byref tr2, byref earlyGameZone) {
	global
	if (gildedRanger > 0) {
		if (gildedRanger > 3) {
			if (gildedRanger > 14) {
				; Use Wepwawet as last transitional hero for gilded Betty or Midas
				tr2 := 14
			} else {
				tr2 := gildedRanger - 3
			}
			if (gildedRanger > 6) {
				tr1 := tr2 - 3
				earlyGameZone := tr1 * 250 - 75
			}
		}
		return 1
	}
	return 0
}

triggerAscension(msg, delay:=0) {
	global
	if (!readyToAscend) {
		if (delay > 0) {
			showDebugSplash("Trigger ascension in " . floor(delay) . " seconds (" . msg . ")")
			SetTimer, ascendTimer, % -delay * 1000
		} else {
			showDebugSplash("Ascension triggered! (" . msg . ")")
			readyToAscend := true
		}
	}
}

setGameMode(newGameMode) {
	global
	showTraceSplash(gameMode . " --> " . newGameMode . " @ Lvl " . getCurrentZone())
	gameMode := newGameMode
}

isActiveZone(zone) {
	global
	if (zone < 10) {
		return true
	}
	if (zone < endLvlActive) {
		if (endLvlIdle < endLvlActive and zone < endLvlIdle) {
			return false
		}
		return true
	}
	return false
}

getBuff(image, byref hasBuff, byref skillSearch) {
	global
	local who := image = imgMax ? "Bomber Max" : "Gog"
	scrollToBottom()
	if (upLocator(image, image.file, xImg, yImg)) {
		showDebugSplash("Get buff from " . who . " @ Lvl " . getCurrentZone())
		ctrlClick(xImg-320, yImg+43, 2, 1, 1) ; hire
		skillSearch := true
	}
	hasBuff := true
}

; Max levels early game for some extra souls
maxLevels() {
	global

	showDebugSplash("Max levels for souls")

	scrollToTop()
	reFocus()

	local xButton, yButton
	loop 9 ; pages
	{
		ControlSend,, {vk51 down}, ahk_id %chWinId% ; {q}, {vk51} or {sc010}
		sleep 500
		if (locateImage(imgMaxLvl, xButton, yButton)) {
			loop 4
			{
				clickPos(xButton, yButton, 1, 1)
				sleep % zzz
				yButton += oLvl
			}
		}
		scrollDown(5)
	}
	ControlSend,, {vk51 up}, ahk_id %chWinId%
}

clickerStart(duration := 0) {
	sendClickerMsg(WM_CLICKER_START)
	if (duration > 0) {
		SetTimer, clickerStopTimer, % -duration * 1000
	}
}

clickerPause() {
	sendClickerMsg(WM_CLICKER_PAUSE)
}

clickerStop() {
	sendClickerMsg(WM_CLICKER_STOP)
	sleep 1000
}

clickerReload() {
	sendClickerMsg(WM_CLICKER_RELOAD)
}

clickerInitialize() {
	sendClickerMsg(WM_CLICKER_INITIALIZE)
}

clickerModeFast() {
	sendClickerMsg(WM_CLICKER_MODE_FAST)
}

clickerModeSlow() {
	sendClickerMsg(WM_CLICKER_MODE_SLOW)
}

getClickerStatus() {
	return sendClickerMsg(WM_CLICKER_STATUS, 1)
}

sendClickerMsg(msg, wait:=0) {
	global
	local reply := 0
	local tmm := A_TitleMatchMode
	local dhw := A_DetectHiddenWindows
	SetTitleMatchMode, 2
	DetectHiddenWindows, on
	if (!wait) {
		PostMessage, %msg%,,,,% clickerName
	} else {
		SendMessage, %msg%,,,,% clickerName
		if (ErrorLevel != "FAIL") {
			reply := ErrorLevel
		} else {
			showWarningSplash("SendMessage failed! " . clickerScript . " started?")
		}
	}
	DetectHiddenWindows,% dhw
	SetTitleMatchMode,% tmm
	return reply
}

openSaveDialog() {
	global

	clickPos(xSettings, ySettings)
	sleep % zzz * 3
	clickPos(xSave, ySave)
	sleep % zzz * 4
}

save() {
	global
	local fileName := "ch" . A_NowUTC . ".txt"
	local newFileName := ""

	showDebugSplash("Save to " . fileName)

	; Close possible other dialog box
	ControlSend,, {esc}, ahk_class %dialogBoxClass%

	clickerPause()
	openSaveDialog()

	; Change the file name...
	if (saveMode = 1) {
		ControlSetText, Edit1, %fileName%, ahk_class %dialogBoxClass%
	} else {
		ControlSend, Edit1, %fileName%, ahk_class %dialogBoxClass%
	}
	sleep % zzz * 4
	; ... and double-check that it's correct
	ControlGetText, newFileName, Edit1, ahk_class %dialogBoxClass%
	if (newFileName = fileName) {
		ControlClick, %saveButtonClassNN%, ahk_class %dialogBoxClass%,,,, NA
	} else {
		ControlSend,, {esc}, ahk_class %dialogBoxClass%
	}

	sleep % zzz * 3
	clickPos(xSettingsClose, ySettingsClose)
	sleep % zzz
}

ascend(autoYes:=false) {
	global
	exitThread := false

	local x, y

	startMonitoring()

	if (autoYes) {
		if (autoAscendDelay > 0) {
			showWarningSplash(autoAscendDelay . " seconds till ASCENSION! (Abort with Alt+Pause)", autoAscendDelay)
			if (exitThread) {
				exitThread := false
				stopMonitoring()
				showUserSplash("Ascension aborted!")
				exit
			}
		}
	} else {
		playWarningSound()
		msgbox, 260,% script,Salvage Junk Pile & Ascend? ; default no
		ifmsgbox no
		{
			stopMonitoring()
			showUserSplash("Salvage aborted!")
			exit
		}
	}

	salvageJunkPile() ; must salvage junk relics before ascending
	setFarmMode()

	showDebugSplash("Ascend @ Lvl " . getCurrentZone())

	clickPos(xAscend, yAscend) ; 0.23 ascend button
	sleep % zzz * 4
	clickPos(xYes, yYes)
	sleep % zzz * 2

	stopMonitoring()
	sleep 1000 ; wait a sec
}

salvageJunkPile() {
	global

	switchToRelicTab()

	if (autoAscend) {
		if (displayRelicsDuration > 0) {
			clickPos(xRelic, yRelic) ; focus (will show the upgrade screen in 0.23)
		}

		if (displayRelicsDuration > 0) {
			showWarningSplash("Salvaging junk in " . displayRelicsDuration . " seconds! (Abort with Alt+Pause)", displayRelicsDuration)
			if (exitThread) {
				exitThread := false
				showUserSplash("Salvage aborted!")
				exit
			}
		}

		if (displayRelicsDuration > 0) {
			clickPos(xUpgradeNo, yUpgradeNo) ; don't upgrade
			sleep % zzz
			clickPos(xRelic+100, yRelic) ; remove focus
		}
	}

	showDebugSplash("Salvage Junk Pile")

	clickPos(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	clickPos(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
}

buyAvailableUpgrades() {
	global
	clickPos(xBuy, yBuy, 2)
	sleep % zzz * 3
}

raid(doSpend:=0, attempts:=1) {
	global
	exitThread := false

	local xBtn := 0, yBtn := 0, raidDuration := 34 * 1000
	local wasClickerRunning := getClickerStatus()

	local mode := doSpend ? "Paid" : "Free"
	showUserSplash(mode . " Raid x " . attempts)

	Thread, NoTimers ; block timers if mid run

	switchToClanTab()
	sleep 1000
	clickAwayImage(imgClanRaid)

	if (!wasClickerRunning) {
		clickerStart()
		sleep 2500
	}
	loop % attempts
	{
		if (exitThread) {
			exitThread := false
			showUserSplash("Raid aborted!")
			break
		}
		if (clickAwayImage(imgClanCollect)) {
			break
		}
		if (doSpend) {
			showSplash(mode . " Raid (" . A_Index . "/" . attempts . ")")
			if (locateImage(imgClanFightAgain, xBtn, yBtn)) {
				while (!locateImage(imgYes)) {
					clickPos(xBtn, yBtn, 1, 1)
					sleep 250
				}
				clickAwayImage(imgYes)
				clickAwayImage(imgClanFight)
				sleep % raidDuration
			}
		} else {
			if (clickAwayImage(imgClanFight)) {
				sleep % raidDuration
			}
		}
		getClickable()
	}
	if (!wasClickerRunning) {
		clickerStop()
	}

	clickAwayImage(imgCombatTab)
	isResuming := true
}

; Toggle between farm and progression modes
toggleMode(toggle:=1) {
	global
	if (toggle) {
		; ControlSend,, {vk41}, ahk_id %chWinId% ; {a}, {vk41} or {sc01E}
		clickPos(xMode, yMode)
		sleep % zzz
	}
}

setFarmMode() {
	global
	if (!manualProgression and locateImage(imgProgression)) {
		clickAwayImage(imgProgression)
		showTraceSplash("Set Farm Mode")
	}
}

setProgressionMode() {
	global
	if (!manualProgression and locateImage(imgFarm)) {
		clickAwayImage(imgFarm)
		showTraceSplash("Set Progression Mode")
	}
}

activateSkills(skills) {
	global
	reFocus()
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, ahk_id %chWinId%
		sleep 25
	}
}

startMonitoring() {
	global
	setTimer, checkMousePosition, 250
	setTimer, checkWindowVisibility, 20000
}

stopMonitoring() {
	global
	setTimer, checkMousePosition, off
	setTimer, checkWindowVisibility, off
}

handleScheduledReload(function := "") {
	global
	local params := function != "" ? "/autorun " . function : ""
	if (scheduleReload) {
		showUserSplash("Script Reload " . params, 3)
		Run "%A_AhkPath%" /restart "%A_ScriptFullPath%" %params%
	}
}

handleScheduledStop() {
	global
	if (scheduleStop) {
		showUserSplash("Scheduled stop. Exiting...")
		scheduleStop := false
		exit
	}
}

handleAutorun() {
	global
	option = %1%
	function = %2%
	if (option = "/autorun") {
		loopVisionRun()
	}
}

hasClickable() {
	global
	return locateImage(imgClickable)
}

; Try to find the first gilded hero/ranger we can lvl up
locateGilded(byref xPos, byref yPos, byref isNew, startAt:=0, silent:=0, byref foundTheHero:=0) {
	global
	isNew := 0
	local xAbs, yAbs
	local retries := 1

	if (startAt = 0 and !locateImage(imgBuyUpgrades)) {
		if (locateImage(imgCombatTab)) {
			clickAwayImage(imgCombatTab)
		}
		scrollToBottom()
	}

	if (gildedRanger = -1 and locateImage(imgBuyUpgrades)) {
		scrollUp(30) ; Locate Samurai
		foundTheHero := true
	} else if (gildedRanger = 15 and locateImage(imgBuyUpgrades) and locateImage(imgChefBuff)) {
		scrollUp(35) ; Locate Betty
		foundTheHero := true
	} else if (gildedRanger = 16 and locateImage(imgBuyUpgrades) and locateImage(imgKingsBuff)) {
		scrollUp(22) ; Locate Midas
		foundTheHero := true
	}

	while (upLocator(imgGilded, "Gilded hero", xAbs, yAbs, retries, 5, 1, startAt, silent)) {
		local xPixel := xAbs + 83 ; HI[R]E
		local yPixel := yAbs + 38
		if (matchPixelColor(dimmedYellowColor, xPixel, yPixel)) {
			startAt := yAbs
			continue
		} else if (matchPixelColor(yellowColor, xPixel, yPixel)) {
			isNew := 1
		}
		; Transform to screen relative and offset coordinates to the lvl up button
		xPos := xAbs - xWinPos + 57
		yPos := yAbs - yWinPos + 56
		return 1
	}
	return 0
}

solomonLeveler(levels) {
	global
	local x, y

	showSplash("Level Solomon x " . levels)

	switchToAncientTab()
	if (locator(imgSolomon, "Solomon", x, y)) {
		; Offset coordinates to the lvl up button
		x -= 365
		y += 28
		clickPos(x, y, levels, 1)
		sleep % zzz * 2
	}
}

checkSafetyZones() {
	global
	local window, x, y
	local i, sz
	local xL, yT, xR, yB

	MouseGetPos,,, window
	if (window = WinExist(winName)) {

		WinActivate
		MouseGetPos, x, y

		for i, sz in safetyZones
		{
			xL := getAdjustedX(sz.x1)
			yT := getAdjustedY(sz.y1)
			xR := getAdjustedX(sz.x2)
			yB := getAdjustedY(sz.y2)

			if (x > xL && y > yT && x < xR && y < yB) {
				if (sz.zone = "gilded" && !locateImage(imgGildedButton)) {
					return
				}
				Thread, NoTimers ; block timers
				playNotificationSound()
				clickerModeSlow()
				if (locateImage(imgProgression)) {
					msgbox,,% script,Click safety pause engaged. Resume?
					clickAwayImage(imgCombatTab)
					isResuming := true
					reFocus()
				} else {
					msgbox,,% script,Click safety pause engaged. Continue?
				}
				clickerModeFast()
			}
		}
	}
}

zoneMovedWithin(zone, sec) {
	loop % sec * 10 {
		sleep 100
		zoneMoved := getCurrentZone() - zone
		if (zoneMoved) {
			return zoneMoved 
		}
	}
	return 0
}

nextZone() {
	global
	if (gameMode != "FARMING") {
		clickPos(xPlusOneZone, yZone)
		sleep % zzz
	}
}

timeBetweenZones(z1, z2) {
	global
	local z1tick := zoneTicks.HasKey(z1) ? zoneTicks[z1] : A_TickCount
	local z2tick := zoneTicks.HasKey(z2) ? zoneTicks[z2] : A_TickCount
	return abs(z1tick - z2tick) / 1000
}

storeZoneTick() {
	global
	local cz := getCurrentZone()
	if (cz > 0) {
		local pz := cz - 1
		local currentTime := A_TickCount

		if (!zoneTicks.HasKey(pz)) {
			zoneTicks[pz] := currentTime
		}
		if (!zoneTicks.HasKey(cz)) {
			zoneTicks[cz] := currentTime
			; Reached a new non-boss zone?
			if (gameMode != "PROGRESSING" and mod(cz, 5) > 0 and zoneTicks.MaxIndex() > 1) {
				; Yup!
				setGameMode("PROGRESSING")
			}
		}
	}
}

logZoneData(zStart, zEnd, zInterval) {
	global
	local startZone := zStart < zoneTicks.MinIndex() ? zoneTicks.MinIndex() : zStart
	local endZone := zEnd > zoneTicks.MaxIndex() ? zoneTicks.MaxIndex() : zEnd
	local intervals := ceil((endZone - startZone) / zInterval)

	local zone := startZone
	local prevZone := zone - zInterval

	local totalTime := 0
	local intervalTime := 0

	local t := "`t" ; tab
	local nl := "`n" ; new line
	local zoneData := "Zones: " . startZone . " -> " . endZone . ", Interval: " . zInterval
	zoneData .= nl . "Zone" . t . "Time" . t . "Diff (s)"
	zoneData .= nl . zone . t . "00:00:00" . t . "0"

	loop % intervals {
		zone += zInterval
		if (zone > endZone) {
			zone := endZone
		}
		prevZone += zInterval

		totalTime := timeBetweenZones(startZone, zone)
		intervalTime := timeBetweenZones(prevZone, zone)

		zoneData .= nl . zone . t . formatSeconds(totalTime) . t . round(intervalTime, 1)
	}

	logger(zoneData, "INFO", "_zone_data")
}

startFarming() {
	global
	setGameMode("FARMING")
	setFarmMode()
	scrollToZone(zoneTicks.MaxIndex())
	local farmZone := getCurrentZone()
	if (mod(farmZone, 5) = 0) {
		scrollToZone(--farmZone)
	}
	; Farm on highest recorded non-boss zone
	showDebugSplash("Farm @ Lvl " . farmZone . " for " . farmTime . "s")
	SetTimer, farmTimer, % -farmTime * 1000
}

bossFight() {
	global
	setGameMode("FIGHTING")
	setProgressionMode()
	SetTimer, bossTimer, % -bossFightTimer * 1000
}

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

; Safety zone around the in-game tabs (that triggers an automatic script pause when breached)
checkMousePosition:
	checkSafetyZones()
return

checkWindowVisibility:
	if (!locateImage(imgSmile)) {
		WinActivate, ahk_id %chWinId%
	}
return

comboTimer:
	activateSkills(skillCombo[comboIndex])
	comboIndex := comboIndex < skillCombo.MaxIndex() ? comboIndex+1 : 2
return

clickerStopTimer:
	clickerStop()
return

farmTimer:
	if (gameMode != "PROGRESSING") {
		bossFight()
	}
return

bossTimer:
	if (!locateImage(imgProgression)) {
		; Failed the boss, back to farming...
		showDebugSplash("Failed boss!")
		startFarming()
	}
return

ascendTimer:
	readyToAscend := true
return

zoneTickTimer:
	storeZoneTick()
return

nextZoneTimer:
	nextZone()
return
