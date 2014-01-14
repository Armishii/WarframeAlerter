#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

SplashTextOn("", "Mise à jour...", 250, 45, -1, -1, 3)
;~ ProgressOn("Préparation du téléchargement ... ", "0%")
Local $hDownload = InetGet("https://dl.dropboxusercontent.com/u/44563780/WarframeAlerter/WarframeAlerter.exe", @ScriptDir & "\WarframeAlerter.exe", 1, 1)
Do
	Sleep(250)
;~ 	ProgressSet(Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)), StringLeft(InetGetInfo($hDownload, 0) / 1048576, 4) & "Mo" & _
;~ 			"/" & StringLeft(InetGetInfo($hDownload, 1) / 1048576, 4) & "Mo", Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)) & "%")
Until InetGetInfo($hDownload, 2) ; Check if the download is complete.
;~ While InetGetInfo($hDownload, 2) ; Check if the download is complete.
;~ 	Sleep(250)
;~ 	ProgressSet(Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)), StringLeft(InetGetInfo($hDownload, 0) / 1048576, 4) & "Mo" & _
;~ 			"/" & StringLeft(InetGetInfo($hDownload, 1) / 1048576, 4) & "Mo", Int(100 * InetGetInfo($hDownload, 0) / InetGetInfo($hDownload, 1)) & "%")
;~ WEnd
Local $nBytes = InetGetInfo($hDownload, 0)
InetClose($hDownload) ; Close the handle to release resources.
ProgressOff()
SplashOff()
Run(@ScriptDir & "\WarframeAlerter.exe")
Exit



