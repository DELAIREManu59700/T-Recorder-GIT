#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 UDF TESTS CECORE
 Auteur:	S. BATTERMANN
			Ph. GARRIGUE
 Objet de l'essai : Bibliothèque de fonctions pour le lancement de tests
 Pré-requis : #include <UDF_tests> ; le script UDF_tests.au3 doit être présent dans le répertoire de tests


#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

#Include <String.au3>
#include "error_return_code.au3"
#include <NMC_Api.au3>
#include <ROCADE_API.au3>
#include <WinAPI.au3>
#include <Array.au3>

Global $fenetre, $x, $y, $w, $l
Global $begin
Global $time = ""
Global $fichierlog = StringRegExpReplace(@ScriptFullPath,"(?i)(\w+\.)au3$","$1log")
Global $globalWindowTitle ; Active window
Global $scriptName=""
Global $rapport
Global $network = False
Global $beginTime = 0

Global $T_WINWAITACTIVE=0
Global $T_MOUSECLICK=1
Global $T_SEND=2
Global $T_ASSERTFULLWINDOW=3
Global $T_ASSERTPARTIALWINDOW=4
Global $T_ASSERTMENU=5
Global $T_FUNCTIONMENU=6
Global $T_ASSERTCOLOR=7
Global $T_WAITFULLWINDOW=8
Global $T_WAITPARTIALWINDOW=9
Global $T_WAITCOLOR=10
Global $T_ASSERTCLIPBOARD=11
Global $T_WINGETPOS=12
Global $T_REFRESHPOS=13
Global $T_FUNCTIONFULLWINDOW=14
Global $T_FUNCTIONPARTIALWINDOW=15
Global $T_FUNCTIONCOLOR=16
Global $T_FUNCTIONMENU=17
Global $T_FUNCTIONCLIPBOARD=18
Global $T_WINWAITCLOSE = 19
Global $T_STARTNMC=22
Global $T_ASSERTOCR=23
Global $T_FUNCTIONOCR=24
Global $T_WINWAITSTATUS=25
Global $T_SELECTITEMINCOMBOBOX=26
Global $T_SELECTITEMINCB=27
Global $T_CLICKWORD=28
Global $globalSendBuffer = ""
Global $globalSendSize = 0
Global $allSendBuffer = ""
Global $allSendSize = 0

Global $ARRET = False

Global $Paused

Dim $comm_socket[10]

Global $PC_0 = '0.0.0.0'
Global $PC_1 = '0.0.0.0'
Global $PC_2 = '0.0.0.0'
Global $PC_3 = '0.0.0.0'
Global $PC_4 = '0.0.0.0'
Global $PC_5 = '0.0.0.0'
Global $PC_6 = '0.0.0.0'
Global $PC_7 = '0.0.0.0'
Global $PC_8 = '0.0.0.0'

Global $dll_OCR
Global $dll_PartialWindow
Global $dll_FullWindow
Global $dll_ColorWindow
Global $dll_snapshot

; StringRegExp Constants
If Not (IsDeclared("STR_REGEXPMATCH")) Then
   Global Const $STR_REGEXPMATCH = 0 ; Return 1 if match.
   Global Const $STR_REGEXPARRAYMATCH = 1 ; Return array of matches.
   Global Const $STR_REGEXPARRAYFULLMATCH = 2 ; Return array of matches including the full match (Perl / PHP style).
   Global Const $STR_REGEXPARRAYGLOBALMATCH = 3 ; Return array of global matches.
   Global Const $STR_REGEXPARRAYGLOBALFULLMATCH = 4 ; Return an array of arrays containing global matches including the full match (Perl / PHP style).
EndIf

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Init
 Goal	: Initialize the name of the current script
 Input	: name of the current script
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Init($name,$net=False)

	$network = $net
	$scriptName=$name
	$rapport=FileOpen($name&'.trp',2)
	FileWriteLine($rapport, 'Test script: '&$name&@TAB&'started on ' &@YEAR&'-'&@MON&'-'&@MDAY&' at '&Get_Time()&@CRLF&@CRLF)
	FileFlush($rapport)
	$beginTime = TimerInit()

	; Press Esc to terminate script, Pause/Break to "pause"
	HotKeySet("{PAUSE}", "T_TogglePause")
	HotKeySet("{ESC}", "T_Terminate")
	HotKeySet("+!d", "T_ShowMessage") ;Shift-Alt-d
 	;EELAIRE- Evolution pour l'application ROCADE
	;~Raccourci pour déclencher la fermeture de la fenêtre ouverte : [Ctrl] +  [Q]
	HotKeySet("^q", FuncName(R_ArretUrgence))
	;~Raccourci pour demander la fermeture de la fenêtre ouverte : [Ctrl] +  [S]
	HotKeySet("^s", FuncName(R_ArretDemande))
	$ARRET = False
 	R_SetArretUrgence($ARRET)	; Arrêt d'urgence non-demandé par défaut
	;--

	; Chargement de la bibliothèque de reconnaisance de caractères
	; La dll se trouve dans le répertoire c:\windows\system32
	ConsoleWrite ("Chargement de la DLL : T_Assert_OCR.dll" & @CRLF);
	$dll_OCR = DllOpen("T_Assert_OCR.dll")

	; Chargement des bibliothèque d'assertion des images (snapshots) de fenêtre, et de couleur
	ConsoleWrite ("Chargement de la DLL : assert_color_window.dll" & @CRLF);
	$dll_ColorWindow = DllOpen("assert_color_window.dll")
	ConsoleWrite ("Chargement de la DLL : assert_partial_window.dll" & @CRLF);
	$dll_PartialWindow = DllOpen("assert_partial_window.dll")
	ConsoleWrite ("Chargement de la DLL : assert_full_window.dll" & @CRLF);
	$dll_FullWindow = DllOpen("assert_full_window.dll")
	ConsoleWrite ("Chargement de la DLL : snapshot.dll" & @CRLF);
	$dll_snapshot = DllOpen("snapshot.dll")

	If $network Then
		ConsoleWrite('PASS1'&@CRLF)
		;Run("Notepad.exe", "", @SW_MINIMIZE)

		;Run("D:\\PSTOOLS\\PsTools\\psexec \\127.0.0.1 D:\\T-INTERPRETER\\T-Interpreter.exe", "", @SW_MAXIMIZE)
		;exit
		;Initialize connexion with remote computers
		If ($PC_0 <> '0.0.0.0') Then
			If (T_Startup_Network(0,$PC_0) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_0&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"0"&@TAB&$PC_0&@CRLF)
				FileFlush($rapport)
			Endif
		Endif
		If ($PC_1 <> '0.0.0.0') Then
			If (T_Startup_Network(1,$PC_1) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_1&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"1"&@TAB&$PC_1&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_2 <> '0.0.0.0') Then
			If (T_Startup_Network(2,$PC_2) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_2&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"2"&@TAB&$PC_2&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_3 <> '0.0.0.0') Then
			If (T_Startup_Network(3,$PC_3) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_3&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"3"&@TAB&$PC_3&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_4 <> '0.0.0.0') Then
			If (T_Startup_Network(4,$PC_4) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_4&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"4"&@TAB&$PC_4&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_5 <> '0.0.0.0') Then
			If (T_Startup_Network(5,$PC_5) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_5&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"5"&@TAB&$PC_5&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_6 <> '0.0.0.0') Then
			If (T_Startup_Network(6,$PC_6) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_6&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"6"&@TAB&$PC_6&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_7 <> '0.0.0.0') Then
			If (T_Startup_Network(7,$PC_7) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_7&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"7"&@TAB&$PC_7&@CRLF)
				FileFlush($rapport)

			Endif
		Endif
		If ($PC_8 <> '0.0.0.0') Then
			If (T_Startup_Network(8,$PC_8) == -1) Then
				FileWriteLine($rapport, "TCPConnect failed with T-Interpreter :"&@TAB&$PC_8&@CRLF)
				FileFlush($rapport)
				Stop_Test()
			Else
				FileWriteLine($rapport, "Connection with T-Interpreter :"&@TAB&"8"&@TAB&$PC_8&@CRLF)
				FileFlush($rapport)

			Endif
		Endif

		FileWriteLine($rapport,@CRLF&@CRLF)
		FileFlush($rapport)
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_WinWaitStatus
 Goal : State of the window
 Input :
		$title : title of the window
		$chaine : Search word
		$lineNumber : the Assertion line Number
		$timeout : Time before of exit
		$master : server
		$socket_id : id of socket

 Output : $returnCode
 Exemple : T_WinWaitStatus("[Active]","Traitement en cours")
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_WinWaitStatus($title,$chaine,$lineNumber=-1,$timeout=120000,$master=True,$socket_id=-1)

	Local $returnCode=0

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id<>-1 Then
		T_NetSend($T_WinWaitStatus,'T_WinWaitStatus("'&$title&','&$chaine&','&$lineNumber&','&$timeout&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WinWaitStatus)
		;Reporting
		If ($returnCode == 0) Then
			If (-1 == $lineNumber) Then
				FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"WinWaitStatus"&@TAB&"-- OK --")
				FileFlush($rapport)
			Else
				FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"WinWaitStatus"&@TAB&"-- OK --")
				FileFlush($rapport)
			EndIf
		Else
			If (-1 == $lineNumber) Then
				FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"WinWaitStatus"&@TAB&"-- ERROR --")
				FileFlush($rapport)
			Else
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"WinWaitStatus"&@TAB&"-- ERROR --")
				FileFlush($rapport)
			EndIf
		Endif
	Else
		$begin = TimerInit()
		$found = False

		$title = WinGetTitle($title)

		Local $sizeWindow = WinGetPos($title)

	;~     MsgBox(4096,"",$sizeWindow[0])
	;~     MsgBox(4096,"",$sizeWindow[1])

		Local $posY = ($sizeWindow[1]+$sizeWindow[3])-$sizeWindow[1] ; Bottom IHM Coord Mode : Window

		While(TimerDiff($begin)<$timeout AND Not $found)
			$begin_OCR = TimerInit()
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $title,"short",5,"short",$posY-20,"short",120,"short",$posY,"int", Dec("0"))
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			$dif_OCR = TimerDiff($begin_OCR)
			If(StringRegExp($result[0] ,"^"&"Traitement en cours"&"$", $STR_REGEXPMATCH)) Then
				ConsoleWrite("Etat de la fenetre: "& $title & " = ["& $result[0] & "] " & @TAB & @TAB & "Temps de traitement OCR :" & $dif_OCR & @CRLF)
			Endif
			$array = StringRegExp($result[0], "^"&$chaine&"$", $STR_REGEXPARRAYGLOBALMATCH)
			If (UBound($array) == 1) Then
				Sleep(300)
			Else
				; Status = "Prêt" ou fenêtre sans status (Bureau,fenêtre d'erreur...)
				$found = True
			EndIf
		WEnd
		If (TimerDiff($begin)>$timeout and Not $found) Then
			ConsoleWrite ("Item non trouvé et gardefou atteint!" & @CRLF)
			$returnCode = $T_WINWAITSTATUS_NOT_EQUAL_WORD
			T_End()
		EndIf
		 ;Sleep(4000)
		 ConsoleWrite($result[0] & @CRLF)
		$dif = TimerDiff($begin)
		;ConsoleWrite("Temps de traitement T_WinWaitStatus: "&$dif&@CRLF)
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_SelectItemInCB
 Goal : Select an item in a combobox
 Input :
		$x1 : x down
		$y1 : y down
		$x2 : x up
		$y2 : y up
		$item : Search word
		$lineNumber : the Assertion line Number
		$enchainement : exception
		$master : server
		$socket_id : id of socket

 Output : $returnCode
 Exemple : T_SelectItemInCB(232,139,"item1") ;Label
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

;$enchainement==2 : Cas particulié : CTRL + ... .
Func T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1,$master=True,$socket_id=-1)

	Local $returnCode=0

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id<>-1 Then
		T_NetSend($T_SelectItemInCB,'T_SelectItemInCB("'&$posX&','&$posY&','&$item&','&$lineNumber&','&$enchainement&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_SelectItemInCB)
		;Reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"SelectItemInCB"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"SelectItemInCB"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		$begin = TimerInit()
		$found = False
		Local $tempItem = "none"
		Local $direction

		If ($enchainement == 1) Then
			T_MouseClick("left",$posX,$posY)
		ElseIf ($enchainement == 2) Then
			T_Send("^{ENTER}")
		Endif
		Sleep(500)
	   Local $hwnd = WinGetHWNDComboBox()
		; Retrieve the window title of the active window.
		Local $sText = WinGetTitle($hwnd)

		Dim $sizeWindowComboBox = WinGetPos($hwnd)
		Local $sizeWindow = WinGetPos($globalWindowTitle)
	;~  MsgBox(4096,"",$sizeWindowComboBox[0])
	;~  MsgBox(4096,"",$sizeWindowComboBox[1])
	;~  MsgBox(4096,"",$sizeWindowComboBox[2])
	;~  MsgBox(4096,"",$sizeWindowComboBox[3])

	;~  MsgBox(4096,"",$sizeWindow[0])
	;~  MsgBox(4096,"",$sizeWindow[1])

		$sizeWindowComboBox[2] = ($sizeWindowComboBox[0]+$sizeWindowComboBox[2])-$sizeWindow[0]
		$sizeWindowComboBox[3] = ($sizeWindowComboBox[1]+$sizeWindowComboBox[3])-$sizeWindow[1]
		$sizeWindowComboBox[0] = $sizeWindowComboBox[0] - $sizeWindow[0]
		$sizeWindowComboBox[1] = $sizeWindowComboBox[1] - $sizeWindow[1]

	;~  MsgBox(4096,"",$sizeWindowComboBox[0])
	;~  MsgBox(4096,"",$sizeWindowComboBox[1])
	;~  MsgBox(4096,"",$sizeWindowComboBox[2])
	;~  MsgBox(4096,"",$sizeWindowComboBox[3])

		While(Not $found And TimerDiff($begin)<120000)
			Sleep(500)
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $globalWindowTitle,"short",$sizeWindowComboBox[0],"short",$sizeWindowComboBox[1],"short",$sizeWindowComboBox[2],"short",$sizeWindowComboBox[3],"int", Dec("FFFFFF"))
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
			ConsoleWrite ("Item Recherche :[" & $item & "]" &@CRLF)

			If($tempItem<>$result[0] And "{UP}"<>$direction) Then
			   $direction = "{DOWN}"
			Else
			   $direction = "{UP}"
			EndIf

			If Not(StringRegExp($result[0],"^"&$item&"$",$STR_REGEXPMATCH)) Then
				If ($enchainement == 1) Then
					T_Send($direction)
				ElseIf ($enchainement == 2) Then
					T_Send("^{DOWN}")
				Endif
				Sleep(500)
				$tempItem = $result[0]
			Else
				$found = True
				ConsoleWrite ("Item trouvé !" & @CRLF)
			EndIf

		Wend
		If (TimerDiff($begin)>120000 and Not $found) Then
			ConsoleWrite ("Item non trouvé et gardefou atteint!" & @CRLF)
			$returnCode = $T_SELECTITEMINCOMBOBOX_NOT_EQUAL_WORD
			T_End()
		EndIf
		T_Send("{ENTER}")
		$dif = TimerDiff($begin)
		ConsoleWrite("Temps de traitement T_SelectItemInComboBox: "&$dif&@CRLF)
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

