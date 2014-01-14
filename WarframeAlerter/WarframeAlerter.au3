#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ico.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <String.au3>
#include <Array.au3>
#include <Inet.au3>
#include <WinAPI.au3>
#include <GUIAnimate.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <Misc.au3>

;-------------------------------------------------------------------------------------
;On sattaque au tray : Mise a jour, Aide,
;Ajout auto quand non traduit
;Pirateur pour s'entrainer
;-------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------
;--------- Variables -----------------------------------------------------------------
;-------------------------------------------------------------------------------------
Global $VERSION_ACTUELLE = 0.8
Global $LANG_DIR = "\Lang\"
Global $fr = "https://dl.dropboxusercontent.com/u/44563780/WarframeAlerter/Lang/fr.lng"
Global $notifSound = "https://dl.dropboxusercontent.com/u/44563780/WarframeAlerter/notif.mp3"
Global $Configuration = @ScriptDir & "\Data.ini"
Global $SOUND = "notif.mp3"
Global $DISPLAY_NOTIFICATION = 10 ;en secondes
Global $xml = "https://www.facebook.com/feeds/page.php?format=rss20&id=126895537502383"
Global $updateInterval = 10 ;secondes

Opt("TrayOnEventMode", 1) ;Mode OnEvent pour la gestion du Tray
Opt("TrayMenuMode", 1) ;On enlève Exit et Script paussed dans le menu du Tray
Opt("TrayAutoPause", 0) ;On désactive la pause du script lors du click sur l'icon
Opt("GUICloseOnESC", 0)

;-------------------------------------------------------------------------------------
;--------- GUI -----------------------------------------------------------------------
;-------------------------------------------------------------------------------------
#region ### START Koda GUI section ### Form=
Global $widht = 615
Global $height = 140
Global $posX = @DesktopWidth - $widht
Global $posY = @DesktopHeight - $height
Global $GUI = GUICreate("", $widht, $height, $posX, $posY - _GetTaskbarSize(4), $WS_POPUPWINDOW)
GUISetFont(16, 400, 0, "Arial")
Global $Localisation = GUICtrlCreateLabel("Localisation", 0, 0, 604, 28, $SS_CENTER)
Global $Mission = GUICtrlCreateLabel("Mission", -1, 27, 604, 28, $SS_CENTER)
Global $Temps = GUICtrlCreateLabel("Temps restant", 0, 52, 604, 28, $SS_CENTER)
Global $Credits = GUICtrlCreateLabel("Crédits", 1, 79, 604, 28, $SS_CENTER)
Global $Autre = GUICtrlCreateLabel("Autre récompenses", 5, 106, 604, 28, $SS_CENTER)
GUICtrlSetColor(-1, 0xFF0000)
#endregion ### END Koda GUI section ###

;-------------------------------------------------------------------------------------
;--------- Tray ----------------------------------------------------------------------
;-------------------------------------------------------------------------------------
Global $tray_LanceLeJeu = TrayCreateItem("Lancer le jeu")
TrayItemSetOnEvent(-1, "_LaunchGame")
Global $tray_LancePiratage = TrayCreateItem("Piratage")
TrayItemSetOnEvent(-1, "_LaunchHacking")
TrayItemSetState(-1, $GUI_DISABLE)
TrayCreateItem("")
Global $tray_DefinirOptions = TrayCreateItem("Définir les options")
TrayItemSetOnEvent(-1, "_SetOptions")
TrayItemSetState(-1, $GUI_DISABLE)
Global $tray_MiseAJour = TrayCreateItem("Mise à jour")
TrayItemSetOnEvent(-1, "_CheckMAJ")
TrayItemSetState(-1, $GUI_DISABLE)
Global $tray_LastUpdate = TrayCreateItem("Traduction de la derniere mise à jour")
TrayItemSetOnEvent(-1, "_ShowLastUpdate")
TrayItemSetState(-1, $GUI_DISABLE)
TrayCreateItem("")
Global $tray_Quitter = TrayCreateItem("Quitter")
TrayItemSetOnEvent(-1, "_Exit")


TraySetState()

;~ HotKeySet("^+d", "_DisplayGUI")
HotKeySet("^+w", "_Exit")

If _Singleton("warframeupdater", 1) = 0 Then ;1 seule occurence du programme
	MsgBox(0, "Erreur", "Une seule occurence du programme est autorisée !")
	Exit
EndIf

;-------------------------------------------------------------------------------------
;--------- Auto-Complete Package -----------------------------------------------------
;-------------------------------------------------------------------------------------
If Not FileExists(@ScriptDir & "\notif.mp3") Then
	_DownloadFile($notifSound, @ScriptDir & "\notif.mp3") ;Son notification
EndIf

If Not FileExists(@ScriptDir & $LANG_DIR & "fr.lng") Then ;si pas dans le dossier
	DirCreate(@ScriptDir & $LANG_DIR)
	_DownloadFile($fr, @ScriptDir & $LANG_DIR & "fr.lng");Fichier de langue
Else ;dans le fichier
	_DownloadFile($fr, @ScriptDir & "\fr_beta.lng") ;télécharge version test
	If FileRead(@ScriptDir & $LANG_DIR & "fr.lng") <> FileRead(@ScriptDir & "\fr_beta.lng") Then
		;si dans dossier <> en ligne
		FileMove(@ScriptDir & "\fr_beta.lng", @ScriptDir & $LANG_DIR & "fr.lng", 9)
		;remplace le fichier obsolete par le nouveau
	Else
		FileDelete(@ScriptDir & "\fr_beta.lng") ;sinon supprime le nouveau fichier
	EndIf
EndIf

;C:\Users\Quentin\AppData\Local\Warframe\EE.cfg
If Not FileExists(@StartupDir & "\WarframeAlerter.lnk") Then
	FileCreateShortcut(@ScriptDir & "\WarframeAlerter", @StartupDir & "\WarframeAlerter.lnk")
EndIf

;-------------------------------------------------------------------------------------
;--------- Starting log --------------------------------------------------------------
;-------------------------------------------------------------------------------------
SplashTextOn("", "Démarrage...", 250, 45, -1, -1, 3)

Local $stringXML = _INetGetSource($xml)
Global $array = _StringBetween($stringXML, ' <description><![CDATA[', '<br/><br/>]]></description>')
;~ _Update()
;~ AdlibRegister("_Update", $updateInterval * 1000)

SplashOff()



;-------------------------------------------------------------------------------------
;--------- Main Loop -----------------------------------------------------------------
;-------------------------------------------------------------------------------------











































;-------------------------------------------------------------------------------------
;--------- Fonctions -----------------------------------------------------------------
;-------------------------------------------------------------------------------------
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

Func _LaunchGame()
	;
EndFunc   ;==>_LaunchGame

Func _SetOptions()
EndFunc   ;==>_SetOptions

Func _LaunchHacking()
EndFunc   ;==>_LaunchHacking

Func _CheckMAJ()
EndFunc   ;==>_CheckMAJ

Func _ShowLastUpdate()
EndFunc   ;==>_ShowLastUpdate

Func _Exit()
	Exit
EndFunc   ;==>_Exit