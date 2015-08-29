# Clicker Heroes Sw1ft Bot

A mid/late game bot for [Clicker Heroes][Reddit].

## Overview

* [Features](#features)
* [Minimum recommended game state](#minimum-recommended-game-state)
* [Setup](#setup)
* [Starting the bot](#starting-the-bot)
* [Configuration](#configuration)
* [Hotkeys](#main-hotkeys)

## Features

* Fully automated (optimal zone) Hero Souls farming
* Can run in the background (behind windows, but not minimized)
* Supports both [Steam][] and [Web][] clients
    - (Steam) Supports window re-sizing (including Full Screen mode)
* Hybrid mode support (e.g. 27 minutes [idle][] plus 6 minutes active)
* Separate active _monster clicker_ script
    - Built in click speed throttle (when mouse enters window)
    - Remotely operated by the main bot script during hybrid/deep runs
* Supports user defined skill combos (see `tools/combo_tester.ahk`)
* Built in re-gilder between rangers
* Built in configuration assistant
* Option to auto-save before ascending
* Progress bar showing remaining time
* Mis-click prevention with a _click safety zone_ around the in-game tabs (that triggers an automatic script pause when breached)

### Minimum recommended game state

To operate as intended, the bot needs a certain minimum game state:

* Atlas or higher ranger gilded
* _Optimal zone_ > 1000
* Iris > 145 (and within 1001 levels of the _optimal zone_)
* Siyalatas > 200
    - Argaiv, Libertas/Mammon/Mimzee, Morgulis and Solomon following the [Rules of Thumb][]
* __Maxed:__ Atman, Bubos, Dogcog, Dora, Fortuna, Khrysos and Kumawakamaru

These recommendations should give you enough gold after ascending with a *[clickable][Clickables]*, to instantly unlock, level and buy all upgrades for every hero down to and including Frostleaf.

## Setup

* Download and install the latest version of [AutoHotkey][]
* Download and unpack the zip file from the [latest release][].

## Starting the bot

* Start Clicker Heroes
* Double-click the `ch_sw1ft_bot.ahk` file to start the bot. In your taskbar you should see a green **H** icon.

If you run the browser version, you will get a "Clicker Heroes started?" message on your initial start. This is expected until you have configured the [Mandatory lib settings](#mandatory-lib-settings).

Unless they already exist, three user settings files will be created as copies of the default system settings. All configuration changes should be made in these files:

`ch_bot_lib_settings.ahk`, `ch_bot_settings.ahk` and `monster_clicker_settings.ahk`.

Note: If your Windows account don't have administrator rights, you might have to start the script by right-clicking it and select **Run as Administrator**.

## Configuration

* In Clicker Heroes, turn off the __Show relic found popups__ option and keep all heroes expanded.

#### Mandatory lib settings

These only need to be changed if you run the browser client.

| Variable | Explanation |
| -------- | ----------- |
`SetTitleMatchMode` | **`3`** for Steam or **`regex`** for browser version
`browserTopMargin`  | Browser top margin <sup>(1)</sup>

(1) Start Windows Spy, then under **Mouse Position**, check the **Relative** y position of the top left corner of the CH area (below the logo). Update the top margin to this value if they differ and reload the script with <kbd>Alt+F5</kbd>. Still in the top left corner, click <kbd>Alt+Middle Mouse Button</kbd>. With a correctly set top margin, the shown cursor y position should be `30`.

#### Mandatory bot settings

| Variable | Explanation |
| -------- | ----------- |
`irisLevel`    | Set to your Iris level in game
`optimalLevel` | Your optimal zone level <sup>(2)</sup>
`speedRunTime` | The duration of the speed run <sup>(2)</sup>
`gildedRanger` | The number of your gilded ranger <sup>(3)</sup>

(2) Set according to the [Ancients Optimizer][] (open with <kbd>Ctrl+F5</kbd>).

(3) **1**:Dread Knight, **2**:Atlas, **3**:Terra, **4**:Phthalo, **5**:Banana, **6**:Lilin, **7**:Cadmia, **8**:Alabaster, **9**:Astraea

#### Optional bot settings

| Variable | Explanation |
| -------- | ----------- |
`deepRunTime`         | The duration of the deep run
`hybridMode`          | [`true`/`false`] Chain a deep run when the speed run finish
`autoAscend`          | [`true`/`false`] Warning! Set to true will both salvage relics and ascend without any user intervention!
`saveBeforeAscending` | [`true`/`false`] Auto-save before ascending

Note: Not a complete list.

### Function tests

1. <kbd>Ctrl+Alt+F1</kbd> should scroll down to the bottom
2. <kbd>Ctrl+Alt+F2</kbd> should switch to the relics tab and then back

If any of these fail, reload the script with <kbd>Alt+F5</kbd> and try again.

### Starting the main speed run loop

After a fresh ascend with an available clickable, start the speed run loop with <kbd>Ctrl+F1</kbd>.

## Main Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F1</kbd>       | Loop speed runs
<kbd>Ctrl+F2</kbd>       | Start a deep run
<kbd>Pause</kbd>         | Pause/unpause the script
<kbd>Alt+Pause</kbd>     | Abort active speed/deep runs and an initiated auto ascension
<kbd>Shift+Pause</kbd>   | Do not start new speed/deep runs after finishing the current run and ascension
<kbd>Alt+F5</kbd>        | Reload the script (needed after configuration changes or a client window resize)
<kbd>Shift+Ctrl+F5</kbd> | Reload the script after the current run and restart the speed run loop afterwards

#### Supplementary Hotkeys

These hotkeys can be executed while a speed or deep run is active.

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Esc</kbd> | Suspend/Unsuspend all other Hotkeys
<kbd>Ctrl+F5</kbd>  | Open the Ancients Optimizer and auto-import game save data
<kbd>Ctrl+F6</kbd>  | Set previous ranger as re-gild target
<kbd>Ctrl+F7</kbd>  | Set next ranger as re-gild target
<kbd>Ctrl+F8</kbd>  | Move `reGildCount` gilds to the target ranger (will pause the monster clicker if running)
<kbd>Ctrl+F11</kbd> | Autosave the game
<kbd>Shift+Ctrl+F1</kbd>  | Toggle the `autoAscend` flag
<kbd>Shift+Ctrl+F2</kbd>  | Toggle the `screenShotRelics` flag
<kbd>Shift+Ctrl+F6</kbd>  | Toggle the `playNotificationSounds` flag
<kbd>Shift+Ctrl+F7</kbd>  | Toggle the `playWarningSounds` flag
<kbd>Shift+Ctrl+F8</kbd>  | Toggle the `showSplashTexts` flag
<kbd>Shift+Ctrl+F11</kbd> | Toggle the `saveBeforeAscending` flag
<kbd>Shift+Ctrl+F12</kbd> | Toggle the `debug` flag

#### Test Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Alt+F1</kbd>  | Should scroll down to the bottom
<kbd>Ctrl+Alt+F2</kbd>  | Should switch to the relics tab and then back
<kbd>Alt+F1</kbd>       | Test the `getClickable()` function
<kbd>Alt+F2</kbd>       | Test the `initRun()` function
<kbd>Alt+F3</kbd>       | Test the `speedRun()` function
<kbd>Alt+F4</kbd>       | Test the `ascend()` function

## Questions or comments?

Check the [FAQ](FAQ.md) or visit the original script [home][] on Reddit.

[Reddit]: https://www.reddit.com/r/ClickerHeroes/
[Steam]: http://store.steampowered.com/app/363970/
[Web]: https://www.clickerheroes.com/
[AutoHotkey]: http://ahkscript.org/
[idle]: https://www.reddit.com/r/ClickerHeroes/comments/2kk0wi/simple_idle_guide/
[Rules of Thumb]: http://redd.it/339m3j
[Ancients Optimizer]: http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
[Clickables]: http://clickerheroes.wikia.com/wiki/Clickables
[home]: http://redd.it/3a3bmy
[latest release]: https://github.com/swiftb/clicker-heroes-sw1ft-bot/releases/latest
