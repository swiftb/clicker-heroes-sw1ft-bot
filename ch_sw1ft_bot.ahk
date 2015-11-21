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
scriptVersion=3.x
minLibVersion=1.4

script := scriptName . " v" . scriptVersion

clickerName := "monster_clicker.ahk - AutoHotkey"

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

if (useConfigurationAssistant) {
	configurationAssistant()
}

clientCheck()

if (deepRunClicks) {
	Run, "%A_ScriptDir%\monster_clicker.ahk",, UseErrorLevel
	if (ErrorLevel != 0) {
		playWarningSound()
		msgbox,,% script,% "Failed to auto-start monster_clicker.ahk (system error code = " . A_LastError . ")!"
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

; Start the Speed run loop with Ctrl+F1
^F1::
	loopSpeedRun()
return

; Start a Deep run with Ctrl+F2 (expecting to start where a Speed run finishes)
^F2::
	deepRun()
return

; Start a Vision run loop with Ctrl+F3
^F3::
	loopVisionRun()
return

; Pause/unpause the script
Pause::Pause
return

; Abort any active run or initiated ascension with Alt+Pause
!Pause::
	showSplashAlways("Aborting...")
	exitThread := true
return

; Schedule a stop after finishing the current run with Shift+Pause
+Pause::
	toggleFlag("scheduleStop", scheduleStop)
return

; Reload the script (needed after configuration changes)
!F5::
	critical
	global scheduleReload := true
	handleScheduledReload()
return

; Schedule a script reload after finishing the current run, then restart it
+^F5::
	toggleFlag("scheduleReload", scheduleReload)
return

; Re-initialize coordinates (needed after moving or re-sizing the client window)
!F6::
	critical
	clientCheck()
	clickerInitialize()
return

; -- Supplementary Hotkeys ----------------------------------------------------------------

; Suspend/Unsuspend all other Hotkeys with Ctrl+Esc
^Esc::Suspend, Toggle
return

; Open the Ancients Optimizer and auto-import game save data
^F5::
	critical
	openAncientsOptimizer()
return

; Set previous ranger as re-gild target
^F6::
	reGildRanger := reGildRanger > rangers.MinIndex() ? reGildRanger-1 : reGildRanger
	showSplashAlways("Re-gild ranger set to " . rangers[reGildRanger])
return

; Set next ranger as re-gild target
^F7::
	reGildRanger := reGildRanger < rangers.MaxIndex() ? reGildRanger+1 : reGildRanger
	showSplashAlways("Re-gild ranger set to " . rangers[reGildRanger])
return

; Move "reGildCount" gilds to the target ranger
^F8::
	critical
	playNotificationSound()
	msgbox, 4,% script,% "Move " . reGildCount . " gilds to " . rangers[reGildRanger] . "?"
	ifmsgbox no
		return
	clickerPause()
	regild(reGildRanger, reGildCount)
return

; Open new gilds
^F9::
	critical
	clickerPause()
	openNewGilds()
return

; Autosave the game
^F11::
	critical
	save()
return

; Raid once for free with Win+F6
#F6::
	critical
	raid()
return

; One paid raid
#F7::
	critical
	raid(1)
return

; Paid raids
#F8::
	critical
	raid(1, raidAttempts)
return

; Toggle boolean (true/false) flags with Shift+Ctrl+Fx

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F2::
	toggleFlag("screenShotRelics", screenShotRelics)
return

+^F6::
	toggleFlag("playNotificationSounds", playNotificationSounds)
return

+^F7::
	toggleFlag("playWarningSounds", playWarningSounds)
return

+^F8::
	toggleFlag("showSplashTexts", showSplashTexts)
return

+^F11::
	toggleFlag("saveBeforeAscending", saveBeforeAscending)
return

+^F12::
	toggleFlag("debug", debug)
return

; -- Test Hotkeys -------------------------------------------------------------------------

; Ctrl+Alt+F1 should scroll down to the bottom
^!F1::
	scrollToBottom()
return

; Ctrl+Alt+F2 should switch to the relics tab and then back
^!F2::
	switchToRelicTab()
	switchToCombatTab()
return

; Alt+F1 to F4 are here to test the individual parts of the full speed run loop

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

; Test one Midas start with Win+F1
#F1::
	midasStart()
return

; Loop Midas start > init run > ascend, twice
#F2::
	loop 2
	{
		midasStart()
		initRun()
		ascend(autoAscend)
	}
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
	if (locator(image, image.file, x, y, clickCount, 1)) {
		msgbox,,% script,% "Success! (" . x . ", " . y . ")"
	} else {
		msgbox,,% script,% "Failed!"
	}
}

; Image search tests
#F3::
	msgbox,,% script,% "After clickable/Midas start state expected."
	testSearch(imgQuality, "Set high quality")
	testSearch(imgSmile, "Set low quality")
	testSearch(imgProgression, "Toggle progression mode")
	testSearch(imgClickable)
	switchToCombatTab()
	testSearch(imgCombat)
	testSearch(imgHire)
	testSearch(imgCoin)
	testSearch(imgDimmedSkill, "Lvl someone to 1")
	testSearch(imgSkill, "Lvl someone to 10")
	testLocate(imgCid)
	testSearch(imgClickstorm, "Buy Cid's skill")
	testSearch(imgSkillBar)
	testSearch(imgSkillLocked)
	testLocate(imgMercedes)
	testLocate(imgReferi, 2)
	testSearch(imgMetalDetector, "Lvl Broyle to 100")
	testSearch(imgGoldenClicks, "Lvl Midas to 100")
	testLocate(imgDK)
	testSearch(imgFrigidEnchant, "Lvl Frostleaf to 100")

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

; Automatically configure initDownClicks and yLvlInit settings.
configurationAssistant() {
	global

	if (irisLevel < 145) {
		playWarningSound()
		msgbox,,% script,% "Your Iris do not fulfill the minimum level requirement of 145 or higher!"
		exit
	}

	if (irisThreshold(2010)) { ; Astraea
		initDownClicks := [6,5,6,5,6,3]
		yLvlInit := 241
	} else if (irisThreshold(1760)) { ; Alabaster
		initDownClicks := [6,6,6,5,6,3]
		yLvlInit := 227
	} else if (irisThreshold(1510)) { ; Cadmia
		initDownClicks := [6,6,6,6,6,3]
		yLvlInit := 240
	} else if (irisThreshold(1260)) { ; Lilin
		initDownClicks := [6,6,6,6,6,3]
		yLvlInit := 285
	} else if (irisThreshold(1010)) { ; Banana
		initDownClicks := [6,7,6,7,6,3]
		yLvlInit := 240
	} else if (irisThreshold(760)) { ; Phthalo
		initDownClicks := [6,7,7,6,7,3]
		yLvlInit := 273
	} else if (irisThreshold(510)) { ; Terra
		initDownClicks := [7,7,7,7,7,3]
		yLvlInit := 240
	} else if (irisThreshold(260)) { ; Atlas
		initDownClicks := [7,7,7,8,7,3]
		yLvlInit := 273
	} else { ; Dread Knight
		initDownClicks := [7,8,7,8,7,4]
		yLvlInit := 257
	}

	if (irisLevel < optimalLevel - 1001) {
		local levels := optimalLevel - 1001 - irisLevel
		playNotificationSound()
		msgbox,,% script,% "Your Iris is " . levels . " levels below the recommended ""optimal level - 1001"" rule."
	}
}

; Check if Iris is within a certain threshold that can cause a toggling behaviour between different settings
irisThreshold(lvl) {
	global
	local upperThreshold := lvl + 19
	local lowerThreshold := lvl - 20
	if (irisLevel >= lowerThreshold and irisLevel < upperThreshold) {
		playWarningSound()
		msgbox,,% script,% "Threshold proximity warning! You should level up your Iris to " . upperThreshold . " or higher."
	}
	return irisLevel > lvl
}

; Level up and upgrade all heroes
initRun() {
	global
	local hasLeveledHeroes := false

	switchToCombatTab()
	reFocus()

	if (!useImageSearch) {
		if (initPlanB) {
			local clicks := irisLevel > 1600 ? 6 : 7
			loop 6
			{
				upgrade2(2)
				scrollDown(clicks)
			}
			upgrade2()
		} else {
			upgrade(initDownClicks[1],2,,2) ; cid --> brittany
			upgrade(initDownClicks[2]) ; fisherman --> leon
			upgrade(initDownClicks[3]) ; seer --> mercedes
			upgrade(initDownClicks[4],,,,2) ; bobby --> king
			upgrade(initDownClicks[5],2,,,2) ; ice --> amenhotep
			upgrade(initDownClicks[6],,,2) ; beastlord --> shinatobe
			upgrade(0,,,,,true) ; grant & frostleaf
		}
	} else {
		local foundDK := false
		local xButton, yButton, xDK, yDK, x

		locateImage(imgCoin, xButton, yButton) ; get a x coordinate for the hire/lvl up buttons

		loop 9 ; pages
		{
			foundDK := locateImage(imgDK, xDK, yDK)
			loop 5 ; attempts per page
			{
				if (locateImage(imgDimmedSkill, x, yButton)
						or locateImage(imgHire, x, yButton)) {
					if (foundDK and yButton > yDK) {
						; Don't level anything below Frostleaf
						continue
					}
					ctrlClick(xButton, yButton, 2, 1, 1)
				} else {
					break
				}
			}
			if (foundDK) {
				if (locateImage(imgFrigidEnchant)) {
					hasLeveledHeroes := true
				}
				break
			}
			scrollDown(5)
		}
	}
	scrollToBottom()
	buyAvailableUpgrades()

	return useImageSearch ? hasLeveledHeroes and locateImage(imgSkillBar) and !locateImage(imgSkillLocked) : 1
}

upgrade(times, cc1:=1, cc2:=1, cc3:=1, cc4:=1, skip:=false) {
	global

	if (!skip) {
		ctrlClick(xLvl, yLvlInit, cc1)
		ctrlClick(xLvl, yLvlInit + oLvl, cc2)
	}
	ctrlClick(xLvl, yLvlInit + oLvl*2, cc3)
	ctrlClick(xLvl, yLvlInit + oLvl*3, cc4)

	scrollDown(times)
}

upgrade2(clickCount:=1) {
	global
	local y := 213

	loop
	{
		ctrlClick(xLvl, y, clickCount)
		y += 74
	} until y > 669
}

midasStart() {
	global

	local xl := xLvl
	local yl := yLvl - 10

	local midasZone1 := midasZoneConfig[1]
	local midasDelay1 := midasZoneConfig[2]

	local midasExtraZone := midasZoneConfig[3]
	local midasExtraDelay := midasZoneConfig[4]

	local midasZone2 := midasZoneConfig[5]
	local midasDelay2 := midasZoneConfig[6]

	local fromZone := midasExtraZone > 0 ? midasExtraZone : midasZone1

	switchToCombatTab()
	startMonitoring()
	reFocus()

	if (!useImageSearch) {
		loop 3 {
			clickPos(xMonster, yMonster) ; Break idle
			sleep 30
		}
		scrollToZone(1, midasZone1)
		ctrlClick(xl, yl) ; Cid x 100
		clickPos(xSkill + oSkill, ySkillTop) ; Clickstorm
		sleep % zzz

		scrollToBottom()
		clickPos(xl, yl+oLvl) ; Natalia
		sleep % midasDelay1 * 1000
		ctrlClick(xl, yl+oLvl) ; Natalia x 100

		if (midasExtraZone > 0) {
			scrollToZone(midasZone1, midasExtraZone)
			horizontalSkills(xSkill, ySkill2nd, 4)
			sleep % midasExtraDelay * 1000
		}
		scrollDown(8)
		scrollToZone(fromZone, midasZone2)
		ctrlClick(xl, yl+oLvl) ; Broyle x 100
		sleep % midasDelay2 * 1000
		ctrlClick(xl, yl+oLvl*3) ; Midas x 100
		verticalSkills(xSkill + oSkill*4) ; Metal Detector + Golden Clicks

		toggleMode()
		activateSkills("1-4-5")
		sleep % coinPickUpDelay * 1000
	} else {
		if (locateImage(imgProgression)) {
			showDebugSplash("Toggle farm mode")
			toggleMode()
		}
		scrollToZone(1, midasZone1)
		locator(imgCid, "Cid", xl, yl)
		buySkill(imgClickstorm, xl-137, yl+60, 2, 7)

		scrollToBottom()
		upLocator(imgCoin, "Coin", xl, yl)
		ctrlClick(xl, yl, 1, 1, 1)
		sleep % midasDelay1 * 1000
		ctrlClick(xl, yl, 1, 1, 1)
		if (midasExtraZone > 0) {
			scrollToZone(midasZone1, midasExtraZone)
			sleep % midasExtraDelay * 1000
			ctrlClick(xl, yl, 1, 1, 1)
		}
		if (locateImage(imgMercedes)) {
			scrollDown(8)
		} else {
			showDebugSplash("Unknown location, relocating...")
			switchToCombatTab()
			scrollDown(18)
		}
		scrollToZone(fromZone, midasZone2)
		locator(imgReferi, "Referi", xl, yl, 2)
		xl -= 155
		yl += 60
		buySkill(imgMetalDetector, xl, yl-oLvl*3, 5, 5)
		sleep % midasDelay2 * 1000
		buySkill(imgGoldenClicks, xl, yl-oLvl, 5, 6)

		toggleMode()
		activateSkills("1-4-5")
		sleep % coinPickUpDelay * 1000
		zClick(xl, yl-oLvl, 1, 1) ; Midas 125
	}
	stopMonitoring()
}

buySkill(image, xLvlUp, yLvlUp, skill, skills) {
	global
	local xSkill, ySkill
	; msgbox % image.file . " (" . xLvlUp . ", " . yLvlUp . ")"
	if (!locateImage(image) or locateImage(imgSkillLocked)) {
		reFocus()
		ctrlClick(xLvlUp, yLvlUp, 1, 1, 1) ; x 100
		zClick(xLvlUp, yLvlUp, 2, 1) ; x 50
		loop 5
		{
			if (locateImage(imgDimmedSkill)) {
				sleep 2500
			}
			if (locateImage(image, xSkill, ySkill)) {
				clickPos(xSkill, ySkill, 1, 1)
				sleep % zzz
				horizontalSkills(xSkill - oSkill*(skill-1), ySkill, skills, 1)
				break
			} else {
				sleep 2500
				zClick(xLvlUp, yLvlUp, 2, 1)
			}
		}
	}
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
	if (!locateImage(imgProgression) and getCurrentZone() < irisLevel) {
		return 1 ; ready to start
	}
	if (getCurrentZone() < getEndZone()) {
		return 2 ; ready for progression
	} else {
		return 3 ; ready to ascend
	}
}

loopVisionRun() {
	global
	local state := 0
	showSplash("Starting vision runs...")

	loop
	{
		state := getState()
		if (state < 1) {
			showWarningSplash("Start failed (state = " . state . ")! Trying again...")
			clientCheck()
			clickerInitialize()
			continue
		}
		if (state = 1) {
			if (hasClickable()) {
				showDebugSplash("(1) Clickable start...")
				getClickable(useImageSearch)
				sleep % coinPickUpDelay * 1000
				switchToCombatTab()
				ctrlClick(xLvl, yLvl+oLvl) ; Force progression
				toggleMode()
			} else {
				showDebugSplash("(1) Midas start...")
				midasStart()
			}
		}
		if (getState() = 2) {
			showDebugSplash("(2) Progressing...")
			visionRun()
		}
		if (getState() = 3) {
			showDebugSplash("(3) Ascending...")
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

	showSplash("Starting vision run...", 1, 0)
	startMonitoring()
	reFocus()
	
	local isInitiated := false
	local isClickerRunning := false
	local hasActivatedSkills := false

	local xBtn := 0, yBtn := 0, isNew := 0
	local xSkill := 0, ySkill := 0, skillSearch := false

	local zone := getCurrentZone()
	local startZone := zone
	local initZone := 145
	local endZone := getEndZone()
	local stopHuntZone := endZone - ceil(stopHuntThreshold * 250 / 7)

	local t := 0

	local comboDelay := deepRunCombo[1]
	comboIndex := 2

	startProgress("Vision Run", zone // barUpdateDelay, endZone // barUpdateDelay)

	loop
	{
		if (exitThread) {
			SetTimer, comboTimer, off
			clickerStop()
			stopProgress()
			stopMonitoring()
			showSplashAlways("Vision run aborted!")
			exit
		}
		; Traverse bottom up till we find the first gilded hero/ranger we can lvl up
		if (mod(t, 90) = 0 or isResuming) {
			if (locateGilded(xBtn, yBtn, isNew)) {
				maxClick(xBtn, yBtn, 1, 1)
				if (isNew) {
					showDebugSplash("New gilded hero found")
					sleep % coinPickUpDelay
					buyAvailableUpgrades()
				}
				skillSearch := true
				isResuming := false
			}
		}
		if (mod(t, 15) = 0) {
			; Make sure we are progressing
			if (!locateImage(imgProgression)) {
				showDebugSplash("Toggle progression mode")
				toggleMode()
			}
			if (!isInitiated and zone > initZone) {
				; If enough gold, run init
				showDebugSplash("Initializing...")
				isInitiated := initRun()
				isResuming := true
			}
		}
		zone := getCurrentZone()
		; Active zone?
		if (zone > endLvlIdle) {
			if (deepRunClicks) {
				if (!isClickerRunning) {
					; Yup, start hammering!
					showDebugSplash("Start external clicker")
					clickerStart() ; ~38 CPS
					isClickerRunning := true
					Gosub, comboTimer
					SetTimer, comboTimer, % comboDelay * 1000 + 1000
				}
				clickPos(xMonster, yMonster) ; Jugg combo safety click
				sleep 30
			}
		; If option enabled, activate skills once at start
		} else if (zone = startZone and activateSkillsAtStart and !hasActivatedSkills and isInitiated) {
			showDebugSplash("Activate skills at start")
			activateSkills(speedRunStartCombo[2])
			hasActivatedSkills := true
		}
		; Level up...
		if (mod(t, lvlUpDelay) = 0) {
			if (matchPixelColor(blueColor, xBtn+xWinPos, yBtn+yWinPos)) {
				if (skillSearch) {
					; Aquire possible new skills
					while (locateImage(imgSkill, xSkill, ySkill)) {
						clickPos(xSkill, ySkill, 1, 1)
						sleep % 500
					}
					if (!locateImage(imgDimmedSkill)) {
						skillSearch := false
					}
				}
				; ... when we can afford to do so
				ctrlClick(xBtn, yBtn, 1, 1, 1)
			} else if (!matchPixelColor(goldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
				if (!matchPixelColor(brightGoldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
					; ... or not, lost sight of our gilded hero
					showDebugSplash("Lost sight of our gilded hero")
					isResuming := true
				}
			}
		}
		; Let's go fishing!
		if (mod(t, clickableHuntDelay) = 0 and zone < stopHuntZone) {
			getClickable(useImageSearch)
		}
		t += 1
		updateProgress(zone // barUpdateDelay, endZone - zone, 1) ; show lvls remaining
		sleep 1000
	} until zone >= endZone

	SetTimer, comboTimer, off
	clickerStop()
	stopProgress()
	stopMonitoring()

	showSplash("Vision run completed.")
}

loopSpeedRun() {
	global
	local mode := hybridMode ? "hybrid" : "speed"
	showSplash("Starting " . mode . " runs...")
	loop
	{
		if (useMidasStart) {
			midasStart()
			getClickable()
		} else {
			getClickable()
			sleep % coinPickUpDelay * 1000
		}
		initRun()
		if (activateSkillsAtStart) {
			activateSkills(speedRunStartCombo[2])
		}
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

	local stint := 0
	local stints := 0
	local tMax := 7 * 60 ; seconds
	local lMax := 250 ; zones

	local lvlAdjustment := round(firstStintAdjustment * lMax / tMax)
	local zoneLvl := gildedRanger * lMax + lvlAdjustment ; approx zone lvl where we can buy our gilded ranger @ lvl 150
	local lvls := zoneLvl - irisLevel ; lvl's to get there

	local firstStintButton := 1
	local firstStintTime := 0
	local midStintTime := 0

	if (lvls > lMax + 2*60*lMax/tMax) ; add a mid stint if needed
	{
		midStintTime := tMax
		lvls -= lMax
		stints += 1
	} else if (lvls > lMax) {
		firstStintButton := 2
	}
	
	if (lvls > 0)
	{
		firstStintTime := ceil(lvls * tMax / lMax)
		stints += 1
	}

	local srDuration := speedRunTime * 60
	local totalClickDelay := nextHeroDelay * stints
	local lastStintTime := srDuration - firstStintTime - midStintTime - totalClickDelay
	stints += 1

	local lastStintButton := gildedRanger = 9 ? 3 : 2 ; special case for Astraea

	if (debug)
	{
		local nl := "`r`n"
		local s := "    " ; Reddit friendly formatting
		local output := ""
		output .= s . "irisLevel = " . irisLevel . nl
		output .= s . "optimalLevel = " . optimalLevel . nl
		output .= s . "speedRunTime = " . speedRunTime . nl
		if (hybridMode) {
			output .= s . "deepRunTime = " . deepRunTime . nl
		}
		output .= s . "gildedRanger = " . rangers[gildedRanger] . nl
		output .= s . "-----------------------------" . nl
		output .= s . "initDownClicks = "
		for i, e in initDownClicks {
			output .= e " "
		}
		output .= nl
		output .= s . "yLvlInit = " . yLvlInit . nl
		output .= s . "firstStintAdjustment = " . firstStintAdjustment . "s" . nl
		output .= s . "-----------------------------" . nl
		output .= s . "lvlAdjustment = " . lvlAdjustment . nl
		output .= s . "zoneLvl = " . zoneLvl . nl
		output .= s . "lvls = " . lvls . nl
		output .= s . "firstStintButton = " . firstStintButton . nl
		output .= s . "firstStintTime = " . formatSeconds(firstStintTime) . nl
		output .= s . "midStintTime = " . formatSeconds(midStintTime) . nl
		output .= s . "lastStintTime = " . formatSeconds(lastStintTime) . nl
		output .= s . "totalClickDelay = " . formatSeconds(totalClickDelay) . nl

		clipboard := % output
		msgbox % output
		return
	}

	showSplash("Starting speed run...")

	if (irisLevel < 2 * lMax + 10) ; Iris high enough to start with a ranger?
	{
		switchToCombatTab()
		scrollDown(initDownClicks[1])
		toggleMode(!useMidasStart) ; toggle to progression mode
		lvlUp(firstStintTime, 0, 3, ++stint, stints) ; nope, let's bridge with Samurai
		scrollToBottom()
	} else {
		scrollToBottom()
		toggleMode(!useMidasStart) ; toggle to progression mode
		if (firstStintTime > 0) {
			lvlUp(firstStintTime, 1, firstStintButton, ++stint, stints)
			scrollWayDown(3)
		}
	}
	if (midStintTime > 0) {
		lvlUp(midStintTime, 1, 2, ++stint, stints)
		scrollWayDown(2)
	}
	lvlUp(lastStintTime, 1, lastStintButton, ++stint, stints)

	showSplash("Speed run completed.")
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global
	exitThread := false

	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run Progress (" . stint . "/" . stints . ")"

	startMonitoring()
	startProgress(title, 0, seconds // barUpdateDelay)

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
			showSplashAlways("Speed run aborted!")
			exit
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

	local drDuration := deepRunTime * 60
	local button := gildedRanger = 9 ? 3 : 2 ; special case for Astraea
	local y := yLvl + oLvl * (button - 1)

	showSplash("Starting deep run...")

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
			showSplashAlways("Deep run aborted!")
			exit
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

	showSplash("Deep run ended.")
}

clickerStart() {
	sendClickerMsg(WM_CLICKER_START)
}

clickerPause() {
	sendClickerMsg(WM_CLICKER_PAUSE)
}

clickerStop() {
	sendClickerMsg(WM_CLICKER_STOP)
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
				showWarningSplash("SendMessage failed! monster_clicker.ahk started?")
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
				showSplashAlways("Ascension aborted!")
				exit
			}
		}
	} else {
		playWarningSound()
		msgbox, 260,% script,Salvage Junk Pile & Ascend? ; default no
		ifmsgbox no
			exit
	}

	salvageJunkPile() ; must salvage junk relics before ascending
	toggleMode()

	clickPos(xAscend, yAscend) ; 0.23 ascend button
	sleep % zzz * 4
	clickPos(xYes, yYes)
	sleep % zzz * 2

	stopMonitoring()
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
				showSplashAlways("Salvage aborted!")
				exit
			}
		}

		if (screenShotRelics || displayRelicsDuration > 0) {
			clickPos(xUpgradeNo, yUpgradeNo) ; don't upgrade
			sleep % zzz
			clickPos(xRelic+100, yRelic) ; remove focus
		}
	}

	clickPos(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	clickPos(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
}

buyAvailableUpgrades() {
	global
	clickPos(xBuy, yBuy)
	sleep % zzz * 3
}

openNewGilds() {
	global

	clickPos(xNewGild, yNewGild, 100)
	sleep 3000
	clickPos(xOpenGild, yOpenGild)
	sleep 2000
	clickPos(xCloseGild, yCloseGild)
	sleep 250
}

raid(doSpend:=0, attempts:=1) {
	global
	local xBtn := 0, yBtn := 0, raidDuration := 34 * 1000
	local isClickerRunning := getClickerStatus()

	switchToClanTab()
	sleep 1000
	clickAwayImage(imgClanRaid)

	if (!isClickerRunning) {
		clickerStart()
		sleep 2500
	}
	loop % attempts
	{
		if (clickAwayImage(imgClanCollect)) {
			break
		}
		if (doSpend) {
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
	}
	if (!isClickerRunning) {
		clickerStop()
	}
}

clickAwayImage(image) {
	if (locateImage(image)) {
		while (locateImage(image, x, y)) {
			clickPos(x, y, 1, 1)
			sleep 250
		}
		sleep 1000
		return 1
	}
	return 0
}

; Move "gildCount" gilds to given ranger
regild(ranger, gildCount) {
	global
	switchToCombatTab()
	scrollToBottom()

	clickPos(xGilded, yGilded)
	sleep % zzz * 2

	clickPos(xGildedDown, yGildedDown, top2BottomClicks)
	sleep % scrollDelay + top2BottomClicks * scrollClickDelay

	ControlSend,, {shift down}, ahk_id %chWinId%
	clickPos(rangerPositions[ranger].x, rangerPositions[ranger].y, gildCount)
	sleep % 1000 * gildCount/100*6
	ControlSend,, {shift up}, ahk_id %chWinId%

	clickPos(xGildedClose, yGildedClose)
	sleep % zzz * 2
}

; Toggle between farm and progression modes
toggleMode(toggle:=1) {
	global
	if (toggle) {
		ControlSend,, {sc01E}, ahk_id %chWinId% ; {a}, {vk41} or {sc01E}
		sleep % zzz
	}
}

activateSkills(skills) {
	global
	reFocus()
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, ahk_id %chWinId%
		sleep 50
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
		showSplashAlways("Reloading bot... " . params, 3)
		Run "%A_AhkPath%" /restart "%A_ScriptFullPath%" %params%
	}
}

handleScheduledStop() {
	global
	if (scheduleStop) {
		showSplashAlways("Scheduled stop. Exiting...")
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
locateGilded(byref xPos, byref yPos, byref isNew) {
	global
	isNew := 0
	local xAbs, yAbs, startAt := 0

	if (!locateImage(imgBuyUpgrades)) {
		if (!locateImage(imgCombat)) {
			switchToCombatTab()
		}
		scrollToBottom()
	}

	while (upLocator(imgGilded, "Gilded hero", xAbs, yAbs, 5, 2, 1, startAt)) {
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
					if (!locateImage(imgCombat)) {
						switchToCombatTab()
					}
					isResuming := true
					reFocus()
				} else {
					msgbox,,% script,Click safety pause engaged. Continue?
				}
			}
		}
	}
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