Func WinGetClientPos($Handle)
   $hwnd = WinGetHandle($Handle)
   	;Global Const $tagRECT = "struct; long Left;long Top;long Right;long Bottom; endstruct"
   $cPos = DllStructCreate($tagRECT)
   DllCall("user32.dll", "int", "GetWindowRect", "hwnd", $hwnd, "ptr", DllStructGetPtr($cPos))
   Dim $cPos2[4] = [DllStructGetData($cPos, 1), DllStructGetData($cPos, 2), DllStructGetData($cPos, 3), DllStructGetData($cPos, 4)]
   Return $cPos2
EndFunc

Func WinGetHWNDComboBox()
    ; Retrieve a list of window handles.
    Local $aList = WinList()
	Local $aListe, $hwnd=0

    ; Loop through the array displaying only visable windows with a title.
    For $i = 1 To $aList[0][0]
        If $aList[$i][0] = "IlvPopupMenu" And BitAND(WinGetState($aList[$i][1]), 1) And BitAND(WinGetState($aList[$i][1]), 2) And BitAND(WinGetState($aList[$i][1]), 4) Then
            ;MsgBox(4096, "", "Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & "number : " & WinGetState($aList[$i][1]))
			;$aListe &= $aList[$i][0]
			Return $aList[$i][1]
        EndIf
    Next
	For $i = 1 To $aList[0][0]
        If $aList[$i][0] = "IlvStringList" And BitAND(WinGetState($aList[$i][1]), 1) And BitAND(WinGetState($aList[$i][1]), 2) And BitAND(WinGetState($aList[$i][1]), 4) Then
            ;MsgBox(4096, "", "Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & "number : " & WinGetState($aList[$i][1]))
			;$aListe &= $aList[$i][0]
			Return $aList[$i][1]
        EndIf
    Next

   Return $hwnd
EndFunc

; Ancienne méthode.
Func T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1,$master=True,$socket_id=-1)

	Local $returnCode=0

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id<>-1 Then
		T_NetSend($T_SelectItemInComboBox,'T_SelectItemInComboBox("'&$posX1&','&$posY1&','&$posX2&','&$posY2&','&$item&','&$enchainement&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_SelectItemInComboBox)
		;Reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"SelectItemInComboBox"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"SelectItemInComboBox"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		$begin = TimerInit()
		$found = False
		$gardefou = 2000
		T_MouseClick("left",int(($posX1+$posX2)/2),int(($posY1+$posY2)/2))
		If ($enchainement == 1) Then
			T_MouseClick("left",int(($posX1+$posX2)/2),int(($posY1+$posY2)/2))
		ElseIf ($enchainement == 2) Then
			T_Send("^{ENTER}")
		Endif
		While(Not $found And 0 < $gardefou)
			ConsoleWrite ("gardefou : " & $gardefou & @CRLF)
			Sleep(500) ; Attendre que l'IHM affiche la valeur du combobox
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $globalWindowTitle,"short",$posX1,"short",$posY1,"short",$posX2,"short",$posY2, "int", Dec("FFFFFF"))
			; Dec("FFFFFF") -> blanc
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
			ConsoleWrite ("Item Rechercher :[" & $item & "]" &@CRLF)
			If StringRegExp($result[0],$item,$STR_REGEXPMATCH) Then
			   $found = True
			EndIf
			If Not $found Then
				If ($enchainement == 1) Then
					T_Send("{DOWN}")
				ElseIf ($enchainement == 2) Then
					T_Send("^{DOWN}") ; CTRL+DOWN
				Endif
				Sleep(500); Attendre que l'IHM affiche la valeur du combobox
			Else
				ConsoleWrite ("Item trouvé ! : " & $result[0] & @CRLF)
			EndIf
			$gardefou -= 1
		Wend
		If (0 == $gardefou and Not $found) Then
			ConsoleWrite ("Item non trouvé et gardefou atteint!" & @CRLF)
			$returnCode = $T_SELECTITEMINCOMBOBOX_NOT_EQUAL_WORD
			T_End()
		EndIf
		$dif = TimerDiff($begin)
		ConsoleWrite("Temps de traitement T_SelectItemInComboBox: "&$dif&@CRLF)
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
 EndFunc

