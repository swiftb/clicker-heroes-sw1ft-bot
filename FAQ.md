# FAQ

## Speed Run

**Q:** Not supported any more?  
**A:** No, sadly not. Highly repetitive and predictable runs died when Iris was removed. This together with the fact, that the new Transcendent Power speeds up your game progression a great deal, makes it even more difficult to script something even remotely decent when you have no visual cues to guide you. RIP Speed Run, 2015 -- 2016 :(

## Vision Run

**Q:** I get a "Start failed (state = 0)!" warning, what's wrong?  
**A1:** Make sure the CH browser window is at 100% zoom.  
**A2:** In Windows, use standard 100% (96 DPI) display scaling in (32 bit) True Color

**Q:** The bot only level heroes 2 levels at a time, not 200, why?  
**A1:** The bot fails to focus and Ctrl click. Usually this can be fixed by slightly re-sizing the browser window and hit <kbd>Alt+F6</kbd>.

**Q:** Why isn't the Steam client supported?  
**A:** The Vision run utilizes the level shown in the browser client title bar. Something the Steam client lacks.

**Q:** Can it run in the background?  
**A:** No. The image recognition functionality requires it to be visible at all times.

**Q:** The monitor power savings seems to cause issues!  
**A:** Either enable the `noSleep` bot setting, or turn the power savings off.

**Q:** Changing the settings files do nothing!?  
**A:** Make sure you are __NOT__ editing the system default settings. See the __Step-by-step Guide__ in the [README](README.md).

**Q:** The bot seem to miss-click, do I need to update any coordinates?  
**A1:** If you have moved or re-sized the client window, just hit <kbd>Alt+F6</kbd> and try again.  
**A2:** Make sure the `browserTopMargin` setting is correct. See the __Step-by-step Guide__ in the [README](README.md).

**Q:** I have focus issues, why?  
**A1:** You need to run CH in one browser (e.g. Opera), then do your normal surfing in another (e.g. Chrome).  
**A2:** Make sure the CH window IS NOT focused when you start a run.  
**A3:** A trick to get focus back, is to left-click and *draw some boxes* on your desktop.

**Q:** Why do I get an error when trying to run one of the script files?  
**A:** Make sure you have the latest version of both [AutoHotkey][] and the bot.

**Q:** With `saveBeforeAscending` enabled, the bot don't click save after changing the file name.  
**A:** Change the `saveButtonClassNN` setting

**Q:** With `saveBeforeAscending` enabled, the bot changes the file name, but Windows fails to see this and tries to save with the default `clickerHeroSave.txt` name.  
**A:** Change the `saveMode` setting

**Q:** Can the bot farm Hero Souls while I’m AFK?  
**A:** Yes, set the `autoAscend` option to `true`.

**Q1:** Can I turn off sounds?  
**Q2:** Can I move the text splash windows?  
**A1:** Yes. Under __Optional Settings__, you’ll find the __Look & Feel__ section. The monster clicker has similar settings.

**Q:** I just can’t get the bot to work and none of the answers above did help. What should I do?  
**A:** Ask me on [Reddit][home]. Also link me a [Pastebin][] with the contents of today's log file in the logs folder.

[AutoHotkey]: http://ahkscript.org/
[home]: https://www.reddit.com/r/ClickerHeroes/comments/4phxdg/clicker_heroes_sw1ft_bot/?sort=new
[Pastebin]: http://pastebin.com/
