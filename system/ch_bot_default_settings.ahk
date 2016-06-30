
; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

; 0: "Power 5" (Treebeast, Ivan, Brittany, Samurai and Forest Seer)
; -1: Samurai
; 1:Dread Knight, 2:Atlas, 3:Terra, 4:Phthalo, 5:Banana, 6:Lilin, 7:Cadmia, 8:Alabaster, 9:Astraea
; 10:Chiron, 11:Moloch, 12:Bomber Max, 13:Gog, 14:Wepwawet
; 15:Betty, 16:Midas (use Wepwawet as the last transitional ranger)
gildedRanger := 0 ; the number of your main gilded ranger

; Ascensions will automatically trigger when things slow down to much
endLvlIdle := 100000
endLvlActive := 0
; idle:   set endLvlActive = 0
; hybrid: set endLvlActive > endLvlIdle
; active: set endLvlIdle = 0

chronos := 0.00 ; +#.## seconds to Boss Fight timers
kumawakamaru := -0.00 ; -#.## monsters required to advance to the next level
vaagur := -0.00 ; -#.##% skill cooldowns

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; Ascend when exceeded
maxMonsterKillTime := 2.5 ; seconds
; At a zone average monster kill time of 2.0 or higher, the bot will stop and farm before attempting a boss.
; Setting the max to 2.0 or lower, will cause the bot to immediately ascend instead

autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention! <Shift+Ctrl+F1>

; Auto Ascend Warning Mode
; The following two settings may replace each other or can both be used.
; Set to 0 to disable completely
autoAscendDelay := 10 ; warning timer (in seconds) before ascending
displayRelicsDuration := 0 ; warning timer (in seconds) before salvaging the junk pile

levelSolomon := false ; feed Solomon after ascending?
solomonLevels := 5

; -- Saving -------------------------------------------------------------------------------

saveBeforeAscending := false ; autosave the game. <Shift+Ctrl+F11>

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button2" ; Button1 or Button2

; If the auto-save fails to change the file name properly and you get
; a "already exists" message, change save mode to 2.
saveMode := 1 ; 1 or 2

; -- Skill Combos -------------------------------------------------------------------------

; 1 - Clickstorm, 2 - Powersurge, 3 - Lucky Strikes, 4 - Metal Detector, 5 - Golden Clicks
; 6 - The Dark Ritual, 7 - Super Clicks, 8 - Energize, 9 - Reload

; Test with tools/combo_tester.ahk

cooldown := ceil(600*(1 + vaagur/100))

comboEDR := [cooldown, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]
comboGoldenLuck := [cooldown, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

skillCombo := comboGoldenLuck

; -- Look & Feel --------------------------------------------------------------------------

noSleep := false ; keep your computer awake and display turned on

global playNotificationSounds := false ; <Shift+Ctrl+F6>
global playWarningSounds := true ; <Shift+Ctrl+F7>

; Splash text window width and position
wSplash := 200
xSplash := A_ScreenWidth // 2 - wSplash // 2 ; center monitor
ySplash := A_ScreenHeight // 2 - 40

; If you run with a dual/tripple monitor setup, you can move windows
; right or left by adding or subtracting A_ScreenWidth from the x-parameter.

; Left monitor example:
; xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth

; -- Paid Raids ---------------------------------------------------------------------------

raidAttempts := 5

; -- Zone Data Logger ---------------------------------------------------------------------

; Enabled will start to log zone data after each completed run
useZoneDataLogger := false
zdlStart := 100
zdlInterval := 10

; -- Clickables ---------------------------------------------------------------------------

; Existing clickable image files:
; clickable_bag.png, clickable_cake.png, clickable_candy.png, clickable_cane.png
; clickable_egg.png, clickable_fish.png, clickable_heart.png
clickableImageFiles := ["clickable_fish.png", "clickable_egg.png"] ; fish + "current other clickable"

clickableHuntDelay := 5 ; hunt for a clickable every 5s
