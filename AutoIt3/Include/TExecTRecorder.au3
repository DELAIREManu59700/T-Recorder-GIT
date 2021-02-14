#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 Script d'ex�cution du T-Recorder
 Auteur:	E. DELAIRE

 Objet : Pr�senter � l'op�rateur les options d'ex�cution possibles du T-Recorder

#ce

#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>
#Include <String.au3>
#include <Array.au3>
#include <WinAPIFiles.au3>

Const $AUCUN=-1
Const $NOMINAL=0
Const $RECORD=1
Const $PLAY=2

Dim $debugMode=0	;Mode debug: 0: inactif; actif sinon
Dim $timeoutChoix=5	;Timeout d'attente d'une action de l'op�rateur - unit�: secondes

Dim $envAt2_Home = ""	;Le contenu de la variable d'environne�ment AT2_HOME
Dim $pathToExecMode = ""	;Chemin vers le programme TExecTRecorder.Exe

Dim $pathToProgTRecorder
Dim $pathToProgInterpreter
Dim $pathToProgTPlayer

Dim $option=$NOMINAL
Dim $timeoutElapsed=False

Dim $demandeExit = False

;============================================================== MAIN ===========================================================================
HotKeySet("^q", FuncName(R_Exit))
R_SetExit(False)	; arr�t imm�diat non-demand� par d�faut

Main()


;============================================================== Fonctions ======================================================================
;Fonction principale
Func Main()
	;Acquisition de la variable d'environnement "AT2_HOME"
	$regKey_AT2_HOME = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "AT2_HOME")
	$pathToExecMode = $regKey_AT2_HOME & "\ExecMode"

	; charger config
	$debugMode = IniRead($pathToExecMode & "\TExecTRecorder.ini", "IDENT", "debug", "0")
	$timeoutChoix = IniRead($pathToExecMode & "\TExecTRecorder.ini", "IDENT", "timeout", "5")
	$pathToProgTRecorder = IniRead($pathToExecMode & "\TExecTRecorder.ini", "PROGS", "TRecorderFolder", "C:\Program Files\Automated Testing Tools\T-Recorder")
	$pathToProgInterpreter = IniRead($pathToExecMode & "\TExecTRecorder.ini", "PROGS", "TInterpreterFolder", "C:\Program Files\Automated Testing Tools\T-Interpreter")
	$pathToProgTPlayer = IniRead($pathToExecMode & "\TExecTRecorder.ini", "PROGS", "TPlayerFolder", "C:\Program Files\Automated Testing Tools\AutoIt3\Include")

	If $debugMode <> 0 Then
		MsgBox(0,"CONFIG", "Param�tres :" & @CRLF & _
							"AT2_HOME: " & $regKey_AT2_HOME & @CRLF & _
							"$debugMode= " & $debugMode & @CRLF & _
							"timeout= " & $timeoutChoix & " secondes" & @CRLF & _
							"TRecorderFolder= " & $pathToProgTRecorder & @CRLF & _
							"TInterpreterFolder= " & $pathToProgInterpreter & @CRLF & _
							"TPlayerFolder= " & $pathToProgTPlayer & @CRLF)
	EndIf

	;Lancer appli
	$option = ChoixOPtion()
	LancerTRecorder($option)
EndFunc

