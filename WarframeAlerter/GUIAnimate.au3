#cs
	#define AW_HOR_POSITIVE            0x00000001
	#define AW_HOR_NEGATIVE            0x00000002
	#define AW_VER_POSITIVE            0x00000004
	#define AW_VER_NEGATIVE            0x00000008
	#define AW_CENTER                  0x00000010
	#define AW_HIDE                    0x000$speed0
	#define AW_ACTIVATE                0x00020000
	#define AW_SLIDE                    0x00040000
	#define AW_BLEND                    0x00080000
#ce


Func _FadeGUI($gGUI, $mode = 1, $speed = 1000)
	If $mode == 1 Then
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00080000);fade-in
	ElseIf $mode == 2 Then
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00090000);fade-out
	Else
		If Not @Compiled Then
			MsgBox(0, "", "Function '_FadeGUI', mode between 1 and 2", 120)
			Exit
		EndIf
	EndIf
EndFunc   ;==>_FadeGUI


Func _SlideGUI($gGUI, $mode = 1, $speed = 1000)
	Switch $mode
		Case 1
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040001);slide in from left
		Case 2
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050002);slide out to left
		Case 3
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040002);slide in from right
		Case 4
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050001);slide out to right
		Case 5
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040004);slide-in from top
		Case 6
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050008);slide-out to top
		Case 7
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040008);slide-in from bottom
		Case 8
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050004);slide-out to bottom
		Case Else
			If Not @Compiled Then
				MsgBox(0, "", "Function '_SlideGUI', mode between 1 and 8", 120)
				Exit
			EndIf
	EndSwitch
EndFunc   ;==>_SlideGUI


Func _SlideCornerGUI($gGUI, $mode = 1, $speed = 1000)
	Switch $mode
		Case 1
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040005);diag slide-in from Top-left
		Case 2
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x0005000a);diag slide-out to Top-left
		Case 3
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040006);diag slide-in from Top-Right
		Case 4
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050009);diag slide-out to Top-Right
		Case 5
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040009);diag slide-in from Bottom-left
		Case 6
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050006);diag slide-out to Bottom-left
		Case 7
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x0004000a);diag slide-in from Bottom-right
		Case 8
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050005);diag slide-out to Bottom-right
		Case Else
			If Not @Compiled Then
				MsgBox(0, "", "Function '_SlideCornerGUI', mode between 1 and 8", 120)
				Exit
			EndIf
	EndSwitch
EndFunc   ;==>_SlideCornerGUI


Func _ZoomGUI($gGUI, $mode = 1, $speed = 1000)
	If $mode == 1 Then
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00040010);explode
	ElseIf $mode == 2 Then
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gGUI, "int", $speed, "long", 0x00050010);implode
	Else
		If Not @Compiled Then
			MsgBox(0, "", "Function '_ZoomGUI', mode between 1 and 2", 120)
			Exit
		EndIf
	EndIf
EndFunc   ;==>_ZoomGUI





































