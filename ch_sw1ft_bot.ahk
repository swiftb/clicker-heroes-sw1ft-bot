; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb
; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1

scriptName=CH Sw1ft Bot
scriptVersion=2.32
minLibVersion=1.31

script := scriptName . " v" . scriptVersion

; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

irisLevel := 1029 ; try to keep your Iris within 1001 levels of your optimal zone

; Clicker Heroes Ancients Optimizer @ http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html

; Use the optimizer to set the optimal level and time:
optimalLevel := 2000
speedRunTime := 29 ; minutes (usually between 28 and 30 minutes)

; In the Heroes tab you can verify that you are using the optimal ranger.
gildedRanger := 6 ; the number of your main guilded ranger
; 1:Dread Knight, 2:Atlas, 3:Terra, 4:Phthalo, 5:Banana, 6:Lilin, 7:Cadmia, 8:Alabaster, 9:Astraea

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; (Steam only) Want to run borderless fullscreen?
; 1. In Clicker Heroes, turn on the "Full Screen" option.
; 2. Change "fullScreenOption" to "true" in the ch_bot_lib.ahk file.
; 3. Reload with Alt+F5.

; -- Speed run ----------------------------------------------------------------------------

; If the script starts on the 2nd ranger too early (before lvl 100) or too late (after lvl 200), adjust this setting.
firstStintAdjustment := 0 ; Add or remove time (in seconds) to or from the first hero.

activateSkillsAtStart := true ; usually needed in the late game to get going after ascending

hybridMode := false ; chain a deep run when the speed run finish

ascDownClicks := 26 ; # of down clicks needed to get the ascension button center:ish (after a full speed run)

autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention!
autoAscendDelay := 10 ; warning timer (in seconds) before ascending

saveBeforeAscending := false ; autosave the game

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := false

; -- Deep run -----------------------------------------------------------------------------

deepRunTime := 60 ; minutes

clickableHuntDelay := 15 ; hunt for a clickable every 15s
stopHuntThreshold := 30 ; stop hunt when this many minutes remain of a deep run

; Number of gilds to move over at a time
reGildCount := 100 ; don't set this higher than 100 if you plan on moving gilds during a deep run
reGildRanger := gildedRanger + 1 

; -- Init run -----------------------------------------------------------------------------

; The assistant will automatically try to set the correct initDownClicks and yLvlInit settings.
; It will also assist with Iris level recommendations.
useConfigurationAssistant := true

; A list of clicks needed to scroll down 4 heroes at a time, starting from the top.
initDownClicks := [0,0,0,0,0,0]

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
yLvlInit := 000

; Manual configuration (if not using the assistant):
; 1. Ascend with a "clickable" available.
; 2. Click Alt+F1 (the script should pick up the clickable).
; 3. Scroll down to the bottom. What ranger is last?
; 4. From the list below, pick the matching settings:

; Astraea      [6,5,6,5,6,3], 241 (Iris > 2010)
; Alabaster    [6,6,5,6,6,3], 259 (Iris > 1760)
; Cadmia       [6,6,6,6,6,3], 240 (Iris > 1510)
; Lilin        [6,6,6,6,6,3], 285 (Iris > 1260)
; Banana       [6,7,6,7,6,3], 240 (Iris > 1010)
; Phthalo      [6,7,7,6,7,3], 273 (Iris > 760)
; Terra        [7,7,7,7,7,3], 240 (Iris > 510)
; Atlas        [7,7,7,8,7,3], 273 (Iris > 260)
; Dread Knight [7,8,7,8,7,4], 257

; E.g. if Phthalo is last, you set initDownClicks to [6,7,7,6,7,3] and yLvlInit to 273.
; In this case your Iris level should be somewhere between 760 and 1010.

; 5. Now click Alt+F2 (the script should level up and upgrade all heroes from Cid to Frostleaf).

; If some heroes where missed, make sure you have picked the suggested setting for your Iris level.
; If you are close to one of these Iris irisThresholds, you should move above it with some margin. 
; E.g if your Iris is at 489, you should level it to at least 529, pick the setting for Terra,
; reload the script (Alt+F5), ascend with a clickable and try Alt+F2 again.

; -- Look & Feel --------------------------------------------------------------------------

