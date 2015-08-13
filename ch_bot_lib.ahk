; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot Lib
; by Sw1ftb
; -----------------------------------------------------------------------------------------

fullScreenOption := false ; Steam borderless fullscreen option

SetTitleMatchMode, 3 ; Steam [3] or browser [regex] version?

; If browser, you need to verify (or adjust) the top margin setting.
; Start Windows Spy, then check the relative y position of the top edge of the CH area (below the logo).
browserTopMargin := 230 ; Firefox [230], IE [198], Chrome (steals focus!) [222]

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button1" ; or Button2

; If the auto-save fails to change the file name properly and you get
; a "already exists" message, change save mode to 2.
saveMode := 1 ; or 2

; -----------------------------------------------------------------------------------------
; -- BEWARE!        CHANGING ANYTHING BELOW THIS LINE IS ON YOUR OWN RISK        BEWARE! --
; -----------------------------------------------------------------------------------------

libVersion=1.31

winName=Clicker Heroes

global ProgressBar, ProgressBarTime ; progress bar controls

exitThread := false
exitDRThread := false

chWinId := ""

; All the script coordinates are based on these four default dimensions.
chWidth := 1136
chHeight := 640
chMargin := 8
chTopMargin := 30

chTotalWidth := chWidth + chMargin * 2
chTotalHeight := chHeight + chMargin + chTopMargin

; Calculated
leftMarginOffset := 0
topMarginOffset := 0

; Calculated
aspectRatio := 1
hBorder := 0
vBorder := 0

wSplash := 200

zzz := 200 ; sleep delay (in ms) after a click
lvlUpDelay := 5 ; time (in seconds) between lvl up clicks
barUpdateDelay := 30 ; time (in seconds) between progress bar updates
coinPickUpDelay := 6 ; time (in seconds) needed to pick up all coins from a clickable
nextHeroDelay := 6 ; extra gold farm delay (in seconds) between heroes

debug := false

dialogBoxClass := "#32770"

; -- Coordinates --------------------------------------------------------------------------

; Top LVL UP button when scrolled to the bottom
xLvl := 100
yLvl := 285
oLvl := 107 ; offset to next button

; Ascension button
xAsc := 310
yAsc := 434

buttonSize := 35

; Ascend Yes button
xYes := 500
yYes := 445

xCombatTab := 50
yCombatTab := 130

xAncientTab := 297
yAncientTab := 130

xRelicTab := 380
yRelicTab := 130

xRelic := 103
yRelic := 380

xSalvageJunk := 280
ySalvageJunk := 470

xDestroyYes := 500
yDestroyYes := 430

; Scrollbar
xScroll := 554
yUp := 219
yDown := 653
top2BottomClicks := 45

xGilded := 95
yGilded := 582

xGildedClose := 1090
yGildedClose := 54

rangers := ["Dread Knight", "Atlas", "Terra", "Phthalo", "Banana", "Lilin", "Cadmia", "Alabaster", "Astraea"]

rangerPositions := {}
rangerPositions[1] := {x:180, y:435}
rangerPositions[2] := {x:380, y:435}
rangerPositions[3] := {x:580, y:435}
rangerPositions[4] := {x:780, y:435}
rangerPositions[5] := {x:980, y:435}
rangerPositions[6] := {x:180, y:495}
rangerPositions[7] := {x:380, y:495}
rangerPositions[8] := {x:580, y:495}
rangerPositions[9] := {x:780, y:495}

; Buy Available Upgrades button
xBuy := 300
yBuy := 582

xHero := 474
yHero := 227

xMonster := 920
yMonster := 164

; Tab safety zone (script will pause when entering)
xSafetyZoneL := 8
xSafetyZoneR := 505
ySafetyZoneT := 104
ySafetyZoneB := 154

; The wrench
xSettings := 1121
ySettings := 52

xSettingsClose := 961
ySettingsClose := 52

xSave := 286
ySave := 112

xSkill := 201
oSkill := 36 ; offset to next skill
ySkillTop := 279
ySkill2nd := 410
ySkillCenter := 434

xMiddleZone := 858
xNextZone := 1042
yZone := 70

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

