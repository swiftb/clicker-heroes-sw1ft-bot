; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot Lib
; by Sw1ftb
; -----------------------------------------------------------------------------------------

CoordMode, Pixel, Screen

libVersion=4.0

winName := "Clicker Heroes"

exitThread := false

chWinId := ""

; All the script coordinates are based on these four default dimensions.
chWidth := 1136
chHeight := 640
chMargin := 8
chTopMargin := 30

chTotalWidth := chWidth + chMargin * 2
chTotalHeight := chHeight + chMargin + chTopMargin

; Calculated
xScreenL := 0
yScreenT := 0
xScreenR := 0
yScreenB := 0

; Calculated
leftMarginOffset := 0
topMarginOffset := 0

; Calculated
aspectRatio := 1

zzz := 175 ; sleep delay (in ms) after a click
lvlUpDelay := 6 ; time (in seconds) between lvl up clicks
coinPickUpDelay := 5 ; time (in seconds) needed to pick up all coins from a clickable

scrollDelay := 325 ; base delay (in ms)
scrollClickDelay := 20 ; delay per click (in ms)

dialogBoxClass := "#32770"

blueColor := 0x60BEFF
yellowColor := 0xFECB00
dimmedYellowColor := 0x7E6500
goldColor := 0xFFB423
brightGoldColor := 0xFFD911

severityLevels := {"OFF":0, "WARN":1, "USER":2, "INFO":3, "DEBUG":4, "TRACE":5}

gameModes := {"INIT":0, "PROGRESSING":1, "FARMING":2, "FIGHTING":3}

; -- Images -------------------------------------------------------------------------------

; Combat zone offsets
CZTO := 170
CZLO := 500
CZBO := CZTO - chHeight
CZRO := CZLO - chWidth

imageFilePath := "images\"

imgSmile := {file:"smile.png", topOffset:0, leftOffset:1090, bottomOffset:0, rightOffset:0}
imgQuality := {file:"quality.png", topOffset:0, leftOffset:1090, bottomOffset:0, rightOffset:0}
imgFarm := {file:"farm.png", topOffset:0, leftOffset:1090, bottomOffset:0, rightOffset:0}
imgProgression := {file:"progression.png", topOffset:0, leftOffset:1090, bottomOffset:0, rightOffset:0}
imgAscend := {file:"ascend.png", topOffset:0, leftOffset:1090, bottomOffset:0, rightOffset:0}

imgClickable := {file:"clickable.png", topOffset:CZTO, leftOffset:CZLO, bottomOffset:0, rightOffset:0}

imgSkillBar := {file:"skill_bar.png", topOffset:0, leftOffset:575, bottomOffset:0, rightOffset:-496}
imgSkillLocked := {file:"skill_locked.png", topOffset:0, leftOffset:575, bottomOffset:0, rightOffset:-496}

imgCombatTab := {file:"combat_tab.png", topOffset:0, leftOffset:0, bottomOffset:CZBO, rightOffset:CZRO}

