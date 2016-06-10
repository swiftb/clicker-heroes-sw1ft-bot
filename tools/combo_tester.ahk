; -----------------------------------------------------------------------------------------
; Clicker Heroes Skill Combo Tester
; by Sw1ftb
; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv

SetTitleMatchMode, regex ; Steam [3] or browser [regex] version?

; winName=Clicker Heroes ; Steam
winName=Lvl.*Clicker Heroes.* ; browser

; Deep run skill combo tests
; https://redd.it/3il3tx

vaagur := -0.00 ; -#.##% skill cooldowns
cooldown := ceil(600*(1 + vaagur/100))

comboEDR := [cooldown, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"] ; T > 8h
comboEGolden := [cooldown, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"] ; 3h < T < 8h
comboGoldenLuck := [cooldown, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"] ; T < 3h

activeClicker := true ; set to false to add Clickstorm
testMode := true

; -----------------------------------------------------------------------------------------
; -- Hotkeys
; -----------------------------------------------------------------------------------------

F1::
	comboTester(comboEDR)
return

F2::
	comboTester(comboEGolden)
return

F3::
	comboTester(comboGoldenLuck)
return

F5::
	Reload
return

comboTester(combo) {
	global activeClicker, testMode

	seconds := 60*60
	t := 0

	comboDelay := combo[1]
	comboIndex := 2

	s := "    " ; Reddit friendly formatting
	output := ""

	while(t < seconds)
	{
		if (mod(t, comboDelay) = 0) {
			if (testMode and comboIndex = 2 and A_Index > 1) {
				output .= s . formatSeconds(t) . " : " . "repeat"
				break
			}
			skills := activeClicker ? combo[comboIndex] : StrReplace(combo[comboIndex], "2", "1-2")
			if (!testMode) {
				activateSkills(skills)
			}
			output .= s . formatSeconds(t) . " : " . skills . "`r`n"
			comboIndex := comboIndex < combo.MaxIndex() ? comboIndex+1 : 2
		}
		t += 1
		if (!testMode) {
			sleep 1000
		}
	}

	clipboard := % output
	msgbox % output
}

activateSkills(skills) {
	global
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, % winName
		sleep 100
	}
	sleep 1000
}

formatSeconds(s) {
    time := 19990101 ; *Midnight* of an arbitrary date.
    time += %s%, seconds
	FormatTime, timeStr, %time%, mm:ss
    return timeStr
}
