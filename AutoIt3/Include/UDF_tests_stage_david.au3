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
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3> 
#include <FontConstants.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>

Global $fenetre, $x, $y, $w, $l
Global $begin
Global $time = ""
Global $fichierlog = StringRegExpReplace(@ScriptFullPath,"(?i)(\w+\.)au3$","$1log")
Global $globalWindowTitle ; Active window
Global $scriptName=""
Global $rapport
Global $network = False
Global $beginTime = 0

; Enable/Disable animations (David F.)
Global $tempo = True   
Global $tempo_Anim = 1000    

Global $T_WINWAITACTIVE=0
Global $T_MOUSECLICK=1
Global $T_SEND=11
Global $T_ASSERTFULLWINDOW=3
Global $T_ASSERTPARTIALWINDOW=4
Global $T_ASSERTMENU=5
Global $T_ASSERTCOLOR=6
Global $T_WAITFULLWINDOW=7
Global $T_WAITPARTIALWINDOW=8
Global $T_WAITCOLOR=9
Global $T_ASSERTCLIPBOARD=10
Global $T_WINGETPOS=11
Global $T_REFRESHPOS=12
Global $T_FUNCTIONFULLWINDOW=13
Global $T_FUNCTIONPARTIALWINDOW=14
Global $T_FUNCTIONCOLOR=15
Global $T_FUNCTIONMENU=16
Global $T_FUNCTIONCLIPBOARD=17
Global $T_WINWAITCLOSE = 18
Global $T_STARTNMC=19
Global $globalSendBuffer = ""
Global $globalSendSize = 0
Global $allSendBuffer = ""
Global $allSendSize = 0

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

Func T_End($status = "TEST : OK")
	Local $diffTime
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
		Exit 0
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
	ConsoleWrite('$opcode = ['&$opcode&']'&@CRLF)
	ConsoleWrite('$returnCode = ['&$returnCode&']'&@CRLF)

	$opcodeDec = Int($opcode)
	$returnCodeDec = Int($returnCode)
	ConsoleWrite('$opcodeDec = ['&$opcodeDec&']'&@CRLF)
	ConsoleWrite('$returnCodeDec = ['&$returnCodeDec&']'&@CRLF)
	ConsoleWrite('$opcodeExpected = ['&$opcodeExpected&']'&@CRLF)

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

