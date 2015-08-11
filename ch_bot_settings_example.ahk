
; -- Mandatory Configuration --------------------------------------------------------------

; Browser settings:
; SetTitleMatchMode, regex
; browserTopMargin := 230

irisLevel := 1559

; Set according to the Ancients Optimizer
optimalLevel := 2500
speedRunTime := 27 ; minutes
gildedRanger := 8 ; Alabaster

; -- Optional Settings --------------------------------------------------------------------

firstStintAdjustment := -45 ; Add or remove time (in seconds) to or from the first hero.

hybridMode := true ; chain a deep run when the speed run finish
deepRunTime := 6 ; minutes

; Special hybrid run combo setup
speedRunStartCombo := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
deepRunCombo := [30, "5-2-4-6-7", "", "", "3-8-9", "", "", "2", "", "", "3-7", "", "1-2"] ; > golden clicks, 6 minutes

autoAscend := true ; afk farming
autoAscendDelay := 5 ; warning timer (in seconds) before ascending

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := true

saveBeforeAscending := true ; autosave the game

; If the script don't press the save button automatically when running
; with "saveBeforeAscending" set to true, change "Button1" to "Button2".
saveButtonClassNN := "Button1" ; or Button2

; Left monitor
xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth
xProgressBar := 20 - A_ScreenWidth
