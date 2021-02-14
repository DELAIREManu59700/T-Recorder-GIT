#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 Script d'ex�cution du TPlayer
 Auteur:	E. DELAIRE

 Objet : Quand le mode d'ex�cution est PLAYER, pr�sentation de tous les scripts cr��s afin que l'utilisateur puisse choisir celui ou ceux � rejouer

#ce
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>

#include "ROCADE_Api.au3"

Dim $debug=0


Dim Const $temporaryScript = "temporary.au3"		;Scritp AutoIt de travail �dit� par le pr�sent programme afin de r�aliser le rejeu de scripts AutoIt cr��s
Dim Const $headerScript = "header.au3"				;script "header" � ne prendre prendre en compte parmi ceux pr�sent�s � l'utilisateur

Dim Const $ResultatRejeu ="temporaryResultat.txt"	;Fichier texte r�sultat du rejeu

Dim $regKey_AT2_HOME = ""	;Le contenu de la valeur AT2_HOME de la cl� de registre HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
Dim $pathToTPlayScr = ""	;Chemin vers le programme TPlayScr.exe

Dim $confPathToRoot = ""
Dim $confPathToScripts = ""
Dim $confPathToRejeu = ""

Dim $pathToRoot=""		;Le chemin vers un r�pertoire racine depuis lequel faire la recherche de fichiers.
Dim $pathToRejeu=""		;Le chemin vers un r�pertoire dans lequel le programme cr�e le script de rejeu.
Dim $pathToScripts=""	;Le chemin vers les scripts cr��s avec T-Recorder (ce sera aussi l'endroit o� le script temporaire sera cr��)
Dim $temporisation=2	;Temporisation entre le rejeu de deux scripts AutoIt - unit�: secondes
Dim $bouclerRejeu=False	; Flag qui conditionne la commande de bouclage de l'ex�cution des scripts � rejouer
Dim $nbrRepetitions=0	;Nombre de r�p�titions : si $bouclerRejeu est vrais et si $nbrRepetitions vaut 0 alors boucle infinie; sinon si $nbrRepetitions > 0 alors boucle "For" finie; sinon pas de boucle

;============================================================== MAIN ===========================================================================
;Lancement du programme
Main()
;Terminaison
Exit

;============================================================== Fonctions ===========================================================================
;Fonction principale
Func Main()
	;Acquisition de la variable d'environnement "AT2_HOME"
	$regKey_AT2_HOME = GetRegistryKey("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "AT2_HOME")
	$pathToTPlayScr = $regKey_AT2_HOME & "\T-Player"

	; charger config
	LoadConfig()

	#Region ### START Koda GUI section ### Form=c:\program files (x86)\automated testing tools\autoit3\koda_1.7.2.0\forms\frmplayer.kxf
	Global $FrmPlayer = GUICreate("TPlayer", 801, 502, 192, 124)
	GUISetBkColor(0xFFFFFF)

	GUIStartGroup()
	Global $_lbScriptsAutoIt = GUICtrlCreateLabel("Racine des scripts AutoIt ", 32, 64, 180, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_lbScriptsARejouer = GUICtrlCreateLabel("Scripts � rejouer", 424, 64, 118, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_btRechRacine = GUICtrlCreateButton("...", 216, 64, 19, 25, BitOR($BS_FLAT,$WS_BORDER))
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	Global $List1 = GUICtrlCreateListView("", 32, 96, 337, 214)
	_GUICtrlListView_AddColumn($List1, "Scripts cr��s", 300);
	_GUICtrlListView_SetExtendedListViewStyle($List1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))


	Global $_lbDureeAttente = GUICtrlCreateLabel("Dur�e attente entre le rejeu de deux scripts", 24, 320, 254, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $InputTempo = GUICtrlCreateInput("0", 280, 320, 57, 24, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0xFFFF00)

	Global $List2 = GUICtrlCreateListView("", 424, 96, 345, 214)
	_GUICtrlListView_AddColumn($List2, "Scripts � rejouer", 300);
	_GUICtrlListView_SetExtendedListViewStyle($List2, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))

	Global $_btAjouter = GUICtrlCreateButton("->", 376, 160, 35, 25, BitOR($BS_FLAT,$WS_BORDER))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0x008000)

	Global $_btSuppr = GUICtrlCreateButton("X", 376, 208, 35, 25, BitOR($BS_FLAT,$WS_BORDER))
	GUICtrlSetFont(-1, 8, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	Global $_lbUnit = GUICtrlCreateLabel("secondes", 344, 320, 60, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_cbBouclerRejeu = GUICtrlCreateCheckbox("Boucler le rejeu des scripts.", 424, 320, 185, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $Label2 = GUICtrlCreateLabel("Nombre r�p�titions", 616, 320, 113, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $InputNbrRept = GUICtrlCreateInput("", 736, 320, 49, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0xFFFF00)

	GUIStartGroup()
	GUIStartGroup()

	Global $_btExecuter = GUICtrlCreateButton("Executer", 24, 448, 131, 33, BitOR($BS_FLAT,$WS_BORDER,$WS_CLIPSIBLINGS))
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0x008000)

	Global $_btQuitter = GUICtrlCreateButton("Quitter", 632, 448, 131, 33, BitOR($BS_FLAT,$WS_BORDER,$WS_CLIPSIBLINGS))
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	Global $_btSave = GUICtrlCreateButton("Sauver", 328, 448, 131, 33, BitOR($BS_FLAT,$WS_BORDER,$WS_CLIPSIBLINGS))
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0x0000FF)

	GUIStartGroup()

	Global $Label1 = GUICtrlCreateLabel("Rejeu de scripts AutoIt", 261, 8, 281, 36)
	GUICtrlSetFont(-1, 20, 400, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	GUIStartGroup()

	Global $_lbPathToScript = GUICtrlCreateLabel("Racine vers les scripts AutoIt cr��s avec T-Recorder", 32, 368, 260, 17)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_lbPathToRejeu = GUICtrlCreateLabel("Script de rejeu cr��", 32, 400, 166, 17)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_tbPathToScripts = GUICtrlCreateInput("", 296, 368, 489, 21)

	Global $_tbPathToRejeu = GUICtrlCreateInput("", 296, 400, 489, 21)

	GUIStartGroup()

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	;Met � jour l'�tat de la zone de saisie du nombre de r�p�tition
	MgtButtonAvailability($InputNbrRept, $GUI_DISABLE)

	;On ajoute dans la liste des scripts cr��s par T-Recorder tous les scripts AutoIt pr�sents dans le r�pertoire racine choisi (on ne s�lectionnera pas le script temporaire si pr�sent)
	AjouterScriptsDansListeScriptsCrees($pathToScripts)

	;Rafraichit les chemins dans les zones de texte
	MgtChemins()

	;Met � jour l'�tat des boutons de l'IHM
	MgtButtons()

	; Boucle de gestion des messages Windows
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $_btQuitter
				Exit

			Case $_btRechRacine
				; Ouvre une boite de dialogue de recherche de r�pertoire afin d'aller pointer la racine des scripts AutoIt qui contiennent ceux cr��s avec T-Recorder
				RechercherRacineDesScripts($confPathToScripts)	;$confPathToScripts est affect� par le fichier de configuration pour d�finir un r�pertoire depuis lequel faire des recherches de fichiers
				;On ajoute dans la liste des scripts cr��s par T-Recorder tous les scripts AutoIt pr�sents dans le r�pertoire racine choisi (on ne s�lectionnera pas le script temporaire si pr�sent)
				AjouterScriptsDansListeScriptsCrees($pathToScripts)
				;Met � jour l'�tat des boutons de l'IHM
				MgtButtons()
				;Rafraichit les chemins dans les zones de texte
				MgtChemins()

			Case $_btAjouter
				; Copie dans la liste des scripts AutoIt � rejouer ceux choisis dans la liste des scripts cr��s avec T-Recorder
				$tabIdx = _GUICtrlListView_GetSelectedIndices($List1, True)
				If ($tabIdx[0] > 0) Then
					For $i=1 To $tabIdx[0]
						$item = _GUICtrlListView_GetItem($List1, $tabIdx[$i])	;R�cup�re l'�l�ment s�lectionn� � partir de son index dans la liste des scripts cr��s
						AjouterScriptDansListeScriptsARejouer($item[3])			;Ajoute l'�l�ment s�lectionn� dans la liste des scripts � rejouer
					Next
				EndIf
				;Met � jour l'�tat des boutons de l'IHM
				MgtButtons()

			Case $_btSuppr
				; Supprime de la liste des scripts � rejouer ceux s�lectionn�s
				$tabIdx = _GUICtrlListView_GetSelectedIndices($List2, True)
				If ($tabIdx[0] > 0) Then
					For $i=1 To $tabIdx[0]
						_GUICtrlListView_DeleteItem($List2, $tabIdx[$i])		; supprime l'�l�ment s�lectionn� de la liste des scripts � rejouer
					Next
				EndIf
				;Met � jour l'�tat des boutons de l'IHM
				MgtButtons()

			Case $_cbBouclerRejeu
				$bouclerRejeu = IsChecked($_cbBouclerRejeu)
				If ($bouclerRejeu) Then
					MgtButtonAvailability($InputNbrRept, $GUI_ENABLE)
				Else
					MgtButtonAvailability($InputNbrRept, $GUI_DISABLE)
				EndIf

			Case $_btExecuter
				$tempo=GUICtrlRead($InputTempo)	;Lit la valeur de la tempo saisie, ou r�cup�r�e du fichier de configuration TPlayScr.ini
				CreerTemporaryScript($pathToRejeu, $pathToScripts, $tempo)
				ExecuterScript($pathToRejeu & "\\" & $temporaryScript)

			Case $_btSave
				$tempo=GUICtrlRead($InputTempo)	;Lit la valeur de la tempo saisie, ou r�cup�r�e du fichier de configuration TPlayScr.ini
				;La sauvegarde du script temporaire est r�alis�e en recr�ant le script (si existe) et en y ajoutant tous les fichiers scripts mentionn�s dans la liste des scripts � rejouer
				CreerTemporaryScript($pathToRejeu, $pathToScripts, $tempo)

		EndSwitch
	WEnd

EndFunc

;Acquisition de la variable d'environnement "AT2_HOME"
Func GetRegistryKey($key, $value)
	$regKey = RegRead($key, $value)
	return $regKey
EndFunc

;Charge la configuration depuis le fichier TPlayScr.ini
Func LoadConfig()
	; charger config
	$temporisation = IniRead($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "tempo", "5")
	$confPathToRoot = IniRead($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "pathToRoot", "")
	$confPathToScripts = IniRead($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "pathToScripts", "")
	$confPathToRejeu = IniRead($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "pathToRejeu", "")

	$debug = IniRead($pathToTPlayScr & "\TPlayScr.ini", "IDENT", "debug", "0")

	If $debug <> 0 Then
		MsgBox(0,"CONFIG",  "AT2_HOME: " & $regKey_AT2_HOME & @CRLF & _
							"Chemin vers T-Player: " & $pathToTPlayScr & @CRLF & _
							"Param�tres (.ini):" & @CRLF & _
								"tempo= " & $temporisation & " secondes" & @CRLF & _
								"pathToRoot= " & $confPathToRoot & @CRLF & _
								"pathToScripts= " & $confPathToScripts & @CRLF& _
								"pathToRejeu= " & $confPathToRejeu & @CRLF& _
								"debug= " & $debug & @CRLF)
	EndIf

	$pathToRoot = $confPathToRoot
	$pathToScripts = $confPathToScripts
	$pathToRejeu = $confPathToRejeu
EndFunc

;Ouvrer une boite de dialogue qui demande � l'op�rateur de choisir le r�pertoire racine des fichiers scripts AutoIt candidats aux rejeux
Func RechercherRacineDesScripts($path)

	If ($debug <> 0) Then
  		MsgBox(0,"DEBUG", "RechercherRacineDesScripts  Argument= " & $path & @CRLF)
	EndIf

	$selectedPath = FileSelectFolder("Veuillez s�lectionner le r�pertoire racine des fichiers scripts AutoIt candidats aux rejeux.", $path, 0)
	If @error Then
		$pathToScripts = $confPathToScripts
	Else
		$pathToScripts = $selectedPath

		If ($pathToScripts <> $confPathToScripts) Then

			;Sauvegarde dans le fichier de config TPlayScr.ini le nouveau path vers les scripts AutoIt cr��s avec T-Recorder
			IniWrite($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "pathToScripts", '"' & $pathToScripts & '"')
			;Rechargement des param�tres de configuration
			LoadConfig()
		EndIf

	EndIf

	If ($debug <> 0) Then
		MsgBox(0,"DEBUG", "$pathToScripts= " & $pathToScripts & @CRLF)
	EndIf

EndFunc

;Ajoute dans la liste des scripts candidats aux rejeux tous les scripts AutoIt pr�sents dans le r�pertoire $path
Func AjouterScriptsDansListeScriptsCrees($path)
	If ($path <> "") Then
		;Supprime tous les �l�ments de la liste
		_GUICtrlListView_DeleteAllItems($List1)

		;R�cup�re tous les fichiers '.au3' pr�sents dans le r�pertoire $path
		$search = FileFindFirstFile($path & "\*.au3")
		If ($search <> "") Then
			If $debug <> 0 Then
				MsgBox(0,"DEBUG", "AjouterScripts... ")
			EndIf
			while 1
				$file = FileFindNextFile($search)
				If @error Then ExitLoop

				If $debug <> 0 Then
					MsgBox(0,"DEBUG", "AjouterScripts... " & "$file= " & $file & @CRLF)
				EndIf
				;On ne prend pas en comte du script temporaire, ni e script 'header.au3'
				If ($file <> $temporaryScript And $file <> $headerScript) Then
					_GUICtrlListView_BeginUpdate($List1)

					_GUICtrlListView_AddItem($List1, $file)

					_GUICtrlListView_EndUpdate($List1)
				EndIf
			WEnd
		EndIf
 		_GUICtrlListView_EnsureVisible($list1, -1)
	EndIf
EndFunc

;Ajoute le script donn� en argument dans la liste des scripts � rejouer le script
Func AjouterScriptDansListeScriptsARejouer($script)
	If ($script <> "") Then

		;V�rifie d'abord la pr�sence de l'�l�ment dans la liste
  		$idx = _GUICtrlListView_FindInText($list2, $script, -1)
		If ($idx < 0) Then
			; chaque fichier '.au3' est ajout� dans la liste
			_GUICtrlListView_AddItem($List2, $script)
		EndIf

	EndIf

EndFunc

;Cr�e le fichier temporary.au3 � l'emmplacement sp�cifi�
;Ajoute une temporisation entre chaque fichier script ajout�
Func CreerTemporaryScript($pathRejeu, $pathScriptsTRec, $tempo=0)

	If ($pathRejeu <> "") Then

		;D�termine le nombre de fichiers scripts � rejouer
		$cnt = _GUICtrlListView_GetItemCount($List2)
		If ($cnt > 0) Then

			; cr�er le fichier temporary.au3 : $pathRejeu & "\" & $temporaryScript :: si le fichier existe on l'�crase !!
			If (FileExists($pathRejeu & "\" & $temporaryScript)) Then
				FileDelete($pathRejeu & "\" & $temporaryScript)
			EndIf

			FileWrite($pathRejeu & "\" & $temporaryScript, "")

			;Ouvre le fichier et y ajoute tous les noms des fichiers scripts � rejouer r�cup�r� de la liste des scripts � rejouer
			; ...Pour chaque fichier script � ajouter, on cr�e une ligne ins�r�e dans le fichier temporaire : "RunWait("AutoIt3.exe """" & """" & $script & """") "
			; REM: on ajoute, entre chaque ligne d'appel d'un nom de script � rejouer, une commande de temporisation : "R_Timer(" & $tempo & ")

			$file = FileOpen($pathRejeu & "\" & $temporaryScript, 1)

			;Composition du fichier de script "temporary.au3"
			AddScriptHeader($file)		;ajoute au d�but du fichier tous les fichiers d'en-t�te utiles

			;Cr�ation dans le script de rejeu d'une commande pour cr�er un fichier de r�sultat pour y enregistrer les commentaires de chaque test
			FileWriteLine($file, "")
			FileWriteLine($file, ";Cr�e un fichier de r�sultat pour y cumuler le r�sultat des tests")
			$pathResultats = '"' & $pathRejeu & '\' & $ResultatRejeu & '"'
			FileWriteLine($file, '$fileResultat = R_CreerFichierResultatRejeu(' & $pathResultats & ')')
			FileWriteLine($file, "")
			;

			$nbrRepet = GUICtrlRead($InputNbrRept)	;Lit le nombre de r�p�tition
			if ($nbrRepet <> "" And Not IsNumber(Number($nbrRepet))) Then
				MsgBox(0, "ERREUR", "Le nombre de r�p�titions saisi doit �tre un nombre entier, ou sinon il doit rester vide !")
				return
			EndIf

			If ($bouclerRejeu) Then

				FileWriteLine($file, "")
				FileWriteLine($file, "; $$$$$$$$$$$$ R�p�titions du rejeu des scripts $$$$$$$$$$$$$$$$$$$$$$")

				FileWriteLine($file, "	$nbrIteration = 1")
				FileWriteLine($file, "")
				If ($nbrRepet == "") Then

					FileWriteLine($file, "While True")

				ElseIf (Number($nbrRepet) > 0) Then

					FileWriteLine($file, "For $cnt=1 To " & Number($nbrRepet))

				EndIf

				FileWriteLine($file, "")

				FileWriteLine($file, '	R_AddLigneDansFichierResultatRejeu($fileResultat, " =============== It�ration n� " & $nbrIteration & " ===========")')
				FileWriteLine($file, "")

			EndIf

  			For $i=0 To $cnt-1

				FileWriteLine($file, "")
				FileWriteLine($file, ";****************** Script � rejouer n� " & $i & " ************")
				$item = _GUICtrlListView_GetItem($List2, $i)	;R�cup�re l'�l�ment s�lectionn� � partir de son index dans la liste des scripts � rejouer
				$instr= '"AutoIt3.exe " & """' & $pathScriptsTRec & "\" & $item[3] & '"""'
				$instructionExe = '$exitCode = RunWait(' & $instr & ')'	;Cr�ation de l'instruction d'ex�cution du script qui correspond � l'item : Run("AutoIt3.exe " & """" & $item[3] & """")
				FileWriteLine($file, $instructionExe)

				FileWriteLine($file, "If $exitCode == 0 Then")
				FileWriteLine($file, "")
				FileWriteLine($file, "	;Trace dans le fichier de r�sultat des tests")
				$resultatScript = '	R_AddResultatsScriptDansFichierResultatRejeu($fileResultat, "' & $pathScriptsTRec & "\" & $item[3] & '.trp")'
				FileWriteLine($file, $resultatScript)
				FileWriteLine($file, "")

 				If ($tempo > 0) Then
					;Ajout d'une tempo avant de passer � l'ex�cution du script suivant, ou de terminer le rejeu
					$ligne = "	R_Timer(" & $tempo & ")"
					FileWriteLine($file, $ligne)
				EndIf

				FileWriteLine($file, "Else")
				FileWriteLine($file, "")
				FileWriteLine($file, "	;Trace dans le fichier de r�sultat des tests")
				FileWriteLine($file, "	R_AddLigneDansFichierResultatRejeu($fileResultat, " & """ARRET D'URGENCE demand� ! """ & ")")
				FileWriteLine($file, "")
				FileWriteLine($file, "	MsgBox(0," & """STOP""" & ", " & """Arr�t d'urgence demand� !""" & ");")

				If ($bouclerRejeu) Then
					FileWriteLine($file, "	ExitLoop")
				Else
					FileWriteLine($file, "	Exit")
				EndIf
				FileWriteLine($file, "EndIf")
				FileWriteLine($file, "")

			Next

			If ($bouclerRejeu) Then

				FileWriteLine($file, "")
				FileWriteLine($file, "	;==========================")
				FileWriteLine($file, "")

				FileWriteLine($file, "	$nbrIteration = $nbrIteration + 1")
				If ($nbrRepet == "") Then

					FileWriteLine($file, "WEnd")

				ElseIf (Number($nbrRepet) > 0) Then

					FileWriteLine($file, "Next")

				EndIf

				FileWriteLine($file, "; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
				FileWriteLine($file, "")

			EndIf

			;Cr�ation dans le script de rejeu d'une commande pour cr�er un fichier de r�sultat pour y enregistrer les commentaires de chaque test
			FileWriteLine($file, "")
			FileWriteLine($file, ";Ferme le fichier de r�sultat des tests")
			FileWriteLine($file, "R_FermerFichierResultatRejeu($fileResultat)")
			FileWriteLine($file, "")
			;

			AddScriptFooter($file)		;ajoute une fin de fichier

			FileClose($file)

		Else
			MsgBox(0,"ERREUR", "Cr�ation du fichier " & $pathRejeu & "\" & $temporaryScript & " impossible car aucun script � rejouer n'a �t� d�fini !")
			return False
		EndIf

	Else
		MsgBox(0,"ERREUR", "Cr�ation du fichier impossible car non sp�cifi� !")
		return False
	EndIf

	MsgBox(0,"INFO", "Fichier " & $pathRejeu & "\" & $temporaryScript & " cr��.", 2)
	return true

EndFunc

Func AddScriptHeader($file)
	If ($file) Then
		FileWriteLine($file, "#include <UDF_Tests.au3>")
		FileWriteLine($file, "")
		FileWriteLine($file, ";-----------------------------------------")
		FileWriteLine($file, "")
	EndIf
EndFunc

Func AddScriptFooter($file)
	If ($file) Then
		FileWriteLine($file, "")
		FileWriteLine($file, ";-----------------------------------------")
		FileWriteLine($file, "")
		FileWriteLine($file, "Exit")
		FileWriteLine($file, "")
	EndIf
EndFunc

Func AddControlArretUrgence($file, $tempo)
	If ($file) Then
		FileWriteLine($file, "If $exitCode == 0 Then")
		FileWriteLine($file, "	R_Timer(" & $tempo & ")")
		FileWriteLine($file, "Else")
		FileWriteLine($file, "	MsgBox(0," & """STOP""" & ", " & """Arr�t d'urgence demand� !""" & ");")
		FileWriteLine($file, "	ExitLoop")
		FileWriteLine($file, "EndIf")
		FileWriteLine($file, "")
	EndIf
EndFunc

;Change l'�tat d'un contr�le
Func MgtButtonAvailability($idCtrlID, $etat)
;Dim $_btExecuter, $_btQuitter, $_btSave;	;Les id des controls de l'IHM de type 'Button'
	If ($idCtrlID) Then
		GUICtrlSetState($idCtrlID, $etat)
	EndIf

EndFunc

;Met � jour l'�tat des boutons pr�sents sur l'IHM
Func MgtButtons()
	;Contr�le s'il y a au moins un script � rejouer dans la liste
	$cnt = _GUICtrlListView_GetItemCount($List2)
	If ($cnt > 0) Then
		MgtButtonAvailability($_btSuppr, $GUI_ENABLE)

		MgtButtonAvailability($_btExecuter, $GUI_ENABLE)
		MgtButtonAvailability($_btSave, $GUI_ENABLE)

		MgtButtonAvailability($_btQuitter, $GUI_ENABLE)
	Else
		MgtButtonAvailability($_btSuppr, $GUI_DISABLE)

		MgtButtonAvailability($_btExecuter, $GUI_DISABLE)
		MgtButtonAvailability($_btSave, $GUI_DISABLE)

		MgtButtonAvailability($_btQuitter, $GUI_ENABLE)
	EndIf

	$cnt2 = _GUICtrlListView_GetItemCount($List1)
	If ($cnt2 > 0) Then
		MgtButtonAvailability($_btAjouter, $GUI_ENABLE)
	Else
		MgtButtonAvailability($_btAjouter, $GUI_DISABLE)
	EndIf
EndFunc

Func MgtChemins()
	GUICtrlSetData($InputTempo, $temporisation)
	GUICtrlSetData($_tbPathToRejeu, $pathToRejeu & "\" & $temporaryScript)
	GUICtrlSetData($_tbPathToScripts, $pathToScripts)
EndFunc

Func GetPathToTemporaryScript()
	return $pathToScripts
EndFunc

;Lance l'ex�cution d'un script AutoIt
Func ExecuterScript($script)

	If ($script <> "") Then
		;ATTENTION : doit v�rifier l'existence du script avant de le jouer !!
		If (FileExists($script)) Then
			RunWait('AutoIt3.exe "' & $script & '"')
		Else
			MsgBox(0, "Erreur", "Fichier script " & $script & " absent !")
		EndIf
	EndIf

EndFunc

;Lance l'ex�cution d'un programme
Func ExecuterExe($pathToExe)
	If ($pathToExe <> "") Then
		;ATTENTION : doit v�rifier l'exsitence du programme avant de l'ex�cuter !!
		If (FileExists($pathToExe)) Then
			RunWait($pathToExe)
		Else
			MsgBox(0, "Erreur", "Fichier ex�cutable " & $pathToExe & " absent !")
		EndIf
	EndIf

EndFunc

;Retourne True si et seulement si le composant remonte $GUI_CHECKED (cas d'une case � cocher ou d'un Radio bouton)
Func IsChecked($idCtrlID)
	Return BitAND(GUICtrlRead($idCtrlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc

;================================================================== FIN ===========================================================================
