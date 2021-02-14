#include-once

#include <ScreenCapture.au3>
#include <Array.au3>

#cs -----------------------------------------
	Démarre le NMC
#ce ----------------------------------------
Func T_Start_NMC()
	Send("#r")
	WinWaitActive("Exécuter")
	Send("D:\nmc\Raccourcis NMC\NMC (CMX).lnk")
	MouseClick("left", 160, 145) ; clic sur OK
EndFunc   ;==>T_Start_NMC
Func T_Stop_NMC()
	ConsoleWrite("Entre" & @CRLF)
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	T_MouseClick("left", 68, 90)
	T_MouseClick("left", 86, 280)
	;*********** Arrêt de l'application ***********
	T_WinWaitActive("Arrêt de l'application", 368, 147, @ScriptLineNumber)
	T_MouseClick("left", 89, 119)
	T_WinWaitClose("Arrêt de l'application", @ScriptLineNumber)
	;*********** Arret de l'application ***********
	T_WinWaitActive("Arret de l'application", 273, 69, @ScriptLineNumber)
	T_WinWaitClose("Arret de l'application", @ScriptLineNumber)
	Exit(23)
EndFunc   ;==>T_Stop_NMC
Func T_Contexte_Initial($manoeuvre = "D:\VNR\TESTS_FONCTIONNELS\01-PLANIFICATION\mnv\0000_mvn_vide")
	local $path_manoeuvre
	local $redemarrage_du_NMC = false;
	local $isMvnVide = StringRegExp($manoeuvre, ".*\\0000\w+", 0)
	ConsoleWrite($isMvnVide & @CRLF)
	if not $isMvnVide Then
		$path_manoeuvre = @ScriptDir & "\mnv\" & $manoeuvre
		ConsoleRead($path_manoeuvre & @CRLF)
	Else
		$path_manoeuvre = $manoeuvre
		ConsoleWrite($path_manoeuvre & @CRLF)
	EndIf
	If not WinExists("Bureau") Then
		ConsoleWrite("Démarrage du NMC");
		If(StringCompare($manoeuvre, "raz") == 0) Then
			ConsoleWrite(" avec RAZ" & @CRLF);
			T_Demarre_NMC_TC_raz()
		Else
			ConsoleWrite(" avec restauration d'une manoeuvre" & @CRLF);
			T_Demarre_NMC_TC_avec_mnv($path_manoeuvre)
		EndIf
		ConsoleWrite("Done." & @CRLF)
		$redemarrage_du_NMC = true;
	Else
		;ConsoleWrite ("Le bureau est présent !"&@CRLF)
	EndIf
	return $redemarrage_du_NMC
EndFunc   ;==>T_Contexte_Initial
Func T_Demarre_NMC_TC_avec_mnv($manoeuvre)
	T_Start_NMC()
	;*********** LGCONF ***********
	T_WinWaitActive("LGCONF", 535, 469, @ScriptLineNumber)
	;T_WinWaitActive("LGCONF",535,459,@ScriptLineNumber)
	T_MouseClick("left", 402, 129)
	;*********** Première TC ***********
	T_WinWaitActive("Première TC", 266, 397, @ScriptLineNumber)
	;Code opérateur : valable pour stations DR
	T_MouseClick("left", 157, 205)
	T_Send("1234")
	T_MouseClick("left", 155, 229)
	T_Send("1234")
	T_MouseClick("left", 29, 329)
	T_MouseClick("left", 38, 380, 37, 380)
	;*********** Fenêtre d'interrogation ***********
	T_WinWaitActive("Fenêtre d'interrogation", 312, 118, @ScriptLineNumber)
	T_MouseClick("left", 53, 87)
	;*********** Démarrage de la TC depuis sauvegarde ***********
	T_WinWaitActive("Démarrage de la TC depuis sauvegarde", 666, 635, @ScriptLineNumber)
	T_MouseClick("left", 598, 306)
	;*********** Fichier à restaurer ***********
	T_WinWaitActive("Fichier à restaurer", 563, 409, @ScriptLineNumber)
	T_MouseClick("left", 337, 334)
	T_Send($manoeuvre)
	T_MouseClick("left", 504, 335)
	;*********** Démarrage de la TC depuis sauvegarde ***********
	T_WinWaitActive("Démarrage de la TC depuis sauvegarde", 666, 635, @ScriptLineNumber)
	T_MouseClick("left", 483, 446)
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
EndFunc   ;==>T_Demarre_NMC_TC_avec_mnv
Func T_Demarre_NMC_TC_raz()
	T_Start_NMC()
	;*********** LGCONF ***********
	T_WinWaitActive("LGCONF", 535, 469, @ScriptLineNumber)
	;T_WinWaitActive("LGCONF",535,459,@ScriptLineNumber)
	T_MouseClick("left", 402, 129)
	;*********** Première TC ***********
	T_WinWaitActive("Première TC", 266, 397, @ScriptLineNumber)
	;Code opérateur : valable pour stations DR
	T_MouseClick("left", 157, 205)
	T_Send("1234")
	T_MouseClick("left", 155, 229)
	T_Send("1234")
	;T_MouseClick("left",29,329) ;démarrage sur sauvegarde
	T_MouseClick("left", 40, 370)
	;*********** Fenêtre d'interrogation ***********
	T_WinWaitActive("Fenêtre d'interrogation", 317, 118, @ScriptLineNumber)
	T_Send("{ENTER}")
	;T_MouseClick("left",53,87)
	;*********** Démarrage de la TC depuis sauvegarde ***********
	;T_WinWaitActive("Démarrage de la TC avec RAZ des données",666,635,@ScriptLineNumber)
	;T_MouseClick("left",598,306)
	;*********** Fichier à restaurer ***********
	;T_WinWaitActive("Fichier à restaurer",563,409,@ScriptLineNumber)
	;T_MouseClick("left",337,334)
	;T_Send($manoeuvre)
	;T_MouseClick("left",504,335)
	;*********** Démarrage de la TC depuis sauvegarde ***********
	;T_WinWaitActive("Démarrage de la TC depuis sauvegarde",666,635,@ScriptLineNumber)
	;T_MouseClick("left",483,446)
	;*********** Bureau ***********
	;T_WinWaitClose("Démarrage de la TC avec RAZ des données",666,635,@ScriptLineNumber)
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
EndFunc   ;==>T_Demarre_NMC_TC_raz
Dim $tableau_process_a_surveiller[6] = ["Microsoft Visual C++ Runtime Library", "PGRAPH_MMI.exe", "process_2", "process_3", "process_4", "process_5"]
Func T_Surveillance_plantage_process($script_dir)
	;ConsoleWrite ("T_Surveillance_process"&@CRLF)
	for $nom_process in $tableau_process_a_surveiller
		;ConsoleWrite ($nom_process&@CRLF)
		if WinActive($nom_process) Then
			ConsoleWrite("Match !" & @CRLF)
			; Un plantage a été observé, le test doit s'arreter.
			; Un arrêt propre est constitué de 3 étapes :
			; 1] snapshot de l'ecran totale
			; 2] sauvegarde des traces
			; 3] sauvegarde de la manoeuvre (si le process tourne toujours)
			; 1] snapshot de l'ecran totale
			; =============================
			_ScreenCapture_Capture($script_dir & "\plantage.jpg")
			; Puis je ferme les fenêtres de plantage
			If winExists("Microsoft Visual C++ Runtime Library") Then
				MouseClick("left", 192, 139, 1, 40) ; OK
				Sleep(1000)
				If winExists("Fenêtre d'erreur") Then
					MouseClick("left", 167, 96, 1, 40) ; OK
				Endif
				T_Traitement_plantage($script_dir, $nom_process)
				ExitLoop
			EndIf
			If winExists("PGRAPH_MMI.exe") Then
				;*********** PGRAPH_MMI.exe ***********
				MouseClick("left", 362, 165) ; OK
				;*********** Erreur du programme ***********
				;WinWaitActive("Erreur du programme")
				;*********** Fenêtre d'erreur ***********
				WinWaitActive("Fenêtre d'erreur")
				MouseClick("left", 197, 95)
				;*********** Erreur du programme ***********
				WinWaitActive("Erreur du programme")
				T_MouseClick("left", 200, 111)
				T_Traitement_plantage($script_dir, $nom_process)
				ExitLoop
			Endif
		EndIf
	Next
