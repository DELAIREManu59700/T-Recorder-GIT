#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 Script d'exécution du TPlayer
 Auteur:	E. DELAIRE

 Objet : Quand le mode d'exécution est PLAYER, présentation de tous les scripts créés afin que l'utilisateur puisse choisir celui ou ceux à rejouer

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


Dim Const $temporaryScript = "temporary.au3"		;Scritp AutoIt de travail édité par le présent programme afin de réaliser le rejeu de scripts AutoIt créés
Dim Const $headerScript = "header.au3"				;script "header" à ne prendre prendre en compte parmi ceux présentés à l'utilisateur

Dim Const $ResultatRejeu ="temporaryResultat.txt"	;Fichier texte résultat du rejeu

Dim $regKey_AT2_HOME = ""	;Le contenu de la valeur AT2_HOME de la clé de registre HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
Dim $pathToTPlayScr = ""	;Chemin vers le programme TPlayScr.exe

Dim $confPathToRoot = ""
Dim $confPathToScripts = ""
Dim $confPathToRejeu = ""

Dim $pathToRoot=""		;Le chemin vers un répertoire racine depuis lequel faire la recherche de fichiers.
Dim $pathToRejeu=""		;Le chemin vers un répertoire dans lequel le programme crée le script de rejeu.
Dim $pathToScripts=""	;Le chemin vers les scripts créés avec T-Recorder (ce sera aussi l'endroit où le script temporaire sera créé)
Dim $temporisation=2	;Temporisation entre le rejeu de deux scripts AutoIt - unité: secondes
Dim $bouclerRejeu=False	; Flag qui conditionne la commande de bouclage de l'exécution des scripts à rejouer
Dim $nbrRepetitions=0	;Nombre de répétitions : si $bouclerRejeu est vrais et si $nbrRepetitions vaut 0 alors boucle infinie; sinon si $nbrRepetitions > 0 alors boucle "For" finie; sinon pas de boucle

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

	Global $_lbScriptsARejouer = GUICtrlCreateLabel("Scripts à rejouer", 424, 64, 118, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_btRechRacine = GUICtrlCreateButton("...", 216, 64, 19, 25, BitOR($BS_FLAT,$WS_BORDER))
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)

	Global $List1 = GUICtrlCreateListView("", 32, 96, 337, 214)
	_GUICtrlListView_AddColumn($List1, "Scripts créés", 300);
	_GUICtrlListView_SetExtendedListViewStyle($List1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))


	Global $_lbDureeAttente = GUICtrlCreateLabel("Durée attente entre le rejeu de deux scripts", 24, 320, 254, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $InputTempo = GUICtrlCreateInput("0", 280, 320, 57, 24, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0xFFFF00)

	Global $List2 = GUICtrlCreateListView("", 424, 96, 345, 214)
	_GUICtrlListView_AddColumn($List2, "Scripts à rejouer", 300);
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

	Global $Label2 = GUICtrlCreateLabel("Nombre répétitions", 616, 320, 113, 20)
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

	Global $_lbPathToScript = GUICtrlCreateLabel("Racine vers les scripts AutoIt créés avec T-Recorder", 32, 368, 260, 17)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_lbPathToRejeu = GUICtrlCreateLabel("Script de rejeu créé", 32, 400, 166, 17)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Global $_tbPathToScripts = GUICtrlCreateInput("", 296, 368, 489, 21)

	Global $_tbPathToRejeu = GUICtrlCreateInput("", 296, 400, 489, 21)

	GUIStartGroup()

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	;Met à jour l'état de la zone de saisie du nombre de répétition
	MgtButtonAvailability($InputNbrRept, $GUI_DISABLE)

	;On ajoute dans la liste des scripts créés par T-Recorder tous les scripts AutoIt présents dans le répertoire racine choisi (on ne sélectionnera pas le script temporaire si présent)
	AjouterScriptsDansListeScriptsCrees($pathToScripts)

	;Rafraichit les chemins dans les zones de texte
	MgtChemins()

	;Met à jour l'état des boutons de l'IHM
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
				; Ouvre une boite de dialogue de recherche de répertoire afin d'aller pointer la racine des scripts AutoIt qui contiennent ceux créés avec T-Recorder
				RechercherRacineDesScripts($confPathToScripts)	;$confPathToScripts est affecté par le fichier de configuration pour définir un répertoire depuis lequel faire des recherches de fichiers
				;On ajoute dans la liste des scripts créés par T-Recorder tous les scripts AutoIt présents dans le répertoire racine choisi (on ne sélectionnera pas le script temporaire si présent)
				AjouterScriptsDansListeScriptsCrees($pathToScripts)
				;Met à jour l'état des boutons de l'IHM
				MgtButtons()
				;Rafraichit les chemins dans les zones de texte
				MgtChemins()

			Case $_btAjouter
				; Copie dans la liste des scripts AutoIt à rejouer ceux choisis dans la liste des scripts créés avec T-Recorder
				$tabIdx = _GUICtrlListView_GetSelectedIndices($List1, True)
				If ($tabIdx[0] > 0) Then
					For $i=1 To $tabIdx[0]
						$item = _GUICtrlListView_GetItem($List1, $tabIdx[$i])	;Récupère l'élément sélectionné à partir de son index dans la liste des scripts créés
						AjouterScriptDansListeScriptsARejouer($item[3])			;Ajoute l'élément sélectionné dans la liste des scripts à rejouer
					Next
				EndIf
				;Met à jour l'état des boutons de l'IHM
				MgtButtons()

			Case $_btSuppr
				; Supprime de la liste des scripts à rejouer ceux sélectionnés
				$tabIdx = _GUICtrlListView_GetSelectedIndices($List2, True)
				If ($tabIdx[0] > 0) Then
					For $i=1 To $tabIdx[0]
						_GUICtrlListView_DeleteItem($List2, $tabIdx[$i])		; supprime l'élément sélectionné de la liste des scripts à rejouer
					Next
				EndIf
				;Met à jour l'état des boutons de l'IHM
				MgtButtons()

			Case $_cbBouclerRejeu
				$bouclerRejeu = IsChecked($_cbBouclerRejeu)
				If ($bouclerRejeu) Then
					MgtButtonAvailability($InputNbrRept, $GUI_ENABLE)
				Else
					MgtButtonAvailability($InputNbrRept, $GUI_DISABLE)
				EndIf

			Case $_btExecuter
				$tempo=GUICtrlRead($InputTempo)	;Lit la valeur de la tempo saisie, ou récupérée du fichier de configuration TPlayScr.ini
				CreerTemporaryScript($pathToRejeu, $pathToScripts, $tempo)
				ExecuterScript($pathToRejeu & "\\" & $temporaryScript)

			Case $_btSave
				$tempo=GUICtrlRead($InputTempo)	;Lit la valeur de la tempo saisie, ou récupérée du fichier de configuration TPlayScr.ini
				;La sauvegarde du script temporaire est réalisée en recréant le script (si existe) et en y ajoutant tous les fichiers scripts mentionnés dans la liste des scripts à rejouer
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
							"Paramètres (.ini):" & @CRLF & _
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

;Ouvrer une boite de dialogue qui demande à l'opérateur de choisir le répertoire racine des fichiers scripts AutoIt candidats aux rejeux
Func RechercherRacineDesScripts($path)

	If ($debug <> 0) Then
  		MsgBox(0,"DEBUG", "RechercherRacineDesScripts  Argument= " & $path & @CRLF)
	EndIf

	$selectedPath = FileSelectFolder("Veuillez sélectionner le répertoire racine des fichiers scripts AutoIt candidats aux rejeux.", $path, 0)
	If @error Then
		$pathToScripts = $confPathToScripts
	Else
		$pathToScripts = $selectedPath

		If ($pathToScripts <> $confPathToScripts) Then

			;Sauvegarde dans le fichier de config TPlayScr.ini le nouveau path vers les scripts AutoIt créés avec T-Recorder
			IniWrite($pathToTPlayScr & "\TPlayScr.ini", "PLAY", "pathToScripts", '"' & $pathToScripts & '"')
			;Rechargement des paramètres de configuration
			LoadConfig()
		EndIf

	EndIf

	If ($debug <> 0) Then
		MsgBox(0,"DEBUG", "$pathToScripts= " & $pathToScripts & @CRLF)
	EndIf

EndFunc

;Ajoute dans la liste des scripts candidats aux rejeux tous les scripts AutoIt présents dans le répertoire $path
Func AjouterScriptsDansListeScriptsCrees($path)
	If ($path <> "") Then
		;Supprime tous les éléments de la liste
		_GUICtrlListView_DeleteAllItems($List1)

		;Récupère tous les fichiers '.au3' présents dans le répertoire $path
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

;Ajoute le script donné en argument dans la liste des scripts à rejouer le script
Func AjouterScriptDansListeScriptsARejouer($script)
	If ($script <> "") Then

		;Vérifie d'abord la présence de l'élément dans la liste
  		$idx = _GUICtrlListView_FindInText($list2, $script, -1)
		If ($idx < 0) Then
			; chaque fichier '.au3' est ajouté dans la liste
			_GUICtrlListView_AddItem($List2, $script)
		EndIf

	EndIf

EndFunc

;Crée le fichier temporary.au3 à l'emmplacement spécifié
;Ajoute une temporisation entre chaque fichier script ajouté
Func CreerTemporaryScript($pathRejeu, $pathScriptsTRec, $tempo=0)

	If ($pathRejeu <> "") Then

		;Détermine le nombre de fichiers scripts à rejouer
		$cnt = _GUICtrlListView_GetItemCount($List2)
		If ($cnt > 0) Then

			; créer le fichier temporary.au3 : $pathRejeu & "\" & $temporaryScript :: si le fichier existe on l'écrase !!
			If (FileExists($pathRejeu & "\" & $temporaryScript)) Then
				FileDelete($pathRejeu & "\" & $temporaryScript)
			EndIf

			FileWrite($pathRejeu & "\" & $temporaryScript, "")

			;Ouvre le fichier et y ajoute tous les noms des fichiers scripts à rejouer récupéré de la liste des scripts à rejouer
			; ...Pour chaque fichier script à ajouter, on crée une ligne insérée dans le fichier temporaire : "RunWait("AutoIt3.exe """" & """" & $script & """") "
			; REM: on ajoute, entre chaque ligne d'appel d'un nom de script à rejouer, une commande de temporisation : "R_Timer(" & $tempo & ")

			$file = FileOpen($pathRejeu & "\" & $temporaryScript, 1)

			;Composition du fichier de script "temporary.au3"
			AddScriptHeader($file)		;ajoute au début du fichier tous les fichiers d'en-tête utiles

			;Création dans le script de rejeu d'une commande pour créer un fichier de résultat pour y enregistrer les commentaires de chaque test
			FileWriteLine($file, "")
			FileWriteLine($file, ";Crée un fichier de résultat pour y cumuler le résultat des tests")
			$pathResultats = '"' & $pathRejeu & '\' & $ResultatRejeu & '"'
			FileWriteLine($file, '$fileResultat = R_CreerFichierResultatRejeu(' & $pathResultats & ')')
			FileWriteLine($file, "")
			;

			$nbrRepet = GUICtrlRead($InputNbrRept)	;Lit le nombre de répétition
			if ($nbrRepet <> "" And Not IsNumber(Number($nbrRepet))) Then
				MsgBox(0, "ERREUR", "Le nombre de répétitions saisi doit être un nombre entier, ou sinon il doit rester vide !")
				return
			EndIf

			If ($bouclerRejeu) Then

				FileWriteLine($file, "")
				FileWriteLine($file, "; $$$$$$$$$$$$ Répétitions du rejeu des scripts $$$$$$$$$$$$$$$$$$$$$$")

				FileWriteLine($file, "	$nbrIteration = 1")
				FileWriteLine($file, "")
				If ($nbrRepet == "") Then

					FileWriteLine($file, "While True")

				ElseIf (Number($nbrRepet) > 0) Then

					FileWriteLine($file, "For $cnt=1 To " & Number($nbrRepet))

				EndIf

				FileWriteLine($file, "")

				FileWriteLine($file, '	R_AddLigneDansFichierResultatRejeu($fileResultat, " =============== Itération n° " & $nbrIteration & " ===========")')
				FileWriteLine($file, "")

			EndIf

  			For $i=0 To $cnt-1

				FileWriteLine($file, "")
				FileWriteLine($file, ";****************** Script à rejouer n° " & $i & " ************")
				$item = _GUICtrlListView_GetItem($List2, $i)	;Récupère l'élément sélectionné à partir de son index dans la liste des scripts à rejouer
				$instr= '"AutoIt3.exe " & """' & $pathScriptsTRec & "\" & $item[3] & '"""'
				$instructionExe = '$exitCode = RunWait(' & $instr & ')'	;Création de l'instruction d'exécution du script qui correspond à l'item : Run("AutoIt3.exe " & """" & $item[3] & """")
				FileWriteLine($file, $instructionExe)

				FileWriteLine($file, "If $exitCode == 0 Then")
				FileWriteLine($file, "")
				FileWriteLine($file, "	;Trace dans le fichier de résultat des tests")
				$resultatScript = '	R_AddResultatsScriptDansFichierResultatRejeu($fileResultat, "' & $pathScriptsTRec & "\" & $item[3] & '.trp")'
				FileWriteLine($file, $resultatScript)
				FileWriteLine($file, "")

 				If ($tempo > 0) Then
					;Ajout d'une tempo avant de passer à l'exécution du script suivant, ou de terminer le rejeu
					$ligne = "	R_Timer(" & $tempo & ")"
					FileWriteLine($file, $ligne)
				EndIf

				FileWriteLine($file, "Else")
				FileWriteLine($file, "")
				FileWriteLine($file, "	;Trace dans le fichier de résultat des tests")
				FileWriteLine($file, "	R_AddLigneDansFichierResultatRejeu($fileResultat, " & """ARRET D'URGENCE demandé ! """ & ")")
				FileWriteLine($file, "")
				FileWriteLine($file, "	MsgBox(0," & """STOP""" & ", " & """Arrêt d'urgence demandé !""" & ");")

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

			;Création dans le script de rejeu d'une commande pour créer un fichier de résultat pour y enregistrer les commentaires de chaque test
			FileWriteLine($file, "")
			FileWriteLine($file, ";Ferme le fichier de résultat des tests")
			FileWriteLine($file, "R_FermerFichierResultatRejeu($fileResultat)")
			FileWriteLine($file, "")
			;

			AddScriptFooter($file)		;ajoute une fin de fichier

			FileClose($file)

		Else
			MsgBox(0,"ERREUR", "Création du fichier " & $pathRejeu & "\" & $temporaryScript & " impossible car aucun script à rejouer n'a été défini !")
			return False
		EndIf

	Else
		MsgBox(0,"ERREUR", "Création du fichier impossible car non spécifié !")
		return False
	EndIf

	MsgBox(0,"INFO", "Fichier " & $pathRejeu & "\" & $temporaryScript & " créé.", 2)
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
		FileWriteLine($file, "	MsgBox(0," & """STOP""" & ", " & """Arrêt d'urgence demandé !""" & ");")
		FileWriteLine($file, "	ExitLoop")
		FileWriteLine($file, "EndIf")
		FileWriteLine($file, "")
	EndIf
EndFunc

;Change l'état d'un contrôle
Func MgtButtonAvailability($idCtrlID, $etat)
;Dim $_btExecuter, $_btQuitter, $_btSave;	;Les id des controls de l'IHM de type 'Button'
	If ($idCtrlID) Then
		GUICtrlSetState($idCtrlID, $etat)
	EndIf

EndFunc

;Met à jour l'état des boutons présents sur l'IHM
Func MgtButtons()
	;Contrôle s'il y a au moins un script à rejouer dans la liste
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

;Lance l'exécution d'un script AutoIt
Func ExecuterScript($script)

	If ($script <> "") Then
		;ATTENTION : doit vérifier l'existence du script avant de le jouer !!
		If (FileExists($script)) Then
			RunWait('AutoIt3.exe "' & $script & '"')
		Else
			MsgBox(0, "Erreur", "Fichier script " & $script & " absent !")
		EndIf
	EndIf

EndFunc

;Lance l'exécution d'un programme
Func ExecuterExe($pathToExe)
	If ($pathToExe <> "") Then
		;ATTENTION : doit vérifier l'exsitence du programme avant de l'exécuter !!
		If (FileExists($pathToExe)) Then
			RunWait($pathToExe)
		Else
			MsgBox(0, "Erreur", "Fichier exécutable " & $pathToExe & " absent !")
		EndIf
	EndIf

EndFunc

;Retourne True si et seulement si le composant remonte $GUI_CHECKED (cas d'une case à cocher ou d'un Radio bouton)
Func IsChecked($idCtrlID)
	Return BitAND(GUICtrlRead($idCtrlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc

;================================================================== FIN ===========================================================================