; No smart image recognition, so we click'em all!
getClickable() {
	global
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
}

clientCheck() {
	global
	WinGet, activeWinId, ID, A ; remember current active window...
	if (A_TitleMatchMode = 3) {
		calculateSteamAspectRatio() ; Steam
	} else {
		calculateBrowserOffsets() ; Browser
		fullScreenOption := false
	}
	WinActivate, ahk_id %activeWinId% ; ... and restore focus back
}

calculateBrowserOffsets() {
	global
	winName=Lvl.*Clicker Heroes.*
	IfWinExist, % winName
	{
		showSplash("Calculating browser offsets...", 2, 0)
		WinActivate
		WinGetPos, x, y, w, h
		WinGet, chWinId, ID, A

		local leftMargin := (w - chWidth) // 2
		leftMarginOffset := leftMargin - chMargin
		topMarginOffset := browserTopMargin - chTopMargin
	} else {
		showWarningSplash("Clicker Heroes started in browser?")
		ExitApp
	}
}

calculateSteamAspectRatio() {
	global
	IfWinExist, % winName
	{
		WinActivate
		WinGetPos, x, y, w, h
		WinGet, chWinId, ID, A

		; Fullscreen sanity checks
		if (fullScreenOption) {
			if (w <> A_ScreenWidth || h <> A_ScreenHeight) {
				showWarningSplash("Set the fullScreenOption to false in the bot lib file.")
				return
			}
		} else if (w = A_ScreenWidth && h = A_ScreenHeight) {
			showWarningSplash("Set the fullScreenOption to true in the bot lib file.")
			return
		}

		if (w != chTotalWidth || h != chTotalHeight) {
			showSplash("Calculating Steam aspect ratio...", 2, 0)

			local winWidth := fullScreenOption ? w : w - 2 * chMargin
			local winHeight := fullScreenOption ? h : h - chTopMargin - chMargin
			local horizontalAR := winWidth/chWidth
			local verticalAR := winHeight/chHeight

			; Take the lowest aspect ratio and calculate border size
			if (horizontalAR < verticalAR) {
				aspectRatio := horizontalAR
				vBorder := (winHeight - chHeight * aspectRatio) // 2
			} else {
				aspectRatio := verticalAR
				hBorder := (winWidth - chWidth * aspectRatio) // 2
			}
		}
	} else {
		showWarningSplash("Clicker Heroes started?")
		ExitApp
	}
}

switchToCombatTab() {
	global
	clickPos(xCombatTab, yCombatTab)
	sleep % zzz * 4
}

switchToAncientTab() {
	global
	clickPos(xAncientTab, yAncientTab)
	sleep % zzz * 2
}

switchToRelicTab() {
	global
	clickPos(xRelicTab, yRelicTab)
	sleep % zzz * 2
}

scrollToTop() {
	global
	clickPos(xScroll, yUp, top2BottomClicks)
	sleep % 25 * top2BottomClicks + 150
}

scrollToBottom() {
	global
	clickPos(xScroll, yDown, top2BottomClicks)
	sleep % 25 * top2BottomClicks + 150
}

scrollUp(clickCount:=1) {
	global
	clickPos(xScroll, yUp, clickCount)
	sleep % 25 * clickCount + 150
}

scrollDown(clickCount:=1) {
	global
	clickPos(xScroll, yDown, clickCount)
	sleep % 25 * clickCount + 150
}

; Scroll down fix when at bottom and scroll bar don't update correctly
scrollWayDown(clickCount:=1) {
	global
	scrollUp()
	scrollDown(clickCount + 1)
	sleep % nextHeroDelay * 1000
}

maxClick(xCoord, yCoord, clickCount:=1) {
	global
	ControlSend,, {shift down}{q down}, % winName
	clickPos(xCoord, yCoord, clickCount)
	ControlSend,, {q up}{shift up}, % winName
	sleep % zzz
}

ctrlClick(xCoord, yCoord, clickCount:=1, sleepSome:=1) {
	global
	ControlSend,, {ctrl down}, % winName
	clickPos(xCoord, yCoord, clickCount)
	ControlSend,, {ctrl up}, % winName
	if (sleepSome) {
		sleep % zzz
	}
}

