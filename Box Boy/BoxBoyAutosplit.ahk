;World
F8::

;refresh timer value
Click
Click Right		
send {down}
send {enter}
sleep 500 ;wait for value to be received	

;enter form and copy timer value
Click			
click
send ^c

;convert frames to seconds (game is 60fps)
clipboard := clipboard / 60

;switch to livesplit and paste in game time
WinActivate, Enter Game Time
send ^v
send {enter}

;return to ntr and prepare for next execution
WinActivate, NTR Cheat Tool
send {esc}

return

;Time Attack
F9::

;wait for time to update
sleep 2000

;refresh timer value
Click
Click Right		
send {down}
send {enter}
sleep 500 ;wait for value to be received	

;enter form and copy timer value
Click			
click
send ^c

;convert frames to seconds (game is 60fps)
clipboard := clipboard / 60

;switch to livesplit and paste in game time
WinActivate, Enter Game Time
send ^v
send {enter}

;return to ntr and prepare for next execution
WinActivate, NTR Cheat Tool
send {esc}

return