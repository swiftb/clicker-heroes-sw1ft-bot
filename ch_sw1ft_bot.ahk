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

; -----------------------------------------------------------------------------------------
; -- Experimental testing -----------------------------------------------------------------

#F1::
	midasStart()
return

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
	msgbox,,% script,% "Search for " . image.file . "?" . extraInfo
	if (locateImage(image)) {
		msgbox,,% script,% "Success!"
	} else {
		msgbox,,% script,% "Failed!"
	}
}

testLocate(image, clickCount:=5) {
	global
	msgbox,,% script,% "Locate " . image.file . "?"
	if (locator(image, image.file, x, y, clickCount)) {
		msgbox,,% script,% "Success!"
	} else {
		msgbox,,% script,% "Failed!"
	}
}

#F3::
	msgbox,,% script,% "After clickable/Midas start state expected."
	testSearch(imgQuality, "high quality")
	testSearch(imgProgression, "low quality")
	testSearch(imgLocked, "locked skill")
	testSearch(imgClickable)
	switchToCombatTab()
	testSearch(imgCombat)
	testSearch(imgHire)
	testSearch(imgCoin)
	testSearch(imgSkill, "lvl someone to 10")
	testSearch(imgDimmedSkill, "lvl someone to 1")
	testLocate(imgIce, 3)
	testSearch(imgMetalDetector, "Broyle's skill")
	testSearch(imgGoldBlade, "Midas last upgrade")
	testLocate(imgAmenhotep)
	testSearch(imgAscension)
	testLocate(imgDK)
	testSearch(imgFrigidEnchant, "Frostleaf's last upgrade")

	msgbox,,% script,% "Locate " . imgGilded.file . "?"
	if (locateGilded(x, y, isNew)) {
		msgbox,,% script,% "Success!"
	} else {
		msgbox,,% script,% "Failed!"
	}

	switchToAncientTab()
	testLocate(imgSolomon)
return

#F4::
	showSplash("State = " . getState())
return

; -----------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------

; Suspend/Unsuspend all other Hotkeys
^Esc::Suspend, Toggle
return

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

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep/vision runs and auto ascensions with Alt+Pause
!Pause::
	showSplashAlways("Aborting...")
	exitThread := true
return

; Quick tests:
; Ctrl+Alt+F1 should scroll down to the bottom
; Ctrl+Alt+F2 should switch to the relics tab and then back

^!F1::
	scrollToBottom()
return

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

; Reload script with Alt+F5
!F5::
	global scheduleReload := true
	handleScheduledReload()
return

; Re-initialize coordinates
!F6::
	clientCheck()
	clickerInitialize()
return

; Speed run loop
^F1::
	loopSpeedRun()
return

; Stop looping when current speed run finishes with Shift+Pause
+Pause::
	toggleFlag("scheduleStop", scheduleStop)
return

; Deep run
; Use (after a speed run)
^F2::
	deepRun()
return

; Vision run loop
^F3::
	loopVisionRun()
return

; Open the Ancients Optimizer and auto-import game save data
^F5::
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

; Move "reGildCount" gilds to the target ranger (will pause the monster clicker if running)
^F8::
	critical
	playNotificationSound()
	msgbox, 4,% script,% "Move " . reGildCount . " gilds to " . rangers[reGildRanger] . "?"
	ifmsgbox no
		return
	regild(reGildRanger, reGildCount) ; will pause the monster clicker if running
return

; Autosave the game
^F11::
	critical
	clickerPause()
	save()
return

; Toggle boolean (true/false) flags

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F2::
	toggleFlag("screenShotRelics", screenShotRelics)
return

