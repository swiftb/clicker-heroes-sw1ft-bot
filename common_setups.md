# Common Setups

Example settings for different styles of play.

## Overview

* [Speed Run](#speed-run)
* [Vision Run](#vision-run)
* [Early Game Vision Run](#early-game-vision-run)
* [Deep Run](#deep-run)
* [Do not disturb](#do-not-disturb)
* [Dual monitors](#dual-monitors)

## Global Settings

    gildedRanger := 6 ; Lilin

    autoAscend := true
    saveBeforeAscending := true

## Speed Run

    useImageSearch := false

#### Idle

    irisLevel := 1029
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

## Vision Run

    useImageSearch := true

    clickableHuntDelay := 5
    stopHuntThreshold := 0

    useMidasStart := true
    midasZoneConfig := [56, 6, 0, 0, 76, 0]

#### Idle

    irisLevel := 1029
    endLvlIdle := 2000
    endLvlActive := 0

    activateSkillsAtStart := false
    deepRunClicks := false

#### Hybrid

    irisLevel := 1199
    endLvlIdle := 2000
    endLvlActive := 2200

    activateSkillsAtStart := true
    deepRunClicks := true

    speedRunStartCombo := comboHybridIdle
    deepRunCombo := comboHybridActive

#### Active

    gildedRanger := 7 ; Cadmia

    irisLevel := 1669
    endLvlIdle := 0
    endLvlActive := irisLevel + 1 + 630

    activateSkillsAtStart := false
    deepRunClicks := true

    deepRunCombo := comboMidas

## Early Game Vision Run

    useImageSearch := true
    earlyGameMode := true

    deepRunClicks := true
    deepRunCombo := comboEarlyGame

    clickableHuntDelay := 5
    stopHuntThreshold := 0

    clickerDuration := 30

#### Idle

    endLvlIdle := 500
    endLvlActive := 10 ; need this unless Khrysos lvl > 0

    lastFarmZone := 129

#### Active

    endLvlIdle := 0
    endLvlActive := 500

    lastFarmZone := 139

## Deep Run

    deepRunTime := 60 * 8
    deepRunClicks := true

    deepRunCombo := comboEDR

## Do not disturb

    autoAscendDelay := 0
    displayRelicsDuration := 0

    screenShotRelics := false
    saveBeforeAscending := false

    global playNotificationSounds := false
    global playWarningSounds := false
    global showProgressBar := false

    showSeverityLevel := 0 ; ch_bot_lib_settings.ahk

## Dual monitors

#### Left monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth
    xProgressBar := 20 - A_ScreenWidth

#### Right monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 + A_ScreenWidth
    xProgressBar := 20 + A_ScreenWidth

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

*****

    comboHybridIdle := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
   
    comboHybridActive := [30, "5", "", "", "3", "", "", "8-9-2-5-7", "4", "", "3", "", "1-2"] ; > golden clicks, 6 minutes

    00:00 : 5
    01:30 : 3
    03:00 : 8-9-2-5-7
    03:30 : 4
    04:30 : 3
    05:30 : 1-2

*****

    ; ~18 minutes active
    comboMidas := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2", "", "4", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-3-5", "", "", "2-4-7", "", "1", "", ""]

    00:00 : 9-3-8-6
    00:30 : 2
    03:00 : 2
    05:30 : 2
    08:00 : 2
    09:00 : 4
    10:30 : 2-5
    13:30 : 3
    15:00 : 8-9-3-5
    16:30 : 2-4-7
    17:30 : 1