EndFunc   ;==>T_Surveillance_plantage_process
Func T_Traitement_plantage($script_dir, $nom_process)
	;1] Snapshot de l'ecran totale
	;TODO ajouter l'heure dans le nom
	;_ScreenCapture_Capture($script_dir &"\plantage.jpg")
	;2]Sauvergarde des traces
	;Comment ziper un réperotire ?
	;Sauvegarde de la manoeuvre (si c'est possible)
	ConsoleWrite("T_Traitement_plantage" & @CRLF)
	ConsoleWrite("Nom du process :" & $nom_process & @CRLF)
	;if not $nom_process ($nom_process,"padmin_db.exe") Then ; TODO
	T_Assert_Traitement()
	;EndIf
EndFunc   ;==>T_Traitement_plantage
Func T_Assert_Traitement()
	local $pathNok = @ScriptDir & "\NOK\" & StringMid(@ScriptName, 1, StringLen(@ScriptName) - 4) & "\"
	local $genericFile = StringMid(@ScriptName, 1, StringLen(@ScriptName) - 4)
	local $snapshotPath = $pathNok & $genericFile & ".jpg"
	local $manoeuvre = $pathNok & $genericFile & ".mnv"
	local $trace = "D:\nmc\trace "
	If not FileExists($pathNok) Then
		ConsoleWrite("Le répertoire :[" & $pathNok & "] n'existe pas, on le créé" & @CRLF)
		DirCreate($pathNok)
	EndIf
	; le zip est constitué de :
	; 1] Snapshot de l'écran
	; 2] Sauvegarde des traces
	; 3] Sauvegarde de la manoeuvre au moment de l'assertion
	_ScreenCapture_Capture($snapshotPath)
	DirCopy("D:\nmc\trace", $pathNok & "trace", 1)
	T_Sauvegarde_mnv_complete($manoeuvre)
	; On Zip le tout
	Run("C:\Program Files\7-Zip\7z.exe a -r " & $pathNok & $genericFile & ".zip " & ".\NOK\" & $genericFile & "\*", "", @SW_HIDE)
	T_Stop_NMC()
EndFunc   ;==>T_Assert_Traitement
Func T_Sauvegarde_manoeuvre()
	ConsoleWrite("#1&" & @CRLF)
	local $nom_manoeuvre = @ScriptDir & "\mnv\" & StringMid(@ScriptName, 1, StringLen(@ScriptName) - 4); on retire le ".au3"
	ConsoleWrite($nom_manoeuvre & @CRLF)
	T_Sauvegarde_mnv_complete($nom_manoeuvre)
	;ConsoleWrite(@ScriptName&@CRLF)
	;ConsoleWrite(@ScriptDir&@CRLF)
	;ConsoleWrite(@ScriptFullPath&@CRLF)
	;ConsoleWrite(@WorkingDir&@CRLF)
	;T_Sauvegarde_mnv_complete($nom_manoeuvre)
EndFunc   ;==>T_Sauvegarde_manoeuvre
Func T_Sauvegarde_mnv_complete($nom_manoeuvre)
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	T_MouseClick("left", 69, 90)
	T_MouseClick("left", 82, 175)
	;*********** Création ou Restauration d'une sauvegarde ***********
	T_WinWaitActive("Création ou Restauration d'une sauvegarde", 449, 572, @ScriptLineNumber)
	T_MouseClick("left", 401, 216)
	;*********** Sélection d'un fichier ***********
	T_WinWaitActive("Sélection d'un fichier", 563, 412, @ScriptLineNumber)
	T_MouseClick("left", 262, 363)
	T_Send($nom_manoeuvre)
	T_MouseClick("left", 493, 363)
	; Modification fiche pour prendre en compte l'écrasement de la manoeuvre
	Sleep(1000)
	if(FileExists($nom_manoeuvre)) Then
		;*********** Sélection d'un fichier ***********
		T_WinWaitActive("Sélection d'un fichier", 546, 119, @ScriptLineNumber)
		;T_MouseClick("left",228,94) ; OK pour confirmer l'ecrasement de la manoeuvre
		T_Send("{TAB}{ENTER}")
		T_WinWaitClose("Sélection d'un fichier", @ScriptLineNumber)
	Endif
	T_WinWaitActive("Création ou Restauration d'une sauvegarde", 449, 572, @ScriptLineNumber)
	T_MouseClick("left", 21, 58)
	;##### WAIT PARTIAL WINDOW ##### "Pret"
	;T_Wait_Partial_Window("Création ou Restauration d'une sauvegarde",9,548,35,566,"23AF1A23F50E7438C3F47F1558F7E6A5",@ScriptLineNumber); 1_sauvegarde_mnv_Création ou Restauration d'une sauvegarde.bmp
	T_Wait_Partial_Window("Création ou Restauration d'une sauvegarde", 8, 554, 36, 568, "10D4415F6816EAF48502E9F70F549A5E", @ScriptLineNumber); 1_test2_Création ou Restauration d'une sauvegarde.bmp
	;MsgBox(1,"Attente","Attente")
	T_MouseClick("left", 435, 12)
	T_WinWaitClose("Création ou Restauration d'une sauvegarde", @ScriptLineNumber)
EndFunc   ;==>T_Sauvegarde_mnv_complete
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Title	: T_Ouvre_graphe_geo_calque_planif
	Goal	: Ouvre le graphe géoréférencé et applique le calque planification
	Input	: Aucune
	Output : Aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func T_Ouvre_graphe_geo_calque_planif()
	ConsoleWrite("T_Ouvre_graphe_geo_calque_planif" & @CRLF)
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	ConsoleWrite("Le bureau est affiché" & @CRLF)
	T_MouseClick("left", 135, 91)
	T_MouseClick("left", 151, 239)
	T_MouseClick("left", 238, 257)
	;*********** Planisphère 1 ***********
	T_WinWaitActive("Planisphère 1", 846, 693, @ScriptLineNumber)
	T_MouseClick("left", 82, 122)
	;T_Send("31UES100100") ; LILLE
	T_Send("31UCP500500")
	T_MouseClick("left", 15, 63)
	;*********** Gestion des calques 1 [géoréférencé] ***********
	T_WinWaitActive("Gestion des calques 1 [géoréférencé]", 468, 508, @ScriptLineNumber)
	T_MouseClick("left", 53, 279)
	T_MouseClick("left", 228, 202)
	T_MouseClick("left", 21, 59)
EndFunc   ;==>T_Ouvre_graphe_geo_calque_planif
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Title	: T_Ouvre_graphe_geo_calque_conduite
	Goal	: Ouvre le graphe géoréférencé et applique le calque conduite
	Input	: Aucune
	Output : Aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func T_Ouvre_graphe_geo_calque_conduite()
	ConsoleWrite("T_Ouvre_graphe_geo_calque_conduite" & @CRLF)
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	T_MouseClick("left", 135, 91)
	T_MouseClick("left", 151, 239)
	T_MouseClick("left", 238, 257)
	;*********** Planisphère 1 ***********
	T_WinWaitActive("Planisphère 1", 846, 693, @ScriptLineNumber)
	T_MouseClick("left", 82, 122)
	;T_Send("31UES100100") ; LILLE
	T_Send("31UCP500500")
	T_MouseClick("left", 15, 63) ; biscotte
	;*********** Gestion des calques 1 [géoréférencé] ***********
	T_WinWaitActive("Gestion des calques 1 [géoréférencé]", 468, 508, @ScriptLineNumber)
	T_MouseClick("left", 64, 133) ; CONDUITE
	T_MouseClick("left", 228, 202) ; Flèche de sélection
	T_MouseClick("left", 21, 59) ; Biscotte
	;*********** Graphe géoréférencé 1 [Calque : CONDUITE/TRANSMISSION] ***********
	T_WinWaitActive("Graphe géoréférencé 1 [Calque : CONDUITE/TRANSMISSION]", 915, 875, @ScriptLineNumber)
EndFunc   ;==>T_Ouvre_graphe_geo_calque_conduite
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Title	: T_Ouvre_premier_plan_manoeuvre
	Goal	: Ouvre le premier plan de la manoeuvre courante
	Input	: Aucune
	Output : Aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func T_Ouvre_le_premier_plan_de_la_manoeuvre_courante()
	;*********** Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION] ***********
	T_WinWaitActive("Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION]", 915, 875, @ScriptLineNumber)
	T_MouseClick("left", 199, 33)
	T_MouseClick("left", 199, 57)
	T_MouseClick("left", 282, 84)
	;*********** Ouverture d'un plan ***********
	T_WinWaitActive("Ouverture d'un plan", 388, 327, @ScriptLineNumber)
	T_MouseClick("left", 46, 59)
	T_MouseClick("left", 40, 302)
	T_WinWaitClose("Ouverture d'un plan", @ScriptLineNumber)
	;*********** Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION] ***********
	T_WinWaitActive("Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION]", 915, 875, @ScriptLineNumber)