; true or false
global playNotificationSounds := true
global playWarningSounds := true
global showSplashTexts := true ; Note that some splash texts will always be shown
global showProgressBar := true

; Splash text window position
xSplash := A_ScreenWidth // 2 - wSplash // 2 ; centered
ySplash := A_ScreenHeight // 2 - 40

; Progress bar position
xProgressBar := 20
yProgressBar := 20

; If you run with a dual/tripple monitor setup, you can move windows
; right or left by adding or subtracting A_ScreenWidth from the x-parameters.

; Left monitor example:
; xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth
; xProgressBar := 20 - A_ScreenWidth

; -- Skill Combos -------------------------------------------------------------------------

; 1 - Clickstorm, 2 - Powersurge, 3 - Lucky Strikes, 4 - Metal Detector, 5 - Golden Clicks
; 6 - The Dark Ritual, 7 - Super Clicks, 8 - Energize, 9 - Reload

; Test with tools/combo_tester.ahk

comboStart := [15*60, "8-1-2-3-4-5-7-6-9"]
comboEDR := [2.5*60, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]
comboEGolden := [2.5*60, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"] ; energize 3 (dmg) or 5 (gold)
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

speedRunStartCombo := comboStart
deepRunCombo := comboGoldenLuck

; -----------------------------------------------------------------------------------------

if (libVersion != minLibVersion) {
	showWarningSplash("The bot lib version must be " . minLibVersion . "!")
	ExitApp
}

#Include *i ch_bot_settings.ahk

scheduleReload := false

if (useConfigurationAssistant) {
	configurationAssistant()
}

clientCheck()
handleAutorun()

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl)
; -----------------------------------------------------------------------------------------

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox,,% script,% "Cursor position: x" xpos-leftMarginOffset " y" ypos-topMarginOffset
return

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep runs and auto ascensions with Alt+Pause
!Pause::
	showSplashAlways("Aborting...")
	exitThread := true
	exitDRThread := true
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

; Speed run loop.
; Use to farm Hero Souls
^F1::
	loopSpeedRun()
return

; Deep run.
; Use (after a speed run) to get a few new gilds every now and then
^F2::
	deepRun()
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
	monsterClickerPause()
	save()
return

; Toggle boolean (true/false) flags

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F2::
	toggleFlag("screenShotRelics", screenShotRelics)
return

+^F3::
	toggleFlag("playNotificationSounds", playNotificationSounds)
return

+^F4::
	toggleFlag("playWarningSounds", playWarningSounds)
return

+^F5::
	toggleFlag("showSplashTexts", showSplashTexts)
return

+^F11::
	toggleFlag("saveBeforeAscending", saveBeforeAscending)
return

+^F12::
	toggleFlag("debug", debug)
return

; Schedule reload script with Shift+F5
+F5::
	toggleFlag("scheduleReload", scheduleReload)
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
		initDownClicks := [6,6,5,6,6,3]
		yLvlInit := 259
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

	switchToCombatTab()
	clickPos(xHero, yHero) ; prevent fails

	upgrade(initDownClicks[1],2,,2) ; cid --> brittany
	upgrade(initDownClicks[2]) ; fisherman --> leon
	upgrade(initDownClicks[3]) ; seer --> mercedes
	upgrade(initDownClicks[4],,,,2) ; bobby --> king
	upgrade(initDownClicks[5],2,,,2) ; ice --> amenhotep
	upgrade(initDownClicks[6],,,2) ; beastlord --> shinatobe
	upgrade(0,,,,,true) ; grant & frostleaf

	scrollToBottom()
	buyAvailableUpgrades()
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

