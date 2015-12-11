# Clicker Heroes Sw1ft Bot

A mid/late game bot for [Clicker Heroes][Reddit].

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

* Automated (optimal zone) Hero Souls farming
* Separate active _monster clicker_ script
    - Built in click speed throttle (when mouse enters window)
    - Remotely operated by the main bot script
* Supports user defined skill combos (see `tools/combo_tester.ahk`)
* Supports Midas starts
* Fast new gild opener
* Built in re-gilder between rangers
* Option to auto-save before ascending
* Monitored _click safety zones_ preventing bot misclicks

### Features without image search

* Can run in the background (behind windows, but not minimized)
* Supports both [Steam][] and [Web][] clients
    - (Steam) Supports window re-sizing (including Full Screen mode)
* Speed run loop (<kbd>Ctrl+F1</kbd>)
    - Navigates by timings based on your Iris level and gilded ranger
    - Supports idle and hybrid play
* Deep run (<kbd>Ctrl+F2</kbd>)
    - Intended as a continuation of a speed run
    - Utilizes the external _monster clicker_

Limitations:

* Without the support from visual cues, it is critically important that the [recommended game state](#minimum-recommended-game-state) is adhered to.

### Features with image search

* Vision run loop (<kbd>Ctrl+F3</kbd>)
    - Supports idle, hybrid and active play
    - Finds gilded heroes/rangers automatically
    - Levels to given zone lvl's
    - Picks up *clickables* without breaking idle
    - Does a Midas start if no clickable
    - Can automatically resume
* Enhanced Midas starts
* Can auto-level Solomon
* Hotkeys for raiding

Limitations:

* Only supported in the browser client (in low quality)
* Window must be visible in the foreground

### Minimum recommended game state

To operate as intended, the (background) Speed run needs a certain minimum game state:

* Atlas or higher ranger gilded
    - Any transitional hero/ranger used by the script must also be gilded
* _Optimal zone_ > 1000
* Iris > 145 (and within 1001 levels of the _optimal zone_)
* Siyalatas > 200
    - All other ancients must follow the [Rules of Thumb][]. Use the [Ancients Calculator][] to balance your ancients optimally.

These recommendations should give you enough gold after ascending with a *[clickable][Clickables]*, to instantly unlock, level and buy all upgrades for every hero down to and including Frostleaf.

Recommended minimum for the (foreground) Vision run:

* Samurai gilded
    - If the gilded hero is not visible after a clickable or Midas start, a transitional hero must be gilded

Midas start requirements:

* A maxed Khrysos
* Iris equal or higher than the _zone 2_ setting
* With image search - Siya > 400
* Without image search - Siya > 2000

## Setup

* Download and install the latest version of [AutoHotkey][]
* Download and unpack the zip file from the [latest release][]

## Starting the bot

* Start Clicker Heroes
* Double-click the `ch_sw1ft_bot.ahk` file to start the bot. In your taskbar you should see a green **H** icon.

If you run the browser version, you will get a "Clicker Heroes started in Steam?" warning message on your initial start. This is expected until you have configured the [Mandatory lib settings](#mandatory-lib-settings).

Unless they already exist, three user settings files will be created as copies of the default system settings. **All configuration changes should be made in these files:**

`ch_bot_lib_settings.ahk`, `ch_bot_settings.ahk` and `monster_clicker_settings.ahk`.

Note: If your Windows account don't have administrator rights, you might have to start the script by right-clicking it and select **Run as Administrator**.

## Configuration

* In Clicker Heroes, turn off:
    - __Show damage texts__ (can cause progression mode issues if left on)
    - __Show relic found popups__
* The Speed run requires that all heroes and rangers are kept expanded
* The Vision run allow for the following heroes to be be minimized: Brittany, Samurai (if not gilded), Forest Seer, Ma Zhu, Athena and any unused ranger besides Dread Knight.
* Use a decent text editor, like Sublime Text or Notepad++ when you configure this bot.
* [Common Setups](common_setups.md)

### Mandatory lib settings

    ch_bot_lib_settings.ahk

These only need to be changed if you run the browser client.

| Variable | Explanation |
| -------- | ----------- |
`SetTitleMatchMode` | **`3`** for Steam or **`regex`** for browser version <sup>(1)</sup>
`browser` | Browser name (e.g. Firefox)
`browserTopMargin`  | Browser top margin <sup>(2)</sup>

(1) Browser recommendation: Run Clicker Heroes in Firefox, then use Chrome or some other browser for your normal surfing activities.

(2) Make sure the Clicker Heroes window have focus, then click <kbd>Ctrl+Middle Mouse Button</kbd> dead center in the ancient tab eye like this: ![](images/ancient_eye_click.png?raw=true). Update the top margin and reload the script with <kbd>Alt+F5</kbd>, then position your mouse cursor at the top left corner (of the CH area) and click <kbd>Alt+Middle Mouse Button</kbd>. If the setting is correct, it should look like this:
![](images/top_corner_alt_mmb.png?raw=true)

Known issues:

* If active, the power savings setting turning of your monitor(s) can cause issues with AHK's image recognition. When last tested, only Firefox continued to run without any issues.
* The script can't handle any extra _stuff_ on the left side, e.g. a bookmark list.

### Mandatory bot settings

    ch_bot_settings.ahk

| Variable | Explanation |
| -------- | ----------- |
`irisLevel`    | Set to your Iris level in game

**Important!** If the script notifies or warns you about your Iris level, follow it's recommendations. Ignoring to do so, will most likely cause the script to fail.

#### Mandatory Speed run settings

| Variable | Explanation |
| -------- | ----------- |
`optimalLevel` | Your optimal zone level <sup>(3)</sup>
`speedRunTime` | The duration of the speed run <sup>(3)</sup>
`gildedRanger` | The number of your gilded ranger <sup>(4)</sup>

(3) Set according to the [Ancients Optimizer][] (open with <kbd>Ctrl+F5</kbd>).

(4) **1**:Dread Knight, **2**:Atlas, **3**:Terra, **4**:Phthalo, **5**:Banana, **6**:Lilin, **7**:Cadmia, **8**:Alabaster, **9**:Astraea

**Important!** Use the Siyalatas [regilding chart][] to make sure you are gilded correctly. The script will also use one or two heroes prior to your gilded ranger. Giving them one gild each should be enough to guarantee maximum “insta-kill” speed.

#### Mandatory Deep run settings

| Variable | Explanation |
| -------- | ----------- |
`deedRunTime` | The duration of the deep run
`deepRunClicks` | [`true`/`false`] Actively click?

Note: With `deepRunClicks` set to true, the separate _monster clicker_ script will be automatically started and controlled by the main bot script.

#### Mandatory Vision run settings

| Variable | Explanation |
| -------- | ----------- |
`useImageSearch` | Set to `true`
`endLvlIdle` | Idle end level
`endLvlActive` | Active end level

Set `endLvlActive` to zero for idle, `endLvlIdle` to zero for active and `endLvlActive` higher than `endLvlIdle` for hybrid.

### Optional bot settings

These are listed under the Optional Settings section in the `ch_bot_settings.ahk` file.

### Function tests

1. <kbd>Ctrl+Alt+F1</kbd> should scroll down to the bottom
2. <kbd>Ctrl+Alt+F2</kbd> should switch to the relics tab and then back

If any of these fail, validate your [lib settings](#mandatory-lib-settings), then reload the script with <kbd>Alt+F5</kbd> and try again.

## Starting a run

The Speed run (<kbd>Ctrl+F1</kbd>) is expecting to start after a fresh ascend with an available clickable.

The Deep run is expecting to start where a Speed run finishes. Start it manually with <kbd>Ctrl+F2</kbd>, or set `hybridMode` to true to automatically start it.

The Vision run is usually not that picky about game state, just try start it with <kbd>Ctrl+F3</kbd>. Error states:

| State | Error | Solution |
| ----- | ----- | -------- |
-3 | No Clicker Heroes window found   | Open the client
-2 | No vision                        | Set `useImageSearch` to `true`
-1 | Vision, but not in browser       | Use the browser client
 0 | Vision, but not finding anything | Use standard (100%) Windows sizes

## Main Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F1</kbd>       | Start the Speed run loop
<kbd>Ctrl+F2</kbd>       | Start a Deep run
<kbd>Ctrl+F3</kbd>       | Start the Vision run loop <sup>(5)</sup>
<kbd>Pause</kbd>         | Pause/unpause the script
<kbd>Alt+Pause</kbd>     | Abort any active run or initiated ascension
<kbd>Shift+Pause</kbd>   | Schedule a stop after finishing the current run
<kbd>Alt+F5</kbd>        | Reload the script (needed after configuration changes)
<kbd>Shift+Ctrl+F5</kbd> | Schedule a script reload after finishing the current run, then restart it
<kbd>Alt+F6</kbd>        | Re-initialize coordinates (needed after moving or re-sizing the client window)

(5) Requires `useImageSearch` set to `true`.

#### Supplementary Hotkeys

These hotkeys can be executed while a speed, deep or vision run is active.

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Esc</kbd> | Suspend/Unsuspend all other Hotkeys
<kbd>Ctrl+F5</kbd>  | Open the Ancients Optimizer and auto-import game save data
<kbd>Ctrl+F6</kbd>  | Set previous ranger as re-gild target
<kbd>Ctrl+F7</kbd>  | Set next ranger as re-gild target
<kbd>Ctrl+F8</kbd>  | Move `reGildCount` gilds to the target ranger <sup>(6)</sup>
<kbd>Ctrl+F9</kbd> | Open new gilds <sup>(6)</sup>
<kbd>Ctrl+F11</kbd> | Autosave the game
<kbd>Win+F6</kbd> | Raid once for free <sup>(5)</sup>
<kbd>Win+F7</kbd> | One paid raid <sup>(5)</sup>
<kbd>Win+F8</kbd> | `raidAttempts` paid raids <sup>(5)</sup>
<kbd>Shift+Ctrl+F1</kbd>  | Toggle the `autoAscend` flag
<kbd>Shift+Ctrl+F2</kbd>  | Toggle the `screenShotRelics` flag
<kbd>Shift+Ctrl+F6</kbd>  | Toggle the `playNotificationSounds` flag
<kbd>Shift+Ctrl+F7</kbd>  | Toggle the `playWarningSounds` flag
<kbd>Shift+Ctrl+F8</kbd>  | Toggle the `showSplashTexts` flag
<kbd>Shift+Ctrl+F11</kbd> | Toggle the `saveBeforeAscending` flag
<kbd>Shift+Ctrl+F12</kbd> | Toggle the `debug` flag

(6) Will pause the monster clicker if running.

#### Test Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Alt+F1</kbd>  | Should scroll down to the bottom
<kbd>Ctrl+Alt+F2</kbd>  | Should switch to the relics tab and then back
<kbd>Alt+F1</kbd>       | Test the `getClickable()` function
<kbd>Alt+F2</kbd>       | Test the `initRun()` function
<kbd>Alt+F3</kbd>       | Test the `speedRun()` function
<kbd>Alt+F4</kbd>       | Test the `ascend()` function
<kbd>Win+F1</kbd>       | Test the `midasStart()` function
<kbd>Win+F2</kbd>       | Loop Midas start > init run > ascend, twice
<kbd>Win+F3</kbd>       | Image search tests <sup>(5)</sup>

## Questions or comments?

Check the [FAQ](FAQ.md) or visit the original script [home][] on Reddit.

[Reddit]: https://www.reddit.com/r/ClickerHeroes/
[Steam]: http://store.steampowered.com/app/363970/
[Web]: https://www.clickerheroes.com/
[AutoHotkey]: http://ahkscript.org/
[Rules of Thumb]: http://redd.it/339m3j
[Ancients Calculator]: http://hsoptimizer.github.io/ancient/
[Ancients Optimizer]: http://philni.neocities.org/ancientssoul.html
[regilding chart]: https://redd.it/3frj62
[Clickables]: http://clickerheroes.wikia.com/wiki/Clickables
[home]: http://redd.it/3a3bmy
[latest release]: https://github.com/swiftb/clicker-heroes-sw1ft-bot/releases/latest