EndFunc   ;==>T_Ouvre_le_premier_plan_de_la_manoeuvre_courante
#cs -----------------------------------------
	Quitte le NMC à partir de la fenêtre LGCONF
#ce ----------------------------------------
Func Quit_NMC()
	T_Log("clic sur LGCONF", @ScriptLineNumber)
	;*********** LGCONF ***********
	T_WinWaitActive("LGCONF", 523, 459, @ScriptLineNumber)
	T_MouseClick("left", 266, 45)
	T_Log("clic sur croix pour fermer LGCONF", @ScriptLineNumber)
	T_MouseClick("left", 508, 13)
	T_Log("clic sur pop-up de confirmation", @ScriptLineNumber)
	;*********** Fenêtre d'interrogation ***********
	T_WinWaitActive("Fenêtre d'interrogation", 311, 118, @ScriptLineNumber)
	T_MouseClick("left", 141, 9)
	T_Log("clic sur ok", @ScriptLineNumber)
	T_MouseClick("left", 51, 91)
EndFunc   ;==>Quit_NMC
Func ExtraireFH($sInput)
	return StringRegExpReplace($sInput, "\d\/[A-Z]\/\d[A-Z]\d{2}\t\d\/[A-Z]\/\d[A-Z]\d{2}\t\d+\t(Câble|Satellite|Satellite N4|Troposphérique|Concession)\t\d+\t(\n)?", "")
EndFunc   ;==>ExtraireFH
Func ExtraireSatellite($sInput)
	return StringRegExpReplace($sInput, "\d\/[A-Z]\/\d[A-Z]\d{2}\t\d\/[A-Z]\/\d[A-Z]\d{2}\t\d+\t(FH|Câble|Satellite N4|Troposphérique|Concession)\t\d+\t(\n)?", "")
EndFunc   ;==>ExtraireSatellite
Func ExtraireSatelliteN4($sInput)
	return StringRegExpReplace($sInput, "\d\/[A-Z]\/\d[A-Z]\d{2}\t\d\/[A-Z]\/\d[A-Z]\d{2}\t\d+\t(FH|Câble|Satellite|Troposphérique|Concession)\t\d+\t(\n)?", "")
EndFunc   ;==>ExtraireSatelliteN4
Func ExtraireTropospherique($sInput)
	return StringRegExpReplace($sInput, "\d\/[A-Z]\/\d[A-Z]\d{2}\t\d\/[A-Z]\/\d[A-Z]\d{2}\t\d+\t(FH|Câble|Satellite|Satellite N4|Concession)\t\d+\t(\n)?", "")
EndFunc   ;==>ExtraireTropospherique
Func ExtraireConcession($sInput)
	return StringRegExpReplace($sInput, "\d\/[A-Z]\/\d[A-Z]\d{2}\t\d\/[A-Z]\/\d[A-Z]\d{2}\t\d+\t(FH|Câble|Satellite|Satellite N4|Troposphérique)\t\d+\t(\n)?", "")
EndFunc   ;==>ExtraireConcession
Func T_PriseContactReseau1()
	;*********** Bureau ***********
	T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	T_MouseClick("left", 137, 88) ; fonction
	T_MouseClick("left", 139, 108) ; CONDUITE
	T_MouseClick("left", 246, 352) ; Gestion des fréquences
	;*********** Accès au coordinateur de fréquences ***********
	T_WinWaitActive("Accès au coordinateur de fréquences", 508, 438, @ScriptLineNumber)
	T_MouseClick("left", 39, 153) ; sélection du réseau 1
	T_MouseClick("left", 110, 34) ; Contact
	T_MouseClick("left", 114, 54) ; Prise de contact
	;##### WAIT PARTIAL WINDOW #####
	T_Wait_Partial_Window("Accès au coordinateur de fréquences", 7, 419, 36, 433, "D89CDB33E334BCC6FB0CC9570E31BAF3", @ScriptLineNumber); 5_0080_creation_projet_ouverture_liaisons_Accès au coordinateur de fréquences.bmp
	T_MouseClick("left", 496, 11) ; X
	T_WinWaitClose("Accès au coordinateur de fréquences", @ScriptLineNumber)
