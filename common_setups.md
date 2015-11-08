# Common Setups

## Global Settings

    optimalLevel := 2000

    autoAscend := true
    saveBeforeAscending := true

## Speed Run

    useImageSearch := false
    gildedRanger := 6 ; Lilin

#### Idle

    irisLevel := 999
    speedRunTime := 29

    activateSkillsAtStart := true
    deepRunClicks := false
    hybridMode := false

    speedRunStartCombo := comboStart

#### Hybrid

    irisLevel := 1199
    speedRunTime := 23
    deepRunTime := 6

    activateSkillsAtStart := true
    deepRunClicks := true
    hybridMode := true

    speedRunStartCombo := comboHybridIdle
    deepRunCombo := comboHybridActive

## Deep Run

    deepRunTime := 60 * 8
    deepRunClicks := true

    deepRunCombo := comboEDR

## Vision Run

    useImageSearch := true
    gildedRanger := 6 ; Lilin

    clickableHuntDelay := 8
    stopHuntThreshold := 0

    useMidasStart := true
    midasZoneConfig := [56, 6, 0, 0, 76, 0]

#### Idle

    irisLevel := 999
    endLvlIdle := optimalLevel
    endLvlActive := 0

    activateSkillsAtStart := false
    deepRunClicks := false

#### Hybrid

    irisLevel := 1199
    endLvlIdle := optimalLevel
    endLvlActive := 2200

    activateSkillsAtStart := true
    deepRunClicks := true

    speedRunStartCombo := comboHybridIdle
    deepRunCombo := comboHybridActive

#### Active

    gildedRanger := 7 ; Cadmia

    irisLevel := 1649
    endLvlIdle := 0
    endLvlActive := irisLevel + 650

    activateSkillsAtStart := false
    deepRunClicks := true

    deepRunCombo := comboMidas

## Skill combos

    comboEDR := [2.5*60, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

    00:00 : 2-3-4-5-7-8-6-9
    15:00 : 8-9-2-3-4-5-7
    17:30 : 2
    20:00 : 2
    22:30 : 2-3-4
    25:00 : 2
    27:30 : 2
    30:00 : repeat

    comboHybridIdle := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
   
    comboHybridActive := [30, "5-2-4-6-7", "", "", "3-8-9", "", "", "2", "", "", "3-7", "", "1-2"] ; > golden clicks, 6 minutes active

    00:00 : 5-2-4-6-7
    01:30 : 3-8-9
    03:00 : 2
    04:30 : 3-7
    05:30 : 1-2

    ; 19 minutes active
    comboMidas := [30, "8-9-6", "", "2-3-4-5-7", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2-3-4", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2-4-3-5-8-9", "", "", "3-5-7", "", "1-2", "", ""]

    00:00 : 8-9-6
    01:00 : 2-3-4-5-7
    03:30 : 2
    06:00 : 2
    08:30 : 2-3-4
    11:00 : 2
    13:30 : 2
    16:00 : 2-4-3-5-8-9
    17:30 : 3-5-7
    18:30 : 1-2

## Do not disturb

    autoAscendDelay := 0
    displayRelicsDuration := 0

    screenShotRelics := false
    saveBeforeAscending := false

    global playNotificationSounds := false
    global playWarningSounds := false
    global showSplashTexts := false
    global showProgressBar := false

## Dual monitors

#### Left monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth
    xProgressBar := 20 - A_ScreenWidth

#### Right monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 + A_ScreenWidth
    xProgressBar := 20 + A_ScreenWidth
