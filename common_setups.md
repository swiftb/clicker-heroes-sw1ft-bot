# Common Setups

Example settings for different styles of play.

## Overview

* [Vision Run](#vision-run)
* [Do not disturb](#do-not-disturb)
* [Dual monitors](#dual-monitors)

## Vision Run

    gildedRanger := 0 ; "Power 5" (Treebeast, Ivan, Brittany, Samurai and Forest Seer)

    useImageSearch := true

#### Idle

    endLvlIdle := 100000
    endLvlActive := 0
    skillCombo := comboEarlyGameIdle

#### Active

    endLvlIdle := 0
    endLvlActive := 100000
    skillCombo := comboEarlyGameActive

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