EndFunc   ;==>T_PriseContactReseau1
;~ Func T_RechercheLiaisonPourCreationJonction ( $identificationLiaison, $ShouldExist=True)
;~ 	;*********** Création d'une jonction planifiée 1 ***********
;~ 	T_WinWaitActive("Création d'une jonction planifiée 1",478,738,@ScriptLineNumber)
;~ 	T_MouseClick("left",325,582) ; Sélection de toutes les liaisons
;~ 	T_Send("^c") 				 ; Copie dans le Clipboard
;~ 	T_MouseClick("left",329,595) ; Déselection des liaisons
;~ 	T_MouseClick("left",31,616)  ; On Sélectionne la première liaison
;~ 	$line = T_RechercheChaine($identificationLiaison)
;~ 	ConsoleWrite("$line = [" & $line & "]" & @CRLF)
;~ 	if ((($line == -1) AND $ShouldExist) OR (($line > 0) AND NOT $ShouldExist)) Then
;~ 		; Erreur Traitement à faire pour sortir
;~ 		T_End()
;~ 	ElseIf ($line > 0) Then
;~ 		ConsoleWrite("Pass !" & @CRLF)
;~ 		T_Send("{DOWN " & $line & "}")
;~ 		T_MouseClick("left",384,590)
;~ 	Else
;~ 		ConsoleWrite ("Pas de liason : comportement OK" & @CRLF)
;~ 	EndIf
;~ EndFunc
;~ Func T_RechercheChaine($identificationLiaison)
;~ 	$clipboard  = ClipGet()
;~ 	$cptLigne = 0;
;~ 	$array = StringSplit($clipboard, @CRLF)
;~ 	ConsoleWrite("$array[0] = [" & $array[0] & "]" & @CRLF)
;~ 	If ( $array[0] > 1) Then
;~ 			ConsoleWrite ("Il y a bien des liaisons dans la liste" & @CRLF)
;~ 			FOR $line IN $array
;~ 				ConsoleWrite("$line = [" & $line & "]" & @CRLF)
;~ 				if ( StringInStr($line, $identificationLiaison) <> 0) Then
;~ 						return $cptLigne - 1 ; On retire la ligne des noms de colonne
;~ 					Else
;~ 						$cptLigne = $cptLigne + 1
;~ 				Endif
;~ 			NEXT
;~ 		Else
;~ 			ConsoleWrite ("Il n'y a pas de liaisons dans la liste" & @CRLF)
;~ 			return -1;
;~ 	EndIf
;~ EndFunc
;~ Global Enum $HAUT_DEBIT, $BAS_DEBIT, $MIXTE, $NON_SIGNIFICATIF, $NOMBRE_CATEGORIE_DEBIT
;~ Func SelectionCategorieDebit($categorieDebit)
;~ 	Local $isOK = False
;~ 	Local $boucle = 0;
;~ 	T_MouseClick("left",194,266)
;~ 	;Sleep (1000)
;~ 	T_MouseClick("left",194,266)
;~ 	while ((not $isOK) And ($boucle < $NOMBRE_CATEGORIE_DEBIT))
;~ 	Switch $categorieDebit
;~ 		Case $HAUT_DEBIT
;~ 			;##### PARTIAL WINDOW FUNCTION #####
;~ 			T_Log_Function("Haut Débit",@ScriptLineNumber)
;~ 			$isOK = T_Function_Partial_Window("Création d'un pion géré planifié 1",138,257,204,278,"8F0E5B9FA4616F480BC102E8C6D43C7D",@ScriptLineNumber); 1_frederic_Création d'un pion géré planifié 1.bmp
;~ 		Case $BAS_DEBIT
;~ 			;##### PARTIAL WINDOW FUNCTION #####
;~ 			T_Log_Function("Bas Débit",@ScriptLineNumber)
;~ 			$isOK = T_Function_Partial_Window("Création d'un pion géré planifié 1",138,258,200,279,"2A5096DC299AAE484AA977ACA614A26D",@ScriptLineNumber); 2_frederic_Création d'un pion géré planifié 1.bmp
;~ 		Case $MIXTE
;~ 			;##### PARTIAL WINDOW FUNCTION #####
;~ 			T_Log_Function("Mixte",@ScriptLineNumber)
;~ 			$isOK = T_Function_Partial_Window("Création d'un pion géré planifié 1",139,257,195,278,"A9E7134585034EE29DD468B6EF65DE35",@ScriptLineNumber); 3_frederic_Création d'un pion géré planifié 1.bmp
;~ 		Case $NON_SIGNIFICATIF
;~ 			;##### PARTIAL WINDOW ASSERTION #####
;~ 			T_Log_Function("Non Significatif",@ScriptLineNumber)
;~ 			$isOK = T_Function_Partial_Window("Création d'un pion géré planifié 1",138,257,191,278,"06919EC24E8D9973A8CE3C39068A5232",@ScriptLineNumber); 4_frederic_Création d'un pion géré planifié 1.bmp
;~ 		Case Else
;~ 			ConsoleWrite ("Catégorie Débit inconnue !")
;~ 	EndSwitch
;~ 	if ($isOK) Then
;~ 		return True
;~ 	EndIf
;~ 	T_Send(" {SPACE}{DOWN}{ENTER}")
;~ 	$boucle = $boucle + 1
;~ 	WEnd
;~ 	return False
;~ EndFunc
Func T_SelectionLiaisonPourCreationJonction($identificationLiaison, $ShouldSelectedExist, $ShouldSelectableExist)
	;*********** Création d'une jonction planifiée 1 ***********
	T_WinWaitActive("Création d'une jonction planifiée 1", 478, 738, @ScriptLineNumber)
	T_ConsoleWrite("*** Search Link in Selected area ***" & @CRLF)
	T_MouseClick("left", 325, 410) ; Sélection de toutes les liaisons sélectionnées
	ClipPut("")
	T_Send("^c") ; Copie dans le Clipboard
	T_MouseClick("left", 325, 420) ; Déselection des liaisons sélectionnées
	$rc = T_RechercheChaine($identificationLiaison)
	T_ConsoleWrite("$rc = [" & $rc & "]" & @CRLF)
	if(($rc == -1) AND $ShouldSelectedExist) Then
		; Erreur Traitement à faire pour sortir
		T_ConsoleWrite("Link " & $identificationLiaison & " does not exist in selected area but should!" & @CRLF)
		T_End()
	ElseIf(($rc == 0) AND NOT $ShouldSelectedExist) Then
		; Erreur Traitement à faire pour sortir
		T_ConsoleWrite("Link " & $identificationLiaison & " exists in selected area but should not !" & @CRLF)
		T_End()
	ElseIf(($rc == 0) AND $ShouldSelectedExist) Then
		T_ConsoleWrite("Link " & $identificationLiaison & " exists in selected area - OK!" & @CRLF)
	Else ; (($rc == -1) AND NOT $ShouldSelectedExist)
		T_ConsoleWrite("Link " & $identificationLiaison & " does not exist in selected area - OK!" & @CRLF)
	EndIf
	T_ConsoleWrite("*** Search Link in Selectable area ***" & @CRLF)
	T_MouseClick("left", 325, 582) ; Sélection de toutes les liaisons sélectionnables
	ClipPut("")
	T_Send("^c") ; Copie dans le Clipboard
	T_MouseClick("left", 325, 595) ; Déselection des liaisons
	T_MouseClick("left", 31, 616) ; On Sélectionne la première liaison
	$rc = T_RechercheChaine($identificationLiaison)
	T_ConsoleWrite("$rc = [" & $rc & "]" & @CRLF)
	if(($rc == -1) AND $ShouldSelectableExist) Then
		; Erreur Traitement à faire pour sortir
		T_ConsoleWrite("Link " & $identificationLiaison & " does not exist in selectable area but should!" & @CRLF)
		T_End()
	ElseIf(($rc == 0) AND NOT $ShouldSelectableExist) Then
		T_ConsoleWrite("Link " & $identificationLiaison & " exists in selectable area but should not !" & @CRLF)
		T_End()
	ElseIf(($rc == 0) AND $ShouldSelectableExist) Then
		T_ConsoleWrite("Link " & $identificationLiaison & " exists in selectable area - OK!" & @CRLF)
		$stopLoop = 0
		$loopExit = 0
		T_MouseClick("left", 329, 595) ; Déselection des liaisons
		T_MouseClick("left", 31, 616) ; On Sélectionne la première liaison
		While($stopLoop == 0)
			ClipPut("")
			T_Send("^c") ; Copie dans le Clipboard
			$rc = T_RechercheChaine($identificationLiaison)
			If(($rc == 0) OR($loopExit == 256)) Then ; La liaison est trouvée
				$stopLoop = 1
				T_ConsoleWrite("Link found - StopLoop = 1" & @CRLF)
			Else
				$loopExit = $loopExit + 1
				T_Send("{DOWN 1}")
				T_ConsoleWrite("Link not found - $loopExit = " & $loopExit & @CRLF)
			EndIf
		WEnd
		T_MouseClick("left", 384, 590) ; Ajouter
	Else ; (($rc == -1) AND NOT $ShouldSelectableExist)
		T_ConsoleWrite("Link " & $identificationLiaison & " does not exist in selected area - OK!" & @CRLF)
	EndIf
EndFunc   ;==>T_SelectionLiaisonPourCreationJonction
Func T_RechercheChaine($identificationLiaison)
	$clipboard = ClipGet()
	$cptLigne = 0;
	$array = StringSplit($clipboard, @CRLF)
	T_ConsoleWrite("$array[0] = [" & $array[0] & "]" & @CRLF)
	If($array[0] > 1) Then
		T_ConsoleWrite("Il y a bien des liaisons dans la liste" & @CRLF)
		FOR $line IN $array
			T_ConsoleWrite("$line = [" & $line & "]" & @CRLF)
			if( StringInStr($line, $identificationLiaison) <> 0) Then
				return 0;
			Else
				$cptLigne = $cptLigne + 1
			Endif
		NEXT
		T_ConsoleWrite("Link " & $identificationLiaison & " does not exist in list" & @CRLF)
		return -1;
	Else
		T_ConsoleWrite("No links in list" & @CRLF)
		return -1;
	EndIf