+^F5::
	toggleFlag("scheduleReload", scheduleReload)
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
		; [6,6,6,5,6,3], 227
		; [6,5,6,6,6,3], 260
		; [5,6,6,5,6,3], 293
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
	local initiated := false

	switchToCombatTab()
	reFocus()

	if (!useImageSearch) {
		upgrade(initDownClicks[1],2,,2) ; cid --> brittany
		upgrade(initDownClicks[2]) ; fisherman --> leon
		upgrade(initDownClicks[3]) ; seer --> mercedes
		upgrade(initDownClicks[4],,,,2) ; bobby --> king
		upgrade(initDownClicks[5],2,,,2) ; ice --> amenhotep
		upgrade(initDownClicks[6],,,2) ; beastlord --> shinatobe
		upgrade(0,,,,,true) ; grant & frostleaf
	} else {
		local foundDK := false
		local x := 0, xButton := 0, yButton := 0

		locateImage(imgCoin, xButton, yButton) ; get a x coordinate for the hire/lvl up buttons

		loop 9 ; pages
		{
			foundDK := locateImage(imgDK, xDK, yDK)
			loop 5 ; attempts per page
			{
				if (locateImage(imgHire, x, yButton)
						or locateImage(imgDimmedSkill, x, yButton)) {
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
					; Frostleaf has been leveled
					initiated := true
				}
				break
			}
			scrollDown(5)
		}
	}
	scrollToBottom()
	buyAvailableUpgrades()

	return initiated
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

	switchToCombatTab()
	startMonitoring()

	if (!useImageSearch) {
		loop 3 {
			clickPos(xMonster, yMonster) ; Break idle
			sleep 30
		}
	}
	scrollZoneLeft(midasZone1 - 1)
	sleep % zzz
	ctrlClick(xl, yl) ; Cid x 100
	zClick(xl, yl, 2) ; Cid x 50
	clickPos(xSkill + oSkill, ySkillTop) ; Clickstorm
	sleep % zzz

	scrollToBottom()
	clickPos(xl, yl+oLvl) ; Natalia
	sleep % midasDelay1 * 1000
	ctrlClick(xl, yl+oLvl) ; Natalia x 100

	if (midasExtraZone > 0) {
		scrollZoneLeft(midasExtraZone - midasZone1)
		horizontalSkills(ySkill2nd, 4)
		sleep % midasExtraDelay * 1000
	}

	scrollDown(8)

	if (useImageSearch) {
		locator(imgIce, "Ice Wizard", xl, yl, 2)
		; Offset coordinates to the top lvl up button
		xl := xl - 271
		yl := yl + 42 - oLvl*4
	}

	local zones := midasExtraZone > 0 ? midasZone2 - midasExtraZone : midasZone2 - midasZone1
	scrollZoneLeft(zones)
	unlockSkill(xl, yl+oLvl, imgMetalDetector)
	sleep % midasDelay2 * 1000
	unlockSkill(xl, yl+oLvl*3, imgGoldBlade)

	verticalSkills(xSkill + oSkill*4) ; Metal Detector + Golden Clicks
	toggleMode()
	activateSkills("1-4-5")

	sleep 4000
	if (!useImageSearch) {
		sleep % (coinPickUpDelay - 4) * 1000
	}
	stopMonitoring()
}

unlockSkill(x, y, image) {
	global
	if (useImageSearch) {
		ctrlClick(x, y, 2, 1, 1) ; x 200
		sleep 1000
		loop 5
		{
			if (locateImage(image)) {
				break
			} else {
				zClick(x, y, 1, 1) ; x 25
				sleep 6000
			}
		}
	}
	else {
		ctrlClick(x, y)
		zClick(x, y)
	}
}

getState() {
	global

	if (WinExist(winName)) {
		WinActivate
		switchToCombatTab()
	} else {
		return -3 ; no ch window
	}
	if (!useImageSearch) {
		return -2 ; no vision
	}
	if (getCurrentZone() = 0) {
		return -1 ; vision, but not in browser
	}
	if (!locateImage(imgCoin)) {
		return 0 ; vision, but not finding anything
	}
	if (!locateImage(imgProgression) and getCurrentZone() < 100) {
		return hasClickable() ? 2 : 1 ; ascended with (2) or without (1) clickable
	}
	if (locateImage(imgHire)) {
		return 3 ; not initialized
	}
	local endZone := endLvlActive > 0 ? endLvlActive : endLvlIdle
	if (getCurrentZone() < endZone) {
		return 4 ; ready for progression
	} else {
		return 5 ; ready to ascend
	}
}