imgHire := {file:"hire.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgCoin := {file:"coin.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgMaxLvl := {file:"max_lvl.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgDimmedSkill := {file:"skill_dimmed.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgSkill := {file:"skill.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgChefBuff := {file:"way_of_the_chef.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgKingsBuff := {file:"way_of_kings.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgCid := {file:"cid.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgDK := {file:"dk.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgDKG := {file:"dk_g.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgMax := {file:"max.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgGog := {file:"gog.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgSolomon := {file:"solomon.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgGilded := {file:"gilded.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgGildedButton := {file:"gilded_button.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgBuyUpgrades := {file:"upgrades.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgClanRaid := {file:"clan_raid.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgClanFight := {file:"clan_fight.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgClanFightAgain := {file:"clan_fight_again.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}
imgClanCollect := {file:"clan_collect.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:CZRO}

imgYes := {file:"yes.png", topOffset:CZTO, leftOffset:0, bottomOffset:0, rightOffset:0}

; -- Coordinates --------------------------------------------------------------------------

; Top LVL UP button when scrolled to the bottom
xLvl := 80
oLvl := 107 ; offset to next button

; Progression/Farm Mode
xMode := 1121
yMode := 281

xAscend := 1121
yAscend := 322

; Ascend Yes button
xYes := 500
yYes := 510

oTab := 69 ; offset to next tab
xCombatTab := 52
xAncientTab := xCombatTab + oTab*3
xRelicTab := xCombatTab + oTab*4 + 10 ; Halloween fix
xClanTab := xCombatTab + oTab*5
yTab := 130

xRelic := 103
yRelic := 380

xUpgradeNo := 660
yUpgradeNo := 580

xSalvageJunk := 280
ySalvageJunk := 470

xDestroyYes := 500
yDestroyYes := 430

; Scrollbar
xScroll := 554
yUp := 219
yDown := 653
top2BottomClicks := 45

rangers := {0:"Power 5", -1:"Samurai", 1:"Dread Knight", 2:"Atlas", 3:"Terra", 4:"Phthalo", 5:"Banana", 6:"Lilin", 7:"Cadmia", 8:"Alabaster", 9:"Astraea", 10:"Chiron", 11:"Moloch", 12:"Bomber Max", 13:"Gog", 14:"Wepwawet", 15:"Betty", 16:"Midas"}

; Buy Available Upgrades button
xBuy := 370
yBuy := 582

xFocus := 564
yFocus := 69

xMonster := 1010
yMonster := 164

; Safety zones (script will pause when entering)
safetyZones := {}
safetyZones[1] := {zone:"tabs", x1:8, y1:104, x2:575, y2:153}
safetyZones[2] := {zone:"settings", x1:1096, y1:31, x2:1143, y2:74}
safetyZones[3] := {zone:"saleShop", x1:678, y1:600, x2:949, y2:670}
safetyZones[4] := {zone:"gilded", x1:79, y1:554, x2:194, y2:612}

; The wrench
xSettings := 1121
ySettings := 52

xSettingsClose := 961
ySettingsClose := 52

xSave := 286
ySave := 112

xSkill := 201
oSkill := 36 ; offset to next skill

xPrevZone := 679
xMiddleZone := 858
xPlusOneZone := 922
xNextZone := 1044
yZone := 70

; -----------------------------------------------------------------------------------------

; Load system default settings
#Include system\ch_bot_lib_default_settings.ahk

IfNotExist, ch_bot_lib_settings.ahk
{
	FileCopy, system\ch_bot_lib_default_settings.ahk, ch_bot_lib_settings.ahk
}

#Include *i ch_bot_lib_settings.ahk

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

clientCheck() {
	global
	local xPos, yPos
	calculateBrowserOffsets()

	if (locateImage(imgQuality, xPos, yPos)) {
		showTraceSplash("Switching to low quality")
		clickPos(xPos, yPos, 1, 1)
	}
	if (scriptName = "CH Sw1ft Bot") {
		showTraceSplash("xScreenR - xScreenL = " . xScreenR - xScreenL)
		showTraceSplash("yScreenB - yScreenT = " . yScreenB - yScreenT)
	}
}

calculateBrowserOffsets() {
	global
	local w, h
	winName := "Lvl.*Clicker Heroes.*" . browser
	IfWinExist, % winName
	{
		showDebugSplash("Calculating browser offsets (" . scriptName . ")")
		WinActivate
		WinGetPos, xWinPos, yWinPos, w, h
		WinGet, chWinId, ID, A

		local leftMargin := (w - chWidth) // 2
		leftMarginOffset := leftMargin - chMargin
		topMarginOffset := browserTopMargin - chTopMargin

		xScreenL := xWinPos + leftMargin
		yScreenT := yWinPos + browserTopMargin
		xScreenR := xScreenL + chWidth
		yScreenB := yScreenT + chHeight
	} else {
		showWarningSplash("Clicker Heroes started in " . browser . "?")
	}
}

switchToCombatTab() {
	global
	if (locateImage(imgCombatTab)) {
		clickAwayImage(imgCombatTab)
	} else {
		clickPos(xCombatTab, yTab)
		sleep % zzz * 4
	}
}

switchToAncientTab() {
	global
	clickPos(xAncientTab, yTab)
	sleep % zzz * 2
}

switchToRelicTab() {
	global
	clickPos(xRelicTab, yTab)
	sleep % zzz * 2
}

switchToClanTab() {
	global
	clickPos(xClanTab, yTab)
	sleep % zzz * 2
}

scrollToTop() {
	global
	clickPos(xScroll, yUp, top2BottomClicks)
	sleep % scrollDelay + top2BottomClicks * scrollClickDelay
}

scrollToBottom() {
	global
	clickPos(xScroll, yDown, top2BottomClicks)
	sleep % scrollDelay + top2BottomClicks * scrollClickDelay
}

scrollUp(clickCount:=1) {
	global
	clickPos(xScroll, yUp, clickCount)
	sleep % scrollDelay + clickCount * scrollClickDelay
}

scrollDown(clickCount:=1) {
	global
	clickPos(xScroll, yDown, clickCount)
	sleep % scrollDelay + clickCount * scrollClickDelay
}

maxClick(xCoord, yCoord, clickCount:=1, absolute:=0) {
	global
	ControlSend,, {shift down}{vk51 down}, ahk_id %chWinId% ; {q}, {vk51} or {sc010}
	clickPos(xCoord, yCoord, clickCount, absolute)
	ControlSend,, {vk51 up}{shift up}, ahk_id %chWinId%
	sleep % zzz
}

ctrlClick(xCoord, yCoord, clickCount:=1, sleepSome:=1, absolute:=0) {
	global
	ControlSend,, {ctrl down}, ahk_id %chWinId%
	clickPos(xCoord, yCoord, clickCount, absolute)
	ControlSend,, {ctrl up}, ahk_id %chWinId%
	if (sleepSome) {
		sleep % zzz
	}
}

clickPos(xCoord, yCoord, clickCount:=1, absolute:=0) {
	global
	local xAdj := absolute ? xCoord : getAdjustedX(xCoord)
	local yAdj := absolute ? yCoord : getAdjustedY(yCoord)
 	ControlClick, x%xAdj% y%yAdj%, ahk_id %chWinId%,,, %clickCount%, NA
}

getAdjustedX(x) {
	global
	local leftMargin := chMargin + leftMarginOffset
	return round(aspectRatio*(x - chMargin) + leftMargin)
}

getAdjustedY(y) {
	global
	local topMargin := chTopMargin + topMarginOffset
	return round(aspectRatio*(y - chTopMargin) + topMargin)
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

showTraceSplash(text, seconds:=1) {
	showSplash(text, seconds, 0, "TRACE")
}

showDebugSplash(text, seconds:=1) {
	showSplash(text, seconds, 0, "DEBUG")
}

showUserSplash(text, seconds:=2) {
	showSplash(text, seconds, 1, "USER")
}

showWarningSplash(text, seconds:=4) {
	showSplash(text, seconds, 2, "WARN")
}

showSplash(text, seconds:=2, sound:=1, level="INFO") {
	global
	if (seconds > 0) {
		if (severityLevels[level] <= showSeverityLevel) {
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
	logger(text, level)
}

logArray(name, array) {
	local value := ""
	loop % array.Length()
	{
		value .= array[A_Index]
		if (A_Index < array.Length()) {
			value .= ", "
		}
	}
	logVariable(name, "[" . value . "]")
}

logVariable(name, value, isBool:=0, level="DEBUG") {
	if (isBool) {
		value := value ? "true" : "false"
	}
	logger(name . " = " . value, level)
}

; 0:OFF, 1:WARN, 2:USER, 3:INFO, 4:DEBUG, 5:TRACE
logger(msg, level, fileSuffix:="") {
	global
	local localTime := A_Now
	local currentDate
	local currentDateTime
	local fileName
	if (severityLevels[level] <= logSeverityLevel) {
		FormatTime, currentDate, localTime, yyyy-MM-dd
		FormatTime, currentDateTime, localTime, yyyy-MM-dd HH:mm:ss
		fileName := "logs\" . currentDate . fileSuffix . ".txt"
		FileAppend, % currentDateTime . "`t" . level . "`t" . msg . "`n", %fileName%
	}
}

formatSeconds(s) {
	time := 19990101 ; *Midnight* of an arbitrary date.
	time += %s%, seconds
	FormatTime, timeStr, %time%, HH:mm:ss
	return timeStr
}

toggleFlag(flagName, byref flag) {
	flag := !flag
	flagValue := flag ? "On" : "Off"
	showUserSplash("Toggled " . flagName . " " . flagValue)
}

scrollToZone(zone) {
	scrollZone(getZone(), zone)
}

scrollZone(fromZone, toZone) {
	global
	local zones := toZone - fromZone
	local xZone := zones > 0 ? xNextZone : xPrevZone

	if (zones != 0) {
		clickPos(xZone, yZone, abs(zones))
		sleep % scrollDelay + 25 + abs(zones) * scrollClickDelay
		clickPos(xMiddleZone, yZone)
		sleep % zzz
	}
}

getZone() {
	global
	local title, zone
	WinGetTitle, title, ahk_id %chWinId%
	zone := SubStr(title, 5, InStr(title, "-") - 6)
	return zone
}

reFocus() {
	global
	clickPos(xFocus, yFocus)
	sleep 25
}

; -----------------------------------------------------------------------------------------
; Note that all image/pixel searches are done with absolute coordinates relative to the
; screen. The CH window is required to be visible and in default size for this to work.
; -----------------------------------------------------------------------------------------

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

upLocator(image, what, byref xPos, byref yPos, byref retries:=0, clickCount:=5, absolute:=0, startAt:=0, silent:=0) {
	return locator(image, what, xPos, yPos, retries, clickCount, absolute, startAt, silent, 1)
}

; Try to locate the given image one screen at a time
locator(image, what, byref xPos, byref yPos, byref retries:=0, clickCount:=5, absolute:=0, startAt:=0, silent:=0, directionUp:=0) {
	global

	local attempts := ceil(45 / clickCount)
	local attempt := 0
	local keepGoing := true

	while (!locateImage(image, xPos, yPos, absolute, startAt, directionUp)) {
		keepGoing := directionUp ? !locateImage(imgCid) : true
		if (++attempt <= attempts and keepGoing) {
			if (directionUp) {
				scrollUp(clickCount)
				startAt := 0 ; only offset once
			} else {
				scrollDown(clickCount)
			}
		} else if (retries-- != 0) {
			if (!silent) {
				showDebugSplash("Could not locate " . what . "! Trying again...")
			}
			if (directionUp) {
				scrollToBottom()
			} else {
				scrollToTop()
			}
			attempt := 0
		} else {
			return 0
		}
	}
	return 1
}

locateImage(image, byref xPos:="", byref yPos:="", absolute:=0, startAt:=0, directionUp:=0) {
	if (directionUp) {
		return locateImageUp(image, xPos, yPos, absolute, startAt)
	} else {
		return locateImageDown(image, xPos, yPos, absolute, startAt)
	}
}

; Bottom up image search in chunks (size equal to the distance between two lvl up buttons)
locateImageUp(image, byref xPos:="", byref yPos:="", absolute:=0, startAt:=0) {
	global

	local yT := yScreenT + image.topOffset
	local searchCount := ceil((yScreenB - yT) / oLvl)
	local offset := 0
	if (startAt > 0) {
		offset := startAt - yScreenB
		searchCount := ceil((startAt - yT) / oLvl)
	}
	local topOffset := offset + yScreenB - yScreenT - oLvl
	local bottomOffset := offset

	; msgbox % "searchCount=" . searchCount . ", offset=" . offset . ", topOffset=" . topOffset . ", bottomOffset=" . bottomOffset

	loop % searchCount
	{
		if (locateImageDown(image, xPos, yPos, absolute, topOffset,, bottomOffset)) {
			return 1
		} else {
			topOffset -= oLvl
			if (A_Index > 1) { ; don't offset bottom until round two
				bottomOffset -= oLvl
			}
		}
	}
	return 0
}

; Top down image search
locateImageDown(image, byref xPos:="", byref yPos:="", absolute:=0, topOffset:=0, leftOffset:=0, bottomOffset:=0, rightOffset:=0) {
	global
	local imageFile := imageFilePath . image.file

	if (yScreenB = 0) {
		return 0 ; CH not started
	}

	local xL := xScreenL
	local yT := yScreenT
	local xR := xScreenR
	local yB := yScreenB

	xL += leftOffset ? leftOffset : image.leftOffset
	yT += topOffset ? topOffset : image.topOffset
	xR += rightOffset ? rightOffset : image.rightOffset
	yB += bottomOffset ? bottomOffset : image.bottomOffset

	; msgbox % "file=" . image.file . ", topOffset=" . image.topOffset . ", leftOffset=" . image.leftOffset . ", bottomOffset=" . image.bottomOffset . ", rightOffset=" . image.rightOffset
	; msgbox % "Searching from (" . xL . ", " . yT . ") to (" . xR . ", " . yB . ")"

	if (xL > xR or yT > yB) {
		msgbox,,% script,% "ImageSearch failed! xL (" . xL . ") > xR (" . xR . ") or yT (" . yT  . ") > yB (" . yB . ")"
		exit
	}
	reFocus()
	ImageSearch xPos, yPos, xL, yT, xR, yB, *30 %imageFile%
	if (ErrorLevel = 2) {
		playWarningSound()
		msgbox,,% script,% "ImageSearch failed! Could not open: " . imageFile
		exit
	} else if (ErrorLevel = 0 and !absolute) {
		; Absolute --> Relative
		xPos -= xWinPos
		yPos -= yWinPos
	}
	return !ErrorLevel
}

; Search for a specific pixel color within the given region
locatePixel(pixelColor, xL, yT, xR, yB, byref xPos:="", byref yPos:="") {
	global

	reFocus()
	PixelSearch, xPos, yPos, xL, yT, xR, yB, %pixelColor%,, Fast RGB
	if (ErrorLevel = 0) {
		; Absolute --> Relative
		xPos -= xWinPos
		yPos -= yWinPos
	}
	return !ErrorLevel
}

matchPixelColor(color, x, y) {
	reFocus()
	PixelGetColor, pixelColor, x, y, RGB
	; msgbox % "Is " . pixelColor . " at (" . x . ", " . y . ") equal to " . color . "?"
	return color = pixelColor
}
