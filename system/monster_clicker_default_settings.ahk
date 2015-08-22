
; -----------------------------------------------------------------------------------------
; -- Configuration
; -----------------------------------------------------------------------------------------

clickDuration := 0 ; minutes (set to zero for manual/remote operation)

; -- Look & Feel --------------------------------------------------------------------------

global playNotificationSounds := clickDuration > 0 ? true : false ; no sound when operated remotely
global playWarningSounds := true
global showSplashTexts := true

; Splash text window position
xSplash := A_ScreenWidth // 2 - wSplash // 2 ; centered
ySplash := A_ScreenHeight // 2 + 40