loopVisionRun() {
	global
	local state := getState()
	local initiated := true

	showSplashAlways("Starting vision runs...")

	loop
	{
		if (state < 1) {
			showWarningSplash("Can't start vision run (state = " . state . ")!")
			exit
		}
		if (state = 1) {
			showDebugSplash("(1) Midas start...")
			midasStart()
		} else if (state = 2) {
			showDebugSplash("(2) Clickable start...")
			getClickable(useImageSearch)
		    sleep % coinPickUpDelay * 1000
	    	toggleMode()
		}
		if (getState() = 3) {
			showDebugSplash("(3) Initializing...")
			initiated := initRun()
		}
		if (getState() = 4) {
			showDebugSplash("(4) Progressing...")
			visionRun(initiated)
		}
		if (getState() = 5) {
			showDebugSplash("(5) Ascending...")
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
		state := getState()
	}
}

visionRun(initiated:=true) {
	global
	exitThread := false
	isResuming := false
	isClickerRunning := false
	hasActivatedSkills := false

	local xBtn := 0, yBtn := 0, isNew := 0
	local xSkill := 0, ySkill := 0, skillSearch := false

	local zone := getCurrentZone()
	local initZone := 145
	local endZone := endLvlActive > 0 ? endLvlActive : endLvlIdle

	local comboDelay := deepRunCombo[1]
	comboIndex := 2
	local stopHuntZone := endZone - ceil(stopHuntThreshold * 250 / 7)
	local t := 0

	showSplash("Starting vision run...", 1, 0)

	startMonitoring()
	startProgress("Vision Run", zone // barUpdateDelay, endZone // barUpdateDelay)

	if (initiated and locateImage(imgLocked)) {
		showDebugSplash("Trigger delayed re-initialization")
		initiated := false
	}

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
		if (mod(t, 15) = 0) {
			; Make sure we are progressing
			if (!locateImage(imgProgression)) {
				showDebugSplash("Toggle progression mode")
				toggleMode()
			}
			if (!initiated and zone > initZone) {
				; When enough gold, re-init
				showDebugSplash("Delayed re-initialization")
				if (initRun() and !locateImage(imgLocked)) {
					showDebugSplash("Initiated!")
					initiated := true
				}
				isResuming := true
			}
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
			} else {
				showWarningSplash("Could not locate any gilded hero!")
				exit
			}
		}
		; Active zone?
		if (zone > endLvlIdle) {
			if (deepRunClicks) {
				if (!isClickerRunning) {
					; Yup, start hammering!
					showDebugSplash("Start external clicker")
					clickerStart() ; ~38 CPS
					Gosub, comboTimer
					SetTimer, comboTimer, % comboDelay * 1000 + 100
					isClickerRunning := true
				}
				clickPos(xMonster, yMonster) ; ~1 CPS
			}
		; If option enabled, activate skills once at start
		} else if (zone < irisLevel + 5 and activateSkillsAtStart and !hasActivatedSkills) {
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
					if (!locateImageDown(imgDimmedSkill, x, yButton)) {
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
		zone := getCurrentZone()
	} until zone >= endZone

	SetTimer, comboTimer, off
	clickerStop()
	stopProgress()
	stopMonitoring()

	showSplash("Vision run completed.")
}

loopSpeedRun() {
	global
	mode := hybridMode ? "hybrid" : "speed"
	showSplashAlways("Starting " . mode . " runs...")
	loop
	{
		if (useMidasStart) {
			midasStart()
		} else {
			getClickable(useImageSearch)
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

	totalTimeLeft := firstStintTime + midStintTime + lastStintTime
	if (hybridMode) {
		totalTimeLeft += deepRunTime * 60
	}

	local lastStintButton := gildedRanger = 9 ? 3 : 2 ; special case for Astraea

	if (debug)
	{
		local nl := "`r`n"
		local s := "    " ; Reddit friendly formatting
		local output := ""
		output .= s . "irisLevel = " . irisLevel . nl
		output .= s . "optimalLevel = " . optimalLevel . nl
		output .= s . "speedRunTime = " . speedRunTime . nl
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
		if (hybridMode) {
			output .= s . "deepRunTime = " . deepRunTime . nl
		}
		output .= s . "totalTimeLeft = " . formatSeconds(totalTimeLeft) . nl

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

	local stopHuntIndex := totalTimeLeft - stopHuntThreshold * 60
	local t := 0

	loop
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
		if (useImageSearch and mod(t, clickableHuntDelay) = 0 and t < stopHuntIndex) {
			getClickable(useImageSearch)
		}
		t += 1
		updateProgress(t // barUpdateDelay, seconds - t)
		sleep 1000

		if (t >= seconds) {
			if (!hybridMode and !useMidasStart and !hasClickable()) {
				seconds += 30
			} else {
				break
			}
		}
	}
	totalTimeLeft -= seconds

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

	loop
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

		if (t >= drDuration) {
			if (!useMidasStart and !hasClickable()) {
				drDuration += 30
			} else {
				break
			}
		}
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

sendClickerMsg(msg) {
	global
	if (deepRunClicks) {
		DetectHiddenWindows, on
	    PostMessage, %msg%,,,,monster_clicker.ahk - AutoHotkey
		DetectHiddenWindows, off
	}
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
	switchToCombatTab()
	scrollDown(ascDownClicks)

	if (useImageSearch and locator(imgAmenhotep, "Amenhotep", x, y)) {
		if (!locateImage(imgAscension)) {
			unlockSkill(x - 349, y, imgAscension)
		}
	}
	verticalSkills(xSkill + oSkill*3) ; ASCENSION

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
			clickPos(xRelic, yRelic) ; focus
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

; Move "gildCount" gilds to given ranger
regild(ranger, gildCount) {
	global
	clickerPause()
	switchToCombatTab()
	scrollToBottom()

	clickPos(xGilded, yGilded)
	sleep % zzz * 2

	ControlSend,, {shift down}, % winName
	clickPos(rangerPositions[ranger].x, rangerPositions[ranger].y, gildCount)
	sleep % 1000 * gildCount/100*5
	ControlSend,, {shift up}, % winName

	clickPos(xGildedClose, yGildedClose)
	sleep % zzz * 2
}

; Toggle between farm and progression modes
toggleMode(toggle:=1) {
	global
	if (toggle) {
		ControlSend,, {a down}{a up}, % winName
		sleep % zzz
	}
}

activateSkills(skills) {
	global
	reFocus()
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, % winName
		sleep 100
	}
	sleep 1000
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
		showSplashAlways("Reloading bot... " . params, 2)
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

	local startAt := 0
	isNew := 0

	scrollToBottom()

	while (upLocator(imgGilded, "Gilded hero", xAbs, yAbs, 5, 1, startAt)) {
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

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

; Safety zone around the in-game tabs (that triggers an automatic script pause when breached)
checkMousePosition:
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
				} else {
					msgbox,,% script,Click safety pause engaged. Continue?
				}
			}
		}
	}
return

checkWindowVisibility:
	if (!locateImage(imgCoin) or !locateImage(imgProgression)) {
		WinActivate, % winName
	}
return

comboTimer:
	activateSkills(deepRunCombo[comboIndex])
	comboIndex := comboIndex < deepRunCombo.MaxIndex() ? comboIndex+1 : 2
return