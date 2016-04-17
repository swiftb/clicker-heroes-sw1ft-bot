; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb
; -----------------------------------------------------------------------------------------

#Warn All
#Persistent
#NoEnv
#InstallKeybdHook

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1

scriptName=CH Sw1ft Bot
scriptVersion=4.x
minLibVersion=4.0

script := scriptName . " v" . scriptVersion

clickerScript := "monster_clicker.ahk"
clickerName := clickerScript . " - AutoHotkey"

scheduleReload := false
scheduleStop := false

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

if (deepRunClicks) {
	Run, "%A_ScriptDir%\%clickerScript%",, UseErrorLevel
	if (ErrorLevel != 0) {
		playWarningSound()
		msgbox,,% script,% "Failed to auto-start " . clickerScript . " (system error code = " . A_LastError . ")!"
	}
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

; Start the Speed Run loop with Ctrl+F1
^F1::
	showWarningSplash("The Speed Run has not been updated to support a Transcend!")
	; loopSpeedRun()
return

; Start a Deep Run with Ctrl+F2 (expecting to start where a Speed Run finishes)
^F2::
	deepRun()
return

; Start a Vision Run loop with Ctrl+F3
^F3::
	loopVisionRun()
return

; Pause/unpause the script
Pause::Pause
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
^Esc::Suspend, Toggle
return

; Open the Ancients Optimizer and auto-import game save data
^F5::
	openAncientsOptimizer()
return
Hotkey, ^F5, , P5

; Set previous ranger as re-gild target
^F6::
	reGildRanger := reGildRanger > rangers.MinIndex() ? reGildRanger-1 : reGildRanger
	showUserSplash("Re-gild ranger set to " . rangers[reGildRanger])
return

; Set next ranger as re-gild target
^F7::
	reGildRanger := reGildRanger < rangers.MaxIndex() ? reGildRanger+1 : reGildRanger
	showUserSplash("Re-gild ranger set to " . rangers[reGildRanger])
return

; Move all gilds to the target ranger
^F8::
	playNotificationSound()
	msgbox, 4,% script,% "Move all gilds to " . rangers[reGildRanger] . "?"
	ifmsgbox no
		return
	clickerPause()
	regild(reGildRanger)
return
Hotkey, ^F8, , P5

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

; Ctrl+Alt+F1 should scroll down to the bottom
^!F1::
	scrollToBottom()
return

; Ctrl+Alt+F2 should switch between all used tabs
^!F2::
	switchToAncientTab()
	switchToRelicTab()
	switchToClanTab()
	switchToCombatTab()
return

; Alt+F1 to F4 are here to test the individual parts of the full Speed Run loop

!F1::
	getClickable()
return

!F2::
	initRun()
return

!F3::
	switchToCombatTab()
	speedRun()
return

!F4::
	ascend(autoAscend)
return

testSearch(image, info:="") {
	global
	local extraInfo := info != "" ? " (" . info . ")" : ""
	local x, y
	msgbox,,% script,% "Search for " . image.file . "?" . extraInfo
	if (locateImage(image, x, y)) {
		msgbox,,% script,% "Success! (" . x . ", " . y . ")"
	} else {
		msgbox,,% script,% "Failed!"
	}
}

testLocate(image, clickCount:=5) {
	global
	local x, y
	msgbox,,% script,% "Locate " . image.file . "?"
	if (locator(image, image.file, x, y, 1, clickCount)) { ; one retry
		msgbox,,% script,% "Success! (" . x . ", " . y . ")"
	} else {
		msgbox,,% script,% "Failed!"
	}
}

; Image search tests
#F1::
	testSearch(imgQuality, "Set high quality")
	testSearch(imgSmile, "Set low quality")
	testSearch(imgProgression, "Toggle progression mode")
	testSearch(imgClickable)
	switchToCombatTab()
	scrollToTop()
	testSearch(imgHire)
	testSearch(imgCoin)
	testSearch(imgDimmedSkill, "Lvl someone to 1")
	testSearch(imgSkill, "Lvl someone to 10")
	testSearch(imgSkillBar)
	testSearch(imgSkillLocked)
	testSearch(imgAscend, "Lvl Amenhotep to 150")
	testLocate(imgDK)

	msgbox,,% script,% "Locate " . imgGilded.file . "?"
	if (locateGilded(x, y, isNew)) {
		msgbox,,% script,% "Success! (" . x . ", " . y . ")"
	} else {
		msgbox,,% script,% "Failed!"
	}
	scrollToBottom()
	testSearch(imgBuyUpgrades)

	switchToAncientTab()
	testLocate(imgSolomon)
	msgbox,,% script,% "Done."
return

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

getClickable(idle:=0) {
	global
	local xPos, yPos
	if (idle = 0) {
		; Break idle on purpose to get the same amount of gold every run
		loop 3 {
			clickPos(xMonster, yMonster)
		}
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

	if (!useImageSearch) {
		local clicks := 7
		loop 6
		{
			upgrade(2)
			scrollDown(clicks)
		}
		upgrade()
	} else {
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
	}
	scrollToBottom()
	buyAvailableUpgrades()

	if (useImageSearch and initMode = 0) {
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

	return useImageSearch ? hasAscendButton and hasSkillBar and hasNoSkillLocked : 1
}

upgrade(clickCount:=1) {
	global
	local y := 213

	loop
	{
		ctrlClick(xLvl, y, clickCount)
		y += 74
	} until y > 669
}

getEndZone() {
	global
	return endLvlActive > endLvlIdle ? endLvlActive : endLvlIdle
}

getState() {
	global

	if (!WinExist(winName)) {
		return -3 ; no ch window
	}
	if (!useImageSearch) {
		return -2 ; no vision
	}
	if (getCurrentZone() = 0) {
		return -1 ; vision, but not in browser
	}
	if (!locateImage(imgSmile)) {
		return 0 ; vision, but not finding anything
	}
	if (getCurrentZone() < getEndZone()) {
		return 1 ; ready for progression
	} else {
		return 2 ; ready to ascend
	}
}

loopVisionRun() {
	global

	oldEndLvlIdle := endLvlIdle
	oldEndLvlActive := endLvlActive

	local state := 0

	showUserSplash("Starting Vision Runs!")

	logVariable("browser", browser)
	logVariable("browserTopMargin", browserTopMargin)
	logVariable("useImageSearch", useImageSearch, true)
	if (gildedRanger > 0) {
		logVariable("gildedRanger", rangers[gildedRanger])
	}
	logVariable("endLvlIdle", endLvlIdle)
	logVariable("endLvlActive", endLvlActive)
	logVariable("deepRunClicks", deepRunClicks, true)
	if (endLvlActive > 0) {
		logArray("deepRunCombo", deepRunCombo)
	}
	logVariable("clickerDuration", clickerDuration)
	logVariable("clickableHuntDelay", clickableHuntDelay)
	logVariable("stopHuntThreshold", stopHuntThreshold)
	logVariable("saveBeforeAscending", saveBeforeAscending, true)
	logVariable("autoAscend", autoAscend, true)
	logVariable("levelSolomon", levelSolomon, true)
	if (levelSolomon) {
		logVariable("solomonLevels", solomonLevels)
	}

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

	local xBtn := 0, yBtn := 0, isNew := 0
	local xSkill := 0, ySkill := 0, skillSearch := false

	local locateGildedDelay := gildedRanger ? 90 : 4
	local locateBuyUpgradesDelay := 20
	local progressCheckDelay := 10

	local t := 0
	local elapsedTime := 0

	local comboDelay := deepRunCombo[1]
	comboIndex := 2

	manualProgression := false
	switchToCombatTab()
	setProgressionMode()
	if (!locateImage(imgProgression)) {
		showTraceSplash("Manual progression: On")
		manualProgression := true
		SetTimer, nextZoneTimer, 500
	}

	showProgressBar := false
	endLvlIdle := oldEndLvlIdle
	endLvlActive := oldEndLvlActive
	lvlUpDelay := 6

	local startAt := 0
	local secPerMonster := 0

	farmZone := 0
	farmTime := 60

	local zone := getCurrentZone()
	zoneTicks := {}
	local initiatedZone := 0
	local earliestAscendZone := 129 ; xx4/xx9
	local estimatedAscendLevel := gildedRanger ? abs(gildedRanger)*250 + 600 : earliestAscendZone
	local initZone := 146
	local earlyGameZone := initZone
	local stopHuntZone := getEndZone() - ceil(stopHuntThreshold * 250 / 7)

	local earlyGameMode := true
	gameMode := "PROGRESSING"

	showSplash("Starting Vision Run")

	showDebugSplash("Estimated earliest ascension @ Lvl " . estimatedAscendLevel)

	startMonitoring()
	reFocus()

	SetTimer, betaWarningTimer, 2500, 1 ; TODO: REMOVE AFTER BETA
	SetTimer, zoneTickTimer, 500

	loop
	{
		if (exitThread) {
			zoneTicks := ""
			SetTimer, nextZoneTimer, off
			SetTimer, betaWarningTimer, off ; TODO: REMOVE AFTER BETA
			SetTimer, zoneTickTimer, off
			SetTimer, comboTimer, off
			clickerStop()
			stopProgress()
			stopMonitoring()
			showUserSplash("Vision Run aborted!")
			exit
		}

		; Gief moar rubies plox!
		if (mod(t, clickableHuntDelay) = 0 and zone < stopHuntZone) {
			getClickable(useImageSearch)
		}

		if (!isInitiated and zone >= initZone) {
			; If enough gold, run init
			isInitiated := initRun()
			isResuming := true
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
					yBtn -= 8
				}
			}
			if (zone > 30 and zone > initiatedZone and mod(zone-6, 30) = 0 and zone < initZone) {
				; Lvl earlier heroes at zones 36, 66, 96 and 126
				initRun(1) ; x 100
				initiatedZone := zone
			}
		} else {
			earlyGameMode := false
		}

		; Normal progression
		if (!earlyGameMode and mod(t, locateGildedDelay) = 0 or isResuming) {
			; Traverse bottom up till we find the first gilded hero/ranger we can lvl up
			if (locateGilded(xBtn, yBtn, isNew, startAt, !gildedRanger)) {
				maxClick(xBtn, yBtn, 1, 1)
				if (isNew) {
					showDebugSplash("New gilded hero found @ Lvl " . zone)
					buyAvailableUpgrades()
				}
				if (!gildedRanger) {
					; "Power 5" mode, moving between gilded heroes
					startAt := yBtn + yWinPos - 56
				} else {
					skillSearch := true
				}
				isResuming := false
			} else {
				earlyGameZone := zone + 10
				earlyGameMode := true
				showTraceSplash("No gilded hero found yet, earlyGameMode extended to Lvl " . earlyGameZone)
			}
		}

		if (mod(t, progressCheckDelay) = 0) {
			; Progression check
			if (!locateImage(imgProgression) and gameMode != "FARMING") {
				; Failing badly above our estimated ascend level?
				if (zone > estimatedAscendLevel) {
					; Yes, probably best to ascend
					ascendNow(zone)
				}
				; Unless we are farming, toggle progression back on
				setProgressionMode()
			}
		}

		; Ascend or keep farming?
		if (zone > 10 and mod(zone-4, 5) = 0 and gameMode = "PROGRESSING") {
			; Progressing @ zone before boss?
			; Calculate average monster kill time for the previous zone
			secPerMonster := timeBetweenZones(zone-1, zone) / (10 - kumawakamaruLevel)
			; Fast enough to kill next boss easily?
			if (secPerMonster >= farmMonsterKillTime) {
				showDebugSplash("Lvl " . zone-1 . " -> " . zone . " - Avg monster kill time: " . round(secPerMonster, 2))
				; No! Time to ascend?
				if (secPerMonster >= maxMonsterKillTime and zone >= estimatedAscendLevel) {
					; Yes!
					ascendNow(zone)
; KEEPING THINGS SIMPLE FOR NOW
					; In idle mode?
;					if (!isComboActive) {
						; Yes, brute force through two bosses with skills, then ascend
;						zoneMovedWithin(zone, 30) ; wait till boss
;						clickerStart(clickerDuration)
;						showDebugSplash("Push with skills!")
;						Gosub, comboTimer ; trigger skill combo
;						bossFight()
;					}
				}
				if (gameMode = "PROGRESSING") {
					; Farm a bit before next boss
					farmTime := ceil(secPerMonster * 25) ; 20, 25 or 30?
					startFarming()
				}
			}
		}

		; Active zone?
		if (isActiveZone(zone)) {
			if (deepRunClicks) {
				if (!isClickerRunning) {
					; Yup, start hammering!
					clickerStart() ; ~38 CPS
					isClickerRunning := true
				}
				clickPos(xMonster, yMonster) ; Jugg combo safety click
				sleep 30
				if (isInitiated and isClickerRunning and !isComboActive) {
					; Save combos till we have all skills
					Gosub, comboTimer
					SetTimer, comboTimer, % comboDelay * 1000 + 250
					isComboActive := true
				}
			}
		} else if (isClickerRunning) {
			clickerStop()
			isClickerRunning := false
		}

		; Level up...
		if (mod(t, lvlUpDelay) = 0 and !isResuming) {
			if (matchPixelColor(blueColor, xBtn+xWinPos, yBtn+yWinPos)) {
				; Get Bomber Max and Gog global gold and dps buffs when we can
				if (!hasBomberBuff and zone > 2930) {
					getBuff(imgMax, hasBomberBuff, skillSearch)
				} else if (!hasGogBuff and zone > 3210) {
					getBuff(imgGog, hasGogBuff, skillSearch)
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
				; ... when we can afford to do so
				ctrlClick(xBtn, yBtn, 2, 1, 1)
			} else if (!earlyGameMode and gildedRanger and !matchPixelColor(goldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
				if (!matchPixelColor(brightGoldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
					; ... or not, lost sight of our gilded hero
					showTraceSplash("Lost sight of our gilded hero!")
					clickAwayImage(imgCombatTab)
					isResuming := true
				}
			}
		}
		zone := getCurrentZone()
		t += 1
		sleep 1000

	} until zone > getEndZone()

	if (earlyGameMode) {
		maxLevels() ; get some extra souls from levels
	}

	SetTimer, nextZoneTimer, off
	SetTimer, betaWarningTimer, off ; TODO: REMOVE AFTER BETA
	SetTimer, zoneTickTimer, off

	if (useZoneDataLogger) {
		logZoneData(zdlStart, zone, zdlInterval)
	}
	zoneTicks := ""

	SetTimer, comboTimer, off
	clickerStop()
	stopProgress()
	stopMonitoring()

	elapsedTime := (A_TickCount - startTime) / 1000
	showSplash("Vision Run duration: " . formatSeconds(elapsedTime))
}

ascendNow(ascendZone) {
	global
	showDebugSplash("Ascend Warning!")
	endLvlIdle := ascendZone
	endLvlActive := ascendZone
}

setGameMode(newGameMode) {
	global
	showTraceSplash(gameMode . " --> " . newGameMode . " @ Lvl " . getCurrentZone())
	gameMode := newGameMode
}

startFarming() {
	global
	scrollToZone(zoneTicks.MaxIndex()) ; scroll to max
	farmZone := getCurrentZone()
	showDebugSplash("Farm @ Lvl " . farmZone . " for " . farmTime . "s")
	setFarmMode()
	setGameMode("FARMING")
	SetTimer, farmTimer, % -farmTime * 1000
}

isActiveZone(zone) {
	global
	if (zone <= endLvlActive) {
		if (endLvlIdle < endLvlActive and zone <= endLvlIdle) {
			return false
		}
		return true
	}
	return false
}

getBuff(image, byref hasBuff, byref skillSearch) {
	scrollToBottom()
	if (upLocator(image, image.file, xImg, yImg)) {
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
	ControlSend,, {shift down}{vk51 down}, ahk_id %chWinId% ; {q}, {vk51} or {sc010}
	loop 9 ; pages
	{
		loop 10 ; attempts per page
		{
			if (locateImage(imgMaxLvl, xButton, yButton)) {
				clickPos(xButton, yButton, 1, 1)
			}
			sleep 300
		}
		scrollDown(5)
	}
	ControlSend,, {vk51 up}{shift up}, ahk_id %chWinId%
}

loopSpeedRun() {
	global
	local mode := hybridMode ? "Hybrid" : "Speed"
	showUserSplash("Starting " . mode . " Runs!")

	if (isBrowserClient()) {
		logVariable("browser", browser)
		logVariable("browserTopMargin", browserTopMargin)
	}
	logVariable("useImageSearch", useImageSearch, true)
	logVariable("gildedRanger", rangers[gildedRanger])
	logVariable("speedRunTime", speedRunTime)
	logVariable("firstStintAdjustment", firstStintAdjustment)
	logVariable("firstStintButton", firstStintButton)
	logVariable("deepRunClicks", deepRunClicks, true)
	logVariable("hybridMode", hybridMode, true)
	if (hybridMode) {
		logVariable("deepRunTime", deepRunTime)
		logArray("deepRunCombo", deepRunCombo)
		logVariable("clickableHuntDelay", clickableHuntDelay)
		logVariable("stopHuntThreshold", stopHuntThreshold)
	}
	logVariable("clickerDuration", clickerDuration)
	logVariable("saveBeforeAscending", saveBeforeAscending, true)
	logVariable("autoAscend", autoAscend, true)

	loop
	{
		showDebugSplash("Clickable start")
		getClickable()
		sleep % coinPickUpDelay * 1000
		initRun()
		speedRun()
		if (hybridMode) {
			deepRun()
		}
		if (saveBeforeAscending) {
			save()
		}
		ascend(autoAscend)
		handleScheduledStop()
		handleScheduledReload("loopSpeedRun")
	}
}

; All heroes/rangers are expected to "insta-kill" everything at max speed (i.e. around
; 7 minutes per 250 levels). Only the last 2-3 minutes should slow down slightly.
speedRun() {
	global

	local startTime := A_TickCount
	local stint := 0
	local stints := 0
	local tMax := 7 * 60 ; seconds
	local lMax := 250 ; zones

	local lvlAdjustment := round(firstStintAdjustment * lMax / tMax)
	local zoneLvl := gildedRanger * lMax + lvlAdjustment ; approx zone lvl where we can buy our gilded ranger @ lvl 150

	local firstStintTime := 0
	if (zoneLvl > 0)
	{
		firstStintTime := ceil(zoneLvl * tMax / lMax)
		stints += 1
	}

	local srDuration := speedRunTime * 60
	local totalClickDelay := nextHeroDelay * stints
	local lastStintTime := srDuration - firstStintTime - totalClickDelay
	stints += 1

	local lastStintButton := gildedRanger = 14 ? 3 : 2 ; special case for Wepwawet

	showSplash("Starting Speed Run")

	logVariable("zoneLvl", zoneLvl)
	logVariable("firstStintTime", formatSeconds(firstStintTime))
	logVariable("lastStintTime", formatSeconds(lastStintTime))

	scrollToBottom()
	toggleMode() ; toggle to progression mode
	if (firstStintTime > 0) {
		lvlUp(firstStintTime, 1, firstStintButton, ++stint, stints)
		scrollWayDown(6)
	}
	lvlUp(lastStintTime, 1, lastStintButton, ++stint, stints)

	local elapsedTime := (A_TickCount - startTime) / 1000
	showSplash("Speed Run duration: " . formatSeconds(elapsedTime))
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global
	exitThread := false

	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run Progress (" . stint . "/" . stints . ")"

	startMonitoring()
	startProgress(title, 0, seconds // barUpdateDelay)
	showDebugSplash(title . " @ Lvl " . getCurrentZone())

	if (buyUpgrades) {
		ctrlClick(xLvl, y)
		buyAvailableUpgrades()
	}
	maxClick(xLvl, y)

	local t := 0

	loop % seconds
	{
		if (exitThread) {
			stopProgress()
			stopMonitoring()
			showUserSplash("Speed Run aborted!")
			exit
		}
		; Close possible auto-opened buy more rubies window
		if (mod(t, 60) = 0) {
			clickPos(xBuyRubiesClose, yBuyRubiesClose)
		}
		if (t = 30) {
			buyAvailableUpgrades() ; safety upgrade
		}
		if (mod(t, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y, 1, 0)
		}
		t += 1
		updateProgress(t // barUpdateDelay, seconds - t)
		sleep 1000
	}
	stopProgress()
	stopMonitoring()
}

deepRun() {
	global
	exitThread := false

	local startTime := A_TickCount
	local drDuration := deepRunTime * 60
	local button := gildedRanger = 14 ? 3 : 2 ; special case for Wepwawet
	local y := yLvl + oLvl * (button - 1)

	showSplash("Starting Deep Run")

	startMonitoring()
	startProgress("Deep Run Progress", 0, drDuration // barUpdateDelay)
	clickerStart()

	local comboDelay := deepRunCombo[1]
	local comboIndex := 2
	local stopHuntIndex := drDuration - stopHuntThreshold * 60

	local t := 0

	loop % drDuration
	{
		if (exitThread) {
			clickerStop()
			stopProgress()
			stopMonitoring()
			showUserSplash("Deep Run aborted!")
			exit
		}
		; Close possible auto-opened buy more rubies window
		if (mod(t, 60) = 0) {
			clickPos(xBuyRubiesClose, yBuyRubiesClose)
		}
		if (deepRunClicks) {
			clickPos(xMonster, yMonster)
		}
		if (mod(t, comboDelay) = 0) {
			activateSkills(deepRunCombo[comboIndex])
			comboIndex := comboIndex < deepRunCombo.MaxIndex() ? comboIndex+1 : 2
		}
		if (mod(t, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y, 1, 0)
		}
		if (mod(t, clickableHuntDelay) = 0 and t < stopHuntIndex) {
			getClickable()
		}
		t += 1
		updateProgress(t // barUpdateDelay, drDuration - t)
		sleep 1000
	}

	clickerStop()
	stopProgress()
	stopMonitoring()

	local elapsedTime := (A_TickCount - startTime) / 1000
	showSplash("Deep Run duration: " . formatSeconds(elapsedTime))
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

getClickerStatus() {
	return sendClickerMsg(WM_CLICKER_STATUS, 1)
}

sendClickerMsg(msg, wait:=0) {
	global
	local reply := 0
	if (deepRunClicks) {
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
	}
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

openAncientsOptimizer() {
	global

	local templateFileName := "system\ancients_optimizer_loader.html"
	FileRead, loaderSourceTemplate, %templateFileName%

	local loaderFileName := A_Temp . "\ch_ao_" . A_NowUTC . ".html"
	local file = FileOpen(loaderFileName, "w")
	if !IsObject(file)
	{
		MsgBox % "Can't open " . loaderFileName . " for writing."
		return
	}

	openSaveDialog()

	; Abort saving. Clipboard is good enough
	ControlSend,, {esc}, ahk_class %dialogBoxClass%

	sleep % zzz * 3
	clickPos(xSettingsClose, ySettingsClose)

	; Write loader file
	local loaderSource := StrReplace(loaderSourceTemplate, "#####SAVEGAME#####", Clipboard)

	file.write(loaderSource)
	file.Close()

	Run, %loaderFileName%
	sleep % zzz * 5
	FileDelete, %loaderFileName%
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
	toggleMode()

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
		if (screenShotRelics || displayRelicsDuration > 0) {
			clickPos(xRelic, yRelic) ; focus (will show the upgrade screen in 0.23)
		}

		if (screenShotRelics) {
			screenShot()
		}

		if (displayRelicsDuration > 0) {
			showWarningSplash("Salvaging junk in " . displayRelicsDuration . " seconds! (Abort with Alt+Pause)", displayRelicsDuration)
			if (exitThread) {
				exitThread := false
				showUserSplash("Salvage aborted!")
				exit
			}
		}

		if (screenShotRelics || displayRelicsDuration > 0) {
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

; Move all gilds to given ranger
regild(ranger) {
	global
	switchToCombatTab()
	scrollToBottom()

	clickPos(xGilded, yGilded)
	sleep % zzz * 2

	clickPos(xGildedDown, yGildedDown, top2BottomClicks)
	sleep % scrollDelay + top2BottomClicks * scrollClickDelay

	ControlSend,, {q down}, ahk_id %chWinId%
	clickPos(rangerPositions[ranger].x, rangerPositions[ranger].y)
	sleep 1000
	ControlSend,, {q up}, ahk_id %chWinId%

	clickPos(xGildedClose, yGildedClose)
	sleep % zzz * 2
}

; Toggle between farm and progression modes
toggleMode(toggle:=1) {
	global
	if (toggle) {
		ControlSend,, {vk41}, ahk_id %chWinId% ; {a}, {vk41} or {sc01E}
		; clickPos(xMode, yMode)
		sleep % zzz
	}
}

setFarmMode() {
	global
	if (!manualProgression and locateImage(imgProgression)) {
		toggleMode()
		showTraceSplash("Set Farm Mode")
	}
}

setProgressionMode() {
	global
	if (!manualProgression and !locateImage(imgProgression)) {
		toggleMode()
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
	if (useImageSearch) {
		setTimer, checkWindowVisibility, 20000
	}
}

stopMonitoring() {
	global
	setTimer, checkMousePosition, off
	if (useImageSearch) {
		setTimer, checkWindowVisibility, off
	}
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
		if (function = "loopSpeedRun") {
			loopSpeedRun()
		} else if (function = "loopVisionRun") {
			loopVisionRun()
		}
	}
}

hasClickable() {
	global
	return useImageSearch ? locateImage(imgClickable) : 0
}

; Try to find the first gilded hero/ranger we can lvl up
locateGilded(byref xPos, byref yPos, byref isNew, startAt:=0, silent:=0) {
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

	if (useImageSearch) {
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
				playNotificationSound()
				if (useImageSearch and locateImage(imgProgression)) {
					msgbox,,% script,Click safety pause engaged. Resume?
					clickAwayImage(imgCombatTab)
					isResuming := true
					reFocus()
				} else {
					msgbox,,% script,Click safety pause engaged. Continue?
				}
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
	local oldTick := A_TickCount - 10000 ; 10s back in time
	local t1 := zoneTicks.HasKey(z1) ? zoneTicks[z1] : oldTick
	local t2 := zoneTicks.HasKey(z2) ? zoneTicks[z2] : oldTick
	return abs(t1 - t2) / 1000
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

bossFight() {
	setGameMode("FIGHTING")
	SetTimer, bossTimer, % -30 * 1000
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
	activateSkills(deepRunCombo[comboIndex])
	comboIndex := comboIndex < deepRunCombo.MaxIndex() ? comboIndex+1 : 2
return

clickerStopTimer:
	clickerStop()
return

farmTimer:
	setProgressionMode()
	bossFight()
return

bossTimer:
	setGameMode("PROGRESSING")
return

zoneTickTimer:
	storeZoneTick()
return

nextZoneTimer:
	nextZone()
return

betaWarningTimer:
	; If any, close auto-opened beta warning window
	if (locateImage(imgWarning)) {
		clickAwayImage(imgClose)
	}
return