;Pr�sente les options d'ex�cution du T-Recorder � l'op�rateur
Func ChoixOption()
	Local $choix = $NOMINAL
	Local $timer

	#Region ### START Koda GUI section ### Form=C:\Program Files (x86)\Automated Testing Tools\AutoIt3\koda_1.7.2.0\Forms\Lance-TRecorder.kxf
	$MainFrm = GUICreate("T-Recorder", 426, 263, 217, 135, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
	$_lbTitre = GUICtrlCreateLabel("Lancement de T-Recorder", 48, 24, 321, 36)
	GUICtrlSetFont(-1, 20, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	$_lbOptions = GUICtrlCreateLabel("Le mode d'ex�cution du T-Recorder", 72, 72, 252, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x0000FF)

	GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	$_rdNOMINAL = GUICtrlCreateRadio("NOMINAL (par d�faut) : inhibition du T-Recorder", 72, 104, 313, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_CHECKED)	;Radio button choisi par d�faut

	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKHEIGHT)
	$_rdRECORD = GUICtrlCreateRadio("RECORD : mode enregistreur -> T-Recorder actif", 72, 136, 321, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x000000)

	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKHEIGHT)
	$_rdPLAY = GUICtrlCreateRadio("PLAY : mode rejeu -> T-INTERPRETER actif", 72, 168, 289, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x000000)

	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKHEIGHT)
	$_btOK = GUICtrlCreateButton("Valider", 72, 208, 107, 41, BitOR($BS_NOTIFY,$WS_BORDER))
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x008000)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

	$_btQuitter = GUICtrlCreateButton("Quitter", 248, 208, 107, 41)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	;Armement du timer qui controle le timeout de 10 secondes
	;--> le timeout cours tand que l'op�rateur n'a pas fait de choix
 	$timer = _Timer_SetTimer($MainFrm, $timeoutChoix * 1000, "OnTimeOutElapsed")

	;Boucle des messages Windows
	$quitter=False
	While ($quitter == False And $timeoutElapsed == False)
		$nMsg = GUIGetMsg()
		Switch $nMsg

			case $GUI_EVENT_CLOSE
				;On quitte l'application
				$quitter = True

			case $_btQuitter
				;On quitte l'application, on a donc d�cider de ne rien choisir !
				$choix= $AUCUN
				$quitter = True

			case $_btOK
				$quitter = True

			case $_rdNOMINAL
				$choix = $NOMINAL

			case $_rdRECORD
				$choix = $RECORD

			case $_rdPLAY
				$choix = $PLAY

		EndSwitch
	WEnd
	;------------------------------------------------------------------
	_Timer_KillTimer($MainFrm, $timer)

	;Annulation du timeout
	If ($timeoutElapsed) Then
		$choix = $NOMINAL
	EndIf

	GUIDelete($MainFrm)

	return $choix
EndFunc

;Excution d'un ex�cutable de l'application T-Recorder
Func LancerTRecorder($opt)
	switch $opt
		case $RECORD
 			;MsgBox($MB_SYSTEMMODAL, "DEFAULT", "Mode d'ex�cution : RECORD" & @CRLF & "-> L'application T-Recorder est lanc�e pour enregistrer actions")
 			PopUp("Mode", "Mode RECORD -> T-Recorder est lanc� !" , "Arial", 3000, 300, 100, 300, 300, 10, 700)
			Run($pathToProgTRecorder & "\T-Recorder.exe")

		Case $PLAY
 			;MsgBox($MB_SYSTEMMODAL, "DEFAULT", "Mode d'ex�cution : PLAY" & @CRLF & "-> L'application T-Interpreter est lanc�e pour rejouer scripts, notamment en r�seau")
			PopUp("Mode", "Mode PLAY -> T-Interpreter est lanc�e !", "Arial", 3000, 300, 100, 300, 300, 10, 700)
			Run($pathToProgInterpreter & "\T-Interpreter.exe")

			PopUp("Mode", "Mode PLAY -> T-PayScr est lanc�e !", "Arial", 3000, 300, 100, 300, 300, 10, 700)
			Run($pathToProgTPlayer & "\TPlayScr.exe")

		Case $NOMINAL
 			;MsgBox($MB_SYSTEMMODAL, "DEFAULT", "Mode d'ex�cution par d�faut : NOMINAL" & @CRLF & "-> T-Recorder inhib� !")
			PopUp("Mode", "Mode Nominal -> T-Recorder inhib� !", "Arial", 3000, 300, 100, 300, 300, 10, 700)

;		Case Else
;			;Aucun choix n'a �t� fait !
;			PopUp("Mode", "Mode " & $opt & " T-Recorder inhib� !", "Arial", 3000, 300, 100, 300, 300, 10, 700)

	EndSwitch
EndFunc

;Timeout elapsed
Func OnTimeOutElapsed($hWnd, $iMsg, $ilDTimer, $iTime)
	$timeoutElapsed = True
EndFunc

;Affiche un popup pour pr�senter un texte pendant une dur�e donn�e, puis se termine automatiquement
Func PopUp($titre="", $text="", $font="Times New Roman", $timeout=5000, $w=Default, $h=Default, $xPos=Default, $yPos=Default, $size=10, $fontw=800)
	SplashTextOn($titre, $text, $w, $h, $xPos, $yPos, 0+1+16+32, $font, $size, $fontw)
	Sleep($timeout)
	SplashOff()
EndFunc

;G�re l'arr�t imm�diat arm� depuis l'en-t�te du script AutoIt jou�
Func R_Exit()
	R_SetExit(True)	; arr�t imm�diat demand�
	LancerTRecorder($NOMINAL)
	Exit(0);	D�clenche l'arr�t imm�diat du script AutoIt en cours d'ex�cution
EndFunc

;Affecte l'�tat de l'arret d'urgence
; $etat : True : arr�t imm�diat demand�; False : arr�t imm�diat non-demand�
Func R_SetExit($etat)
	$demandeExit = $etat
EndFunc


;================================================================== FIN ===========================================================================