Func T_Read_OCR($posX1,$posY1,$posX2,$posY2)
	$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $globalWindowTitle,"short",$posX1,"short",$posY1,"short",$posX2,"short",$posY2, "int", Dec("000000"))
	DllCall_Error("parseOCR_PartialIlogWindows", @error)
	ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
	Return StringStripWS($result[0], 3) ; strip leading and trailing WS
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : wordPosition
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func wordPosition($title,$word,$color=0,$offset=0)

	If(0==$color) Then
		$color = Dec(000000)
	EndIf

	;=========================================================
	;   Create the struct
	;   struct {
	;       int x;
	;       int y;
	;   }
	;=========================================================

	$str = "long x;long y"
	$cPos = DllStructCreate($str)
	if @error Then
		MsgBox(0,"","Error in DllStructCreate " & @error);
		exit
	endif

	If(0==WinExists($title)) Then
		MsgBox(0,"","Error : Window  no exists");
		exit
	Else
		WinActivate($title)
	EndIf

	$result = DllCall($dll_OCR, "ubyte:cdecl", "wordPosition", "str", $title,"str",$word,"int",$color,"int",$offset,"ptr",DllStructGetPtr($cPos))
	DllCall_Error("wordPosition", @error)
	;MsgBox(4096,"DLL OCR : wordPosition",$result[0])
	Dim $cPos2[2] = [DllStructGetData($cPos, "x"), DllStructGetData($cPos, "y")]

	;=========================================================
	;   Display info in the struct
	;=========================================================
	;MsgBox(0,"DllStruct","Struct Size: " & DllStructGetSize($cPos) & @CRLF & _
	;		"Struct pointer: " & DllStructGetPtr($cPos) & @CRLF & _
	;		"Data:" & @CRLF & _
	;		$cPos2[0] & @CRLF & _
	;		$cPos2[1])
	Return $cPos2
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_ClickWord
 Goal : Click on the word (OCR)
 Input :	$title : the targeted window title
		$word : Search word
		$color : color of text
		$offset : number of element (identique word)
		$lineNumber : the Assertion line Number
		$master : server
		$socket_id : id of socket

 Output : aucune
 Exemple : T_ClickWord("Identification du réseau courant","Label")
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_ClickWord($title,$word,$color=0,$offset=0,$lineNumber=-1,$master=True,$socket_id=-1)
	Local $returnCode=0
	Dim $cPos2[2]

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id<>-1 Then
		T_NetSend($T_CLICKWORD,'T_ClickWord("'&$title&'","'&$word&'","'&$color&'","'&$offset&'",'&$lineNumber&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_CLICKWORD)
		;Reporting
		If ($returnCode == 0) Then
			If(-1 == $lineNumber) Then
				FileWriteLine($rapport, Get_Time()&@TAB&$socket_id&@TAB&"ClickWord"&@TAB&"-- OK --")
				FileFlush($rapport)
			Else
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"ClickWord"&@TAB&"-- OK --")
				FileFlush($rapport)
			EndIf
		Else
			If(-1 == $lineNumber) Then
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"ClickWord"&@TAB&"-- ERROR --")
				FileFlush($rapport)
			Else
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"ClickWord"&@TAB&"-- ERROR --")
				FileFlush($rapport)
			EndIf
		Endif
	Else
		$cPos2 = wordPosition($title,$word,$color,$offset)
		If(-1==$cPos2[0] Or -1==$cPos2[1]) Then
			$returnCode = $T_CLICKWORD_NOT_EQUAL_WORD
		Else
			T_MouseClick("left",$cPos2[0],$cPos2[1]+4)
		EndIf
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_Assert_OCR
 Goal : Get a word and compare it with the recorded word
 Input :	$title : the targeted window title
		$x1 : x down
		$y1 : y down
		$x2 : x up
		$y2 : y up
		$word : Search word
		$lineNumber : the Assertion line Number
		$master : server
		$socket_id : id of socket

 Output : aucune
 Exemple : T_Assert_OCR("Letter - Paint",122,392,136,410,"ABC",@ScriptLineNumber)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTOCR,'T_Assert_OCR("'&$title&'",'&$x1&','&$y1&','&$x2&','&$y2&',"'&$word&'",'&$lineNumber&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTOCR)
		;Reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_OCR"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_OCR"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		;Color BLACK
		$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $title,"short",$x1,"short",$y1,"short",$x2,"short",$y2,"int", Dec("000000"))
		DllCall_Error("parseOCR_PartialIlogWindows", @error)
		ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)

		;Reporting
		If(Not StringRegExp($result[0], "^"&$word&"$", $STR_REGEXPMATCH)) Then
			;Color WHITE
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $title,"short",$x1,"short",$y1,"short",$x2,"short",$y2,"int", Dec("FFFFFF"))
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
			; Not identical
			If(Not StringRegExp($result[0], "^"&$word&"$", $STR_REGEXPMATCH)) Then
				ConsoleWrite("ERROR - word are not identical." & @CRLF )
				$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_OCR"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
				FileFlush($rapport)

;				$snapshot = "snapshot.dll"
;				$dll_snapshot = DllOpen($snapshot)

;				$result=DllCall($dll_snapshot, "short:cdecl", "TakeWindowSnapshot", "str", $title,"str",$filePath)
;				DllCall_Error("TakeWindowSnapshot",@error)
				$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$x1,"int",$y+$y1,"int",($x2 - $x1) ,"int",($y2 - $y1))
				DllCall_Error("TakeAreaSnapshot",@error)

				$pathToTMP='.\Temp\snapshot_T_Assert_OCR.bmp'
				$savedsnapShotCnt='01'
				$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
				DllCall_Error("SauvegardeToFile",@error)

				$returnCode = $T_ASSERTOCR_NOT_EQUAL_WORD
;				DllClose($dll_snapshot)
			Else
				ConsoleWrite("OK - identical word!" & @CRLF )
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_OCR"&@TAB&"-- OK --")
				FileFlush($rapport)
			EndIf
		Else
			ConsoleWrite("OK - identical word!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_OCR"&@TAB&"-- OK --")
			FileFlush($rapport)
		EndIf
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_Function_OCR
 Goal : Get a word and compare it with the recorded word
 Input :	$title : the targeted window title
		$x1 : x down
		$y1 : y down
		$x2 : x up
		$y2 : y up
		$word : Search word
		$lineNumber : the Assertion line Number
		$master : server
		$socket_id : id of socket

 Output : boolean : True => recorded and played word are identical 		False => not identical
 Exemple : $var = T_Function_OCR("Letter - Paint",122,392,136,410,"ABC",@ScriptLineNumber)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode = 0
	Local $returnCodeBool = False

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id <>-1 Then
		T_NetSend($T_FUNCTIONOCR,'T_Function_OCR("'&$title&'",'&$x1&','&$y1&','&$x2&','&$y2&',"'&$word&'",'&$lineNumber&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_FUNCTIONOCR)
		;Reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_OCR"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_OCR"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		;Color BLACK
		$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $title,"short",$x1,"short",$y1,"short",$x2,"short",$y2,"int", Dec("000000"))
		DllCall_Error("parseOCR_PartialIlogWindows", @error)
		ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)

		;Reporting
		If(Not StringRegExp($result[0], "^"&$word&"$", $STR_REGEXPMATCH)) Then
			;Color WHITE
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $title,"short",$x1,"short",$y1,"short",$x2,"short",$y2,"int", Dec("FFFFFF"))
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
			; Not identical
			If(Not StringRegExp($result[0], "^"&$word&"$", $STR_REGEXPMATCH)) Then
				ConsoleWrite("ERROR - word are not identical." & @CRLF )
				$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_OCR"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
				FileFlush($rapport)

;				$snapshot = "snapshot.dll"
;				$dll_snapshot = DllOpen($snapshot)

;				$result=DllCall($dll_snapshot, "short:cdecl", "TakeWindowSnapshot", "str", $title,"str",$filePath)
;				DllCall_Error("TakeWindowSnapshot",@error)
				$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$x1,"int",$y+$y1,"int",($x2 - $x1) ,"int",($y2 - $y1))
				DllCall_Error("TakeAreaSnapshot",@error)

				$pathToTMP='.\Temp\snapshot_T_Function_OCR.bmp'
				$savedsnapShotCnt='01'
				$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
				DllCall_Error("SauvegardeToFile",@error)

				$returnCode = $T_FUNCTIONOCR_NOT_EQUAL_WORD
;				DllClose($dll_snapshot)
			Else
				ConsoleWrite("OK - identical word!" & @CRLF )
				FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_OCR"&@TAB&"-- OK --")
				FileFlush($rapport)
				$returnCodeBool = True
			EndIf
		Else
			ConsoleWrite("OK - identical word!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_OCR"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		EndIf
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode& ']'& @CRLF)
return $returnCodeBool
EndFunc

Func T_OCR_Liste($x,$y,$x2,$y2,$width,$height,$words)
    $verif = False
    $aLabels = stringSplit($words,"+")
	T_MouseClick("left",$x,$y)

	$y = $y + 7
	For $i = 2 To $aLabels[0] ; Boucle dans le tableau renvoyé par StringSplit pour afficher les valeurs individuelles. La première valeur est le click donc $i=2
		 While False==$verif
			Sleep(3000)
			$result = DllCall($dll_OCR, "str:cdecl", "parseOCR_PartialIlogWindows", "str", $globalWindowTitle,"short",$x2,"short",$y2-20,"short",$width,"short",$height, "int", Dec("FFFFFF"))
			DllCall_Error("parseOCR_PartialIlogWindows", @error)
			ConsoleWrite ("Item Lu :[" & $result[0] & "]" &@CRLF)
			If 0<>StringInStr($result[0],$aLabels[$i]) Then
			   Sleep(3000)
			   T_Send("{ENTER}")
			   $x = $x + 95
			   $verif = True
			Else
			   Sleep(3000)
			   T_Send("{DOWN}")
			EndIf
			;$y = $y + 19
		 WEnd
		 $verif = False
    Next
EndFunc

Func T_Startup_Network($id,$ip_addr)
; Start The TCP Services
;==============================================
TCPStartUp()
; Connect to a Listening "SOCKET"
;==============================================
$comm_socket[$id] = TCPConnect( $ip_addr, 3000 )
    ;If @error Then
     ;   MsgBox(4112, "Error", "TCPConnect failed when attempting to connect to T-Interpreter: " & @error)
	;EndIf
	ConsoleWrite('$comm_socket[$id] =['&$comm_socket[$id]&']'&@CRLF)
	return $comm_socket[$id]
EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_End
 Goal	: Close the differents opened files, shut down network connection, etc.
 Input	: none
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_End($status = "TEST : OK",$returnCode = 0)
	Local $diffTime

	; Close de la bibliothèque de reconnaisance de caractères
	; La dll se trouve dans le répertoire c:\windows\system32
	ConsoleWrite ("Close de la DLL  : T_Assert_OCR.dll" & @CRLF);
	DllClose($dll_OCR)

	;Ferme les bibliothèques d'assertion des images de fenêtre et de couleur
	ConsoleWrite ("Close de la DLL  : assert_color_window.dll" & @CRLF);
	DllClose($dll_ColorWindow)
	ConsoleWrite ("Close de la DLL  : assert_full_window.dll" & @CRLF);
	DllClose($dll_FullWindow)
	ConsoleWrite ("Close de la DLL  : assert_partial_window.dll" & @CRLF);
	DllClose($dll_PartialWindow)
	ConsoleWrite ("Close de la DLL  : snapshot.dll" & @CRLF);
	DllClose($dll_snapshot)

	if $network Then
		;Shutting down the connexion with remote computers
		TCPShutdown ( ) ; To stop TCP services
	EndIf
	FileWriteLine($rapport, @CRLF&'Test ended on ' &@YEAR&'-'&@MON&'-'&@MDAY&' at '&Get_Time())
	FileFlush($rapport)
	$diffTime = TimerDiff($beginTime)
	FileWriteLine($rapport, @CRLF&'Test has last : '&Int($diffTime/1000)&' seconds.'&@CRLF)
	FileFlush($rapport)
	FileWriteLine($rapport, @CRLF&$status&@CRLF)
	FileFlush($rapport)
	FileClose($rapport)
	If ($status == "TEST : OK") Then
		Exit $returnCode
	Else
		Exit 1
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Log
 Goal	: Dump an action (used by T-Report)
 Input	: 	action description
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Log($description,$lineNb,$socket_id=-1)
	if ($socket_id ==-1) Then
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"----- ACTION -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
else
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"----- ACTION -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Log_Step
 Goal	: Dump the step (used by T-Report)
 Input	: 	step id
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Log_Step($stepId,$lineNb,$socket_id=-1)
	if ($socket_id ==-1) Then
	FileWriteLine($rapport, @CRLF&"Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"----- STEP "&$stepId&" -----")
	FileFlush($rapport)
else
	FileWriteLine($rapport, @CRLF&"Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"----- STEP "&$stepId&" -----")
	FileFlush($rapport)
EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Log_Assert
 Goal	: Dump the assertion (used by T-Report)
 Input	: 	Description of the Assertion
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Log_Assert($description,$lineNb,$socket_id=-1)
	if ($socket_id ==-1) Then
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"----- ASSERT LOG -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
else
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"----- ASSERT LOG -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
	EndIf
EndFunc
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Log_Function
 Goal	: Dump the description of the function (used by T-Report)
 Input	: 	Description of the function
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Log_Function($description,$lineNb,$socket_id=-1)
	if ($socket_id ==-1) Then
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"----- FUNCTION LOG -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
else
	FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"----- FUCNTION LOG -----")
	FileFlush($rapport)
	FileWriteLine($rapport, $description)
	FileFlush($rapport)
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_NetSend
 Objectif : Envoie à l'ordinateur distant l'intruction à exécuter
 Entrée(s) :
			- type de message
			- msg Le message à envoyer
			- socket id
 Sortie(s) : aucune
 Exemple : T_NetSend('T_WinWaitActive("Bureau",@ScriptLineNumber)', $PC_0)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_NetSend ($tag,$msg, $socket_id)
	EncodeTag($tag) ; The 4 first digits are used to encode the language ; The 12th last digits are used to encode the instructions
	AppendString($msg)
	EncodeSize()
	EncodeData()
	ConsoleWrite('$SOCKET_ID =['&$socket_id&']'&@CRLF)
	;$taille = _ArraySize($comm_socket)
	;ConsoleWrite('$TAILLE =['&$TAILLE&']'&@CRLF)
	TCPSend($comm_socket[$socket_id], _HexToString($allSendBuffer))
	$globalSendBuffer = ""
	$globalSendSize = 0
	$allSendBuffer = ""
	$allSendSize = 0
	ConsoleWrite('Sending instruction('&$msg&') over the network...'&@CRLF)

EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_NetReceive
 Objectif : Receive the result
 Entrée(s) :
			- type de message
			- msg Le message à envoyer
			- socket id
 Sortie(s) : aucune
 Exemple : T_NetSend('T_WinWaitActive("Bureau",@ScriptLineNumber)', $PC_0)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_NetReceive ($socket_id,$opcodeExpected)
	ConsoleWrite('Receiving message from the network...'&@CRLF)
	Local $recv=""
	Local $dif = 0
	Local $bytesRead = 0
	$begin = TimerInit()
	While(($dif < 10000) and ($bytesRead < 8)) ; watchdog of 10 seconds to avoid to block the reading socket
											; This value should be read in an ini file.
											; TODO
		$data = TCPRecv($comm_socket[$socket_id],8,1) ; 4 bytes for the opcode + 4 bytes for the return code of the T_... function
													; This value should be read in an ini file.
													;TODO
		if (BinaryLen($data)<>0) Then
			$bytesRead += BinaryLen($data)
			$recv = $recv & BinaryToString($data)

		Endif
	Wend
	$dif = TimerDiff($begin)
	$recv = StringToBinary($recv)
	ConsoleWrite('dif ='&$dif&@CRLF)

	$opcode = BinaryMid($recv, 1, 4)
	$returnCode = BinaryMid($recv, 5, 4)
	ConsoleWrite('$recv = ['&$recv&']'&@CRLF)
	;ConsoleWrite('$opcode = ['&$opcode&']'&@CRLF)
	;ConsoleWrite('$returnCode = ['&$returnCode&']'&@CRLF)

	$opcodeDec = Int($opcode)
	$returnCodeDec = Int($returnCode)
	;ConsoleWrite('$opcodeDec = ['&$opcodeDec&']'&@CRLF)
	ConsoleWrite('$returnCodeDec = ['&$returnCodeDec&']'&@CRLF)
	;ConsoleWrite('$opcodeExpected = ['&$opcodeExpected&']'&@CRLF)

	if ($opcodeExpected == $opcodeDec) Then
			return $returnCodeDec
		Else
				return -1 ; Bad Operand Code
	Endif

EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_WinWaitActive
 Goal	: Call and wait a new active window. Update the $x and $y, two variables standing for the position of the actual window in the screen.
 Input	: $windowTitle = Title of the window to bring to front
	: $lineNb = Current line number when this function is called in the main script.
	: id : PC id on the network
 Output : $x = X position of the window in the screen
 	  $y = Y position of the window in the screen
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_WinWaitActive($windowTitle,$length,$height,$lineNb,$bloquant=true,$timeout=2400000,$master=True,$socket_id=-1)
	FileWriteLine($rapport, "Entering T_WinWaitActive(" & $windowTitle & ")")
	FileFlush($rapport)

	Local $instruction=""
	Local $returnCode=0
	Local $state=0
	Local $timeoutflag = True
	Local $begin = 0
	Local $winsize

	T_Surveillance_plantage_process(@ScriptDir)

	If $socket_id <> -1 Then
		$instruction = "T_WinWaitActive("&$windowTitle&","&$length&","&$height&","&$lineNb&","&$timeout&",False)"
		T_NetSend($T_WINWAITACTIVE,$instruction, $socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WINWAITACTIVE)
	Else
		$begin = TimerInit()
		$state = WinGetState($windowTitle, "")

		While (not BitAnd($state, 2) AND $timeoutflag)
			sleep (100)
			$timeoutflag = TimerDiff($begin)<$timeout
			$state = WinGetState($windowTitle, "")
		Wend
		sleep (300)
		$winsize = WinGetPos($windowTitle)
		if ($winsize <> 0) Then ; <> 0 la fenêtre existe
			If ($length<>-1 and $height<>-1) Then
				If (($winsize[2] <> $length) OR ($winsize[3] <> $height)) Then
					WinMove($windowTitle,"",$winsize[0],$winsize[1],$length,$height)
					$winsize = WinGetPos($windowTitle)
					If ((($winsize[2] <> $length) OR ($winsize[3] <> $height)) AND ($master)) Then
						If ($master) Then
							If ($bloquant) Then
								;Reporting
								FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"T_WinWaitActive RESIZE Not possible : "&@TAB&$windowTitle)
								FileFlush($rapport)
								T_Assert_Traitement()
							EndIf
						Else
							If ($bloquant) Then
								$returnCode = $T_WINWAITACTIVE_RESIZE_NOT_POSSIBLE
							EndIf
						Endif
					Endif
				EndIf
			Endif
		Endif
		If (not $timeoutflag) Then
			; TIMEOUT is triggered !
			If ($master) Then
				;Reporting
				FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"T_WinWaitActive TIMEOUT : "&@TAB&$windowTitle)
				FileFlush($rapport)
				T_Assert_Traitement()
			Else
				$returnCode = $T_WINWAITACTIVE_TIME_ELAPSED
			EndiF
		Else
			;$hwnd = WinGetHandle($windowTitle)
			$globalWindowTitle = $windowTitle
			T_WinGetPos($windowTitle,$lineNb)
		EndIf
	EndIf
	If (($returnCode <> 0) And ($master)) Then
		FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"T_WinWaitActive TIMEOUT : "&@TAB&$windowTitle)
		FileFlush($rapport)
		T_Assert_Traitement()
	EndIf
	FileWriteLine($rapport, "Exiting T_WinWaitActive(" & $windowTitle & ") : " & $returnCode)
	FileFlush($rapport)
	return $returnCode
EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_WinWaitClose
 Goal	: Wait a closing window.
 Input	: $windowTitle = Title of the window to bring to front
	: $lineNb = Current line number when this function is called in the main script.
	: id : PC id on the network
 Output : $x = X position of the window in the screen
 	  $y = Y position of the window in the screen
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func T_WinWaitClose($windowTitle,$lineNb,$timeout=120000,$master=True,$socket_id=-1)
	Local $instruction=""
	Local $returnCode=0
	Local $state=0
	Local $timeoutflag = True
	Local $begin = 0
	T_Surveillance_plantage_process(@ScriptDir)
	If $socket_id <> -1 Then
		$instruction = "T_WinWaitClose("&$windowTitle&","&$lineNb&","&$timeout&",False)"
		T_NetSend($T_WINWAITCLOSE,$instruction, $socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WINWAITCLOSE)
	Else
		$begin = TimerInit()
		$state = WinGetState($windowTitle, "")
		While ($state<>0 AND $state<>5 AND $state<>13  AND $timeoutflag) ; Sur le CECORE, certaines fenêtres ne sont plus visibles mais toujours présentes en mémoire
                                                                                 ; state = (1,2,4,8)=(exists,visible,enabled,active)
			sleep (100)
			$timeoutflag = TimerDiff($begin)<$timeout
			$state = WinGetState($windowTitle, "")
			ConsoleWrite ($windowTitle&" : " & $state&@CRLF)
		Wend
		sleep (300)
		If (not $timeoutflag) Then
			; TIMEOUT is triggered !
			If ($master) Then
				;Reporting
				FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"T_WinWaitClose TIMEOUT : "&@TAB&$windowTitle)
				FileFlush($rapport)
				T_Assert_Traitement()
			Else
				$returnCode = $T_WINWAITCLOSE_TIME_ELAPSED
			EndiF
		EndIf
	EndIf
	If (($returnCode <> 0) And ($master)) Then
		FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"T_WinWaitClose TIMEOUT : "&@TAB&$windowTitle)
		FileFlush($rapport)
		T_Assert_Traitement()
	EndIf
	return $returnCode
EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_MouseClick
 Goal	: Simulate a simple or drag click on a window in absolute mode
 Input	: $mouseButton = stands for the left,middle, right mouse button. Possible values can be only "left","middle","right"
	: $x = X absolute begin position in the screen
 	: $y = Y absolute begin position in the screen
	: $xx = X absolute end position in the screen (optional)
 	: $yy = Y absolute end position in the screen (optional)
	: $id : PC id on the network

 Output : None
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=30,$id=-1)
	;T_TogglePause()
	Local $instruction="";
	Local $returnCode=0
	Local $isGrapheGeoreference = false;
	Local $isGrapheLogique = false;
	T_WinWaitStatus("[Active]","Traitement en cours")
	T_Surveillance_plantage_process(@ScriptDir)

	;ConsoleWrite("$x:"&$x&"$y:"&$y&"$xx:"&$xx&"$yy:"&$yy&"$id:"&$id&@CRLF)
	If $id <> -1 Then
		If $xx==-1 and $yy==-1 Then
			If $speed >= 0 And $speed <=100 Then
				$instruction = 'T_MouseClick('&$mouseButton&','&$x&','&$y&','&$speed&')';
			Else
				$instruction = 'T_MouseClick('&$mouseButton&','&$x&','&$y&')';
			EndIf
			ConsoleWrite("$instruction : "&$instruction)
			T_NetSend($T_MOUSECLICK,$instruction, $id)
			$returnCode = T_NetReceive($id,$T_MOUSECLICK)
		Else
			If $speed >= 0 And $speed <=100 Then
				$instruction = 'T_MouseClick('&$mouseButton&','&$x&','&$y&','&$xx&','&$yy&','&$speed&')'
			Else
				$instruction = 'T_MouseClick('&$mouseButton&','&$x&','&$y&','&$xx&','&$yy&')'
			EndIf
			T_NetSend($T_MOUSECLICK,$instruction, $id)
			$returnCode = T_NetReceive($id,$T_MOUSECLICK)
		EndIf
	Else
		$isGrapheGeoreference = StringRegExp($globalWindowTitle,"^Graphe géoréférencé",0)
		$isGrapheLogique = StringRegExp($globalWindowTitle,"^Graphe logique",0)
		If ($globalWindowTitle == "Bureau") or $isGrapheGeoreference or $isGrapheLogique Then
			; for the menu to avoid to use tear off
			$pos = MouseGetPos()
			;$pos[0] : X position at present time
			;$pos[1] : Y position at present time
			MouseMove($x,$pos[1],$speed)
		EndIf
		MouseMove($x,$y,$speed)
		MouseDown($mouseButton)
		If (($xx<>-1) AND ($yy<>-1)) Then
			MouseMove($xx,$yy)
		EndIf
		MouseUp($mouseButton)
	EndIf
	;CUSTOMISATION NMC : pour les menus déroulants obtenus par clic droit, Ilog prend du temps à afficher le menu.
	If ($mouseButton == "right") Then
		Sleep(1000)
	Endif
	return $returnCode
EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_WinGetPos
 Objectif : Répère la position de la fenêtre sur l'écran.
			Indique si la fenêtre est présente. Dans le cas échéant, ajoute une trace dans le fichier .log.
 Entrée(s) : $texte, le titre de la fenêtre.
		   : $ligne, numéro de la ligne où cette fonction a été appelée.
 Sortie(s) : $x, l'abscisse du coin supérieur gauche de la fenêtre
			 $y, l'ordonnée du coin supérieur gauche de la fenêtre
			 $w, la largeur de la fenêtre en pixel
			 $l, la hauteur de la fenêtre en pixel
 Exemple : T_WinGetPos("Fenêtre d'interrogation",@ScriptLineNumber)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_WinGetPos($titre,$ligne,$socket_id=-1)
	Local $returnCode=0
	If $socket_id <> -1 Then
		T_NetSend($T_WINGETPOS,'T_WinGetPos("'&$titre&'",'&$ligne&')',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WINGETPOS)
	Else
		WinActivate ($titre)
		$fenetre = WinGetPos($titre)

		If @error Then
 		;EDELAIRE 08/12/2020 - suppression de la boite de dialogue qui mentionne l'erreur
		;	MsgBox (0,"ERROR","La fenêtre n'est pas présente !!!!")
			ConsoleWrite(@ScriptLineNumber&"| "&Get_Time()&" La fenêtre "&$titre&" n"&"'"&"est pas ouverte "&@CRLF)
			ConsoleWrite("Temps test : "&$time)
			BlockInput(0)
		;	Exit
			$returnCode = 1	;EDELAIRE - mettre ici un code d'erreur à retourner
			return $returnCode
		EndIf

		$x = $fenetre[0]
		$y = $fenetre[1]
		$w = $fenetre[2]
		$l = $fenetre[3]

		If ($fenetre[0] = -32000 And $fenetre[1] = -32000) Then ; si la fenêtre est minimisée
			WinSetState($titre,"",@SW_MAXIMIZE)
			ConsoleWrite($ligne&"| "& @hour&":"&@MIN&":"&@SEC&" La fenêtre "&$titre&" était minimisée"&@CRLF)
			T_WinGetPos($titre,@ScriptLineNumber)
		EndIf
	EndIf
	return $returnCode
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_RefreshPos
 Objectif : Rafraichir la position de la fenêtre sur l'écran.

  Sortie(s) : $x, l'abscisse du coin supérieur gauche de la fenêtre
			 $y, l'ordonnée du coin supérieur gauche de la fenêtre
			 $w, la largeur de la fenêtre en pixel
			 $l, la hauteur de la fenêtre en pixel
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_RefreshPos($socket_id=-1)
	Local $returnCode=0
	If $socket_id <> -1 Then
		T_NetSend($T_REFRESHPOS,'T_RefreshPos()',$socket_id)
	;	$returnCode = T_NetReceive($socket_id,$T_WINGETPOS)	;<-- EDELAIRE - 08/12/2020 -  N'est pas une erreur ????
		$returnCode = T_NetReceive($socket_id,$T_REFRESHPOS)	;<-- EDELAIRE - 08/12/2020 - N'est pas là plutot le code correct ?
	Else

		$titre=$globalWindowTitle
		WinActivate ($titre)
		$fenetre = WinGetPos($titre)

		If @error Then
		; EDELAIRE - 08/12/2020 - Suppression de la boite de dialogue avec l'erreur
		;	MsgBox (0,"ERROR","La fenêtre n'est pas présente !!!!")
			ConsoleWrite(@ScriptLineNumber&"| "&@hour&":"&@MIN&":"&@SEC&" La fenêtre "&$titre&" n"&"'"&"est pas ouverte "&@CRLF)
			ConsoleWrite("Temps test : "&$time)
			BlockInput(0)
		;	Exit
			$returnCode = 1	;EDELAIRE - mettre ici un code d'erreur à retourner
			return $returnCode
		EndIf

		$x = $fenetre[0]
		$y = $fenetre[1]
		$w = $fenetre[2]
		$l = $fenetre[3]

		If ($fenetre[0] = -32000 And $fenetre[1] = -32000) Then ; si la fenêtre est minimisée
			WinSetState($titre,"",@SW_MAXIMIZE)
			T_WinGetPos($titre,@ScriptLineNumber)
		EndIf
	Endif
	return $returnCode
EndFunc




