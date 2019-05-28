;download AutoHotKey to be able to run script: https://autohotkey.com/download/
;F8 to disable/enable the script (you may need it if you run Super Meat Boy in windowed mode)
;if you play in fullscreen the script will automatically enable/disable

#Singleinstance force
#InstallKeybdHook
#MaxHotkeysPerInterval, 1000

!Numpad8::Suspend 
#IfWinActive ahk_exe SuperMeatBoy.exe
	;pausing
	z::escape
	x::p
	
	;spamming
	v::space
	b::enter
	n::s

	;directional
	.::left
	'::right
	/::down
	`;::up
#IfWinActive
; more key codes can be found here: https://autohotkey.com/docs/KeyList.htm