EndFunc   ;==>T_RechercheChaine
; *************************************************************
; 					T_ListeDeroulante
; *************************************************************
; *** MISC
Global Enum $MISC_START = 0, $ACTION_CHECK, $ACTION_SET, $VIDE_BLANC, $VIDE_GRIS, $FLOU, $ROUGE, $DECISION_ERROR, $DECISION_WARNING, $MISC_END, $MISC_NB = $MISC_END - $MISC_START - 1
; *** OBJECT
Global Enum $OBJECT_START = 20, $PION_GERE, $PION_EXTERNE, $LIAISON, $JONCTION, $OBJECT_END, $OBJECT_NB = $OBJECT_END - $OBJECT_START - 1
; *** PARAM
Global Enum $PARAMETER_START = 100, $NATURE_PION, $ETAT_PLANIFIE, $CATEGORIE_DEBIT, $ZONE_MOBILITE, $NATURE_STATION, $CTA_INTEGRE, $IDENTIFIANT_SITE, $NATURE_LIAISON, $PARAMETER_END, $PARAMETER_NB = $PARAMETER_END - $PARAMETER_START - 1
; *** VALUES
Global Enum $ETAT_PLANIFIE_START = 1000, $ACTIF, $DEFINI, $RESERVE, $ETAT_PLANIFIE_END, $ETAT_PLANIFIE_NB = $ETAT_PLANIFIE_END - $ETAT_PLANIFIE_START - 1
Global Enum $NATURE_PION_START = 1050, $COMMUTANT, $NON_COMMUTANT, $NATURE_PION_END, $NATURE_PION_NB = $NATURE_PION_END - $NATURE_PION_START - 1
Global Enum $CATEGORIE_DEBIT_START = 1100, $HAUT_DEBIT, $BAS_DEBIT, $MIXTE, $NON_SIGNIFICATIF, $CATEGORIE_DEBIT_END, $CATEGORIE_DEBIT_NB = $CATEGORIE_DEBIT_END - $CATEGORIE_DEBIT_START - 1
Global Enum $ZONE_MOBILITE_START = 1150, $ZDM1, $ZDM2, $ZDM3, $ZDM4, $ZONE_MOBILITE_END, $ZONE_MOBILITE_NB = $ZONE_MOBILITE_END - $ZONE_MOBILITE_START - 1
Global Enum $NATURE_STATION_START = 1200, $CART, $CMAI, $CTRT, $ASTR1, $CART_A, $CMAI_A, $Type_2, $Type_3, $Hub_HD, $Hub_THD, $NATURE_STATION_END, $NATURE_STATION_NB = $NATURE_STATION_END - $NATURE_STATION_START - 1
Global Enum $CTA_INTEGRE_START = 1250, $CTA_11, $CTA_12, $CTA_13, $CTA_14, $CTA_21, $CTA_22, $CTA_23, $CTA_24, $CTA_25, $CTA_26, $CTA_INTEGRE_END, $CTA_INTEGRE_NB = $CTA_INTEGRE_END - $CTA_INTEGRE_START - 1
Global Enum $IDENTIFIANT_SITE_START = 1300, $CTA_1, $CTA_2, $CTA_3, $CTA_4, $CTA_5, $CTA_6, $CTA_7, $CTS_8, $IDENTIFIANT_SITE_END, $IDENTIFIANT_SITE_NB = $IDENTIFIANT_SITE_END - $IDENTIFIANT_SITE_START - 1
Global Enum $NATURE_LIAISON_START = 1350, $FH, $SATELLITE, $SATELLITE_N4, $TROPOSPHERIQUE, $CONCESSION, $CABLE, $NATURE_LIAISON_END, $NATURE_LIAISON_NB = $NATURE_LIAISON_END - $NATURE_LIAISON_START - 1
Func T_ListeDeroulante($Action, $objectName, $parameterName, $parameterValue, $gravity = $DECISION_WARNING)
	Local $isFound = False
	Local $boucle = 0
	Local $windowTitle = ""
	Local $parameterX = 0
	Local $parameterY = 0
	Local $partialWindowX1 = 0
	Local $partialWindowY1 = 0
	Local $partialWindowX2 = 0
	Local $partialWindowY2 = 0
	Local $checksum = ""
	Local $parameterLog = ""
	Local $parameterValueNb = 0
	T_Log_Function("T_ListeDeroulante: " & $Action & "/" & $objectName & "/" & $parameterName & "/" & $parameterValue, @ScriptLineNumber)
	T_Log("T_ListeDeroulante: " & $Action & "/" & $objectName & "/" & $parameterName & "/" & $parameterValue, @ScriptLineNumber)
	Switch $objectName
		case $PION_GERE
			$windowTitle = "Création d'un pion géré planifié 1"
			Switch $parameterName
				Case $NATURE_PION
					$parameterX = 188
					$parameterY = 179
					$parameterValueNb = $NATURE_PION_NB
					Switch $parameterValue
						Case $COMMUTANT
							$partialWindowX1 = 143
							$partialWindowY1 = 169
							$partialWindowX2 = 213
							$partialWindowY2 = 184
							$checksum = "B2956007FB79D3BD9CB8FE57A48F2CD7"
							$parameterLog = "Nature = Commutant"
						Case $NON_COMMUTANT
							$partialWindowX1 = 142
							$partialWindowY1 = 168
							$partialWindowX2 = 224
							$partialWindowY2 = 184
							$checksum = "87770A11B09B3CC4845D35A16C8E0FCB"
							$parameterLog = "Nature = Non commutant"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $ETAT_PLANIFIE
					$parameterX = 190
					$parameterY = 241
					$parameterValueNb = $ETAT_PLANIFIE_NB
					Switch $parameterValue
						Case $ACTIF
							$partialWindowX1 = 141
							$partialWindowY1 = 229
							$partialWindowX2 = 218
							$partialWindowY2 = 244
							$checksum = "AF66570A7FF934825B818FEAB5FF089C"
							$parameterLog = "Etat planifié = Actif"
						Case $DEFINI
							$partialWindowX1 = 141
							$partialWindowY1 = 229
							$partialWindowX2 = 222
							$partialWindowY2 = 245
							$checksum = "B3F486EA658309DA1043B0D77CB37FE3"
							$parameterLog = "Etat planifié = Défini"
						Case $RESERVE
							$partialWindowX1 = 143
							$partialWindowY1 = 229
							$partialWindowX2 = 214
							$partialWindowY2 = 247
							$checksum = "AD4A1023DD3E2023CE7CC253F2B2CA09"
							$parameterLog = "Etat planifié = Réserve"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $CATEGORIE_DEBIT
					$parameterX = 194
					$parameterY = 266
					$parameterValueNb = $CATEGORIE_DEBIT_NB
					Switch $parameterValue
						Case $HAUT_DEBIT
							$partialWindowX1 = 138
							$partialWindowY1 = 257
							$partialWindowX2 = 204
							$partialWindowY2 = 278
							$checksum = "8F0E5B9FA4616F480BC102E8C6D43C7D" ; 11_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Haut Débit"
						Case $BAS_DEBIT
							$partialWindowX1 = 138
							$partialWindowY1 = 258
							$partialWindowX2 = 200
							$partialWindowY2 = 279
							$checksum = "2A5096DC299AAE484AA977ACA614A26D" ; 12_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Bas Débit"
						Case $MIXTE
							$partialWindowX1 = 139
							$partialWindowY1 = 257
							$partialWindowX2 = 195
							$partialWindowY2 = 278
							$checksum = "A9E7134585034EE29DD468B6EF65DE35" ; 13_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Mixte"
						Case $NON_SIGNIFICATIF
							$partialWindowX1 = 138
							$partialWindowY1 = 257
							$partialWindowX2 = 191
							$partialWindowY2 = 278
							$checksum = "06919EC24E8D9973A8CE3C39068A5232" ; 14_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = NS"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $ZONE_MOBILITE
					$parameterX = 200
					$parameterY = 300
					$parameterValueNb = $ZONE_MOBILITE_NB
					Switch $parameterValue
						Case $VIDE_GRIS
							$partialWindowX1 = 151
							$partialWindowY1 = 289
							$partialWindowX2 = 245
							$partialWindowY2 = 303
							$checksum = "448D2A09123132A4FED50F20CEAD8869"
							$parameterLog = "Zone de Mobilité = Vide gris"
						Case $VIDE_BLANC
							$partialWindowX1 = 146
							$partialWindowY1 = 289
							$partialWindowX2 = 221
							$partialWindowY2 = 303
							$checksum = "B16F177150ABE6197FF61B4D79C4EF39"
							$parameterLog = "Zone de Mobilité = Vide blanc"
						Case $ZDM1
							$partialWindowX1 = 141
							$partialWindowY1 = 289
							$partialWindowX2 = 216
							$partialWindowY2 = 304
							$checksum = "D7E451CB67F3A5D66CDF403C86C2103C"
							$parameterLog = "Zone de Mobilité = ZdM1"
						Case $ZDM2
							$partialWindowX1 = 141
							$partialWindowY1 = 289
							$partialWindowX2 = 210
							$partialWindowY2 = 304
							$checksum = "57BE9EA2E82E37CF3A0C846282985F52"
							$parameterLog = "Zone de Mobilité = ZdM2"
						Case $ZDM3
							$partialWindowX1 = 140
							$partialWindowY1 = 289
							$partialWindowX2 = 218
							$partialWindowY2 = 305
							$checksum = "9339618EA1D123BAB56E3F4AD6A9CFBB"
							$parameterLog = "Zone de Mobilité = ZdM3"
						Case $ZDM4
							$partialWindowX1 = 141
							$partialWindowY1 = 288
							$partialWindowX2 = 219
							$partialWindowY2 = 304
							$checksum = "6CC7BA4E89DFE0F586CCC83B8C63EF55"
							$parameterLog = "Zone de Mobilité = ZdM4"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $NATURE_STATION
					$parameterX = 472
					$parameterY = 204
					$parameterValueNb = $NATURE_STATION_NB
					Switch $parameterValue
						Case $CART
							$partialWindowX1 = 418
							$partialWindowY1 = 198
							$partialWindowX2 = 496
							$partialWindowY2 = 215
							$checksum = "6F1ED51BF86CE2BF77CEF1055BB945F8"
							$parameterLog = "Nature de la Station = CART"
						Case $CMAI
							$partialWindowX1 = 418
							$partialWindowY1 = 199
							$partialWindowX2 = 488
							$partialWindowY2 = 213
							$checksum = "A7E151B4E01E2A7387345F3591045F58"
							$parameterLog = "Nature de la Station = CMAI"
						Case $CTRT
							$partialWindowX1 = 419
							$partialWindowY1 = 198
							$partialWindowX2 = 493
							$partialWindowY2 = 214
							$checksum = "FF5A8D95326BDFB0B60F39FCD6FCB12D"
							$parameterLog = "Nature de la Station = CTRT"
						Case $ASTR1
							$partialWindowX1 = 418
							$partialWindowY1 = 198
							$partialWindowX2 = 495
							$partialWindowY2 = 214
							$checksum = "32597418BA74A440A824D45A0138FA5C"
							$parameterLog = "Nature de la Station = ASTR1"
						Case $CART_A
							$partialWindowX1 = 417
							$partialWindowY1 = 198
							$partialWindowX2 = 497
							$partialWindowY2 = 213
							$checksum = "56D2FF7880346BCFA13A488632476292"
							$parameterLog = "Nature de la Station = CART_A"
						Case $CMAI_A
							$partialWindowX1 = 419
							$partialWindowY1 = 199
							$partialWindowX2 = 496
							$partialWindowY2 = 215
							$checksum = "90B9B8A2278FAA7963902A424F6A2E0B"
							$parameterLog = "Nature de la Station = CMAI_A"
						Case $Type_2
							$partialWindowX1 = 419
							$partialWindowY1 = 198
							$partialWindowX2 = 496
							$partialWindowY2 = 215
							$checksum = "AD92C4795546D09C62DB3C515838B7C2"
							$parameterLog = "Nature de la Station = Type 2"
						Case $Type_3
							$partialWindowX1 = 417
							$partialWindowY1 = 199
							$partialWindowX2 = 503
							$partialWindowY2 = 215
							$checksum = "8ED5C1B2B747BE28823C9C4103165FE2"
							$parameterLog = "Nature de la Station = Type 3"
						Case $Hub_HD
							$partialWindowX1 = 418
							$partialWindowY1 = 199
							$partialWindowX2 = 503
							$partialWindowY2 = 214
							$checksum = "4081E28F4B313EA8C189CD5D7CE39F9B"
							$parameterLog = "Nature de la Station = Hub HD"
						Case $Hub_THD
							$partialWindowX1 = 418
							$partialWindowY1 = 199
							$partialWindowX2 = 503
							$partialWindowY2 = 214
							$checksum = "0BF8BFC91BF7060A9ADD6860C541575A"
							$parameterLog = "Nature de la Station = Hub THD"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $CTA_INTEGRE
					$parameterX = 469
					$parameterY = 267
					$parameterValueNb = $CTA_INTEGRE_NB
					Switch $parameterValue
						Case $VIDE_GRIS
							$partialWindowX1 = 419
							$partialWindowY1 = 259
							$partialWindowX2 = 512
							$partialWindowY2 = 272
							$checksum = "05D83B22D6E022C0E364E61503A64528"
							$parameterLog = "CTA intégré = Vide gris"
						Case $ROUGE
							$partialWindowX1 = 409
							$partialWindowY1 = 251
							$partialWindowX2 = 514
							$partialWindowY2 = 284
							$checksum = "D086F8B5A5D2D4686B238587C5A2CBD7"
							$parameterLog = "CTA intégré = Rouge"
						Case $VIDE_BLANC
							$partialWindowX1 = 417
							$partialWindowY1 = 259
							$partialWindowX2 = 509
							$partialWindowY2 = 273
							$checksum = "072F1957B2E460CBFB4276F74DD850BE"
							$parameterLog = "CTA intégré = Vide blanc"
						Case $CTA_11
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 485
							$partialWindowY2 = 276
							$checksum = "1B5896CC405CC6AA7200373986A82E8D"
							$parameterLog = "CTA intégré = CTA_11"
						Case $CTA_12
							$partialWindowX1 = 418
							$partialWindowY1 = 260
							$partialWindowX2 = 479
							$partialWindowY2 = 274
							$checksum = "B9EB5474AEB955C5CE5823C7FFAA739E"
							$parameterLog = "CTA intégré = CTA_12"
						Case $CTA_13
							$partialWindowX1 = 419
							$partialWindowY1 = 259
							$partialWindowX2 = 484
							$partialWindowY2 = 276
							$checksum = "ACD03F5B27E86951084F84884C1D2B25"
							$parameterLog = "CTA intégré = CTA_13"
						Case $CTA_14
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 497
							$partialWindowY2 = 275
							$checksum = "B0265C3A6736DD7703E2189A7F6E0B24"
							$parameterLog = "CTA intégré = CTA_14"
						Case $CTA_21
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 484
							$partialWindowY2 = 275
							$checksum = "54B43B42E539863E2D2D7198DCDA1000"
							$parameterLog = "CTA intégré = CTA_21"
						Case $CTA_22
							$partialWindowX1 = 417
							$partialWindowY1 = 259
							$partialWindowX2 = 482
							$partialWindowY2 = 276
							$checksum = "FE5F73C934190C9D0D297961F4659948"
							$parameterLog = "CTA intégré = CTA_22"
						Case $CTA_23
							$partialWindowX1 = 417
							$partialWindowY1 = 259
							$partialWindowX2 = 490
							$partialWindowY2 = 275
							$checksum = "7762D93606091CFCB0EBDDD92A4463DE"
							$parameterLog = "CTA intégré = CTA_23"
						Case $CTA_24
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 491
							$partialWindowY2 = 277
							$checksum = "B874179C822FB63D512C20E6052E2A7C"
							$parameterLog = "CTA intégré = CTA_24"
						Case $CTA_25
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 494
							$partialWindowY2 = 274
							$checksum = "2E8D1770D33C61FC591679A270148010"
							$parameterLog = "CTA intégré = CTA_25"
						Case $CTA_26
							$partialWindowX1 = 417
							$partialWindowY1 = 258
							$partialWindowX2 = 501
							$partialWindowY2 = 277
							$checksum = "088488CABFEBC7865846373D425652D6"
							$parameterLog = "CTA intégré = CTA_26"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case Else
					T_ConsoleWrite("Unknown $parameterName" & @CRLF)
					T_End("TEST : NOK")
			EndSwitch
		Case $PION_EXTERNE
			$windowTitle = "Création d'un pion externe planifié 1"
			Switch $parameterName
				Case $CATEGORIE_DEBIT
					$parameterX = 193
					$parameterY = 267
					$parameterValueNb = $CATEGORIE_DEBIT_NB
					Switch $parameterValue
						Case $HAUT_DEBIT
							$partialWindowX1 = 142
							$partialWindowY1 = 259
							$partialWindowX2 = 200
							$partialWindowY2 = 274
							$checksum = "761573E41D71CB287443D6B76B7C846D" ; 21_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Haut Débit"
						Case $BAS_DEBIT
							$partialWindowX1 = 142
							$partialWindowY1 = 259
							$partialWindowX2 = 195
							$partialWindowY2 = 275
							$checksum = "5E9B0D12F483FC9B9697F67F24C1731C" ; 22_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Bas Débit"
						Case $MIXTE
							$partialWindowX1 = 143
							$partialWindowY1 = 259
							$partialWindowX2 = 179
							$partialWindowY2 = 274
							$checksum = "9B1D2BE331E3C8571E273EC474AA4922" ; 23_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Mixte"
						Case $NON_SIGNIFICATIF
							$partialWindowX1 = 143
							$partialWindowY1 = 259
							$partialWindowX2 = 173
							$partialWindowY2 = 275
							$checksum = "D351736A6603DD210C8A2ECBFBBACC35" ; 24_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = NS"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $NATURE_PION
					$parameterX = 189
					$parameterY = 176
					$parameterValueNb = $NATURE_PION_NB
					Switch $parameterValue
						Case $COMMUTANT
							$partialWindowX1 = 142
							$partialWindowY1 = 169
							$partialWindowX2 = 217
							$partialWindowY2 = 185
							$checksum = "7BDF9DA0EADD3662A7435A1B9AA40D27"
							$parameterLog = "Nature = Commutant"
						Case $NON_COMMUTANT
							$partialWindowX1 = 141
							$partialWindowY1 = 168
							$partialWindowX2 = 229
							$partialWindowY2 = 186
							$checksum = "1D21CAE44F217DF026ED14132FAC25AE"
							$parameterLog = "Nature = Non commutant"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $IDENTIFIANT_SITE
					$parameterX = 465
					$parameterY = 267
					$parameterValueNb = $IDENTIFIANT_SITE_NB
					Switch $parameterValue
						Case $VIDE_BLANC
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 504
							$partialWindowY2 = 274
							$checksum = "B5F2EC273B4A858AEA3CEB3FB6192D4B"
							$parameterLog = "Identifiant de site = Vide blanc"
						Case $CTA_1
							$partialWindowX1 = 417
							$partialWindowY1 = 259
							$partialWindowX2 = 481
							$partialWindowY2 = 275
							$checksum = "5CB27717524036305CBE6F645CD9D17C"
							$parameterLog = "Identifiant de site = CTA_1"
						Case $CTA_2
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 491
							$partialWindowY2 = 276
							$checksum = "CA7223921DF5B339E8C492FCBDFB9FC2"
							$parameterLog = "Identifiant de site = CTA_2"
						Case $CTA_3
							$partialWindowX1 = 417
							$partialWindowY1 = 257
							$partialWindowX2 = 490
							$partialWindowY2 = 274
							$checksum = "DC6E3F1A4C4F41245D0214AE196CF328"
							$parameterLog = "Identifiant de site = CTA_3"
						Case $CTA_4
							$partialWindowX1 = 417
							$partialWindowY1 = 259
							$partialWindowX2 = 500
							$partialWindowY2 = 274
							$checksum = "9FE1E0C16B2D4633C70BE31F1C380A18"
							$parameterLog = "Identifiant de site = CTA_4"
						Case $CTA_5
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 489
							$partialWindowY2 = 275
							$checksum = "727F710FE73A536C1AC39D3504428EB4"
							$parameterLog = "Identifiant de site = CTA_5"
						Case $CTA_6
							$partialWindowX1 = 418
							$partialWindowY1 = 259
							$partialWindowX2 = 487
							$partialWindowY2 = 276
							$checksum = "68676119EA32F475F27084AE3D4F9D02"
							$parameterLog = "Identifiant de site = CTA_6"
						Case $CTA_7
							$partialWindowX1 = 419
							$partialWindowY1 = 259
							$partialWindowX2 = 497
							$partialWindowY2 = 276
							$checksum = "B49F1A13DFA50A156BCA31081CB4D694"
							$parameterLog = "Identifiant de site = CTA_7"
						Case $CTS_8
							$partialWindowX1 = 418
							$partialWindowY1 = 258
							$partialWindowX2 = 493
							$partialWindowY2 = 277
							$checksum = "DEC95F661B710618D71C92BB6F854D30"
							$parameterLog = "Identifiant de site = CTS_8"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case Else
					T_ConsoleWrite("Unknown $parameterName" & @CRLF)
					T_End("TEST : NOK")
			EndSwitch
		Case $LIAISON
			$windowTitle = "Création d'une liaison planifiée 1"
			Switch $parameterName
				Case $NATURE_LIAISON
					$parameterX = 162
					$parameterY = 180
					$parameterValueNb = $NATURE_LIAISON_NB
					Switch $parameterValue
						Case $FH
							$partialWindowX1 = 117
							$partialWindowY1 = 170
							$partialWindowX2 = 187
							$partialWindowY2 = 186
							$checksum = "69FCE629B309AF822056D0CB0B9BAB99"
							$parameterLog = "Nature = FH"
						Case $SATELLITE
							$partialWindowX1 = 118
							$partialWindowY1 = 171
							$partialWindowX2 = 185
							$partialWindowY2 = 187
							$checksum = "C61F83B0FCB0D4A63CD064CCB106A3FE"
							$parameterLog = "Nature = Satellite"
						Case $SATELLITE_N4
							$partialWindowX1 = 118
							$partialWindowY1 = 171
							$partialWindowX2 = 201
							$partialWindowY2 = 185
							$checksum = "B6FFEC7BD6940D7F58C4441EB0120B5F"
							$parameterLog = "Nature = Satellite N4"
						Case $TROPOSPHERIQUE
							$partialWindowX1 = 118
							$partialWindowY1 = 170
							$partialWindowX2 = 210
							$partialWindowY2 = 187
							$checksum = "76F2112CB3B78DCDE15796070C0F6805"
							$parameterLog = "Nature = Troposphérique"
						Case $CONCESSION
							$partialWindowX1 = 118
							$partialWindowY1 = 171
							$partialWindowX2 = 196
							$partialWindowY2 = 187
							$checksum = "4466845108955EAC93A7260A4DA06F29"
							$parameterLog = "Nature = Concession"
						Case $CABLE
							$partialWindowX1 = 119
							$partialWindowY1 = 171
							$partialWindowX2 = 198
							$partialWindowY2 = 188
							$checksum = "649E02C3F49B63EB4D68FE861A82DB17"
							$parameterLog = "Nature = Câble"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case $CATEGORIE_DEBIT
					$parameterX = 163
					$parameterY = 208
					$parameterValueNb = $CATEGORIE_DEBIT_NB
					Switch $parameterValue
						Case $HAUT_DEBIT
							$partialWindowX1 = 118
							$partialWindowY1 = 201
							$partialWindowX2 = 174
							$partialWindowY2 = 216
							$checksum = "64A6566BBCB7985188EF9E51F89579E3" ; 31_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Haut Débit"
						Case $BAS_DEBIT
							$partialWindowX1 = 118
							$partialWindowY1 = 200
							$partialWindowX2 = 171
							$partialWindowY2 = 217
							$checksum = "F981FFB8A582B0C33EDF36E214F547B9" ; 32_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Bas Débit"
						Case $NON_SIGNIFICATIF
							$partialWindowX1 = 119
							$partialWindowY1 = 201
							$partialWindowX2 = 152
							$partialWindowY2 = 214
							$checksum = "1B130996521EAA2F1C01702AF23D1C11" ; 33_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = NS"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case Else
					T_ConsoleWrite("Unknown $parameterName" & @CRLF)
					T_End("TEST : NOK")
			EndSwitch
		Case $JONCTION
			$windowTitle = "Création d'une jonction planifiée 1"
			Switch $parameterName
				Case $CATEGORIE_DEBIT
					$parameterX = 392
					$parameterY = 178
					$parameterValueNb = $CATEGORIE_DEBIT_NB
					Switch $parameterValue
						Case $HAUT_DEBIT
							$partialWindowX1 = 342
							$partialWindowY1 = 170
							$partialWindowX2 = 393
							$partialWindowY2 = 186
							$checksum = "A054B3ED050E90DEE735FD31FD05F638" ; 41_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Haut Débit"
						Case $BAS_DEBIT
							$partialWindowX1 = 342
							$partialWindowY1 = 170
							$partialWindowX2 = 393
							$partialWindowY2 = 186
							$checksum = "A696FA221ECE9617922D27A51194D841" ; 42_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = Bas Débit"
						Case $NON_SIGNIFICATIF
							$partialWindowX1 = 341
							$partialWindowY1 = 170
							$partialWindowX2 = 368
							$partialWindowY2 = 185
							$checksum = "9704DCBA9B08916FF99B4C03456336BD" ; 43_NMC_Api_Création d'un pion géré planifié 1.bmp
							$parameterLog = "Catégorie Débit = NS"
						Case Else
							T_ConsoleWrite("Unknown $parameterValue" & @CRLF)
							T_End("TEST : NOK")
					EndSwitch
				Case Else
					T_ConsoleWrite("Unknown $parameterName" & @CRLF)
					T_End("TEST : NOK")
			EndSwitch
		Case Else
			T_ConsoleWrite("Unknown $objectName" & @CRLF)
			T_End("TEST : NOK")
	EndSwitch
	T_MouseClick("left", $parameterX, $parameterY)
	T_MouseClick("left", $parameterX, $parameterY)
	;##### PARTIAL WINDOW FUNCTION #####
	;T_Log_Function($parameterLog,@ScriptLineNumber)
	Switch $Action
		Case $ACTION_SET
			while((not $isFound) And($boucle < $parameterValueNb))
				$isFound = T_Function_Partial_Window($windowTitle, $partialWindowX1, $partialWindowY1, $partialWindowX2, $partialWindowY2, $checksum, @ScriptLineNumber)
				T_Log_Function("SET PARAMETER (" & $objectName & " - " & $parameterLog & ": " & $isFound & ")", @ScriptLineNumber)
				if($isFound) Then
					return True
				EndIf
				;T_Send(" {SPACE}{DOWN}{ENTER}")
				T_Send(" {UP}{ENTER}")
				$boucle = $boucle + 1
			WEnd
			; DECIDE IF Not Found is just a WARNING or an ERROR
			if(NOT $isFound) AND($gravity == $DECISION_ERROR) Then
				T_Log_Function("SET PARAMETER ERROR (" & $objectName & " - " & $parameterLog & ": " & $isFound & ")", @ScriptLineNumber)
				T_End("TEST : NOK")
			EndIf
			return False
		Case $ACTION_CHECK
			$isFound = T_Function_Partial_Window($windowTitle, $partialWindowX1, $partialWindowY1, $partialWindowX2, $partialWindowY2, $checksum, @ScriptLineNumber)
			; DECIDE IF Not Found is just a WARNING or an ERROR
			if(NOT $isFound) AND($gravity == $DECISION_ERROR) Then
				T_Log_Function("CHECK PARAMETER ERROR (" & $objectName & " - " & $parameterLog & ": " & $isFound & ")", @ScriptLineNumber)
				T_End("TEST : NOK")
			Else
				T_Log_Function("CHECK PARAMETER (" & $objectName & " - " & $parameterLog & ": " & $isFound & ")", @ScriptLineNumber)
			EndIf
			return $isFound
		Case Else
			T_ConsoleWrite("Unknown $action" & @CRLF)
			T_End("TEST : NOK")
	EndSwitch
