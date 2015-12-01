
; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

irisLevel := 1029 ; try to keep your Iris within 1001 levels of your optimal zone

; -- Speed Run ----------------------------------------------------------------------------

; Clicker Heroes Ancients Optimizer @ http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
; Use the optimizer to set the optimal level and time:
optimalLevel := 2000
speedRunTime := 29 ; minutes (usually between 28 and 30 minutes)

; Siyalatas regilding chart @ https://redd.it/3frj62
; 1:Dread Knight, 2:Atlas, 3:Terra, 4:Phthalo, 5:Banana, 6:Lilin, 7:Cadmia, 8:Alabaster, 9:Astraea
gildedRanger := 6 ; the number of your main guilded ranger

; Speed Run debug info: Shift+Ctrl+F12 > Alt+F3

; -- Deep Run -----------------------------------------------------------------------------

deepRunTime := 60 ; minutes

deepRunClicks := true ; click the monster during a deep run?

; -- Vision Run ---------------------------------------------------------------------------

useImageSearch := false ; requires browser client in low quality mode
; Test hotkey: Win+F3 - Search & locate tests for all images

; Vision run
endLvlIdle := optimalLevel
endLvlActive := 0
; idle:   set endLvlActive = 0 (set activateSkillsAtStart to false for 100% idle)
; hybrid: set endLvlActive > endLvlIdle
; active: set endLvlIdle = 0

levelSolomon := false ; feed solomon after ascending?
solomonLevels := 5

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; -- Speed Run ----------------------------------------------------------------------------

; Add or remove time (in seconds) to or from the first hero.
firstStintAdjustment := 0 ; can be used to temporarily compensate for low Iris levels

hybridMode := false ; chain a deep run when the speed run finish

; -- Speed/Vision run ---------------------------------------------------------------------

activateSkillsAtStart := true ; usually needed in the late game to get going after ascending

autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention! <Shift+Ctrl+F1>

; Auto Ascend Warning Mode
; The following two settings may replace each other or can both be used.
; Set to 0 to disable completely
autoAscendDelay := 0 ; warning timer (in seconds) before ascending
displayRelicsDuration := 10 ; warning timer (in seconds) before salvaging the junk pile

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := false ; <Shift+Ctrl+F2>

saveBeforeAscending := false ; autosave the game. <Shift+Ctrl+F11>

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button2" ; Button1 or Button2

; If the auto-save fails to change the file name properly and you get
; a "already exists" message, change save mode to 2.
saveMode := 1 ; 1 or 2

; -- Deep/Vision run ----------------------------------------------------------------------

clickableHuntDelay := 8 ; hunt for a clickable every 8s
stopHuntThreshold := 4 ; stop hunt when this many minutes remain of a run

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
; Win+F1 - One Midas start
; Win+F2 - Loop Midas start + init run + ascend

; -- Look & Feel --------------------------------------------------------------------------

; true or false
global playNotificationSounds := false ; <Shift+Ctrl+F6>
global playWarningSounds := true ; <Shift+Ctrl+F7>
global showSplashTexts := true ; Note that some splash texts will always be shown. <Shift+Ctrl+F8>
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

comboEDR := [2.5*60, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]
comboEGolden := [2.5*60, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"]
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

; Hybrid combo
comboHybridIdle := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
comboHybridActive := [30, "5", "", "", "3", "", "", "8-9-2-5-7", "4", "", "3", "", "1-2"] ; > golden clicks, 6 minutes

; Midas: 1-4-5                                2:30                 5:00                 7:30                 10:00                  12:30                    15:00                        17:30
comboMidas := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2", "", "4", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-3-5", "", "", "2-4-7", "", "1", "", ""]

speedRunStartCombo := comboStart
deepRunCombo := comboGoldenLuck

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
; Alabaster    [6,6,6,5,6,3], 227 (Iris > 1760)
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

initPlanB := false ; alternate hero upgrade process

; -----------------------------------------------------------------------------------------

; Number of gilds to move over at a time
reGildCount := 300
reGildRanger := gildedRanger

raidAttempts := 5 ; Requires useImageSearch set to true

global debug := false ; Extra debug splash texts <Shift+Ctrl+F12>
