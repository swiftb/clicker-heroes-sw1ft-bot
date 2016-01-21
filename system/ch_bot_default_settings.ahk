
; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

irisLevel := 1029 ; try to keep your Iris within 1001 levels of your optimal zone

; Siyalatas regilding chart @ https://redd.it/3frj62
; 1:Dread Knight, 2:Atlas, 3:Terra, 4:Phthalo, 5:Banana, 6:Lilin, 7:Cadmia, 8:Alabaster, 9:Astraea
; 10:Chiron, 11:Moloch, 12:Bomber Max, 13:Gog, 14:Wepwawet
gildedRanger := 6 ; the number of your main guilded ranger

; -- Speed Run ----------------------------------------------------------------------------

; Clicker Heroes Ancients Optimizer @ http://philni.neocities.org/ancientssoul.html
; Use the optimizer to set the time:
speedRunTime := 29 ; minutes

; -- Vision Run ---------------------------------------------------------------------------

useImageSearch := false ; requires browser client in low quality mode
; Test hotkey: Win+F3 - Search & locate tests for all images

; Vision Run
endLvlIdle := 2000
endLvlActive := 0
; idle:   set endLvlActive = 0 (set activateSkillsAtStart to false for 100% idle)
; hybrid: set endLvlActive > endLvlIdle
; active: set endLvlIdle = 0

; -- Early Game Vision Run ----------------------------------------------------------------

earlyGameMode := false

kumawakamaruLevel := 0

; Farm till clearing this zone, then use skills when getting stuck on a boss, twice, then ascend
lastFarmZone := 129 ; xx4/xx9

; When reaching this zone the script will start leveling only gilded heroes
power5Zone := 181 ; pref. Treebeast, Ivan, Brittany, Samurai, Seer

; -- Deep Run -----------------------------------------------------------------------------

deepRunTime := 60 ; minutes

deepRunClicks := true ; click the monster during a Deep Run?

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; -- Speed Run ----------------------------------------------------------------------------

firstStintAdjustment := 0 ; add or remove time (in seconds) to or from the first hero
firstStintButton := 1 ; 1 or 2 (if possible)

hybridMode := false ; chain a Deep Run when the Speed Run finish

; -- Vision Run ---------------------------------------------------------------------------

forcedMidasStart := false ; use only for active play with custom Midas combo 

levelSolomon := false ; feed solomon after ascending?
solomonLevels := 5

; -- Speed/Vision Run ---------------------------------------------------------------------

activateSkillsAtStart := true ; usually needed in the late game to get going after ascending

clickerDuration := 90 ; monster clicker duration (in seconds). 0 = endless

autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention! <Shift+Ctrl+F1>

; Auto Ascend Warning Mode
; The following two settings may replace each other or can both be used.
; Set to 0 to disable completely
autoAscendDelay := 0 ; warning timer (in seconds) before ascending
displayRelicsDuration := 10 ; warning timer (in seconds) before salvaging the junk pile

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := false

saveBeforeAscending := false ; autosave the game. <Shift+Ctrl+F11>

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button2" ; Button1 or Button2

; If the auto-save fails to change the file name properly and you get
; a "already exists" message, change save mode to 2.
saveMode := 1 ; 1 or 2

; -- Deep/Vision Run ----------------------------------------------------------------------

clickableHuntDelay := 5 ; hunt for a clickable every 5s

; Stop hunt when this many minutes remain of a run.
; Set to 0 when using the Vision Run, or Speed Run in hybrid mode with Midas starts
stopHuntThreshold := 20
; Odds of getting a clickable for different thresholds:
; 5 - 59.4%, 10 - 83.5%, 15 - 93.3%, 20 - 97.3%, 25 - 98.9%, 30 - 99.55%

; -- Midas --------------------------------------------------------------------------------

useMidasStart := false ; pref. used with the useImageSearch option

; Getting a stable Midas start without visual aid, is hard with low Siyalatas levels.
; The tricky part is the scroll down from Natalia to Midas. No new heroes must spawn
; during this time or this step will fail.

; Config syntax:
; [<zone 1>, <delay 1>, <extra zone>, <extra delay>, <zone 2>, <delay 2>]

midasZoneConfig := [56, 6, 0, 0, 76, 0]

; Example configs:

; useImageSearch = false           | useImageSearch = true
; Siya 28000: [65, 6, 0, 0, 86, 0] | [66, 5, 0, 0, 86, 0]
; Siya 14000: [60, 7, 0, 0, 83, 4] | [63, 6, 0, 0, 83, 0]
; Siya 7000:  [55, 9, 0, 0, 79, 5] | [59, 6, 0, 0, 79, 0]
; Siya 3500: [50, 5, 60, 4, 76, 4] | [56, 6, 0, 0, 76, 0]
; Siya 2000: [50, 6, 60, 6, 73, 4] | [53, 6, 0, 0, 73, 4]
; Siya 400:                        | [47, 5, 57, 4, 67, 4]

; Test hotkeys:
; Win+F1 - One Midas Start
; Win+F2 - Loop Midas Start + Init Run + ascend

; -- Look & Feel --------------------------------------------------------------------------

; true or false
global playNotificationSounds := false ; <Shift+Ctrl+F6>
global playWarningSounds := true ; <Shift+Ctrl+F7>
global showProgressBar := true

; Splash text window width and position
wSplash := 200
xSplash := A_ScreenWidth // 2 - wSplash // 2 ; centered
ySplash := A_ScreenHeight // 2 - 40

; Progress bar width and position
wProgressBar := 325
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
comboStart2 := [15*60, "8-5-2-3-4-7-6-9"] ; requires deepRunClicks set to true

comboEDR := [2.5*60, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]
comboEGolden := [2.5*60, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"]
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

comboEarlyGame := [10*60, "3-7-8-9-4-5-6", "2-3-7", "2", "2", "2-3-4", "2", "2"]

; Hybrid combo
comboHybridIdle := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
comboHybridActive := [30, "5", "", "", "3", "", "", "8-9-2-5-7", "4", "", "3", "", "1-2"] ; > golden clicks, 6 minutes

; Midas: 1-4-5                                2:30                 5:00                 7:30                 10:00                  12:30                    15:00                        17:30
comboMidas := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2", "", "4", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-3-5", "", "", "2-4-7", "", "1", "", ""]

; Midas: 1-4-5                                 2:30                 5:00                 7:30                  10:00                  12:30                     15:00                       17:30
comboMidas2 := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2-4", "", "", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-2-5-7", "4", "", "3", "", "1-2", "", ""]

speedRunStartCombo := comboStart2
deepRunCombo := comboGoldenLuck

; -----------------------------------------------------------------------------------------

; Number of gilds to move over at a time
reGildCount := 300
reGildRanger := gildedRanger

raidAttempts := 5 ; Requires useImageSearch set to true