EndFunc   ;==>T_ListeDeroulante
Func T_VerificationPlan()
	;*********** Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION] [Plan : plan1] ***********
	T_WinWaitActive("Graphe géoréférencé 1 [Calque : MANFUT/TRANSMISSION] [Plan : plan1]", 915, 875, @ScriptLineNumber)
	T_MouseClick("left", 206, 34)
	T_MouseClick("left", 203, 54)
	T_MouseClick("left", 296, 237)
	;*********** Vérification de la cohérence du plan courant 1 ***********
	T_WinWaitActive("Vérification de la cohérence du plan courant 1", 658, 553, @ScriptLineNumber)
	ClipPut("") ; On vide le Clipboard
	T_MouseClick("left", 615, 301, 27, 194) ; On sélectionne la zone de texte dans le menu Erreurs
	T_MouseClick("left", 64, 31, 64, 32) ; Edition
	T_MouseClick("left", 65, 61) ; Copier
	;##### CLIPBOARD ASSERTION #####
	T_Log_Assert("Vérification de la cohérence du plan. On vérifie qu'il y a aucune erreur !", @ScriptLineNumber)
	T_TogglePause()
	T_Assert_Clipboard("", @ScriptLineNumber)
	T_MouseClick("left", 644, 13)
	T_WinWaitClose("Vérification de la cohérence du plan courant 1", @ScriptLineNumber)
