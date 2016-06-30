
; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

SetTitleMatchMode, regex

browser := "Opera" ; browser name used by the title matching

; With the CH window focused, click Ctrl+MMB dead center in the ancient tab eye to get this setting.
browserTopMargin := 211

; Browser recommendation: Run Clicker Heroes in Firefox or Opera, then use Chrome or some other browser for your normal surfing activities.

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; Severity Levels: 0:OFF, 1:WARN, 2:USER, 3:INFO, 4:DEBUG, 5:TRACE
showSeverityLevel := 3 ; splash texts
logSeverityLevel := 5 ; file

; Setting a level to X, will show or log all messages from that level and below.
; E.g. setting showSeverityLevel to 1 and logSeverityLevel to 5, will only show
; warning messages as splash texts, but will log everything to file.
