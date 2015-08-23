
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

; -- Midas --------------------------------------------------------------------------------

useMidasStart := false

; Config syntax:
; [<boss zone 1>, <delay 1>, <extra boss zone>, <extra delay>, <zone 2>, <delay 2>]

; Midas Start Procedure:

; * Scroll to "boss zone 1" > Lvl Cid to 100 > Buy Clickstorm (1) > Scroll down and lvl Natalia to 1 > "delay 1"
; * (Optional) Scroll to "extra boss zone" > Lvl Natalias to 100 > Buy Natalias upgrades > "extra delay"

; We want to reach this point with an accumulated gold (ag) amount between one of these thresholds:
; 160T (Abaddon) <- ag -> 1350T (Ma Zhu) <- ag -> 12000T (Amenhotep) <- ag -> 150q (Beastlord)
; Target amounts:  755T                    6675T                      81000T

; At each threshold, a new hero will spawn and trigger a movement in the scrollbar.
; If that happens just as we try to scroll down to Broyle and Midas, the start will fail.
; Hence why we try to be between two thresholds in gold.

; * Scroll down > Scroll to "zone 2" > Lvl Broyle to 100 > "delay 2"
; * Lvl Midas to 100 > Buy Metal Detector (4) and Golden Clicks (5) -- Total cost ~60000T
; * Activate Progression Mode > Activate skills 1-4-5 > Coin pickup delay (6 seconds)

; Example configs:

; Two zones
; Siya 14000: [60, 7, 0, 0, 79, 5]
; Siya 7000: [55, 6, 0, 0, 79, 5]

; Three zones
; Siya 3500: [50, 5, 60, 4, 74, 5]
; Siya 2000: [50, 6, 60, 6, 69, 5]

midasZoneConfig := [60, 7, 0, 0, 79, 5]

; -- Speed run ----------------------------------------------------------------------------

; If the script starts on the 2nd ranger too early (before lvl 100) or too late (after lvl 200), adjust this setting.
firstStintAdjustment := 0 ; Add or remove time (in seconds) to or from the first hero.

activateSkillsAtStart := true ; usually needed in the late game to get going after ascending

hybridMode := false ; chain a deep run when the speed run finish

ascDownClicks := 26 ; # of down clicks needed to get the ascension button center:ish (after a full speed run)

autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention!

; Auto Ascend Warning Mode
; The following two settings may replace each other or can both be used.
; Set to 0 to disable completely
autoAscendDelay := 10 ; warning timer (in seconds) before ascending
displayRelicsDuration := 10 ; warning timer (in seconds) before salvaging the junk pile

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := false

saveBeforeAscending := false ; autosave the game

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button1" ; Button1 or Button2

; If the auto-save fails to change the file name properly and you get
; a "already exists" message, change save mode to 2.
saveMode := 1 ; 1 or 2

debug := false ; when set to "true", you can press Alt+F3 to show some debug info (also copied into your clipboard)

; -- Deep run -----------------------------------------------------------------------------

deepRunTime := 60 ; minutes

clickableHuntDelay := 15 ; hunt for a clickable every 15s
stopHuntThreshold := 30 ; stop hunt when this many minutes remain of a deep run

; Number of gilds to move over at a time
reGildCount := 100 ; don't set this higher than 100 if you plan on moving gilds during a deep run
reGildRanger := gildedRanger + 1 

deepRunClicks := true ; click the monster during a deep run?

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
; Alabaster    [6,5,6,6,6,3], 260 (Iris > 1760)
; Alabaster    [5,6,6,5,6,3], 293 (Iris > 1760)
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
comboEGolden := [2.5*60, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"] ; energize 3 (dmg) or 5 (gold)
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

speedRunStartCombo := comboStart
deepRunCombo := comboGoldenLuck
