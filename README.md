# Clicker Heroes Sw1ft Bot

A mid/late game bot for [Clicker Heroes][Reddit].

## Overview

* [Features](#features)
* [Minimum recommended game state](#minimum-recommended-game-state)
* [Setup](#setup)
* [Starting the bot](#starting-the-bot)
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
* Iris > 145
* Siyalatas > 200
    - Argaiv, Libertas/Mammon/Mimzee, Morgulis and Solomon following the [Rules of Thumb][]
* __Maxed:__ Atman, Bubos, Dogcog, Dora, Fortuna, Khrysos and Kumawakamaru

These recommendations should give you enough gold after ascending with a *[clickable][Clickables]*, to instantly unlock, level and buy all upgrades for every hero down to and including Frostleaf.

## Setup

* In Clicker Heroes, turn off the *Show relic found popups* option
* Download and install the latest version of [AutoHotkey][]
* Download all `.ahk` script files to a new folder
* Set the variables listed in the table(s) below
    - Note: Settings can be made directly in the script files, but the preferred way is to create a `ch_bot_settings.ahk` file and override them there. Look at `ch_bot_settings_example.ahk` for a hybrid run example.

#### Mandatory bot configuration variables

| Variable | Explanation |
| -------- | ----------- |
irisLevel    | Set to your Iris level in game
optimalLevel | Your optimal zone level <sup>(1)</sup>
speedRunTime | The duration of the speed run <sup>(1)</sup>
gildedRanger | The number of your gilded ranger <sup>(2)</sup>

(1) Set according to the [Ancients Optimizer][]  
(2) **1**:Dread Knight, **2**:Atlas, **3**:Terra, **4**:Phthalo, **5**:Banana, **6**:Lilin, **7**:Cadmia, **8**:Alabaster, **9**:Astraea

#### Optional bot configuration variables

| Variable | Explanation |
| -------- | ----------- |
deepRunTime         | The duration of the deep run
hybridMode          | [true/false] Chain a deep run when the speed run finish
autoAscend          | [true/false] Warning! Set to true will both salvage relics and ascend without any user intervention!
saveBeforeAscending | [true/false] Auto-save before ascending

Note: Not a complete list (see *Optional Settings* in the bot file)

#### Mandatory lib configuration variables

These only need to be changed if you run the browser client.

| Variable | Explanation |
| -------- | ----------- |
SetTitleMatchMode | **3** for Steam or **regex** for browser version
browserTopMargin  | Browser top margin <sup>(3)</sup>

(3) Start Windows Spy, then check the relative y position of the top edge of the CH area (below the logo).

## Starting the bot

Double-click the `ch_sw1ft_bot.ahk` file to start the bot. In your taskbar you should see a green **H** icon.

Note: If your Windows account don't have administrator rights, you might have to start the script by right-clicking it and select *Run as Administrator*.

### Function tests

1. <kbd>Ctrl+Alt+F1</kbd> should scroll down to the bottom
2. <kbd>Ctrl+Alt+F2</kbd> should switch to the relics tab and then back

If any of these fail, reload the script with <kbd>Alt+F5</kbd> and try again.

### Starting the main speed run loop

If you plan on doing any hybrid (or deep) runs, then start the `monster_clicker.ahk` script too.

After a fresh ascend with an available clickable, start the speed run loop with <kbd>Ctrl+F1</kbd>.

Note: Changing settings while a script is running don't take effect until you reload the script.

## Main Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F1</kbd>   | Loop speed runs
<kbd>Ctrl+F2</kbd>   | Start a deep run (requires a running `monster_clicker.ahk`)
<kbd>Pause</kbd>     | Pause/unpause the script
<kbd>Alt+Pause</kbd> | Abort active speed/deep runs and an initiated auto ascension
<kbd>Alt+F5</kbd>    | Reload the script (needed after configuration changes and a client window resize)

### Supplementary Hotkeys

These hotkeys can be executed while a speed or deep run is active.

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F6</kbd> | Set previous ranger as re-gild target
<kbd>Ctrl+F7</kbd> | Set next ranger as re-gild target
<kbd>Ctrl+F8</kbd> | Move `reGildCount` gilds to the target ranger (will pause the monster clicker if running)
<kbd>Ctrl+F11</kbd> | Autosave the game
<kbd>Shift+Ctrl+F1</kbd>  | Toggle the `autoAscend` flag
<kbd>Shift+Ctrl+F2</kbd>  | Toggle the `screenShotRelics` flag
<kbd>Shift+Ctrl+F3</kbd>  | Toggle the `playNotificationSounds` flag
<kbd>Shift+Ctrl+F4</kbd>  | Toggle the `playWarningSounds` flag
<kbd>Shift+Ctrl+F5</kbd>  | Toggle the `showSplashTexts` flag
<kbd>Shift+Ctrl+F11</kbd>  | Toggle the `saveBeforeAscending` flag

### Test Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Alt+F1</kbd>  | Should scroll down to the bottom
<kbd>Ctrl+Alt+F2</kbd>  | Should switch to the relics tab and then back
<kbd>Alt+F1</kbd>       | Test the `getClickable()` function
<kbd>Alt+F2</kbd>       | Test the `initRun()` function
<kbd>Alt+F3</kbd>       | Test the `speedRun()` function
<kbd>Alt+F4</kbd>       | Test the `ascend()` function

## Questions or comments?

Check the FAQ or visit the original script [home][] on Reddit.

[Reddit]: https://www.reddit.com/r/ClickerHeroes/
[Steam]: http://store.steampowered.com/app/363970/
[Web]: https://www.clickerheroes.com/
[AutoHotkey]: http://ahkscript.org/
[idle]: https://www.reddit.com/r/ClickerHeroes/comments/2kk0wi/simple_idle_guide/
[Rules of Thumb]: http://redd.it/339m3j
[Ancients Optimizer]: http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
[Clickables]: http://clickerheroes.wikia.com/wiki/Clickables
[home]: http://redd.it/3a3bmy