Func T_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=120000,$master=True,$socket_id=-1)
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
							;Reporting
							FileWriteLine($rapport, "Line "&$lineNb&@TAB&Get_Time()&@TAB&@TAB&"T_WinWaitActive RESIZE Not possible : "&@TAB&$windowTitle)
							FileFlush($rapport)
							T_Assert_Traitement()
						Else
							$returnCode = $T_WINWAITACTIVE_RESIZE_NOT_POSSIBLE
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
		While (($state<>0) AND $timeoutflag)
			sleep (100)
			$timeoutflag = TimerDiff($begin)<$timeout
			$state = WinGetState($windowTitle, "")
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
	Local $instruction="";
	Local $returnCode=0
	Local $isGrapheGeoreference = false;
	Local $isGrapheLogique = false;

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
			MouseMove($x,$y,$speed)
		EndIf
		MouseMove($x,$y,$speed)
		MouseDown($mouseButton)            ; MouseButton = "left" or "right"
		If (($xx<>-1) AND ($yy<>-1)) Then  ; Si il y a déplacement du curseur sur l'écran
			MouseMove($xx,$yy)             ; On fait déplacer la souris tout en restant appuyé
		EndIf
		MouseUp($mouseButton)              ; pas de déplacement = on relâche la souris
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
			MsgBox (0,"ERROR","La fenêtre n'est pas présente !!!!")
			ConsoleWrite(@ScriptLineNumber&"| "&Get_Time()&" La fenêtre "&$titre&" n"&"'"&"est pas ouverte "&@CRLF)
			ConsoleWrite("Temps test : "&$time)
			BlockInput(0)
			Exit
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
		$returnCode = T_NetReceive($socket_id,$T_WINGETPOS)
	Else

		$titre=$globalWindowTitle
		WinActivate ($titre)
		$fenetre = WinGetPos($titre)

		If @error Then
			MsgBox (0,"ERROR","La fenêtre n'est pas présente !!!!")
			ConsoleWrite(@ScriptLineNumber&"| "&@hour&":"&@MIN&":"&@SEC&" La fenêtre "&$titre&" n"&"'"&"est pas ouverte "&@CRLF)
			ConsoleWrite("Temps test : "&$time)
			BlockInput(0)
			Exit
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
	Local $assert_funct = "Assertion", $colorgraph, $tempo_Anim = 500
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


		$dll = DllOpen($assertfullwindowdll)
		$result = DllCall($dll, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
		DllCall_Error("EvalChecksumFullWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = _StringToHex($String_checksum)

		;Reporting local
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Full_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			$colorgraph = 0xFF33FF33
		Else
			ConsoleWrite('ERROR - checksums are not identical' & @CRLF)
			$filePath=$scriptName
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Full_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)
			$result=DllCall($dll, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath)
			DllCall_Error("TakeWindowSnapshot",@error)
			$returnCode = $T_ASSERTFULLWINDOW_NOT_EQUAL_CHECKSUM
			$colorgraph = 0xFFFF0000
		EndIf
			
			if $tempo Then
				Animation_FullWindow($windowTitle, $assert_funct, $colorgraph)
			Else
				Endif

		DllClose($dll)
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
	Local $assert_funct = "Function", $colorgraph, $tempo_Anim = 500
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


		$dll = DllOpen($assertfullwindowdll)
		$result = DllCall($dll, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
		DllCall_Error("EvalChecksumFullWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = _StringToHex($String_checksum)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Full_Window"&@TAB&"-- TRUE --")
			FileFlush($rapport)
			$returnCodeBool = True
			$colorgraph = 0xFF33FF33
		Else
			ConsoleWrite('ERROR - checksums are not identical')
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Full_Window"&@TAB&"-- FALSE --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$colorgraph = 0xFFFF0000
		EndIf
		
		if $tempo Then
			Animation_FullWindow($windowTitle, $assert_funct, $colorgraph)
		Else
			EndIf
	
		DllClose($dll)
		WinActivate($windowTitle, "")
	Endif
	return $returnCodeBool
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : Animation_FullWindow
	Objectif : Affiche une animation sur la fenêtre cliente afin de visualiser la zone de l'assertion
	Entrée(s) : - titre de la fenêtre
				- couleur de l'animation (vert/rouge)
				- Durée de l'animation
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_FullWindow($windowTitle, $assert_funct, $colorgraph)
	Local $sizewindow = WinGetPos($windowTitle)
	Local $sizeclient = WinGetClientSize($windowTitle)
	Local $left = $sizewindow[0]+($sizewindow[2]-$sizeclient[0])/2     	; posxclient = posxwindow + (widthwindow - widthclient)/2
	Local $top = $sizewindow[1]+($sizewindow[3]-$sizeclient[1])			; posyclient = posywindow + (heightwindow - heightclient)
	Local $width = $sizeclient[0], $height = $sizeclient[1]

	Local $guiwindow = GUICreate($assert_funct&" Full Window", $width,$height,$left,$top,$WS_POPUP,$WS_EX_LAYERED)   ; On crée la fenêtre: $width,$length,$left,$top,$WS_POPUP
	;~ 	 $WS_POPUP = enlève la barre de titre	;~ 	 $WS_EX_LAYERED = style permettant la transparence
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	GUISetState()			; On affiche la GUI grise transparente

	; Draw Graphic
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hPen = _GDIPlus_PenCreate($colorgraph, 3)
	_GDIPlus_GraphicsDrawRect($hGraphic, 0,0,$width-2,$height-2,$hPen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $width/2, 0, $width/2, $height, $hPen)     ; vertical
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $height/2, $width, $height/2, $hPen)    ; horizontal
	_GDIPlus_GraphicsDrawEllipse($hGraphic, 0.2*$width, 0.2*$height, 0.6*$width, 0.6*$height, $hPen)

	SoundPlay("C:\Program Files\AutoIt3\Icons\Photo.wav", 0)      ; 0 = continue script while sound is playing (default)
	Sleep($tempo_Anim)

	GUIDelete($guiwindow)    ; On supprime la fenêtre
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
	Local $assert_funct = "Assertion", $colorgraph, $tempo_Anim = 500
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

		$dll = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)
		Local $leftp=$x+$posX1, $topp=$y+$posY1, $rightp=$x+$posX2, $bottomp=$y+$posY2
		
		$bin_array = DllStructGetData ( $struct,"checkSum")   ; On met le checksum, appelé via DllStrucGetPtr, dans la variable $bin_array
		DllStructGetData_Error(@error)
	
		$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = _StringToHex($String_checksum)

		ConsoleWrite('Assert_Partial_Window' & @CRLF)
		ConsoleWrite("Recorded checksum = " & $recorded_checksum & @CRLF)
		ConsoleWrite("Played checksum = " & $hex_checksum & @CRLF)
		
		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			$colorgraph = 0xFF33FF33	
		Else
			ConsoleWrite("ERROR - checksum are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Partial_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)

			$result=DllCall($dll, "short:cdecl", "TakePartialSnapshot", "str", $windowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
			DllCall_Error("TakePartialSnapshot",@error)
			$returnCode = $T_ASSERTPARTIALWINDOW_NOT_EQUAL_CHECKSUM
			$colorgraph = 0xFFFF0000	
		EndIf
		
		if $tempo Then
			Animation_PartialWindow ($assert_funct, $leftp, $topp, $rightp, $bottomp, $colorgraph)
		Else
			Endif
		
		DllClose($dll)
		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		;T_Assert_Traitement()
		T_End("TEST : NOK")
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
	Local $assert_funct = "Function", $colorgraph, $tempo_Anim = 500
	If $socket_id<>-1 Then
		T_NetSend($T_ASSERTPARTIALWINDOW,'T_Function_Partial_Window("'&$windowTitle&'",'&$posX1&','&$posY1&','&$posX2&','&$posY2&',"'&$recorded_checksum&'",'&$lineNumber&')',$socket_id)
		$returnCode = T_NetReceive($socket_id,$T_ASSERTPARTIALWINDOW)
		;reporting
		If ($returnCode == 0) Then
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
		Else
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&$socket_id&@TAB&"Function_Partial_Window"&@TAB&"-- ERROR --")
			FileFlush($rapport)
		Endif
	Else
		T_WinWaitActive($windowTitle,-1,-1,$lineNumber)
		$assertpartialwindowdll = "assert_partial_window.dll"
		$str = "ubyte checksum[16]"
		$struct = DllStructCreate($str)
		DllStructCreate_Error(@error)

		$dll = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)
		Local $leftp=$x+$posX1, $topp=$y+$posY1, $rightp=$x+$posX2, $bottomp=$y+$posY2
		
		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = _StringToHex($String_checksum)

		ConsoleWrite('Assert_Partial_Window' & @CRLF)
		ConsoleWrite("Recorded checksum = " & $recorded_checksum & @CRLF)
		ConsoleWrite("Played checksum = " & $hex_checksum & @CRLF)

		;Reporting
		If($recorded_checksum==$hex_checksum) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
			$colorgraph = 0xFF33FF33			
		Else
			ConsoleWrite("ERROR - checksum are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Partial_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)

			$result=DllCall($dll, "short:cdecl", "TakePartialSnapshot", "str", $windowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
			DllCall_Error("TakePartialSnapshot",@error)
			$returnCode = $T_ASSERTPARTIALWINDOW_NOT_EQUAL_CHECKSUM
			$colorgraph = 0xFFFF0000
		EndIf
		
		if $tempo Then
			Animation_PartialWindow ($assert_funct, $leftp, $topp, $rightp, $bottomp, $colorgraph)
		Else
			Endif
		
		DllClose($dll)
		WinActivate($windowTitle, "")
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	return $returnCodeBool
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : Animation_PartialWindow
	Objectif : Affiche une animation sur la fenêtre afin de visualiser la zone de l'assertion
	Entrée(s) : - Coordonnées de la zone du ckecksum à calculer (leftp,topp,rightp,bottomp)
				- indique l'assertion ou la fonction
				- couleur de l'animation (vert/rouge)
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_PartialWindow ($assert_funct, $leftp, $topp, $rightp, $bottomp, $colorgraph)
	Local $widthp = $rightp-$leftp, _
		  $heightp = $bottomp-$topp

	Local $guiwindow = GUICreate($assert_funct&" Partial Window", $widthp,$heightp,$leftp,$topp,$WS_POPUP,$WS_EX_LAYERED)   ; On crée la fenêtre: $width,$length,$left,$top,$WS_POPUP
	;~ 	 $WS_POPUP = enlève la barre de titre	;~ 	 $WS_EX_LAYERED = style permettant la transparence
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	GUISetState()			; On affiche la GUI grise transparente

	; Draw Graphic
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hPen = _GDIPlus_PenCreate($colorgraph, 2)
	_GDIPlus_GraphicsDrawRect($hGraphic, 1,1,$widthp-2,$heightp-2,$hPen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $widthp/2, 0, $widthp/2, $heightp, $hPen)     ; vertical
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $heightp/2, $widthp, $heightp/2, $hPen)    ; horizontal
	_GDIPlus_GraphicsDrawEllipse($hGraphic, 0.2*$widthp, 0.2*$heightp, 0.6*$widthp, 0.6*$heightp, $hPen)

	SoundPlay("C:\Program Files\AutoIt3\Icons\Photo.wav", 0)      ; 0 = continue script while sound is playing (default)
	Sleep($tempo_Anim)
	GUIDelete($guiwindow)    ; On supprime la fenêtre
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

		$dll = DllOpen($assertpartialwindowdll)
		$result = DllCall($dll, "short:cdecl", "EvalChecksumPartialWindow", "str", $globalWindowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
		DllCall_Error("EvalChecksumPartialWindow",@error)

		$bin_array = DllStructGetData ( $struct,"checkSum")
		DllStructGetData_Error(@error)

		$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
		$hex_checksum = _StringToHex($String_checksum)

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
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)

			$result=DllCall($dll, "short:cdecl", "TakePartialSnapshot", "str", $globalWindowTitle,"str",$filePath,"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
			DllCall_Error("TakePartialSnapshot",@error)
			$returnCode = $T_ASSERTMENU_NOT_EQUAL_CHECKSUM
		EndIf

		DllClose($dll)
	EndIf
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
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
	Local $assert_funct = "Assertion", $tempo_Anim = 500
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

		$dll = DllOpen($assertcolordll)

		$result = DllCall($dll, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
		DllCall_Error("GetPixelColor",@error)
		$played_rgb = $result[0]

		;Reporting
		If $recorded_rgb == $played_rgb Then
			ConsoleWrite('OK - identical colors!')
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$pipette = "pipettevert.png"
		Else
			Local $colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			ConsoleWrite('ERROR - colors are not identical: '&$colors)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Assert_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCOLOR_BAD_COLOR
			$pipette = "pipetterouge.png"
		EndIf

		If $tempo Then
			Animation_Color ($windowTitle, $assert_funct, $posX, $posY, $pipette)
		Else
			Endif

		DllClose($dll)
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
	Local $assert_funct = "Function", $pipette, $tempo_Anim = 500

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

		$dll = DllOpen($assertcolordll)

		$result = DllCall($dll, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
		DllCall_Error("GetPixelColor",@error)
		$played_rgb = $result[0]

		;Reporting
		If $recorded_rgb == $played_rgb Then
			ConsoleWrite('OK - identical colors!')
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool = True
			$pipette = "pipettevert.png"

		Else
			Local $colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			ConsoleWrite('ERROR - colors are not identical: '&$colors)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&@TAB&"Function_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCOLOR_BAD_COLOR
			$pipette = "pipetterouge.png"
		EndIf
		
		if $tempo Then
			Animation_Color ($windowTitle, $assert_funct, $posX, $posY, $pipette)
		Else
			Endif
		
		DllClose($dll)
		WinActivate($windowTitle, "")
	EndIf
	return $returnCodeBool
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : SetBitmap
	Objectif : rafraîchit l'image à afficher et règle son opacité
	Entrée(s) : - handle de la GUI
				- image chargée
				- Valeur de l'opacité voulue
	Sortie(s) : Aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func SetBitmap($hGUI, $hImage, $iOpacity)
      Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
      $hScrDC  = _WinAPI_GetDC(0)								
      $hMemDC  = _WinAPI_CreateCompatibleDC($hScrDC)       		  	   ; the function creates a memory DC compatible with the application's current screen.
      $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)   	   ; Create a handle to a bitmap from a bitmap object
      $hOld    = _WinAPI_SelectObject($hMemDC, $hBitmap)      	       ; Selects the picture into the memory DC
      $tSize   = DllStructCreate($tagSIZE)					           ; struct; X; Y; endstruct
      $pSize   = DllStructGetPtr($tSize  )					           ; X; Y;
      DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth ($hImage))  ; X=width
      DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))  ; Y=Height

      $tSource = DllStructCreate($tagPOINT) 						   ; struct; X; Y; endstruct;
      $pSource = DllStructGetPtr($tSource)						   	   ; X; Y;  (coordinates on DC)
      $tBlend  = DllStructCreate($tagBLENDFUNCTION)			           ; struct; op; Flags; Alpha; Format; endstruct
      $pBlend  = DllStructGetPtr($tBlend)					           ; $pBlend = source blend operation; Flags; Alpha; Format
      DllStructSetData($tBlend, "Alpha" , $iOpacity    )	           ; Alpha = $iOpacity
      DllStructSetData($tBlend, "Format", 1)				           ; Format = 1
      _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, _		   ; handle layered window, DC, Position of window not changing, size of layered window
	  $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)			           ; handle to DC for the surface, location of layer in DC, color, transparency, use $tBlend
      _WinAPI_ReleaseDC   (0, $hScrDC)
      _WinAPI_SelectObject($hMemDC, $hOld)	
      _WinAPI_DeleteObject($hBitmap)
      _WinAPI_DeleteDC    ($hMemDC)
    EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : Animation_Color
	Objectif : Affiche une animation (pipette) sur la fenêtre afin de visualiser la zone de l'assertion
	Entrée(s) : - Titre de la fenêtre
				- Coordonnées de la zone du ckecksum à calculer
				- indique l'assertion ou la fonction
				- couleur de l'animation (vert/rouge)
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_Color ($windowTitle, $assert_funct, $posX, $posY, $pipette)
	Global $hGUI2, $hImage
	Local $sizewindow = WinGetPos($windowTitle)
	Local $left = $sizewindow[0], $top = $sizewindow[1], $width = $sizewindow[2], $height = $sizewindow[3]

	; GUI principale
	$hGUI2 = GUICreate($assert_funct&" Color", 46, 46, $left+$posX+1, $top+$posY-46, $WS_POPUP, $WS_EX_LAYERED)

	GUICtrlSetState(-1, $GUI_ONTOP)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUISetState()

	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile("C:\Program Files\AutoIt3\Icons\"&$pipette)
	SetBitMap($hGUI2, $hImage, 255)

	SoundPlay("C:\Program Files\AutoIt3\Icons\Photo.wav")
	Sleep($tempo_Anim)				; pendant 1sec

	; Shut down GDI+ library
	SetBitmap($hGUI2,$hImage,0)
	GUIDelete($hGUI2)
	_GDIPlus_Shutdown()
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
	$assert_funct = "Wait"
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

		$dll = DllOpen($assertfullwindowdll)
		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)    ; init = True AND NOT False
			ConsoleWrite("PASS"&@CRLF)
			$result = DllCall($dll, "short:cdecl", "EvalChecksumFullWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"))
			DllCall_Error("EvalChecksumFullWindow",@error)

			$bin_array = DllStructGetData ( $struct,"checkSum")
			DllStructGetData_Error(@error)

			$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
			$hex_checksum = _StringToHex($String_checksum)
			
			If($recorded_checksum==$hex_checksum) Then
				$check=True     ; On sort du while
			Else
				
				if $tempo Then
					Animation_WaitFullWindow ($windowTitle)
				Else
					Endif
				
			EndIf

		WEnd

		;Reporting
		ConsoleWrite('Assert_Full_Window_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Full_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			
			; Animation Snapshot
			$colorgraph = 0xFF33FF33
			$colortext = 0x33FF33
			$text = "OK"
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Full_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)

			$result=DllCall($dll, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath)
			DllCall_Error("TakeWindowSnapshot",@error)
			$returnCode = $T_WAITFULLWINDOW_TIME_ELAPSED
			
			; Animation Snapshot
			$colorgraph = 0xFFFF0000
			$colortext = 0x0000FF
			$text = "ERROR"
		EndIf

		if $tempo Then
			Animation_FullWindow($windowTitle, $assert_funct, $colorgraph)
		Else
			EndIf

		DllClose($dll)
		;WinActivate($windowTitle, "") POURQUOI
	EndIf
	ConsoleWrite('$returnCode = [' &$returnCode&']'& @CRLF)
	If (($returnCode <> 0) And ($master)) Then
		T_Assert_Traitement()
	Else
		return $returnCode
	Endif
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : Animation_WaitFullWindow
	Objectif : Affiche un sablier sur la fenêtre cliente afin de visualiser la zone de l'assertion
	Entrée(s) : - titre de la fenêtre
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_WaitFullWindow ($windowTitle)
	Local $sizewindow = WinGetPos($windowTitle)
	Local $sizeclient = WinGetClientSize($windowTitle)
	Local $left = $sizewindow[0]+($sizewindow[2]-$sizeclient[0])/2     	; posxclient = posxwindow + (widthwindow - widthclient)/2
	Local $top = $sizewindow[1]+($sizewindow[3]-$sizeclient[1])			; posyclient = posywindow + (heightwindow - heightclient)
	Local $width = $sizeclient[0], $height = $sizeclient[1]

	Local $guiwindow = GUICreate("Wait Full Window", $width,$height,$left,$top,$WS_POPUP,$WS_EX_LAYERED)   ; On crée la fenêtre: $width,$length,$left,$top,$WS_POPUP
	;~ 	 $WS_POPUP = enlève la barre de titre	;~ 	 $WS_EX_LAYERED = style permettant la transparence
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	GUISetState()			; On affiche la GUI grise transparente

	; Draw Graphic (Sablier)
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hPen = _GDIPlus_PenCreate(0xFF000000, 3)
	; Sablier haut
	_GDIPlus_GraphicsDrawLine($hGraphic, $width/3, $height/3, 2*($width/3), $height/3, $hPen)     					;  -
	_GDIPlus_GraphicsDrawLine($hGraphic, 2*($width/3), $height/3, $width/2, $height/2, $hPen) 						; /
	_GDIPlus_GraphicsDrawLine($hGraphic, $width/2, $height/2, $width/3, $height/3, $hPen)    						; \
	; Sablier bas
	_GDIPlus_GraphicsDrawLine($hGraphic, $width/3, 2*($height/3), 2*($width/3), 2*($height/3), $hPen)     			; -
	_GDIPlus_GraphicsDrawLine($hGraphic, 2*($width/3), 2*($height/3), $width/2, $height/2, $hPen)  	  				; \
	_GDIPlus_GraphicsDrawLine($hGraphic, $width/2, $height/2, $width/3, 2*($height/3), $hPen)    					; /
	
	Sleep(3000)
	GUIDelete($guiwindow)    ; On supprime la fenêtre
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
	Local $assert_funct= "Wait"
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

		$dll = DllOpen($assertpartialwindowdll)

		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)

			$result = DllCall($dll, "short:cdecl", "EvalChecksumPartialWindow", "str", $windowTitle,"ptr", DllStructGetPtr($struct,"checksum"),"int",$x+$posX1,"int",$y+$posY1,"int",$x+$posX2,"int",$y+$posY2)
			DllCall_Error("EvalChecksumPartialWindow",@error)
			Local $leftp=$x+$posX1, $topp=$y+$posY1, $rightp=$x+$posX2, $bottomp=$y+$posY2

			$bin_array = DllStructGetData ( $struct,"checkSum")
			DllStructGetData_Error(@error)

			$string_checksum = BinaryToString($bin_array,1) ;flag = 1 (default), binary data is taken to be ANSI
			$hex_checksum = _StringToHex($String_checksum)

			If($recorded_checksum==$hex_checksum) Then
				$check=True
			Else
				
				if $tempo Then
					Animation_WaitPartialWindow ($leftp, $topp, $rightp, $bottomp)
				Else
					EndIf
				
			EndIf

		WEnd

		;Reporting
		ConsoleWrite('Assert_Partial_Window_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical checksums!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Partial_Window"&@TAB&"-- OK --")
			FileFlush($rapport)
			
			; Animation Snapshot
			$colorgraph = 0xFF33FF33
			$colortext = 0x33FF33
			$text = "OK"
		Else
			ConsoleWrite("ERROR - checksums are not identical." & @CRLF )
			$filePath=$scriptName&" "&Get_Time()&" line "&$lineNumber
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Partial_Window"&@TAB&"-- ERROR --"&@TAB&'"'&$filePath&'"')
			FileFlush($rapport)
			$snapshot = "snapshot.dll"
			$dll = DllOpen($snapshot)

			$result=DllCall($dll, "short:cdecl", "TakeWindowSnapshot", "str", $windowTitle,"str",$filePath)
			DllCall_Error("TakeWindowSnapshot",@error)
			$returnCode = $T_WAITPARTIALWINDOW_TIME_ELAPSED
			
			; Animation Snapshot
			$colorgraph = 0xFFFF0000
			$colortext = 0x0000FF
			$text = "ERROR"
		EndIf

		if $tempo Then
			Animation_PartialWindow ($assert_funct, $leftp, $topp, $rightp, $bottomp, $colorgraph)
		Else
			EndIf
		
		DllClose($dll)
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
	Titre : Animation_WaitpartialWindow
	Objectif : Affiche un sablier sur la zone de l'assertion
	Entrée(s) : - Coordonnées de la zone du ckecksum à calculer (leftp,topp,rightp,bottomp)
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_WaitPartialWindow ($leftp, $topp, $rightp, $bottomp)
	Local $widthp = $rightp-$leftp, _
		  $heightp = $bottomp-$topp

	Local $guiwindow = GUICreate("Wait Partial Window", $widthp,$heightp,$leftp,$topp,$WS_POPUP,$WS_EX_LAYERED)   ; On crée la fenêtre: $width,$length,$left,$top,$WS_POPUP
	;~ 	 $WS_POPUP = enlève la barre de titre	;~ 	 $WS_EX_LAYERED = style permettant la transparence
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	GUISetState()			; On affiche la GUI grise transparente

	; Draw Graphic (Sablier)
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hPen = _GDIPlus_PenCreate(0xFF000000, 3)

	; Sablier haut
	_GDIPlus_GraphicsDrawLine($hGraphic, $widthp/3, $heightp/3, 2*($widthp/3), $heightp/3, $hPen)     					;  -
	_GDIPlus_GraphicsDrawLine($hGraphic, 2*($widthp/3), $heightp/3, $widthp/2, $heightp/2, $hPen) 						; /
	_GDIPlus_GraphicsDrawLine($hGraphic, $widthp/2, $heightp/2, $widthp/3, $heightp/3, $hPen)    						; \
	; Sablier bas
	_GDIPlus_GraphicsDrawLine($hGraphic, $widthp/3, 2*($heightp/3), 2*($widthp/3), 2*($heightp/3), $hPen)     			; -
	_GDIPlus_GraphicsDrawLine($hGraphic, 2*($widthp/3), 2*($heightp/3), $widthp/2, $heightp/2, $hPen)  	  				; \
	_GDIPlus_GraphicsDrawLine($hGraphic, $widthp/2, $heightp/2, $widthp/3, 2*($heightp/3), $hPen)    					; /  			

	Sleep(3000)
	GUIDelete($guiwindow)    ; On supprime la fenêtre
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
	Local $assert_funct= "Wait"
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
		$dll = DllOpen($assertcolordll)

		$begin = TimerInit()
		$check=False

		While(TimerDiff($begin)<$timeout AND Not $check)

			$result = DllCall($dll, "ulong:cdecl", "GetPixelColor", "int", $x+$posX,"int", $y+$posY)
			DllCall_Error("GetPixelColor",@error)

			$played_rgb = $result[0]

			If($played_rgb==$recorded_rgb) Then
				$check=True
			Else
				
				if $tempo Then
					Animation_WaitColor ($windowTitle,$posX,$posY)
				Else
					EndIf
				
			EndIf

		WEnd

		;Reporting
		ConsoleWrite('Assert_Color_Wait' & @CRLF)
		If($check) Then
			ConsoleWrite("OK - identical colors!" & @CRLF )
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Color"&@TAB&@TAB&"-- OK --")
			FileFlush($rapport)
			
			; Animation
			$pipette = "pipettevert.png"
		Else
			ConsoleWrite("ERROR - colors are not identical." & @CRLF )
			$colors = 'expected: '&Get_RGB($recorded_rgb)&@TAB&'received:'&Get_RGB($played_rgb)
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Wait_Color"&@TAB&@TAB&"-- ERROR --"&@TAB&$colors)
			FileFlush($rapport)
			$returnCode = $T_WAITCOLOR_TIME_ELAPSED
			
			; Animation
			$pipette = "pipetterouge.png"
		EndIf

		Animation_Color ($windowTitle, $assert_funct, $posX, $posY, $pipette)

		DllClose($dll)
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
	Titre : Animation_WaitColor
	Objectif : Affiche un sablier au centre du pixel correspondant à la couleur
	Entrée(s) : - Titre de la fenêtre
				- Coordonnées du pixel de la couleur
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_WaitColor ($windowTitle,$posX,$posY)
	Local $sizewindow = WinGetPos($windowTitle)
	Local $sizeclient = WinGetClientSize($windowTitle)
	Local $left = $sizewindow[0]+($sizewindow[2]-$sizeclient[0])/2     	; posxclient = posxwindow + (widthwindow - widthclient)/2
	Local $top = $sizewindow[1]+($sizewindow[3]-$sizeclient[1])			; posyclient = posywindow + (heightwindow - heightclient)
	Local $width = $sizeclient[0], $height = $sizeclient[1]
	
	; Taille zone non cliente
	$posX = $posX - ($sizewindow[2]-$sizeclient[0])/2
	$posY = $posY - ($sizewindow[3]-$sizeclient[1])
			
	Local $guiwindow = GUICreate("Wait Color Window", $width,$height,$left,$top,$WS_POPUP,$WS_EX_LAYERED)   ; On crée la fenêtre: $width,$length,$left,$top,$WS_POPUP
	;~ 	 $WS_POPUP = enlève la barre de titre	;~ 	 $WS_EX_LAYERED = style permettant la transparence
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	GUISetState()			; On affiche la GUI grise transparente
			
	; Draw Graphic (Sablier)
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hPen = _GDIPlus_PenCreate(0xFF000000, 3)

	; Sablier haut
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX-15, $posY-15, $posX+15, $posY-15, 	$hPen)     		;  -
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX+15, $posY-15, $posX, $posY, 			$hPen) 			; /
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX, $posY, $posX-15, $posY-15, 			$hPen)    		; \
	; Sablier bas
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX-15, $posY+15, $posX+15, $posY+15, 	$hPen)     		; -
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX+15, $posY+15, $posX, $posY, 			$hPen)  	  	; \
	_GDIPlus_GraphicsDrawLine($hGraphic, $posX, $posY, $posX-15, $posY+15, 			$hPen)    		; /  	 			
			
	Sleep(3000)
	GUIDelete($guiwindow)    ; On supprime la fenêtre
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
	Local $resultmatch, $colorbrush, $assert_funct = "Assertion"
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
			$resultmatch = "OK"
			$colorbrush = 0xFF33FF33
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- OK --")
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- OK --" &@CRLF)
			FileFlush($rapport)
		ElseIf (UBound($array) > 1) Then
			ConsoleWrite("WARNING- Clipboard's content matches the regexp several times !"&@CRLF )
			$resultmatch = "WARNING"
			$colorbrush = 0xFF6600
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- WARNING -- matches several times !!!")
			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_MATCH_SEVERAL_TIMES
		Else
			ConsoleWrite("ERROR - Clipboard's content does not match the regexp."&@CRLF )
			$resultmatch = "ERROR"
			$colorbrush = 0xFFFF0000
			Local $content = "RegExp: " &$regExp &@TAB& "ClpBrdStr: " & $clipBoardStr & @CRLF
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Assert ClipBoard"&@TAB&"-- ERROR --"&@TAB&'"'&$content&'"')
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- ERROR --" &@CRLF)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_NOT_MATCH
		EndIf
		
		if $tempo Then
			Animation_Clipboard ($assert_funct, $ClipBoardStr, $regExp, $resultmatch, $colorbrush)
		Else
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
	Local $resultmatch, $colorbrush, $assert_funct = "Function Bool"
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
			$resultmatch = "OK"
			$colorbrush = 0xFF33FF33
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- OK --")
			FileFlush($rapport)
			$returnCodeBool=True
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- OK --" &@CRLF)
			FileFlush($rapport)
		ElseIf (UBound($array) > 1) Then
			ConsoleWrite("WARNING- Clipboard's content matches the regexp several times !"&@CRLF )
			$resultmatch = "WARNING"
			$colorbrush = 0xFF6600
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- WARNING -- matches several times !!!")
			FileFlush($rapport)
		Else
			ConsoleWrite("ERROR - Clipboard's content does not match the regexp."&@CRLF )
			$resultmatch = "ERROR"
			$colorbrush = 0xFFFF0000
			Local $content = "RegExp: " &$regExp &@TAB& "ClpBrdStr: " & $clipBoardStr & @CRLF
			FileWriteLine($rapport, "Line "&$lineNumber&@TAB&Get_Time()&@TAB&"Function ClipBoard"&@TAB&"-- ERROR --"&@TAB&'"'&$content&'"')
			FileFlush($rapport)