#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_Assert_Full_Window
 Goal : Eval a full window checksum and compare it with the recorded checksum
 Input :	$windowTitle : the targeted window title
		$recorded_checksum : this recorded checksum is used to compare it with the played checksum
		$lineNumber : the Assertion line Number
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
 Output : aucune
 Exemple : T_Assert_Full_Window("Calculatrice","2558D143810211245C1F51BBF5E52699") ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	ConsoleWrite("T_Assert_Full_Window" & @CRLF )
	If $socket_id <>-1 Then
		T_NetSend($T_ASSERTFULLWINDOW,'T_Assert_Full_Window("'&$windowTitle&'","'&$recorded_checksum&'",'&$lineNumber&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTFULLWINDOW)
		;reporting Remote
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Full_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Full_Window"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		;WinActivate("[CLASS:Progman]", "")
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertfullwindowdll = "assert_full_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		$returnCode = DllStructCreate_Error(@error)

		;$dll_FullWindow = DllOpen($assertfullwindowdll)
		$result = DllCall($dll_FullWindow, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
		DllCall_Error("EvalChecksumFullWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checksum")
		DllStructGetData_Error(@error)

		;DllClose($dll_FullWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

;EDELAIRE++
 		MsgBox(0, "Checksums", "Checksum attendu : " &  $recorded_checksum & @CRLF & "Checksum obtenu : " & $hex_checksum & @CRLF)	; EDELAIRE - for debug only
;EDELAIRE--

		;Reporting local
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Full_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite('ERROR - checksums are not identical' & @CRLF)
			$filePath=$scriptName
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Full_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath);; EDELAIRE 10/11/2020
;			DllCall_Error("TakeWindowSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int", $x, "int", $y, "int", $w, "int", $l)
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Assert_Full_Window.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_ASSERTFULLWINDOW_NOT_EQUAL_CHECKSUM
;			DllClose($dll_snapshot)
		EndIf

		WinActivate($windowTitle, "")
	Endif
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_Function_Full_Window
 Goal : Eval a full window checksum and compare it with the recorded checksum
 Input :	$windowTitle : the targeted window title
		$recorded_checksum : this recorded checksum is used to compare it with the played checksum
		$lineNumber : the Assertion line Number
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
 Output : boolean : True => recorded and played checksums are identical 		False => not identical
 Exemple : T_Function_Full_Window("Calculatrice","2558D143810211245C1F51BBF5E52699") ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$socket_id=-1)
	Local $returnCode = 0
	Local $returnCodeBool = False
	ConsoleWrite("T_Function_Full_Window" & @CRLF )
	If $socket_id <>-1 Then
		T_NetSend($T_FUNCTIONFULLWINDOW,'T_Function_Full_Window("'&$windowTitle&'","'&$recorded_checksum&'",'&$lineNumber&')',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_FUNCTIONFULLWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Full_Window"&@TAB&"-- TRUE --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Full_Window"&@TAB&"-- FALSE --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertfullwindowdll = "assert_full_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		$returnCode = DllStructCreate_Error(@error)


		;$dll_FullWindow = DllOpen($assertfullwindowdll)
		$result = DllCall($dll_FullWindow, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
		DllCall_Error("EvalChecksumFullWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		;DllClose($dll_FullWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Full_Window"&@TAB&"-- TRUE --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			ConsoleWrite('ERROR - checksums are not identical')
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Full_Window"&@TAB&"-- FALSE --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
		EndIf
		WinActivate($windowTitle, "")
	Endif
return $returnCodeBool
EndFunc


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Assert_Partial_Window
 Objectif : Calcule la signature d'une partie de la fenêtre et la compare avec la valeur enregistrée.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
			 - coordonnees relative du rectangle auquel on calcule le Checksum (x1,y1,x2,y2)
 Sortie(s) : aucune
 Exemple : T_Assert_Partial_Window("Calculatrice","2558D143810211245C1F51BBF5E52699",155,145,270,230) ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTPARTIALWINDOW,'T_Assert_Partial_Window("'&$windowTitle&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&',"'&$recorded_checksum&'",'&$lineNumber& ',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTPARTIALWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Partial_Window"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_PartialWindow = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		;DllClose($dll_PartialWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

		ConsoleWrite('Assert_Partial_Window' & @CRLF)
		ConsoleWrite("Recorded checksum = " & $recorded_checksum & @CRLF)
		ConsoleWrite("Played checksum = " & $hex_checksum & @CRLF)


		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - checksum are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Partial_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakePartialSnapshot", "str", $windowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
;			DllCall_Error("TakePartialSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$posX1,"int",$y+$posY1,"int",($posX2 - $posX1) ,"int",($posY2 - $posY1))
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Assert_Partial_Window.bmp'
			$savedsnapShotCnt='01'
 			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_ASSERTPARTIALWINDOW_NOT_EQUAL_CHECKSUM
;			DllClose($dll_snapshot)
		EndIf
		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Function_Partial_Window
 Objectif : Calcule la signature d'une partie de la fenêtre et la compare avec la valeur enregistrée.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
			 - coordonnees relative du rectangle auquel on calcule le Checksum (x1,y1,x2,y2)
 Sortie(s) : True : Les deux checksums sont identiques
 Exemple : T_Function_Partial_Window("Calculatrice","2558D143810211245C1F51BBF5E52699",155,145,270,230) ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$socket_id=-1)
	Local $returnCode=0
	Local $returnCodeBool = false;
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTPARTIALWINDOW,'T_Function_Partial_Window("'&$windowTitle&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&',"'&$recorded_checksum&'",'&$lineNumber&')',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTPARTIALWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Partial_Window"&@TAB&"-- IDENTICAL --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Partial_Window"&@TAB&"-- DIFFERENT --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_PartialWindow = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		;DllClose($dll_PartialWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

		ConsoleWrite('Assert_Partial_Window' & @CRLF)
		ConsoleWrite("Recorded checksum = " & $recorded_checksum & @CRLF)
		ConsoleWrite("Played checksum = " & $hex_checksum & @CRLF)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("YES - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Partial_Window"&@TAB&"-- IDENTICAL --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			ConsoleWrite("NO - checksum are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Partial_Window"&@TAB&"-- DIFFERENT --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakePartialSnapshot", "str", $windowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
;			DllCall_Error("TakePartialSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$posX1,"int",$y+$posY1,"int",($posX2 - $posX1) ,"int",($posY2 - $posY1))
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Function_Partial_Window.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_ASSERTPARTIALWINDOW_NOT_EQUAL_CHECKSUM
;			DllClose($dll_snapshot)
		EndIf
		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
return $returnCodeBool
EndFunc



#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Assert_Menu
 Objectif : Calcule la signature d'une partie de la fenêtre correspondant à un menu et la compare avec la valeur enregistrée.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
			 - coordonnees relative du rectangle (menu)auquel on calcule le Checksum (x1,y1,x2,y2)
 Sortie(s) : aucune
 Exemple : T_Assert_Menu("Calculatrice","2558D143810211245C1F51BBF5E52699",155,145,270,230) ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTMENU,'T_Assert_Menu("'&$recorded_checksum&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&','&$lineNumber& ',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTMENU)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Menu"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Menu"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_PartialWindow = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $globalWindowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		;DllClose($dll_PartialWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert_Menu"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF)
			$filePath=$scriptName&" "&Get_Time()&" ligne "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert_Menu"&@TAB&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakePartialSnapshot", "str", $globalWindowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
;			DllCall_Error("TakePartialSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$posX1,"int",$y+$posY1,"int",($posX2 - $posX1) ,"int",($posY2 - $posY1))
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Assert_Menu.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_ASSERTMENU_NOT_EQUAL_CHECKSUM
;			DllClose($dll_snapshot)
		EndIf

	EndIf
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Function_Menu
 Objectif : Calcule la signature d'une partie de la fenêtre correspondant à un menu et la compare avec la valeur enregistrée.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
			 - coordonnees relative du rectangle (menu)auquel on calcule le Checksum (x1,y1,x2,y2)
 Sortie(s) : True or False
 Exemple : $variable = T_Function_Menu("Calculatrice","2558D143810211245C1F51BBF5E52699",155,145,270,230) ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	Local $returnCodeBool = False

	If $socket_id<>-1 Then
		T_NetSend($T_FUNCTIONMENU,'T_Function_Menu("'&$recorded_checksum&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&','&$lineNumber& ',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_FUNCTIONMENU)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Menu"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Menu"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_PartialWindow = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $globalWindowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		;DllClose($dll_PartialWindow)

		;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = Hex($bin_array)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function_Menu"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF)
			$filePath=$scriptName&" "&Get_Time()&" ligne "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function_Menu"&@TAB&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakePartialSnapshot", "str", $globalWindowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
;			DllCall_Error("TakePartialSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$posX1,"int",$y+$posY1,"int",($posX2 - $posX1) ,"int",($posY2 - $posY1))
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Function_Menu.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_FUNCTIONMENU_NOT_EQUAL_CHECKSUM
;			DllClose($dll_snapshot)
		EndIf

	EndIf
		return $returnCodeBool
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Assert_Color
 Objectif : Calcule la valeur d'un pixel et la compare avec la valeur enregistrée.
 Entrée(s) : - position relative du pixel enregistré
			 - valeur du pixel
 Sortie(s) : aucune
 Exemple : T_Assert_Color(129,198,255);
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTCOLOR,'T_Assert_Color("'&$windowTitle&'",'&$posX&','&$posY&','&$recorded_rgb&','& $lineNumber &',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTCOLOR)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Color"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertcolordll = "assert_color_window.dll"

		;$dll_ColorWindow = DllOpen($assertcolordll)

		$result = DllCall($dll_ColorWindow, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
		DllCall_Error("GetPixelColor",@error)
		$played_rgb = $result[0]

		;DllClose($dll_ColorWindow)

		;Reporting
		If $recorded_rgb == $played_rgb Then
			ConsoleWrite('OK - identical colors!')
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)

		Else
			Local $colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			ConsoleWrite('ERROR - colors are not identical: '&$colors)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCOLOR_BAD_COLOR
		EndIf

		WinActivate($windowTitle, "")
	EndIf
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Function_Color
 Objectif : Calcule la valeur d'un pixel et la compare avec la valeur enregistrée.
 Entrée(s) : - position relative du pixel enregistré
			 - valeur du pixel
 Sortie(s) : Bool : True => la couleur est identique
 Exemple : $isGoodColor = T_Function_Color(129,198,255);
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$socket_id=-1)
	Local $returnCode=0
	Local $returnCodeBool = False

	If $socket_id<>-1 Then
		T_NetSend($T_FUNCTIONCOLOR,'T_Function_Color("'&$windowTitle&'",'&$posX&','&$posY&','&$recorded_rgb&')',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_FUNCTIONCOLOR)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Color"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertcolordll = "assert_color_window.dll"


		;$dll_ColorWindow = DllOpen($assertcolordll)

		$result = DllCall($dll_ColorWindow, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
		DllCall_Error("GetPixelColor",@error)
		$played_rgb = $result[0]

		;DllClose($dll_ColorWindow)

		;Reporting
		If $recorded_rgb == $played_rgb Then
			ConsoleWrite('OK - identical colors!')
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True

		Else
			Local $colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			ConsoleWrite('ERROR - colors are not identical: '&$colors)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCOLOR_BAD_COLOR
		EndIf

		WinActivate($windowTitle, "")
	EndIf
	return $returnCodeBool
EndFunc

;MODE WAIT
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Wait_Full_Window
 Objectif : il faut parfois attendre que le contenu d'une fenetre soit généré. Cette fonction permet d'attendre jusqu'a ce que le fenêtre présente le Checksum voulut.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
 Sortie(s) : aucune
 Exemple : T_Wait_Full_Window("Calculatrice","2558D143810211245C1F51BBF5E52699") ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_WAITFULLWINDOW,'T_Wait_Full_Window("'&$windowTitle&'","'&$recorded_checksum&'",'&$lineNumber&','&$timeout&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WAITFULLWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Full_window"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Full_window"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertfullwindowdll = "assert_full_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_FullWindow = DllOpen($assertfullwindowdll)
		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)
			ConsoleWrite("PASS"&@CRLF)
			$result = DllCall($dll_FullWindow, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
			DllCall_Error("EvalChecksumFullWindow",@error)

			$bin_array = DllStructGetData ( $struct,"checkSum")
			DllStructGetData_Error(@error)

			;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
			$hex_checksum = Hex($bin_array)

			If($recorded_checksum==$hex_checksum) Then
				$check=True
			Else
				Sleep(3000)
			EndIf

		WEnd
		;DllClose($dll_FullWindow)

		;Reporting
		ConsoleWrite('Assert_Full_Window_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Full_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Full_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath)
;			DllCall_Error("TakeWindowSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x,"int",$y,"int",$w,"int",$l)
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Wait_Full_Window.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_WAITFULLWINDOW_TIME_ELAPSED
;			DllClose($dll_snapshot)
		EndIf

	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Wait_Partial_Window
 Objectif : il faut parfois attendre que le contenu d'une fenetre soit généré. Cette fonction permet d'attendre jusqu'a ce qu'une partie de la fenêtre présente le Checksum voulut.
 Entrée(s) : - $titre, le titre de la fenêtre
			 - une chaine de 16 caractères représentant la signature de l'image de la fenêtre (format BMP)
			 - coordonnees relative du rectangle auquel on calcule le Checksum (x1,y1,x2,y2)
 Sortie(s) : aucune
 Exemple : T_Wait_Partial_Window("Calculatrice","2558D143810211245C1F51BBF5E52699",155,145,270,230) ; 1_Calculatrice.bmp
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_WAITPARTIALWINDOW,'T_Wait_Partial_Window("'&$windowTitle&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&','&'"'&$recorded_checksum&'",'&$lineNumber&','&$timeout&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WAITPARTIALWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Partial_window"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Partial_window"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		;$dll_PartialWindow = DllOpen($assertpartialwindowdll)

		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)

			$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
			DllCall_Error("EvalChecksumPartialWindow",@error)

			$bin_array = DllStructGetData ( $struct,"checkSum")
			DllStructGetData_Error(@error)

			;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
			$hex_checksum = Hex($bin_array)

			If($recorded_checksum==$hex_checksum) Then
				$check=True
			Else
				Sleep(3000)
			EndIf

		WEnd
		;DllClose($dll_PartialWindow)

		;Reporting
		ConsoleWrite('Assert_Partial_Window_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Partial_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)

;			$snapshot = "snapshot.dll"
;			$dll_snapshot = DllOpen($snapshot)

;			$result=DllCall($dll_snapshot, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath)
;			DllCall_Error("TakeWindowSnapshot",@error)
 			$result=DllCall($dll_snapshot, "short:cdecl", "TakeAreaSnapshot", "int",$x+$posX1,"int",$y+$posY1,"int",($posX2 - $posX1) ,"int",($posY2 - $posY1))
			DllCall_Error("TakeAreaSnapshot",@error)

			$pathToTMP='.\Temp\snapshot_T_Wait_Partial_Window.bmp'
			$savedsnapShotCnt='01'
			$result=DllCall($dll_snapshot, "short:cdecl", "SauvegardeToFile", "str",$pathToTMP,"str",$savedsnapShotCnt)
			DllCall_Error("SauvegardeToFile",@error)

			$returnCode = $T_WAITPARTIALWINDOW_TIME_ELAPSED
;			DllClose($dll_snapshot)
		EndIf


		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Wait_Color
 Objectif : Attendre jusqu'à ce que le pixel ai la couleur voulue.
 Entrée(s) : - position relative du pixel enregistré
			 - couleur du pixel
 Sortie(s) : aucune
 Exemple : T_Wait_Color(129,198,255);
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_WAITCOLOR,'T_Wait_Color("'&$windowTitle&'",'&$posX&','&$posY&','&$recorded_rgb&','&$lineNumber&','&$timeout&',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_WAITCOLOR)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Wait_Color"&@TAB&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertcolordll = "assert_color_window.dll"
		;$dll_ColorWindow = DllOpen($assertcolordll)

		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)

			$result = DllCall($dll_ColorWindow, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
			DllCall_Error("GetPixelColor",@error)

			$played_rgb = $result[0]

			If($played_rgb==$recorded_rgb) Then
				$check=True
			Else
				Sleep(3000)
			EndIf

		WEnd
		;DllClose($dll_ColorWindow)

		;Reporting
		ConsoleWrite('Assert_Color_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical colors!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - colors are not identical." & @CRLF )
			$colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_WAITCOLOR_TIME_ELAPSED
		EndIf

		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc



#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Assert_Clipboard
 Objectif : Comparer le contenu du clipboard avec l'expression réglière donnée en paramètre.
 Entrée(s) : - L'expression régulière donnée par l'utilisateur pour la comparaison
 Sortie(s) : aucune
 Exemple : T_Assert_Clipboard
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func T_Assert_Clipboard($regExp,$lineNumber,$master=True,$socket_id=-1)
	Local $returnCode=0
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTCLIPBOARD,'T_Assert_Clipboard("'&$regExp&'",' & $lineNumber & ',False)',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTCLIPBOARD)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Clipboard"&@TAB&"-- OK --")
			FileFlush($rapport)
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Assert_Clipboard"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		sleep(1000) ; Insure the clipboard is done CUSTOMISATION NMC
		Local $clipBoardStr=ClipGet()
		ConsoleWrite('Assert_Clipboard' & @CRLF)
		ConsoleWrite($clipBoardStr & @CRLF)
		ConsoleWrite($regExp & @CRLF)
		$array = StringRegExp($clipBoardStr,$regExp,3)
		If(UBound($array) == 1) Then
			ConsoleWrite("OK - Clipboard's content matches the regexp!"&@CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- OK --")
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- OK --" &@CRLF)
 			FileFlush($rapport)
		ElseIf (UBound($array) > 1) Then
			ConsoleWrite("WARNING- Clipboard's content matches the regexp several times !"&@CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- WARNING -- matches several times !!!")
			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_MATCH_SEVERAL_TIMES
		Else
			ConsoleWrite("ERROR - Clipboard's content does not match the regexp."&@CRLF )
			Local $content = "RegExp: " &@CRLF&$regExp&@CRLF& "ClpBrdStr: " &@CRLF&$clipBoardStr& @CRLF
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- ERROR --"&@TAB&'"'&$content&'"')
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- ERROR --" &@CRLF)
 			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_NOT_MATCH
		EndIf
	EndIf
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Function_Bool_Clipboard
 Objectif : Comparer le contenu du clipboard avec l'expression réglière donnée en paramètre.
 Entrée(s) : - L'expression régulière donnée par l'utilisateur pour la comparaison
 Sortie(s) : aucune
 Exemple : T_Function_Bool_Clipboard
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Bool_Clipboard($regExp,$lineNumber,$socket_id=-1)
	Local $returnCode=0
	Local $returnCodeBool=False
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTCLIPBOARD,'T_Function_Clipboard("'&$regExp&'")',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTCLIPBOARD)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Clipboard"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool=True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Clipboard"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		sleep(1000) ; Insure the clipboard is done
		Local $clipBoardStr=ClipGet()

		ConsoleWrite('Assert_Clipboard' & @CRLF)
		ConsoleWrite($clipBoardStr & @CRLF)
		ConsoleWrite($regExp & @CRLF)
		$array = StringRegExp($clipBoardStr,$regExp,3)
		If(UBound($array) == 1) Then
			ConsoleWrite("OK - Clipboard's content matches the regexp!"&@CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool=True
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- OK --" &@CRLF)
 			FileFlush($rapport)
		ElseIf (UBound($array) > 1) Then
			ConsoleWrite("WARNING- Clipboard's content matches the regexp several times !"&@CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- WARNING -- matches several times !!!")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - Clipboard's content does not match the regexp."&@CRLF )
			Local $content = "RegExp: " &$regExp &@TAB& "ClpBrdStr: " & $clipBoardStr & @CRLF
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- ERROR --"&@TAB&'"'&$content&'"')
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- ERROR --" &@CRLF)
 			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_NOT_MATCH
		EndIf
	EndIf
	return $returnCodeBool
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Function_Str_Clipboard
 Objectif : Comparer le contenu du clipboard avec l'expression réglière donnée en paramètre.
 Entrée(s) : - L'expression régulière donnée par l'utilisateur pour la comparaison
 Sortie(s) : aucune
 Exemple : T_Function_Str_Clipboard
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Function_Str_Clipboard($regExp,$lineNumber,$socket_id=-1)
	; A FINIR
	return $regExp
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_IsArretUrgenceDemande
 Objectif : Retourne l'état du flag de demande d'arret d'urgence.
 Entrée(s) : aucune
 Sortie(s) : aucune
 Exemple : T_IsArretUrgenceDemande
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_IsArretUrgenceDemande()
	$ARRET = R_IsArretUrgenceDemande()
	return $ARRET
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title : T_Send
 Goal : Sends simulated keystrokes to the active window.
 Input : $keys: Keyboard string
	 $socket_id : index to retrieve the socket id in the $comm_socket[] tab
 Output : $return code
 Exemple : T_Send("1{+}2{ENTER}")
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Send($keys,$socket_id=-1)
	Local $returnCode=0

	;EDELAIRE - Modification pour l'application Rocade : tout texte "$keys" à envoyer à l'application est chiffré...
	;... il faut donc le déchiffré avant de l'envoyer à l'application
	$unCryptedkeys = R_DecrypterTexte($keys)
	if @error = 0 Then
		T_WinWaitStatus("[Active]","Traitement en cours")
		If $socket_id <> -1 Then
			;T_NetSend($T_SEND,'T_Send("'&$keys&'")', $socket_id)
			T_NetSend($T_SEND,'T_Send("'&$unCryptedkeys&'")', $socket_id)	;EDELAIRE - Modification pour l'application Rocade
			$returnCode = T_NetReceive($socket_id,$T_SEND)
		Else
			;Send($keys)
			Send($unCryptedkeys)											;EDELAIRE - Modification pour l'application Rocade
		EndIf
	EndIf
	return $returnCode
EndFunc



#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : DllCall_Error
 Objectif : Traite les éventuelles erreur suite à DllCall
 Entrée(s) : - nom de la fonction appelée (pour le message d'erreur)
 Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func DllCall_Error ($func,$error)
	If ($error == 1) Then
			FileWriteLine($rapport, "Unable to use the DLL file"&@CRLF)
			FileFlush($rapport)
	ElseIf($error == 2) Then
			FileWriteLine($rapport, "Unknown return type"&@CRLF)
			FileFlush($rapport)
	ElseIf($error == 3) Then
			FileWriteLine($rapport, "Function not found in the DLL file"&@CRLF)
			FileFlush($rapport)
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : DllStructCreate_Error
 Objectif : Traite les éventuelles erreur suite à DllStructCreate
 Entrée(s) : aucune
 Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func DllStructCreate_Error($error)
	Local $return_code=0;
	If ($error == 0) Then
		$return_code=0
	ElseIf ($error == 1) Then ;Variable passed to DllStructCreate was not a string
		$return_code=1
	ElseIf ($error == 2) Then ;There is an unknown Data Type in the string passed.
		$return_code=2
	ElseIf ($error == 3) Then ;Failed to allocate the memory needed for the struct, or Pointer = 0.
		$return_code=3
	ElseIf ($error == 4) Then ;There is an unknown Data Type in the string passed.
		$return_code=4
	Endif
	return $return_code
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : DllStructGetData_Error
 Objectif : Traite les éventuelles erreur suite à DllStructGetData
 Entrée(s) : aucune
 Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func DllStructGetData_Error($error)
	If ($error == 1) Then
		MsgBox (0,"ERROR","Struct not a correct struct returned by DllStructCreate.")
	ElseIf($error == 2) Then
		MsgBox (0,"ERROR","Element value out of range.")
	ElseIf($error == 3) Then
		MsgBox (0,"ERROR","Index would be outside of the struct.")
	ElseIf($error == 4) Then
		MsgBox (0,"ERROR","Element data type is unknown.")
	ElseIf($error == 5) Then
		MsgBox (0,"ERROR","index <= 0.")
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : Get_Time
 Objectif : Renvoie une chaîne de caractères avec l'heure actuelle
 Entrée(s) : aucune
 Sortie(s) : chaîne de caractères avec l'heure exacte (en secondes)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Get_Time()
	Return (@HOUR&'h'&@MIN&'m'&@SEC&'s')
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : Get_RGB
 Objectif : Renvoie une chaîne de caractères avec la décomposition en RGB d'une couleur passée en paramètre
 Entrée(s) : la couleur à décomposer
 Sortie(s) : chaîne de caractères avec la couleur décomposée
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Get_RGB($color)
	Local $blue = BitShift(BitAND(16711680, $color),16);
	Local $green = BitShift(BitAND(65280, $color), 8);
	Local $red = BitAND(255, $color);
	Return ('R:'&$red&' G:'&$green&' B:'&$blue)
EndFunc

Func EncodeTag($opcode)
	$allSendBuffer = ""
	$allSendSize = 0
	$sOpcode = HexToStrWord(Hex($opcode))
	$allSendBuffer = StringMid($sOpcode, 3, 2) & StringMid($sOpcode, 1, 2)
	$allSendBuffer = $allSendBuffer & "0000" ; Security bytes
	$allSendSize = 4
	;MsgBox(0, "", $allSendBuffer)
EndFunc

Func EncodeSize()
	$sSize = HexToStrWord(Hex($globalSendSize))
	$allSendBuffer = $allSendBuffer & StringMid($sSize, 3, 2) & StringMid($sSize, 1, 2)
	$allSendSize +=2
	;MsgBox(0, "", $allSendBuffer)
EndFunc

Func EncodeData()
	$allSendBuffer = $allSendBuffer & $globalSendBuffer
	;MsgBox(0, "", $allSendBuffer)
EndFunc

Func HexToStrWord($var)
	$len = StringLen($var)
	if $len > 4 then
		return StringRight($var, 4)
	elseif $len == 4 then
		return $var
	elseif $len == 3 then
		return "0" & $var
	elseif $len == 2 then
		return "00" & $var
	elseif $len == 1 then
		return "000" & $var
	endif
EndFunc

;----------------------------------------------------------------------------------------------------

Func HexToStrDword($var)
	$len = StringLen($var)
	if $len > 8 then
		return StringRight($var, 8)
	elseif $len == 8 then
		return $var
	elseif $len == 7 then
		return "0" & $var
	elseif $len == 6 then
		return "00" & $var
	elseif $len == 5 then
		return "000" & $var
	elseif $len == 4 then
		return "0000" & $var
	elseif $len == 3 then
		return "00000" & $var
	elseif $len == 2 then
		return "000000" & $var
	elseif $len == 1 then
		return "0000000" & $var
	endif
EndFunc

;----------------------------------------------------------------------------------------------------

Func HexToStrByte($var)
	$len = StringLen($var)
	if $len > 2 then
		return StringRight($var, 2)
	elseif $len == 2 then
		return $var
	else ; Error condition
		return "00"
	endif
EndFunc

Func AppendByte($value)
	$sValue = HexToStrByte(Hex($value))
	$globalSendBuffer = $globalSendBuffer & $sValue
	$globalSendSize = $globalSendSize + 1
EndFunc

Func AppendWord($value)
	$sValue = HexToStrWord(Hex($value))
	$globalSendBuffer = $globalSendBuffer & StringMid($sValue, 3, 2) & StringMid($sValue, 1, 2)
	$globalSendSize = $globalSendSize + 2
EndFunc

Func AppendDword($value)
	$sValue = HexToStrDword(Hex($value))
	$globalSendBuffer = $globalSendBuffer & StringMid($sValue, 7, 2) & StringMid($sValue, 5, 2) & StringMid($sValue, 3, 2) & StringMid($sValue, 1, 2)
	$globalSendSize = $globalSendSize + 4
EndFunc

Func AppendString($value)
	For $i = 1 to StringLen($value) Step 1
		$xh = StringMid($value, $i, 1)
		$sValue = HexToStrByte(Hex(Asc($xh)))
		$globalSendBuffer = $globalSendBuffer & $sValue
		$globalSendSize = $globalSendSize + 1
	Next
EndFunc

Func Stop_Test()
	T_End("TEST : NOK")
	ConsoleWrite ("Arret du NMC ...")
	Exit
EndFunc


;~ Func T_Start_NMC($socket_id=-1)
;~ 	Local $returnCode=0
;~ 		If $socket_id <> -1 Then
;~ 			T_NetSend($T_STARTNMC,'T_Start_NMC()',$socket_id)
;~ 			$returnCode = T_NetReceive($socket_id,$T_STARTNMC)
;~ 		Else
;~ 			ShellExecute("D:\nmc\application\commun\exe\launch_with_hide_window.exe", "d:\nmc\Application\Commun\Cmd\nmc_environ.cmd call d:\nmc\Application\Commun\Cmd\environ.cmd call d:\nmc\Application\lcecore2\cmd\startcecore_cmx.cmd", @ScriptDir, "open",@SW_MINIMIZE )
;~ 		EndIf
;~ 		; return 1 si tout va bien ...
;~ 	return $returnCode
;~ EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_TogglePause
 Objectif : Pause du script en cours
 Entrée(s) :
 Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_TogglePause()
    $Paused = Not $Paused
    While $Paused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_Terminate
 Objectif : Arret du script en cours
 Entrée(s) :
 Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_Terminate()
    Exit 0
EndFunc   ;==>Terminate

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : T_ShowMessage()
 Objectif : Permet d'afficher des informations sur le script en cours. Pas encore utilisé.
 Entrée(s) :
 Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_ShowMessage()
    MsgBox(4096, "",$globalWindowTitle)
EndFunc   ;==>ShowMessage

Func GenereChecksum($windowTitle,$before,$after,$posX1,$posY1,$posX2,$posY2,$fichier_sortie)
	$file = FileOpen($fichier_sortie, 1) ;1 = Write mode (append to end of file)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	T_WinWaitActive($windowTitle,-1,-1,@ScriptLineNumber)
	$assertpartialwindowdll = "assert_partial_window.dll"
	$str = "ubyte checksum[16]"
	$struct = DllStructCreate($str)
	DllStructCreate_Error(@error)
	;$dll_PartialWindow = DllOpen($assertpartialwindowdll)
	$result = DllCall($dll_PartialWindow, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
	DllCall_Error("EvalChecksumPartialWindow",@error)

	$bin_array = DllStructGetData ( $struct,"checkSum")
	DllStructGetData_Error(@error)

	;DllClose($dll_PartialWindow)

	;$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
	$hex_checksum = Hex($bin_array)

	ConsoleWrite("Played checksum = " & $hex_checksum & @CRLF)
	FileWrite($file, $before & $posX1 & "," & $posY1 & "," & $posX2 & "," & $posY2 & "," &  $hex_checksum & $after & @CRLF)
	FileFlush($file)
	FileClose($file)

EndFunc