loopSpeedRun() {
	global

	mode := hybridMode ? "hybrid" : "speed"
	showSplashAlways("Starting " . mode . " runs...")
	loop
	{
		getClickable()
		sleep % coinPickUpDelay * 1000
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
		handleScheduledReload(true)
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
	local totalClickDelay := ceil(srDuration / lvlUpDelay * zzz / 1000 + nextHeroDelay * stints)
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
		output .= s . "srDuration = " . formatSeconds(srDuration) . nl
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
		toggleMode() ; toggle to progression mode
		lvlUp(firstStintTime, 0, 3, ++stint, stints) ; nope, let's bridge with Samurai
		scrollToBottom()
	} else {
		scrollToBottom()
		toggleMode() ; toggle to progression mode
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

deepRun() {
	global

	exitDRThread := false

	local drDuration := deepRunTime * 60
	local button := gildedRanger = 9 ? 3 : 2 ; special case for Astraea
	local y := yLvl + oLvl * (button - 1)

	showSplash("Starting deep run...")

	startMouseMonitoring()
	startProgress("Deep Run Progress", 0, drDuration // barUpdateDelay)
	monsterClickerOn()

	local comboDelay := deepRunCombo[1]
	local comboIndex := 2
	local stopHuntIndex := drDuration - stopHuntThreshold * 60
	local t := 0

	loop % drDuration
	{
		if (exitDRThread) {
			monsterClickerOff()
			stopProgress()
			stopMouseMonitoring()
			showSplashAlways("Deep run aborted!")
			exit
		}
		clickPos(xMonster, yMonster)
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

	monsterClickerOff()
	stopProgress()
	stopMouseMonitoring()

	showSplash("Deep run ended.")
	sleep 1000
}

monsterClickerOn() {
	send {shift down}{f1 down}{f1 up}{shift up}
}

monsterClickerPause() {
	send {shift down}{f2 down}{f2 up}{shift up}
}

monsterClickerOff() {
	send {shift down}{pause down}{pause up}{shift up}
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global

	exitThread := false
	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run Progress (" . stint . "/" . stints . ")"

	startMouseMonitoring()
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
			stopMouseMonitoring()
			showSplashAlways("Speed run aborted!")
			exit
		}
		if (mod(t, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y)
		}
		t += 1
		updateProgress(t // barUpdateDelay, seconds - t)
		sleep 1000
	}
	stopProgress()
	stopMouseMonitoring()
}

ascend(autoYes:=false) {
	global
	exitThread := false
	local extraClicks := 6
	local y := yAsc - extraClicks * buttonSize

	if (autoYes) {
		showWarningSplash(autoAscendDelay . " seconds till ASCENSION! (Abort with Alt+Pause)", autoAscendDelay)
		if (exitThread) {
			showSplashAlways("Ascension aborted!")
			exit
		}
	} else {
		playWarningSound()
		msgbox, 260,% script,Salvage Junk Pile & Ascend? ; default no
		ifmsgbox no
			exit
	}

	salvageJunkPile() ; must salvage junk relics before ascending

	switchToCombatTab()
	scrollDown(ascDownClicks)
	sleep % zzz * 2

	; Scrolling is not an exact science, hence we click above, center and below
	loop % 2 * extraClicks + 1
	{
		clickPos(xAsc, y)
		y += buttonSize
	}
	sleep % zzz * 4
	clickPos(xYes, yYes)
	sleep % zzz * 2
}

salvageJunkPile() {
	global

	switchToRelicTab()
	if (autoAscend && screenShotRelics) {
		clickPos(xRelic, yRelic) ; focus
		screenShot()
		clickPos(xRelic+100, yRelic) ; remove focus
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
	monsterClickerPause()
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
toggleMode() {
	global
	ControlSend,, {a down}{a up}, % winName
	sleep % zzz
}

activateSkills(skills) {
	global
	clickPos(xHero, yHero) ; prevent fails
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, % winName
		sleep 100
	}
	sleep 1000
}

startMouseMonitoring() {
	setTimer, checkMousePosition, 250
}

stopMouseMonitoring() {
	setTimer, checkMousePosition, off
}


handleScheduledReload(autorun := false) {
	global
	if(scheduleReload) {
		showSplashAlways("Reloading bot...", 1)

		autorun_flag := autorun = true ? "/autorun" : ""
		Run "%A_AhkPath%" /restart "%A_ScriptFullPath%" %autorun_flag%
	}
}

handleAutorun() {
	global
	param_1 = %1%
	if(param_1 = "/autorun") {
		showSplashAlways("Autorun speedruns...")
		loopSpeedrun()
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

		xL := getAdjustedX(xSafetyZoneL)
		xR := getAdjustedX(xSafetyZoneR)
		yT := getAdjustedY(ySafetyZoneT)
		yB := getAdjustedY(ySafetyZoneB)

		if (x > xL && x < xR && y > yT && y < yB) {
			playNotificationSound()
			msgbox,,% script,Click safety pause engaged. Continue?
		}
	}
return

