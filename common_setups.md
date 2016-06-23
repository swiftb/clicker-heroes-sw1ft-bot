# Common Setups

Example settings for different styles of play.

#### Idle

    endLvlIdle := 100000
    endLvlActive := 0

#### Hybrid

    endLvlIdle := 1000
    endLvlActive := 100000

#### Active

    endLvlIdle := 0
    endLvlActive := 100000

## Do not disturb

    autoAscendDelay := 0
    displayRelicsDuration := 0

    saveBeforeAscending := false

    global playNotificationSounds := false
    global playWarningSounds := false

    showSeverityLevel := 0 ; ch_bot_lib_settings.ahk

## Dual monitors

#### Left monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 - A_ScreenWidth

#### Right monitor

    xSplash := A_ScreenWidth // 2 - wSplash // 2 + A_ScreenWidth
