
; -----------------------------------------------------------------------------------------
; -- Configuration
; -----------------------------------------------------------------------------------------

clickDuration := 0 ; minutes (set to zero for manual/remote operation)

; -- Look & Feel --------------------------------------------------------------------------

global playNotificationSounds := clickDuration > 0 ? true : false ; no sound when operated remotely
global playWarningSounds := false

; Splash text window position
wSplash := 200
xSplash := A_ScreenWidth // 2 - wSplash // 2 ; centered
ySplash := A_ScreenHeight // 2 + 40
