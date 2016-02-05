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
minLibVersion=1.5

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

if (!useImageSearch and irisLevel < 145) {
	playWarningSound()
	msgbox,,% script,% "Your Iris do not fulfill the minimum level requirement of 145 or higher!"
	exit
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
	loopSpeedRun()
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
Hotkey, !Pause, , P2

; Schedule a stop after finishing the current run with Shift+Pause
+Pause::
	toggleFlag("scheduleStop", scheduleStop)
return

; Reload the script (needed after configuration changes)
!F5::
	global scheduleReload := true
	handleScheduledReload()
return
Hotkey, !F5, , P2

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
Hotkey, !F6, , P2

; -- Supplementary Hotkeys ----------------------------------------------------------------

; Suspend/Unsuspend all other Hotkeys with Ctrl+Esc
^Esc::Suspend, Toggle
return

; Open the Ancients Optimizer and auto-import game save data
^F5::
	openAncientsOptimizer()
return
Hotkey, ^F5, , P1

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
Hotkey, ^F8, , P1

; Open new gilds
^F9::
	clickerPause()
	openNewGilds()
return
Hotkey, ^F9, , P1

; Autosave the game
^F11::
	save()
return
Hotkey, ^F11, , P1

; Raid once for free with Win+F6
#F6::
	raid()
return
Hotkey, #F6, , P1

; One paid raid
#F7::
	raid(1)
return
Hotkey, #F7, , P1

; Paid raids
#F8::
	raid(1, raidAttempts)
return
Hotkey, #F8, , P1

; Toggle boolean (true/false) flags with Shift+Ctrl+Fx

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F6::
	toggleFlag("playNotificationSounds", playNotificationSounds)
return
Hotkey, +^F6, , P1

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

; Test one Midas Start with Win+F1
#F1::
	midasStart()
return

; Loop Midas Start > Init Run > Ascend, twice
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
	if (locator(image, image.file, x, y, 1, clickCount)) { ; one retry
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
	testSearch(imgClose, "Open Shop > Get More! window")
	testSearch(imgClickable)
	switchToCombatTab()
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

; Level up and upgrade all heroes
initRun(initMode:=0) {
	global
	local hasAscendButton := false
	local hasSkillBar := false
	local hasNoSkillLocked := false

	showDebugSplash("Init Run @ Lvl " . getCurrentZone())

	switchToCombatTab()
	reFocus()

	if (!useImageSearch) {
		local clicks := 7
		if (irisLevel > 3000) {
			clicks := 5
		} else if (irisLevel > 1500) {
			clicks := 6
		}
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
		logVariable("hasAscendButton", hasAscendButton, true)
		logVariable("hasSkillBar", hasSkillBar, true)
		logVariable("hasNoSkillLocked", hasNoSkillLocked, true)
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

	showDebugSplash("Midas Start")

	switchToCombatTab()
	startMonitoring()
	reFocus()

	if (!useImageSearch) {
		loop 3 {
			clickPos(xMonster, yMonster) ; Break idle
			sleep 30
		}
		scrollZone(1, midasZone1)
		ctrlClick(xl, yl) ; Cid x 100
		clickPos(xSkill + oSkill, ySkillTop) ; Clickstorm
		sleep % zzz

		scrollToBottom()
		clickPos(xl, yl+oLvl) ; Natalia
		sleep % midasDelay1 * 1000
		ctrlClick(xl, yl+oLvl) ; Natalia x 100

		if (midasExtraZone > 0) {
			scrollZone(midasZone1, midasExtraZone)
			horizontalSkills(xSkill, ySkill2nd, 4)
			sleep % midasExtraDelay * 1000
		}
		scrollDown(8)
		scrollZone(fromZone, midasZone2)
		ctrlClick(xl, yl+oLvl) ; Broyle x 100
		sleep % midasDelay2 * 1000
		ctrlClick(xl, yl+oLvl*3) ; Midas x 100
		verticalSkills(xSkill + oSkill*4) ; Metal Detector + Golden Clicks

		toggleMode()
		activateSkills("1-4-5")
		sleep % coinPickUpDelay * 1000
	} else {
		setFarmMode()
		scrollToZone(midasZone1)
		locator(imgCid, "Cid", xl, yl, -1) ; endless retries
		buySkill(imgClickstorm, xl-137, yl+60, 2, 7)

		scrollToBottom()
		upLocator(imgCoin, "Coin", xl, yl, -1) ; endless retries
		ctrlClick(xl, yl, 1, 1, 1)
		sleep % midasDelay1 * 1000
		ctrlClick(xl, yl, 1, 1, 1)
		if (midasExtraZone > 0) {
			scrollToZone(midasExtraZone)
			sleep % midasExtraDelay * 1000
			ctrlClick(xl, yl, 1, 1, 1)
		}
		if (locateImage(imgMercedes)) {
			scrollDown(8)
		} else {
			switchToCombatTab()
			scrollDown(18)
		}
		scrollToZone(midasZone2)
		if (!locator(imgReferi, "Referi", xl, yl, 1, 2)) { ; one retry
			showWarningSplash("Failed Midas start!")
			return
		}
		xl -= 155
		yl += 60
		buySkill(imgMetalDetector, xl, yl-oLvl*3, 5, 5)
		sleep % midasDelay2 * 1000
		buySkill(imgGoldenClicks, xl, yl-oLvl, 5, 6)

		setProgressionMode()
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
	if (!earlyGameMode and !locateImage(imgProgression) and getCurrentZone() < irisLevel) {
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
	if (earlyGameMode) {
		oldEndLvlIdle := endLvlIdle
		oldEndLvlActive := endLvlActive
	}
	local state := 0

	showUserSplash("Starting Vision Runs!")

	logVariable("browser", browser)
	logVariable("browserTopMargin", browserTopMargin)
	logVariable("useImageSearch", useImageSearch, true)
	logVariable("earlyGameMode", earlyGameMode, true)
	if (!earlyGameMode) {
		logVariable("irisLevel", irisLevel)
		logVariable("gildedRanger", rangers[gildedRanger])
	}
	logVariable("endLvlIdle", endLvlIdle)
	logVariable("endLvlActive", endLvlActive)
	if (!earlyGameMode) {
		logVariable("useMidasStart", useMidasStart, true)
		logVariable("forcedMidasStart", forcedMidasStart, true)
		logArray("midasZoneConfig", midasZoneConfig)
		if (!isActiveZone(irisLevel)) {
			logVariable("activateSkillsAtStart", activateSkillsAtStart, true)
			if (activateSkillsAtStart) {
				logArray("speedRunStartCombo", speedRunStartCombo)
			}
		}
	}
	logVariable("deepRunClicks", deepRunClicks, true)
	if (endLvlActive > 0) {
		logArray("deepRunCombo", deepRunCombo)
	}
	logVariable("clickerDuration", clickerDuration)
	logVariable("clickableHuntDelay", clickableHuntDelay)
	logVariable("stopHuntThreshold", stopHuntThreshold)
	logVariable("saveBeforeAscending", saveBeforeAscending, true)
	logVariable("autoAscend", autoAscend, true)
	if (!earlyGameMode) {
		logVariable("levelSolomon", levelSolomon, true)
		if (levelSolomon) {
			logVariable("solomonLevels", solomonLevels)
		}
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
		if (state = 1) {
			if (!forcedMidasStart and hasClickable()) {
				showDebugSplash("Clickable start")
				getClickable(useImageSearch)
				sleep % coinPickUpDelay * 1000
				switchToCombatTab()
				ctrlClick(xLvl, yLvl+oLvl) ; Force progression
				setProgressionMode()
			} else {
				midasStart()
			}
		}
		if (getState() = 2) {
			visionRun()
		}
		if (getState() = 3) {
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
	local hasActivatedSkills := false
	local hasBomberBuff := gildedRanger = 12 ? true : false
	local hasGogBuff := gildedRanger = 13 ? true : false

	local xClose := 0, yClose := 0
	local xBtn := 0, yBtn := 0, isNew := 0
	local xSkill := 0, ySkill := 0, skillSearch := false

	local locateGildedDelay := 90
	local locateBuyUpgradesDelay := 20
	local progressCheckDelay := 10

	local zone := getCurrentZone()
	zoneTicks := {}
	local maxZone := zone
	local initiatedZone := 0
	farmZone := 0
	local initZone := 146
	local endZone := getEndZone()
	local stopHuntZone := endZone - ceil(stopHuntThreshold * 250 / 7)

	local t := 0
	local elapsedTime := 0

	local comboDelay := deepRunCombo[1]
	comboIndex := 2

	if (earlyGameMode) {
		endLvlIdle := oldEndLvlIdle
		endLvlActive := oldEndLvlActive
		locateGildedDelay := 6
		lvlUpDelay := 6
	}
	local startAt := 0
	local timeToAscend := 0
	local zoneClearTime := 0
	secPerMonster := 0
	farmTime := 0
	isFarming := false

	local mode := earlyGameMode ? "Early Game Mode " : ""
	showSplash("Starting " . mode . "Vision Run")

	startMonitoring()
	reFocus()

	startProgress("Vision Run", zone // barUpdateDelay, endZone // barUpdateDelay)

	SetTimer, zoneTickTimer, 500

	loop
	{
		if (exitThread) {
			zoneTicks := ""
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

		; Early game mode until "power 5" zone
		if (earlyGameMode and zone < power5Zone) {
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
					xBtn := 79
					yBtn -= 8
				}
			}
			if (zone > 30 and zone > initiatedZone and mod(zone-6, 30) = 0 and zone < initZone) {
				; Lvl earlier heroes at zones 36, 66, 96 and 126
				initRun(1) ; x 100
				initiatedZone := zone
			}
			; xx4/xx9 zone before boss?
			if (zone > 10 and zone > farmZone and mod(zone-4, 5) = 0 and zone <= lastFarmZone and !isFarming) {
				; If the previous zone took 2s or more per monster, start farming
				zoneClearTime := (zoneTicks[zone] - zoneTicks[zone-1]) / 1000
				secPerMonster := zoneClearTime / (10 - kumawakamaruLevel)
				if (secPerMonster >= 2) {
					farmTime := ceil(secPerMonster * 25) ; 20, 25 or 30?
					showDebugSplash("Farming for " . farmTime . "s")
					setFarmMode(1)
					SetTimer, farmTimer, % -farmTime * 1000, 1
					isFarming := true
					farmZone := zone
				}
			}
		} else if (mod(t, locateGildedDelay) = 0 or isResuming) {
			; Traverse bottom up till we find the first gilded hero/ranger we can lvl up
			if (locateGilded(xBtn, yBtn, isNew, startAt, earlyGameMode)) {
				maxClick(xBtn, yBtn, 1, 1)
				if (isNew) {
					showDebugSplash("New gilded hero found @ Lvl " . zone)
					buyAvailableUpgrades()
				}
				if (earlyGameMode) {
					; Power 5 mode
					startAt := yBtn + yWinPos - 56
				}
				skillSearch := true
				isResuming := false
			} else {
				; If any, close auto-opened buy more rubies window
				if (locateImage(imgClose, xClose, yClose)) {
					clickPos(xClose, yClose, 1, 1)
				} else {
					showWarningSplash("Could not locate any gilded hero! Restarting...")
					; Restart
					scrollToZone(irisLevel - 1)
					setFarmMode()
					break
				}
			}
		}

		if (!isInitiated and zone >= initZone) {
			; If enough gold, run init
			isInitiated := initRun()
			isResuming := true
		}

		; Make sure we are progressing
		if (mod(t, progressCheckDelay) = 0) {
			if (!locateImage(imgProgression) and !isFarming) {
				if (earlyGameMode and zone > lastFarmZone) {
					; Brute force through two bosses with skills, then ascend
					if (++timeToAscend >= 2) {
						showDebugSplash("Ascend after next boss")
						endLvlIdle := zone + 1
						endLvlActive := zone + 1
						endZone := getEndZone()
					}
					showDebugSplash("Push with skills! (" . timeToAscend . "/2) @ Lvl " . zone)
					if (!isClickerRunning) {
						clickerStart(clickerDuration)
					}
					Gosub, comboTimer
				}
				setProgressionMode()
			}
		}

		; Active zone?
		if (isActiveZone(zone)) {
			if (deepRunClicks) {
				if (!isClickerRunning) {
					; Yup, start hammering!
					clickerStart() ; ~38 CPS
					isClickerRunning := true
					if (!earlyGameMode) {
						; Save skill combos till after lastFarmZone
						Gosub, comboTimer
						SetTimer, comboTimer, % comboDelay * 1000 + 250
					}
				}
				clickPos(xMonster, yMonster) ; Jugg combo safety click
				sleep 30
			}
		} else if (isClickerRunning) {
			clickerStop()
			isClickerRunning := false
		} else if (zone = irisLevel + 1 and activateSkillsAtStart and !hasActivatedSkills and isInitiated) {
			; If option enabled, activate skills once at start (if fully initiated)
			showDebugSplash("Activate skills at start!")
			clickerStart(clickerDuration)
			activateSkills(speedRunStartCombo[2])
			hasActivatedSkills := true
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
			} else if (!earlyGameMode and !matchPixelColor(goldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
				if (!matchPixelColor(brightGoldColor, xBtn-51+xWinPos, yBtn+yWinPos)) {
					; ... or not, lost sight of our gilded hero
					showDebugSplash("Lost sight of our gilded hero!")
					clickAwayImage(imgCombatTab)
					isResuming := true
				}
			}
		}

		updateProgress(zone // barUpdateDelay, endZone - zone, 1) ; show lvls remaining

		zone := getCurrentZone()
		if (zone > maxZone) {
			maxZone := zone
		}

		t += 1
		sleep 1000

	} until zone > endZone

	if (earlyGameMode) {
		maxLevels() ; get some extra souls from levels
	}

	SetTimer, zoneTickTimer, off
	if (useZoneDataLogger) {
		logZoneData(zdlStart, endZone, zdlInterval)
	}
	zoneTicks := ""

	SetTimer, comboTimer, off
	clickerStop()
	stopProgress()
	stopMonitoring()

	elapsedTime := (A_TickCount - startTime) / 1000
	showSplash("Vision Run duration: " . formatSeconds(elapsedTime))
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

	switchToCombatTab()
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
	logVariable("irisLevel", irisLevel)
	logVariable("gildedRanger", rangers[gildedRanger])
	logVariable("speedRunTime", speedRunTime)
	logVariable("firstStintAdjustment", firstStintAdjustment)
	logVariable("firstStintButton", firstStintButton)
	logVariable("useMidasStart", useMidasStart, true)
	if (useMidasStart) {
		logArray("midasZoneConfig", midasZoneConfig)
	}
	logVariable("activateSkillsAtStart", activateSkillsAtStart, true)
	if (activateSkillsAtStart) {
		logArray("speedRunStartCombo", speedRunStartCombo)
	}
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
		if (useMidasStart) {
			midasStart()
			getClickable()
		} else {
			showDebugSplash("Clickable start")
			getClickable()
			sleep % coinPickUpDelay * 1000
		}
		initRun()
		if (activateSkillsAtStart) {
			clickerStart(clickerDuration)
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

	local startTime := A_TickCount
	local stint := 0
	local stints := 0
	local tMax := 7 * 60 ; seconds
	local lMax := 250 ; zones

	local lvlAdjustment := round(firstStintAdjustment * lMax / tMax)
	local zoneLvl := gildedRanger * lMax + lvlAdjustment ; approx zone lvl where we can buy our gilded ranger @ lvl 150
	local lvls := zoneLvl - irisLevel ; lvl's to get there

	local firstStintTime := 0
	if (lvls > 0)
	{
		firstStintTime := ceil(lvls * tMax / lMax)
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
	toggleMode(!useMidasStart) ; toggle to progression mode
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

openNewGilds() {
	global

	showUserSplash("Open new gilds")

	clickPos(xNewGild, yNewGild, 100)
	sleep 3000
	clickPos(xOpenGild, yOpenGild)
	sleep 2000
	clickPos(xCloseGild, yCloseGild)
	sleep 250
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
	}
	if (!wasClickerRunning) {
		clickerStop()
	}

	clickAwayImage(imgCombatTab)
	isResuming := true
}

clickAwayImage(image) {
	local xImg := 0, yImg := 0
	if (locateImage(image)) {
		while (locateImage(image, xImg, yImg)) {
			clickPos(xImg, yImg, 1, 1)
			sleep 250
		}
		sleep 1000
		return 1
	}
	return 0
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

setFarmMode(silent:=0) {
	global
	if (locateImage(imgProgression)) {
		toggleMode()
		if (!silent) {
			showDebugSplash("Set Farm Mode")
		}
	}
}

setProgressionMode(silent:=0) {
	global
	if (!locateImage(imgProgression)) {
		toggleMode()
		if (!silent) {
			showDebugSplash("Set Progression Mode")
		}
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
locateGilded(byref xPos, byref yPos, byref isNew, startAt:=0, earlyGameMode:=0) {
	global
	isNew := 0
	local xAbs, yAbs

	if (startAt = 0 and !locateImage(imgBuyUpgrades)) {
		if (locateImage(imgCombatTab)) {
			clickAwayImage(imgCombatTab)
		}
		scrollToBottom()
	}

	while (upLocator(imgGilded, "Gilded hero", xAbs, yAbs, 2, 5, 1, startAt, earlyGameMode)) { ; two retries
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

farmOrFight() {
	global
	local silent := true
	local bossZone := farmZone + 1
	local maxTime := 1.5 ; s

	setProgressionMode(silent) ; Toggle progress on, then
	if (zoneMovedWithin(farmZone, maxTime) > 0) { ; if we reached the boss in time
		scrollToZone(farmZone) ; scroll back
		local startTime := A_TickCount
		if (zoneMovedWithin(farmZone, maxTime) > 0) { ; if fast enough still
			showDebugSplash("Lvl " . bossZone . " boss fight!")
			local zoneMoved := zoneMovedWithin(bossZone, 30)
			local elapsedTime := (A_TickCount - startTime - zzz) // 1000
			if (zoneMoved > 0) {
				showDebugSplash("Fight duration: " . elapsedTime . "s")
				isFarming := false
				lvlUpDelay := 6 ; reset
				return
			} else {
				showDebugSplash("Failed boss... :(")
			}
		}
	}

	if (zoneTicks.HasKey(bossZone)) {
		zoneTicks.Delete(bossZone)
	}

	; Keep farming...
	if (bossZone >= 110 and secPerMonster >= 5 and locateImage(imgLuckyStrikes)) {
		; If available, use skills on tough bosses
		showDebugSplash("Push with skills @ Lvl " . getCurrentZone())
		isFarming := false
		if (!getClickerStatus()) {
			clickerStart(clickerDuration)
		}
		setProgressionMode(silent)
		activateSkills("2-3")
	} else {
		setFarmMode(silent)
		sleep % zzz
		if (farmZone < getCurrentZone()) {
			; Make sure we are farming on the correct lvl
			scrollToZone(farmZone)
		}
		showDebugSplash("Keep farming!")
		SetTimer, farmTimer, % -farmTime * 1000, 1
		lvlUpDelay := 18 ; up the chance to lvl up next hero
	}
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
			local elapsed := (zoneTicks[cz] - zoneTicks[pz]) / 1000
			if (mod(cz-4, 5) = 0 and elapsed >= 20) {
				showDebugSplash("Lvl " . pz . " -> " . cz . " : " . formatSeconds(elapsed))
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

		totalTime := (zoneTicks[zone] - zoneTicks[startZone]) / 1000
		intervalTime := (zoneTicks[zone] - zoneTicks[prevZone]) / 1000

		zoneData .= nl . zone . t . formatSeconds(totalTime) . t . round(intervalTime, 1)
	}

	logger(zoneData, "INFO", "_zone_data")
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
	farmOrFight()
return

zoneTickTimer:
	storeZoneTick()
return