clickPos(xCoord, yCoord, clickCount:=1) {
	global
	local xAdj := getAdjustedX(xCoord)
	local yAdj := getAdjustedY(yCoord)
 	ControlClick, x%xAdj% y%yAdj%, ahk_id %chWinId%,,, %clickCount%, NA
}

getAdjustedX(x) {
	global
	local leftMargin := fullScreenOption ? 0 : chMargin + leftMarginOffset
	return round(aspectRatio*(x - chMargin) + leftMargin + hBorder)
}

getAdjustedY(y) {
	global
	local topMargin := fullScreenOption ? 0 : chTopMargin + topMarginOffset
	return round(aspectRatio*(y - chTopMargin) + topMargin + vBorder)
}

playNotificationSound() {
	if (playNotificationSounds) {
		SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
	}
}

playWarningSound() {
	if (playWarningSounds) {
		SoundPlay, %A_WinDir%\Media\tada.wav
	}
}

showSplashAlways(text, seconds:=2) {
	showSplash(text, seconds, 1, 1)
}

showWarningSplash(text, seconds:=5) {
	showSplash(text, seconds, 2, 1)
}

showSplash(text, seconds:=2, sound:=1, showAlways:=0) {
	global
	if (seconds > 0) {
		if (showSplashTexts or showAlways) {
			progress,% "w" wSplash " x" xSplash " y" ySplash " zh0 fs10", %text%,,% script
		}
		if (sound = 1) {
			playNotificationSound()
		} else if (sound = 2) {
			playWarningSound()
		}
		sleep % seconds * 1000
		progress, off
	}
}

startProgress(title, min:=0, max:=100) {
	global
	if (showProgressBar) {
		gui, new
		gui, margin, 0, 0
		gui, font, s18
		gui, add, progress,% "w300 h28 range" min "-" max " -smooth vProgressBar"
		gui, add, text, w92 vProgressBarTime x+2
		gui, show,% "na x" xProgressBar " y" yProgressBar,% script " - " title
	}
}

updateProgress(position, remainingTime) {
	if (showProgressBar) {
		guicontrol,, ProgressBar,% position
		guicontrol,, ProgressBarTime,% formatSeconds(remainingTime)
	}
}

stopProgress() {
	if (showProgressBar) {
		gui, destroy
	}
}

formatSeconds(s) {
    time := 19990101 ; *Midnight* of an arbitrary date.
    time += %s%, seconds
	FormatTime, timeStr, %time%, HH:mm:ss
    return timeStr
}

secondsSince(startTime) {
	return (A_TickCount - startTime) // 1000
}

toggleFlag(flagName, byref flag) {
	flag := !flag
	flagValue := flag ? "On" : "Off"
	showSplashAlways("Toggled " . flagName . " " . flagValue)
}

screenShot() {
	global
	if (A_TitleMatchMode = 3) { ; Steam only
		WinGet, activeWinId, ID, A ; remember current active window...
		WinActivate, % winName
		send {f12 down}{f12 up} ; screenshot
		sleep % zzz
		WinActivate, ahk_id %activeWinId% ; ... and restore focus back
	}
}

save() {
	global
	local fileName := "ch" . A_NowUTC . ".txt"
	local newFileName := ""

	clickPos(xSettings, ySettings)
	sleep % zzz * 3
	clickPos(xSave, ySave)
	sleep % zzz * 4

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

scrollZoneLeft(zones) {
	global
	clickPos(xNextZone, yZone, zones)
	sleep % 25 * zones + 150
	clickPos(xMiddleZone, yZone)
}

horizontalSkills(y, skills) {
	global
	local x := xSkill

	loop % skills
	{
		clickPos(x, y)
		sleep 30
		x += oSkill
	}
}

verticalSkills(x) {
	global
	local extraClicks := 6
	local y := ySkillCenter - extraClicks * buttonSize

	; Scrolling is not an exact science, hence we click above, center and below
	loop % 2 * extraClicks + 1
	{
		clickPos(x, y)
		sleep 30
		y += buttonSize
	}
}