;~ 			FileWriteLine($rapport,"Assert_Clipboard" &@TAB&$scriptName&" "&@HOUR&"H"&@MIN&" -- ERROR --" &@CRLF)
			FileFlush($rapport)
			$returnCode = $T_ASSERTCLIPBOARD_NOT_MATCH
		EndIf
		
		if $tempo Then
			Animation_Clipboard ($assert_funct, $ClipBoardStr, $regExp, $resultmatch, $colorbrush)
		Else
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
	Titre : Animation_Clipboard
	Objectif : Affiche une fenêtre de dialogue transparente avec le contenu du clipboard, l"expression régulière et le résultat de la comparaison
	Entrée(s) : - indique le type de la fonction
				- contenu du clipboard (string)
				- contenu de l'expression à retrouver (string)
				- résultat de la comparaison
				- couleur du texte indiquant le résultat
	Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Animation_Clipboard ($assert_funct, $ClipBoardStr, $regExp, $resultmatch, $colorbrush)
	Local $guiwindow = GUICreate( $assert_funct&" Assertion", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP,$WS_EX_LAYERED)
	Local $color = 0xA0A0A0    										; Couleur grise
	GUISetBkColor($color,$guiwindow) 										; Mettre cette couleur en fond d'écran
	_WinAPI_SetLayeredWindowAttributes($guiwindow,0x010101,200)			; Activer transparence (0x010101 = Noir)
	
	GUICtrlCreateEdit($clipBoardStr, @DesktopWidth/2 - 210, @DesktopHeight/4, 420, 75, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
	GUICtrlCreateLabel("ClipBoard's Content", @DesktopWidth/2 - 210, @DesktopHeight/4 - 22,150)
	GUICtrlCreateEdit($regExp, @DesktopWidth/2 - 210, @DesktopHeight/2.8, 420, 75, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
	GUICtrlCreateLabel("Regular Expression", @DesktopWidth/2 - 210, @DesktopHeight/2.8 - 22, 150)
	GUISetState()
		
	; Draw a string
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($guiwindow)
	$hBrush = _GDIPlus_BrushCreateSolid($colorbrush)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Arial")
	$hFont = _GDIPlus_FontCreate($hFamily, 25, 1)
	$tLayout = _GDIPlus_RectFCreate(@DesktopWidth/2 - 180, @DesktopHeight/2 - 25, 400, 200)
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $resultmatch, $hFont, $tLayout, $hFormat, $hBrush)

	; Clean up resources
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
		
	Sleep($tempo_Anim)
	GUIDelete()
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
	If $socket_id <> -1 Then
		T_NetSend($T_SEND,'T_Send("'&$keys&'")', $socket_id)
		$returnCode = T_NetReceive($socket_id,$T_SEND)
	Else
		Send($keys)
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
	MsgBox(4096, "", "This is a message.")
EndFunc   ;==>ShowMessage