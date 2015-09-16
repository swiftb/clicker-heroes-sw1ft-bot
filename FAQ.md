# FAQ

**Q:** Does the bot handle early (optimal zone < 1000) game?  
**A:** No. You should play this stage of the game all by yourself, it’s the best part!

**Q:** So, at what point does the bot start to work?  
**A:** See __Minimum recommended game state__ in the [README](README.md).

**Q:** What ancients do I need?  
**A1:** For idle speed runs: Argaiv, Iris, Libertas, Mammon, Mimzee, Morgulis, Siyalatas, Solomon. Maxed: Atman, Bubos, Dogcog, Dora, Fortuna, Khrysos, Kumawakamaru.  
**A2:** For active deep runs: Bhaal, Chronos, Fragsworth, Juggernaut, Pluto, Thusia. Maxed: Berserker, Chawedo, Energon, Hecatoncheir, Kleptos, Revolc, Sniperino, Vaagur.

**Q:** Does the bot work with the Steam or browser version?  
**A:** Both. If you run the browser version, I recommend running Clicker Heroes in e.g. Firefox, then use Chrome or some other browser for you normal surfing activities.

**Q:** Is the bot for idle or active play?  
**A:** It’s mainly designed for idle play, doing short _optimal zone_ runs over and over to farm Hero Souls. With the included active clicker it can also run in hybrid mode (e.g. 27 minutes idle, 6 minutes active), or you can re-gild to a higher ranger and start a long deep run to up your *HZE* (Highest Zone Ever).

**Q:** Does it run in the background?  
**A:** Yes. The Clicker Heroes window can be behind other windows, but not minimized.

**Q:** How do I start the bot?  
**A:** See __Starting the bot__ in the [README](README.md).

**Q:** Why do I get an error when trying to run one of the script files?  
**A:** Make sure you have the latest version of both [AutoHotkey][] and the bot files.

**Q:** I get an error saying: *#Include file “ch_bot_lib.ahk” cannot be opened.*  
**A:** This file needs to be in the same folder as the other `.ahk` files.

**Q:** The bot seem to miss-click, do I need to update any coordinates?  
**A1:** If you have re-sized the Steam window, just hit <kbd>Alt+F5</kbd> and try again.  
**A2:** If you run in the browser, make sure the `browserTopMargin` setting is correct.

**Q:** The quick tests all work and I managed to start the speed run, but why did it miss to upgrade a few of the heroes?  
**A:** Set the `useConfigurationAssistant` option to `true` and reload the script with <kbd>Alt+F5</kbd>.

**Q:** The script got stuck in farm mode when not killing the first monster in time. What to do?  
**A:** Set the `activateSkillsAtStart` option to `true` or level up Chronos (to lvl 12 or higher).

**Q:** Even with `activateSkillsAtStart` set to `false` the script is breaking idle at the start. Is that a bug?  
**A:** The current script don’t use any image recognition to spot the clickables, so it just clicks on all known spawn locations. Then to prevent a toggling behaviour, it actually breaks idle on purpose.

**Q:** Do I need to gild in a certain way for the script to work?  
**A:** The script will use one or two rangers prior to your gilded ranger. Giving them one gild each should be enough to guarantee maximum “insta-kill” speed.

**Q:** Why didn’t the bot level my gilded ranger?  
**A:** Make sure the `irisLevel`, `optimalLevel`, `speedRunTime` and `gildedRanger` settings are correct. Use the [Ancients Optimizer][] (open with <kbd>Ctrl+F5</kbd>) to tune the latter three. Then follow the _optimal level - 1001_ rule for Iris.

**Q:** Why didn’t the bot buy all ranger upgrades?  
**A:** It got there too early. Use the `firstStintAdjustment` setting to give it some extra time.

**Q:** With `saveBeforeAscending` enabled, the script don't seem to click save after changing the file name.  
**A:** Change the `saveButtonClassNN` setting to `Button2`

**Q:** With `saveBeforeAscending` enabled, the script changes the file name, but Windows fails to see this and tries to save with the default `clickerHeroSave.txt` name.  
**A:** Change the `saveMode` setting to `2`

**Q:** The script didn’t ascend. Why?  
**A:** Adjust the `ascDownClicks` setting.

**Q:** Why did the bot seem to get stuck after ascending?  
**A:** It needs a *clickable* to get going, so leave them alone!

**Q:** Can the bot farm Hero Souls while I’m AFK?  
**A:** Yes, change the `autoAscend` option, but be aware that new relics will be salvaged! A warning will be given 10 seconds (can be changed) before the script salvage and ascend, giving you some time to respond. You can pause/unpause with the <kbd>Pause</kbd> key or abort with <kbd>Alt+Pause</kbd>.

**Q1:** Can I turn off sounds?  
**Q2:** Can I move the text splash windows or the progress bar?  
**A:** Yes. Under __Optional Settings__, you’ll find the __Look & Feel__ section. The monster clicker has similar settings.  
**A2:** Screenshot sounds in Steam can also be turned off: Right-click __Steam__ in your toolbar and uncheck __Play a sound__ under __Settings__ > __In-Game__

**Q:** Can I safely upgrade ancients while the bot runs?  
**A:** Yes, the script will automatically halt when your mouse pointer gets close to the tab section.

**Q:** I just can’t get the bot to work and none of the answers above did help. What should I do?  
**A:** Save your game and copy the save data to [Pastebin][], then send me a link on [Reddit][] with some info about the issue at hand. Also include debug information via <kbd>Ctrl+Shift+F12</kbd> + <kbd>Alt+F3</kbd>.

[AutoHotkey]: http://ahkscript.org/
[Ancients Optimizer]: http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
[Pastebin]: http://pastebin.com/
[Reddit]: https://www.reddit.com/user/Sw1ftb/