#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
If ProcessExists("WarframeAlerter.exe") Or ProcessExists("Updater.exe") Then
	MsgBox(0, "Compilation impossible", "Un des programmes est en cours d'utilisation...")
Else
	RunWait(@ScriptDir & "\BAT\Updater.bat")
	RunWait(@ScriptDir & "\BAT\Alerter.bat")
	$version = FileRead("Data.ini")
	$data = FileOpen("Data.ini", 2)
	FileWrite($data, $version + 0.1)
DirErase(@scriptdir & "\BackUp" ) 
EndIf