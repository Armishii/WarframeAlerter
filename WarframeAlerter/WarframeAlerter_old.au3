_CheckVersion()
AdlibRegister("_CheckVersion", 600000)







While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func _Update()
	Local $stringXML = _INetGetSource($xml)
	$array__Test = _StringBetween($stringXML, ' <description><![CDATA[', '<br/><br/>]]></description>')
	Global $pubDate = _StringBetween($stringXML, '<pubDate>', '+0000</pubDate>')
;~ 	_ArrayDisplay($pubDate)
	If $array[0] == $array__Test[0] Then ;pas de changement
		ConsoleWrite("No changes..." & @LF)
	Else
		$array = _StringBetween($stringXML, ' <description><![CDATA[', '<br/><br/>]]></description>');update value
		_DisplayGUI()
	EndIf
EndFunc   ;==>_Update

Func _DisplayGUI()
	ConsoleWrite("Nouvelle alerte ! " & $array[0] & @LF)
	SoundPlay($SOUND, 0)
	$pubDate = StringSplit($pubDate[0], " ")
;~ 	_ArrayDisplay($pubDate)
	$correction = _DoCorrection($array[0])
	$results = StringSplit($correction, "-")

	$secResults = StringSplit($results[1], ":")
	$results[2] = StringReplace($results[2], "m", "")

	GUICtrlSetData($Localisation, "Localisation : " & $secResults[1])
	GUICtrlSetData($Mission, "Mission :" & $secResults[2])
	GUICtrlSetData($Temps, "Temps restant :" & $results[2] & "(" & _CalcEndMissionTime($pubDate[5], $results[2]) & ")")
	GUICtrlSetData($Credits, "Crédits reçus :" & $results[3])
	If $results[0] > 3 Then
		GUICtrlSetData($Autre, "Autres :" & $results[4])
	Else
		GUICtrlSetData($Autre, "Autres : N/A")
	EndIf

	ConsoleWrite($secResults[2] & @LF)
;~ 	GUISetState(@SW_SHOW)
	$pos = WinGetPos($GUI)
	_WinAPI_SetWindowPos($GUI, $HWND_TOPMOST, $pos[0], $pos[1], $pos[2], $pos[3], $SWP_SHOWWINDOW)
	_FadeGUI($GUI, 1, 800)
;~ 	For $i = 0 To _GetTaskbarSize(4) Step 1
;~ 		_WinAPI_SetWindowPos($GUI, $HWND_TOP, $pos[0], $pos[1] - $i, $pos[2], $pos[3], $SWP_NOZORDER)
;~ 		Sleep(25)
;~ 	Next
	Sleep($DISPLAY_NOTIFICATION * 1000)
	$pos = WinGetPos($GUI)
	_FadeGUI($GUI, 2, 800)
;~ 	For $i = 0 To _GetTaskbarSize(4) Step 1
;~ 		_WinAPI_SetWindowPos($GUI, $HWND_TOP, $pos[0], $pos[1] + $i, $pos[2], $pos[3], $SWP_NOZORDER)
;~ 		Sleep(25)
;~ 	Next
	GUISetState(@SW_HIDE)
EndFunc   ;==>_DisplayGUI


Func _GetTaskbarSize($param = 0)
	$aPos = WinGetPos("[CLASS:Shell_TrayWnd]")
	$left = $aPos[0]
	$right = $aPos[1]
	$width = $aPos[2]
	$height = $aPos[3]

	Switch $param
		Case 0
			Return $aPos
		Case 1
			Return $left
		Case 2
			Return $right
		Case 3
			Return $widht
		Case 4
			Return $height
	EndSwitch
EndFunc   ;==>_GetTaskbarSize

Func _DoCorrection($string)
	Local $dir = @ScriptDir & "\Lang\fr.lng"
	$newString = StringReplace($string, "&#039;", "'")
	$newString = StringReplace($string, "Ã©", "e")

	;Translate

	$planetesSection = IniReadSection($dir, "Planetes")
	_ArrayDisplay($planetesSection)
	For $i = 1 To UBound($planetesSection, 2) Step 1
		If StringInStr($newString, $planetesSection[$i][0]) Then
			$newString = StringReplace($newString, $planetesSection[$i][0], $planetesSection[$i][1], "")
		EndIf
	Next

	$MissionSection = IniReadSection($dir, "Mission")
	Local $translated = False
	For $i = 1 To $MissionSection[0][0] Step 1
		If StringInStr($newString, $MissionSection[$i][0]) Then
			$newString = StringReplace($newString, $MissionSection[$i][0], $MissionSection[$i][1], "")
			$translated = True
		EndIf
	Next

	If $translated == False Then
		Local $reg = StringRegExp($newString, ":(.*?)-", 1)
		Local $write = $reg[0];StringReplace($reg[0], " ", "")
		IniWrite($dir, "Mission", $write, $write & @CRLF & ";A traduire ^^^")
	EndIf

	Return $newString
EndFunc   ;==>_DoCorrection

Func _CheckVersion()
	$bversion = InetRead("https://dl.dropboxusercontent.com/u/44563780/warframealerter/Data.ini")
	If @error Then ConsoleWrite(@error & @LF)
	$version = BinaryToString($bversion)
	$maj = ""

	If $version > $VERSION_ACTUELLE Then
		SplashOff()
		$ouvrir_site = MsgBox(64 + 4, "Info", "Nouvelle version du programme disponible !" & @CRLF & "Télécharger ?")
		If $ouvrir_site = 6 Then
			FileInstall("Updater.exe", "Updater.exe", 1)
			Run(@ScriptDir & "\Updater.exe")
			Exit

		ElseIf $ouvrir_site = 7 Then
			$maj = " (" & $version & " disponible)"
		EndIf
	EndIf

	FileDelete(@ScriptDir & "\Updater.exe")
EndFunc   ;==>_CheckVersion
Func _DownloadFile($adress, $destination)
;~ 	ProgressOn("Préparation du téléchargement ... ", "0%")
	Local $hDownload = InetGet($adress, $destination, 1, 1)
	Do
		Sleep(250)
;~ 		ProgressSet(Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)), StringLeft(InetGetInfo($hDownload, 0) / 1048576, 4) & "Mo" & _
;~ 				"/" & StringLeft(InetGetInfo($hDownload, 1) / 1048576, 4) & "Mo", Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)) & "%")
	Until InetGetInfo($hDownload, 2) ; Check if the download is complete.
	Local $nBytes = InetGetInfo($hDownload, 0)
	InetClose($hDownload) ; Close the handle to release resources.
;~ 	ProgressOff()
	Return $destination
EndFunc   ;==>_DownloadFile

Func _CalcEndMissionTime($time, $addTime)
	;system time to ticks - number of minutes to ticks
	Local $hour, $min, $sec
	$timeSplit = StringSplit($time, ":")
	_ArrayDisplay($timeSplit)
	$tickTime = _TimeToTicks($timeSplit[1] + 1, $timeSplit[2], $timeSplit[3])
	$tickTimeAdd = _TimeToTicks(0, $addTime, 0)
	$totalTime = $tickTime + $tickTimeAdd
	$nowTime = _TimeToTicks()
	$totalTime -= $nowTime
	_TicksToTime($totalTime, $hour, $min, $sec)
	$returnString = $hour & ":" & $min & ":" & $sec
	Return $returnString
EndFunc   ;==>_CalcEndMissionTime