EndFunc   ;==>T_VerificationPlan
Func T_ConsoleWrite($output, $debugLevel = 0)
	$T_DebugLevel = 1
	If($T_DebugLevel >= $debugLevel) Then
		;ConsoleWrite($output)
	EndIf
EndFunc   ;==>T_ConsoleWrite
Func T_Repeated_Send($keys, $iter)
	$i = 0;
	While($i < $iter)
		T_Send($keys)
		$i += 1
	WEnd
 EndFunc   ;==>T_Repeated_Send


 ; Les services de messagerie sont a activer dans les services.
 ; Une fois activé Et démarré ("net start messenger")
 ; = > net send SATURNE mon message
Func T_Controle_SIMINS($messageSimins)
   ;*********** Service Affichage des messages ***********
	T_WinWaitActive("Service Affichage des messages", 309, 126, @ScriptLineNumber) ; 324, 126
	Local $text = WinGetText("Service Affichage des messages")
	Local $pattern = ".*" & $messageSimins & ".*"
	If StringRegExp($text,$pattern,0) Then
		MsgBox(0,"titre","Match !")
		T_MouseClick("left",161,100)
	 Else
		MsgBox(0,"titre","Doesn't Match !")
		T_End()
	Endif
EndFunc

Func  T_SelectLineInArray($identifiant,$posX1, $posY1, $posX2, $posY2)
	Local $cptLigne = 0
	Local $found = false
	T_MouseClick("left",$posX1,$posY1) ; select all
	T_MouseClick("left",68,37) ; edition
	T_MouseClick("left",68,55) ; copier
	Local $text = ClipGet()
	$array = StringSplit($text, @CRLF, 0)
	If($array[0]> 1) Then
		_ArrayDelete($array, 1) ; suppresion des noms des colonnes
		; Liste non vide
		FOR $line IN $array
			;MsgBox(0,"titre",$line)
			If( StringInStr($line, $identifiant) <> 0) Then
				;MsgBox(0,"titre","Trouvé !")
				;MsgBox(0,"titre",$cptLigne)
				$found = true
				ExitLoop
			Else
				$cptLigne = $cptLigne + 1
		Endif
	NEXT
	if ($found) Then
		T_MouseClick("left",$posX2,$posY2)
		T_Send("{CTRLDOWN}"&_StringRepeat("{DOWN}",$cptLigne)&"{CTRLUP}")
	Endif
EndIf
EndFunc
;T_SelectLineInArray("PR102",709,276,37,283)

