# Clicker Heroes Sw1ft Bot

A game bot for [Clicker Heroes][Reddit].

## Overview

* [Features](#general-features)
* [Minimum recommended game state](#minimum-recommended-game-state)
* [Step-by-step Guide](#step-by-step-guide)
* [Troubleshooting](#troubleshooting)
* [Known issues](#known-issues)
* [Hotkeys](#main-hotkeys)
* [Questions or comments?](#questions-or-comments)

## General Features

* Automated Hero Souls farming
* Vision Run loop (<kbd>Ctrl+F1</kbd>)
    - Supports idle, hybrid and active play
    - Finds gilded heroes/rangers automatically
    - Picks up *clickables* without breaking idle
    - Dynamic ascensions triggered by a tunable max monster kill time setting
    - Option to auto-save before ascending
    - Option to auto-level Solomon after ascending
    - Can automatically resume
    - **Limitations:** Only supported in the CH browser client (in low quality). The window must also be visible in the foreground
* Hotkeys for raiding
* Separate active _monster clicker_ script
    - Built in click speed throttle (when mouse enters window)
    - Remotely operated by the main bot script
* Supports user defined skill combos (see `tools/combo_tester.ahk`)
* Monitored _click safety zones_ preventing bot misclicks
* Logging to file

### Minimum recommended game state

* Two world ascensions to get the Buy Available Upgrades button
    - **Recommendation:** Save 100 rubies and buy two Quick Ascension's @ Lvl 10 after every Transcension.

## Step-by-step Guide

**1.** Start Clicker Heroes in your browser and set the graphics quality to low. Click the *wrench* and make sure these three options are unchecked:  
![](images/guide/ch_settings.png?raw=true)

**2.** Download and install the latest version of [AutoHotkey][]  
![](images/guide/autohotkey.png?raw=true)

**3.** Download the [latest bot release][] from GitHub:  
![](images/guide/dl_bot.png?raw=true)

**4.** Extract the bot zip file:  
![](images/guide/unzip_bot.png?raw=true)

**5.** Double-click the `ch_sw1ft_bot.ahk` file to start the bot:  
![](images/guide/start_bot.png?raw=true)  
Unless you run Clicker Heroes in the Opera browser, you will get the following error message:  
![](images/guide/error_msg.png?raw=true)  
This is expected.

In your taskbar you should see two green **H** icons. One for the bot, one for separate monster clicker:  
![](images/guide/taskbar.png?raw=true)

Unless they already exist, three user settings files will be created:  
![](images/guide/bot_settings.png?raw=true)

**6.** Open the `ch_bot_lib_settings.ahk` file:  
![](images/guide/lib_settings.png?raw=true)  
**Important!** Use a decent text editor, like [Sublime Text][] or [Notepad++][] when you configure this bot.

* If needed, change the `browser` name.
* Make sure the Clicker Heroes window have focus, then click <kbd>Ctrl+Middle Mouse Button</kbd> dead center in the ancient tab eye like this:  
![](images/guide/ancient_eye_click.png?raw=true)
* Update the `browserTopMargin` according to the pop-up window:  
![](images/guide/browserTopMargin.png?raw=true)
* Save and reload the script with <kbd>Alt+F5</kbd>.

**Test hotkeys:**

* <kbd>Ctrl+Alt+F1</kbd> should scroll down to the bottom, then back up
* <kbd>Ctrl+Alt+F2</kbd> should switch between all used tabs

If any of these two fail, check the [Troubleshooting](#troubleshooting) section and the [FAQ](FAQ.md) for possible solutions.

**7.** Open the `ch_bot_settings.ahk` file:
![](images/guide/gildedRanger.png?raw=true)

* With e.g. a lvl 90,000 Siyalatas:  
![](images/guide/siyalatas.png?raw=true)  
Following the [regilding chart][], you should be gilded on Moloch:  
![](images/guide/gilded.png?raw=true)  
Then you would set `gildedRanger` to 11.

* Depending on your playstyle, you set `endLvlIdle` and `endLvlActive` differently:
![](images/guide/playstyle.png?raw=true)

* The settings for `chronos`, `kumawakamaru` and `vaagur`:
![](images/guide/ancient_settings.png?raw=true)  
Should match your in-game values:  
![](images/guide/kumawakamaru.png?raw=true)

Recommended optional settings:

* Set `autoAscend` to "true"
* Set `saveBeforeAscending` to "true"


**8.** Save and reload with <kbd>Alt+F5</kbd>, then start the Vision Run with <kbd>Ctrl+F1</kbd>.

In the logs folder:  
![](images/guide/logs.png?raw=true)

Open today's log file. The most important bits here are:

    DEBUG   browser = Opera
    DEBUG   browserTopMargin = 216
    DEBUG   gildedRanger = Moloch
    DEBUG   endLvlIdle = 1600
    DEBUG   endLvlActive = 100000
    DEBUG   chronos = 11.36
    DEBUG   kumawakamaru = -2.59
    DEBUG   vaagur = -39.71
    INFO    Recommended transitional hero(es): Banana > Alabaster
    DEBUG   Estimated ascension @ Lvl 3075 (idle), 3475 (active)

Make sure these match with your settings and that you follow the recommended transitional hero(es).

## Troubleshooting

* Keep your mouse pointer outside the Clicker Heroes window to avoid *click speed throttling*.
* Use a separate web browser for web surfing while running the script.
* Make sure your browser window is not zoomed in or out, and is at 100% viewing size.
* In Windows:
    - Set display scaling to 100% (96 DPI)  
![](images/guide/display_settings.png?raw=true)
    - Use True Color (32 bit)  
![](images/guide/monitor_true_color.png?raw=true)
    - If your account don't have administrator rights, you might have to start the script by right-clicking it and select **Run as Administrator**.

## Known issues

* If active, the power savings setting turning of your monitor(s) can cause issues with AHK's image recognition. When last tested, only Firefox continued to run without any issues.
* The script can't handle any extra _stuff_ on the left side, e.g. a bookmark list.

## Vision Run Error States

| State | Error | Solution |
| ----- | ----- | -------- |
-2 | No Clicker Heroes window found   | Open the client
-1 | Vision, but not in browser       | Use the browser client
 0 | Vision, but not finding anything | In Windows, use standard 100% (96 DPI) display scaling in (32 bit) True Color

## Main Hotkeys

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+F1</kbd>       | Start the Vision Run loop
<kbd>Pause</kbd>         | Pause/unpause the script
<kbd>Alt+Pause</kbd>     | Abort any active run or initiated ascension
<kbd>Shift+Pause</kbd>   | Schedule a stop after finishing the current run
<kbd>Alt+F5</kbd>        | Reload the script (needed after configuration changes)
<kbd>Shift+Ctrl+F5</kbd> | Schedule a script reload after finishing the current run, then restart it
<kbd>Alt+F6</kbd>        | Re-initialize coordinates (needed after moving or re-sizing the client window)

#### Supplementary Hotkeys

These hotkeys can be executed while a Vision run is active.

| Hotkey | Function |
| ------ | -------- |
<kbd>Ctrl+Esc</kbd> | Suspend/Unsuspend all other Hotkeys
<kbd>Ctrl+F11</kbd> | Autosave the game
<kbd>Win+F6</kbd> | Raid once for free
<kbd>Win+F7</kbd> | One paid raid
<kbd>Win+F8</kbd> | `raidAttempts` paid raids
<kbd>Shift+Ctrl+F1</kbd>  | Toggle the `autoAscend` flag
<kbd>Shift+Ctrl+F6</kbd>  | Toggle the `playNotificationSounds` flag
<kbd>Shift+Ctrl+F7</kbd>  | Toggle the `playWarningSounds` flag
<kbd>Shift+Ctrl+F11</kbd> | Toggle the `saveBeforeAscending` flag

## Questions or comments?

Check the [FAQ](FAQ.md) or visit the original script [home][] on Reddit.

[Reddit]: https://www.reddit.com/r/ClickerHeroes/
[AutoHotkey]: http://ahkscript.org/
[home]: https://redd.it/3wxwfu
[latest bot release]: https://github.com/swiftb/clicker-heroes-sw1ft-bot/releases/latest
[regilding chart]: https://redd.it/3frj62
[Sublime Text]: https://www.sublimetext.com/
[Notepad++]: https://notepad-plus-plus.org/