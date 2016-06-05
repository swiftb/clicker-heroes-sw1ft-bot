
; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

SetTitleMatchMode, regex ; Steam [3] or browser [regex] version?

browser := "Opera" ; browser name used by the title matching

; With the CH window focused, click Ctrl+MMB dead center in the ancient tab eye to get this setting.
browserTopMargin := 211

; Browser recommendation: Run Clicker Heroes in Opera, then use Chrome or some other browser for your normal surfing activities.

; If active, the power savings setting turning of your monitor(s) can cause issues with AHK's image recognition.
; When last tested, only Firefox continued to run without any issues.

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

fullScreenOption := false ; Steam borderless fullscreen option

; Note: You need to turn on the "Full Screen" option in Clicker Heroes for this option to work.

; Severity Levels: 0:OFF, 1:WARN, 2:USER, 3:INFO, 4:DEBUG, 5:TRACE
showSeverityLevel := 3 ; splash texts
logSeverityLevel := 4 ; file

; Setting a level to X, will show or log all messages from that level and below.
; E.g. setting showSeverityLevel to 1 and logSeverityLevel to 5, will only show
; warning messages as splash texts, but will log everything to file.
