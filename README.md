# Clicker Heroes Sw1ft Bot

A game bot for [Clicker Heroes][Reddit].

## Overview

* [Features](#general-features)
* [Minimum recommended game state](#minimum-recommended-game-state)
* [Setup](#setup)
* [Starting the bot](#starting-the-bot)
* [Configuration](#configuration)
* [Starting a run](#starting-a-run)
* [Hotkeys](#main-hotkeys)
* [Questions or comments?](#questions-or-comments)

## General Features

* Automated Hero Souls farming
* Separate active _monster clicker_ script
    - Built in click speed throttle (when mouse enters window)
    - Remotely operated by the main bot script
* Supports user defined skill combos (see `tools/combo_tester.ahk`)
* Built in re-gilder between rangers
* Option to auto-save before ascending
* Monitored _click safety zones_ preventing bot misclicks
* Logging to file

### Features without image search

* Can run in the background (behind windows, but not minimized)
* Supports both [Steam][] and [Web][] clients
    - (Steam) Supports window re-sizing (including Full Screen mode)
* Speed run loop (<kbd>Ctrl+F1</kbd>)
    - DOES NOT SUPPORT THE TRANSCEND RELEASE!
* Deep run (<kbd>Ctrl+F2</kbd>)
    - DOES NOT SUPPORT THE TRANSCEND RELEASE!

### Features with image search

* Vision run loop (<kbd>Ctrl+F3</kbd>)
    - Supports idle, hybrid and active play
    - Finds gilded heroes/rangers automatically
    - Dynamic ascensions triggered by tunable monster kill time thresholds
    - Picks up *clickables* without breaking idle
    - Can automatically resume
* Can auto-level Solomon
* Hotkeys for raiding

**Limitations:**

* Only supported in the browser client (in low quality)
* Window must be visible in the foreground

### Minimum recommended game state

**Recommended minimum for the (foreground) Vision run:**

* World Ascensions > 2
    - Need the Buy Available Upgrades button. Recommendation: Save 100 rubies and buy two Quick Ascension's @ Lvl 10 after every Trancend.

## Setup

* Download and install the latest version of [AutoHotkey][]
* Download and unpack the zip file from the [latest release][]

## Starting the bot

* Start Clicker Heroes
* Double-click the `ch_sw1ft_bot.ahk` file to start the bot. In your taskbar you should see a green **H** icon.

If you run the browser version, you will get a "Clicker Heroes started in Steam?" warning message on your initial start. This is expected until you have configured the [Mandatory lib settings](#mandatory-lib-settings).

Unless they already exist, three user settings files will be created as copies of the default system settings. **All configuration changes should be made in these files:**

`ch_bot_lib_settings.ahk`, `ch_bot_settings.ahk` and `monster_clicker_settings.ahk`.

**Note:** If your Windows account don't have administrator rights, you might have to start the script by right-clicking it and select **Run as Administrator**.

## Configuration

* In Windows:
    - Set display scaling to 100% (96 DPI)
    - Use True Color (32 bit)
* In Clicker Heroes, turn off:
    - __Show damage texts__ (can cause progression mode issues if left on)
    - __Show relic found popups__
* The Speed run requires that all heroes and rangers are kept expanded
* The Vision run allow for the following heroes to be be minimized: Brittany, Samurai, Forest Seer, Natalia, Ma Zhu, Athena and any unused rangers besides Dread Knight. Bomber Max and Gog should also not be minimized as we want the 50% gold and dps buffs.
* Use a decent text editor, like Sublime Text or Notepad++ when you configure this bot.
* [Common Setups](common_setups.md)

### Mandatory lib settings

    ch_bot_lib_settings.ahk

These only need to be changed if you run the browser client.

| Variable | Explanation |
| -------- | ----------- |
`SetTitleMatchMode` | **3** for Steam or **regex** for browser version <sup>(1)</sup>
`browser`           | Browser name (e.g. Opera)
`browserTopMargin`  | Browser top margin <sup>(2)</sup>

(1) Browser recommendation: Run Clicker Heroes in Opera, then use Chrome or some other browser for your normal surfing activities.

(2) Make sure the Clicker Heroes window have focus, then click <kbd>Ctrl+Middle Mouse Button</kbd> dead center in the ancient tab eye like this: ![](images/ancient_eye_click.png?raw=true). Update the top margin and reload the script with <kbd>Alt+F5</kbd>, then position your mouse cursor at the top left corner (of the CH area) and click <kbd>Alt+Middle Mouse Button</kbd>. If the setting is correct, it should look like this:
![](images/top_corner_alt_mmb.png?raw=true)

### Optional lib settings

| Variable | Explanation |
| -------- | ----------- |
`fullScreenOption` | [**true**/**false**] Steam borderless fullscreen
`showSeverityLevel` | **0**:OFF, **1**:WARN, **2**:USER, **3**:INFO, **4**:DEBUG, **5**:TRACE
`logSeverityLevel`  | **0**:OFF, **1**:WARN, **2**:USER, **3**:INFO, **4**:DEBUG, **5**:TRACE

Setting a level to X, will show or log all messages from that level and below. E.g. setting `showSeverityLevel` to **1** and `logSeverityLevel` to **5**, will only show warning messages as splash texts, but will log everything to file.

**Known issues:**

* If active, the power savings setting turning of your monitor(s) can cause issues with AHK's image recognition. When last tested, only Firefox continued to run without any issues.
* The script can't handle any extra _stuff_ on the left side, e.g. a bookmark list.

### Mandatory bot settings

    ch_bot_settings.ahk

| Variable | Explanation |
| -------- | ----------- |
`gildedRanger` | The number of your main gilded ranger <sup>(3)</sup> <sup>(4)</sup>

(3) **1**:Dread Knight, **2**:Atlas, **3**:Terra, **4**:Phthalo, **5**:Banana, **6**:Lilin, **7**:Cadmia, **8**:Alabaster, **9**:Astraea, **10**:Chiron, **11**:Moloch, **12**:Bomber Max, **13**:Gog, **14**:Wepwawet

(4) **0**:*Power 5*, **-1**:Samurai

#### Mandatory Speed run settings

| Variable | Explanation |
| -------- | ----------- |
`speedRunTime` | The duration of the speed run <sup>(5)</sup>

(5) Set according to the [Ancients Optimizer][] (open with <kbd>Ctrl+F5</kbd>).

**Important!** Use the Siyalatas [regilding chart][] to make sure you are gilded correctly. Any transitional hero used by the bot must also be gilded.

#### Mandatory Vision run settings

| Variable | Explanation |
| -------- | ----------- |
`useImageSearch` | Set to **true**
`endLvlIdle`     | Idle end level
`endLvlActive`   | Active end level

Set `endLvlActive` to zero for idle, `endLvlIdle` to zero for active and `endLvlActive` higher than `endLvlIdle` for hybrid.

#### Mandatory Deep run settings

| Variable | Explanation |
| -------- | ----------- |
`deedRunTime`   | The duration of the deep run
`deepRunClicks` | [**true**/**false**] Actively click?

**Note:** With `deepRunClicks` set to true, the separate _monster clicker_ script will be automatically started and controlled by the main bot script.

### Optional bot settings

These are listed under the Optional Settings section in the `ch_bot_settings.ahk` file.

### Function tests

1. <kbd>Ctrl+Alt+F1</kbd> should scroll down to the bottom
2. <kbd>Ctrl+Alt+F2</kbd> should switch between all used tabs

If any of these fail, validate your [lib settings](#mandatory-lib-settings), then reload the script with <kbd>Alt+F5</kbd> and try again.

## Starting a run

The Vision run is usually not that picky about game state, just try start it with <kbd>Ctrl+F3</kbd>. Error states:

| State | Error | Solution |
| ----- | ----- | -------- |
-3 | No Clicker Heroes window found   | Open the client
-2 | No vision                        | Set `useImageSearch` to **true**
-1 | Vision, but not in browser       | Use the browser client
 0 | Vision, but not finding anything | In Windows, use standard 100% (96 DPI) display scaling in (32 bit) True Color

## Main Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F1</kbd>       | Start the Speed run loop
<kbd>Ctrl+F2</kbd>       | Start a Deep run
<kbd>Ctrl+F3</kbd>       | Start the Vision run loop <sup>(6)</sup>
<kbd>Pause</kbd>         | Pause/unpause the script
<kbd>Alt+Pause</kbd>     | Abort any active run or initiated ascension
<kbd>Shift+Pause</kbd>   | Schedule a stop after finishing the current run
<kbd>Alt+F5</kbd>        | Reload the script (needed after configuration changes)
<kbd>Shift+Ctrl+F5</kbd> | Schedule a script reload after finishing the current run, then restart it
<kbd>Alt+F6</kbd>        | Re-initialize coordinates (needed after moving or re-sizing the client window)

(6) Requires `useImageSearch` set to **true**.

#### Supplementary Hotkeys

These hotkeys can be executed while a speed, deep or vision run is active.

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Esc</kbd> | Suspend/Unsuspend all other Hotkeys
<kbd>Ctrl+F5</kbd>  | Open the Ancients Optimizer and auto-import game save data
<kbd>Ctrl+F6</kbd>  | Set previous ranger as re-gild target
<kbd>Ctrl+F7</kbd>  | Set next ranger as re-gild target
<kbd>Ctrl+F8</kbd>  | Move all gilds to the target ranger <sup>(7)</sup>
<kbd>Ctrl+F11</kbd> | Autosave the game
<kbd>Win+F6</kbd> | Raid once for free <sup>(6)</sup>
<kbd>Win+F7</kbd> | One paid raid <sup>(6)</sup>
<kbd>Win+F8</kbd> | `raidAttempts` paid raids <sup>(6)</sup>
<kbd>Shift+Ctrl+F1</kbd>  | Toggle the `autoAscend` flag
<kbd>Shift+Ctrl+F6</kbd>  | Toggle the `playNotificationSounds` flag
<kbd>Shift+Ctrl+F7</kbd>  | Toggle the `playWarningSounds` flag
<kbd>Shift+Ctrl+F11</kbd> | Toggle the `saveBeforeAscending` flag

(7) Will pause the monster clicker if running.

#### Test Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Alt+F1</kbd>  | Should scroll down to the bottom
<kbd>Ctrl+Alt+F2</kbd>  | Should switch between all used tabs
<kbd>Alt+F1</kbd>       | Test the `getClickable()` function
<kbd>Alt+F2</kbd>       | Test the `initRun()` function
<kbd>Alt+F3</kbd>       | Test the `speedRun()` function
<kbd>Alt+F4</kbd>       | Test the `ascend()` function
<kbd>Win+F1</kbd>       | Image search tests <sup>(6)</sup>

## Questions or comments?

Check the [FAQ](FAQ.md) or visit the original script [home][] on Reddit.

[Reddit]: https://www.reddit.com/r/ClickerHeroes/
[Steam]: http://store.steampowered.com/app/363970/
[Web]: https://www.clickerheroes.com/
[AutoHotkey]: http://ahkscript.org/
[Rules of Thumb]: https://redd.it/3y57jd
[Ancients Optimizer]: http://philni.neocities.org/ancientssoul.html
[regilding chart]: https://redd.it/3frj62
[Clickables]: http://clickerheroes.wikia.com/wiki/Clickables
[home]: https://redd.it/3wxwfu
[latest release]: https://github.com/swiftb/clicker-heroes-sw1ft-bot/releases/latest
