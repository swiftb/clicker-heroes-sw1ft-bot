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

; T > 8h
comboEDR := [2.5*60, "2-3-4-5-7-8-6-9", "", "", "", "", "", "8-9-2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

; 3h < T < 8h
comboEGolden := [2.5*60, "8-5-2-3-4-7-6-9", "2", "2", "2-3-4", "2", "2"] ; energize 3 (dmg) or 5 (gold)

; T < 3h
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

; Hybrid combo
comboHybridIdle := [15*60, "1-2-3-4-5-7-6-9-8"] ; energize >
comboHybridActive := [30, "5-2-4-6-7", "", "", "3-8-9", "", "", "2", "", "", "3-7", "", "1-2"] ; > golden clicks, 6 minutes

; Midas: 1-4-5                                2:30                 5:00                 7:30                 10:00                  12:30                    15:00                        17:30
comboMidas := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2", "", "4", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-3-5", "", "", "2-4-7", "", "1", "", ""]

; Midas: 1-4-5                                 2:30                 5:00                 7:30                  10:00                  12:30                     15:00                       17:30
comboMidas2 := [30, "9-3-8-6", "2", "", "", "", "", "2", "", "", "", "", "2", "", "", "", "", "2-4", "", "", "", "", "2-5", "", "", "", "", "", "3", "", "", "8-9-2-5-7", "4", "", "3", "", "1-2", "", ""]

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
	comboTester(comboHybridActive)
return

F4::
	comboTester(comboMidas)
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
