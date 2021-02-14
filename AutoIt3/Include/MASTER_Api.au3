#include-once

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

	MASTER_API.au3
	Auteur:	V.P.

	Objectif : Bibliothèque de fonctions pour MASTER
	Pré-requis : #include <UDF_tests> ; le script UDF_tests.au3 doit être présent dans le répertoire de tests


#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

#include "UDF_tests.au3"
;#include <UDF_network_tests>

Global $TIMEOUT_INFO_SEC = 1
Global $DEBUG = False


Global Const $RAZ = "raz" ; démarrage en première TC du réseau avec RAZ
Global Const $MNV = "mnv" ; démarrage en première TC du réseau avec restauration d'une manoeuvre
Global Const $CUR = "cur" ; démarrage de la TC en données courantes
Global Const $TD = "td" ; démarrage de la TD
Global Const $TLC = "tlc" ; démarrage de la TC en téléchargement
Global Const $DWL = "dwl" ; téléchargement des EM


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	FONCTIONS PUBLIQUES
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : Usage
	Objectif : Si le nombre d'arguments est incorrect, alors le script s'arrête
	Entrée(s) :
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Usage()
	T_Log("Mauvais usage du script " & @ScriptFullPath, @ScriptLineNumber)
	T_End($T_ERREUR)
EndFunc   ;==>Usage

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : is_valid_ip
	Objectif : retourne vrai si le paramètre est une adresse IP valide
	Entrée(s) :
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func is_valid_ip($adresse)

	If Not StringRegExp($adresse, "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$") Then
		Return False
	Else
		$octects = StringSplit($adresse, '.')
		For $i = 1 To 4
			If Int($octects[$i]) > 255 Then
				Return False
			EndIf
		Next
	EndIf
	Return True
EndFunc   ;==>is_valid_ip




#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : telecharger
	Objectif : Démarrage de la TC de la deuxième EM ($PC_1)
	Entrée(s) :
	;			$fichier_ini
	;			$em_idx1
	;			$em_idx2
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func telecharger($fichier_ini, $em_idx1, $em_idx2)
	Local $code_retour = $T_OK
	If $DEBUG Then
		MsgBox(0, "Info", "$fichier_ini : " & $fichier_ini, $TIMEOUT_INFO_SEC)
		MsgBox(0, "Info", "$em_idx1 : " & $em_idx1, $TIMEOUT_INFO_SEC)
		MsgBox(0, "Info", "$em_idx2 : " & $em_idx2, $TIMEOUT_INFO_SEC)
	EndIf


	Local $TC1 = IniRead($fichier_ini, $em_idx1, "TC", "Value not found")
	If @error Then
		T_Log("Erreur lors de la lecture du fichier : " & $fichier_ini & @CRLF & _
				"L'adresse de la première TC du réseau n'a pas été trouvée !" & @CRLF, @ScriptLineNumber)
		T_End($T_ERREUR)
	Else
		If $DEBUG Then MsgBox(0, "Info", "Adresse de la première TC du réseau : " & $TC1, $TIMEOUT_INFO_SEC)
	EndIf

	Local $TC2 = IniRead($fichier_ini, $em_idx2, "TC", "Value not found")
	If @error Then
		T_Log("Erreur lors de la lecture du fichier : " & $fichier_ini & @CRLF & _
				"L'adresse de la TC à télécharger n'a pas été trouvée !" & @CRLF, @ScriptLineNumber)
		T_End($T_ERREUR)
	Else
		If $DEBUG Then MsgBox(0, "Info", "Adresse de la TC à télécharger : " & $TC2, $TIMEOUT_INFO_SEC)
	EndIf

	$PC_0 = $TC1
	$PC_1 = $TC2 ; TO DO : paramètre à valider

	;**** Initialisation ****

	If $DEBUG Then MsgBox(0, "Info", "$PC_0 : " & $PC_0 & @CRLF & "$PC_1 : " & $PC_1, $TIMEOUT_INFO_SEC)

	T_Init(@ScriptFullPath, True)
	T_Log("Start logging script : " & @ScriptFullPath, @ScriptLineNumber)
	T_Log("Adresse de la première TC du réseau trouvée : " & $PC_0 & @CRLF, @ScriptLineNumber)
	T_Log("Adresse de la TC à télécharger : " & $PC_1 & @CRLF, @ScriptLineNumber)



	Global $code_operateur = "1234"
	$code_retour += demarrage_TC2($code_operateur)
	$code_retour += telechargement_em($em_idx1, $em_idx2)
	$code_retour += fin_demarrage_TC2()
	Return ($code_retour)
EndFunc   ;==>telecharger



#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	FONCTIONS PRIVEES
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : demarrage_TC2
	Objectif : Démarrage de la TC de la deuxième EM ($PC_1)
	Entrée(s) :
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func demarrage_TC2($code_em = "1234")
	Local $code_retour = $T_OK
	T_1_Log("Entering function demarrage_TC2(" & $code_em & ")", @ScriptLineNumber)
	If $DEBUG Then MsgBox(0, "Info", "Entering function demarrage_TC2(" & $code_em & ")", $TIMEOUT_INFO_SEC)

	If Not StringRegExp($code_em, "[0-9]{4}") Then
		T_1_Log("Erreur ! Valeur du code inattendue : " & $code_em, @ScriptLineNumber)
		T_1_Log("Le code doit être un entier positif à 4 chiffres", @ScriptLineNumber)
	EndIf
	Local $code = $code_em ; format du code validé

	T_1_Log("Utiliser le raccourci windows+R", @ScriptLineNumber)
	$code_retour = T_1_Send("#r")
	If $code_retour <> $T_OK Then Return $T_ERREUR


	$width_executer = 363
	$height_executer = 179

	$code_retour = T_1_WinWaitActive("Exécuter", $width_executer, $height_executer, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_Send("{BS}")
	If $code_retour <> $T_OK Then Return $T_ERREUR

	Local $raccourci = "D:\nmc\Raccourcis NMC\NMC (CMX).lnk"
	;Local $raccourci = "D:\nmc\application\commun\exe\launch_with_hide_window.exe d:\nmc\Application\Commun\Cmd\nmc_environ.cmd call d:\nmc\Application\Commun\Cmd\environ.cmd call d:\nmc\Application\lcecore2\cmd\startcecore_cmx.cmd"

	$code_retour = T_1_Send($raccourci)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_Send("{ENTER}") ; appui sur entrée pour exécuter le raccourci nmc
	If $code_retour <> $T_OK Then Return $T_ERREUR

	;T_1_MouseClick("left", 155, 151) ; clic sur OK
	;;;T_1_WinWaitClose("Exécuter", @ScriptLineNumber)


	Sleep(100)
	; Faire un NetSend de la commande WinExists
	;If WinExists("Problème d'installations") Then
	;	T_1_Log("La procédure d'installation du tome 2 n'est pas respectée !", @ScriptLineNumber)
	;	T_1_WinWaitActive("Problème d'installations", 386, 119, @ScriptLineNumber)
	;	T_1_Log("appui sur Entrée", @ScriptLineNumber)
	;	T_1_Send("{ENTER}")
	;	;;T_1_WinWaitClose("Problème d'installations", @ScriptLineNumber)
	;EndIf

	$TEST_PB_INSTALL = True
	If $TEST_PB_INSTALL Then
		$commandes = @CRLF & _
				"Sleep(200)" & @CRLF & _
				"If WinExists(""Problème d'installations"") Then" & @CRLF & _
				"    T_WinWaitActive(""Problème d'installations"",386,119,@ScriptLineNumber)" & @CRLF & _
				"    T_Send(""{ENTER}"")" & @CRLF & _
				"    Sleep(200)" & @CRLF & _
				"Endif" & @CRLF & @CRLF
		$code_retour = T_RemoteCommandsBlock($commandes, 1)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_1_Log("Info " & $PC_1 & " : " & @CRLF & "Le résultat des commandes : " & $commandes & @CRLF & " est " & $code_retour, @ScriptLineNumber)
	EndIf
	;*********** LGCONF on PC_1 ***********
	$code_retour = T_1_WinWaitActive("LGCONF", 523, 459, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_1_Log("clic sur démarrage en téléchargement", @ScriptLineNumber)
	$code_retour = T_1_MouseClick("left", 270, 50) ; clic sur LGCONF pour avoir le focus sur le premier bouton
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_Send("{TAB}")
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_Send("{TAB}") ; focus sur "Démarrage en téléchargement"
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_Send("{ENTER}")
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_WinWaitActive("TC téléchargement", 266, 312, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_1_MouseClick("left", 160, 200) ; clic sur valeur code opérateur
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_1_Log("entrer le code : " & $code, @ScriptLineNumber)

	$code_retour = T_1_Send($code)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_1_Log("accéder au champ confirmation", @ScriptLineNumber)
	$code_retour = T_1_Send("{TAB}")
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_1_Log("confirmer le code : " & $code, @ScriptLineNumber)

	$code_retour = T_1_Send($code)
	If $code_retour <> $T_OK Then Return $T_ERREUR


	$code_retour = T_1_Send("{TAB}")
	If $code_retour <> $T_OK Then Return $T_ERREUR



	$code_retour = T_1_Send("{ENTER}") ; appui sur OK
	If $code_retour <> $T_OK Then Return $T_ERREUR


	$code_retour = T_1_WinWaitActive("Fenêtre d'interrogation", 365, 118, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	; Confirmez-vous le démarrage de la TC en téléchargement ?
	T_1_Log("Confirmez le démarrage de la TC en téléchargement", @ScriptLineNumber)
	$code_retour = T_1_Send("{ENTER}") ; appui sur OK
	If $code_retour <> $T_OK Then Return $T_ERREUR


	T_1_Log("Nous attendons l'apparition de la fenetre de téléchargement", @ScriptLineNumber)
	$code_retour = T_1_WinWaitActive("Téléchargement de la TC", 666, 635, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR


	T_1_Log("vérifier que le téléchargement de la TC est en attente", @ScriptLineNumber)
	$code_retour = T_1_Wait_Partial_Window("Téléchargement de la TC", 449, 197, 490, 210, "6A20EEB94BE2041ECED3785F74FD8E49", @ScriptLineNumber); 0_attente_telechargement_Téléchargement de la TC.bmp
	If $code_retour <> $T_OK Then Return $T_ERREUR


	T_1_Log("Exiting function demarrage_TC2", @ScriptLineNumber)
	Return($T_OK)
EndFunc   ;==>demarrage_TC2


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : telechargement_em
	Objectif : Télécharger la première EM ($PC_0) sur la seconde EM
	Hypothèses :
	;				Le bureau NMC de la première TC est démarrée
	;				La TC de l'EM à démarrer en téléchargement n'est pas démarrée
	Entrée(s) :
	$em1 : première EM initialisée			(valeurs possibles : EM1, EM2, EM3, EM4)
	$em2 : EM à démarrer en téléchargement 	(valeurs possibles : EM1, EM2, EM3, EM4)
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func telechargement_em($em1, $em2)
	T_Log("Entering function telechargement_em(" & $em1 & ", " & $em2 & ")", @ScriptLineNumber)
	If $DEBUG Then MsgBox(0, "Info", "Entering function telechargement_em(" & $em1 & ", " & $em2 & ")", $TIMEOUT_INFO_SEC)

	; Téléchargement
	$code_retour = T_0_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_MouseClick("left", 71, 90) ; clic sur menu Administration
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_MouseClick("left", 71, 150) ; clic sur "synoptiques"
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_MouseClick("left", 230, 150) ; clic sur "EM"
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Synoptique EM", 808, 729, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$em_idx2 = StringRight($em2, 1) ; indice de l'EM à télécharger de 1 à 4

	; coordonnées des centres des carrés EM
	Dim $em_x[4]
	Dim $em_y[4]

	; EM1
	$em_x[0] = 266
	$em_y[0] = 158

	; EM2
	$em_x[1] = $em_x[0] + 274
	$em_y[1] = $em_y[0]

	; EM3
	$em_x[2] = $em_x[0]
	$em_y[2] = $em_y[0] + 340

	; EM4
	$em_x[3] = $em_x[0] + 274
	$em_y[3] = $em_y[0] + 340

	T_0_Log("clic sur l'EM" & $em_idx2, @ScriptLineNumber)
	$code_retour = T_0_MouseClick("left", $em_x[$em_idx2 - 1], $em_y[$em_idx2 - 1]) ; clic sur le carré de l'EM
	If $code_retour <> $T_OK Then Return $T_ERREUR

	;T_0_Log("vérifier que l'icone ""declarer l'em "" est opérationnel", @ScriptLineNumber)
	;$code_retour = T_0_Wait_Partial_Window("Synoptique EM", 383, 53, 407, 72, "CCBFFF03620C8AEA458F1E18CFEDCCD8", @ScriptLineNumber); 3_declarer_em_Synoptique EM - NMC1 - Réseau RV 1.bmp
	;If $code_retour <> $T_OK Then Return $T_ERREUR
Sleep(1000)

	T_0_Log("clic sur déclarer l'EM", @ScriptLineNumber)

	$code_retour = T_0_MouseClick("left", 395, 62) ; clic sur Déclarer l'EM
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 692, 107, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	; Voulez-vous déclarer l'EM sélectionnée ?
	T_0_Log("confirmer la déclaration de l'EM dans le réseau", @ScriptLineNumber)
	T_0_Log("clic sur ok", @ScriptLineNumber)

	$code_retour = T_0_Send("{ENTER}") ; appui sur OK
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Synoptique EM", 808, 729, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	;T_0_Log("vérifier que l'icone télécharger est opérationnel", @ScriptLineNumber)
	;$code_retour = T_0_Wait_Partial_Window("Synoptique EM", 358, 52, 382, 73, "5045B95A88BE1ADE8C852B16EF850B42", @ScriptLineNumber); 4_declarer_em_Synoptique EM - NMC1 - Réseau RV 1.bmp
	;If $code_retour <> $T_OK Then Return $T_ERREUR
Sleep(1000)

	T_0_Log("clic sur telecharger", @ScriptLineNumber)

	$code_retour = T_0_MouseClick("left", 371, 62) ; clic sur Télécharger l'EM
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 289, 118, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR
	; Voulez-vous télécharger l'EM sélectionnée ?
	T_0_Log("confirmer le téléchargement de l'EM sélectionnée", @ScriptLineNumber)
	T_0_Log("clic sur ok", @ScriptLineNumber)
	$code_retour = T_0_Send("{ENTER}") ; appui sur OK
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Etat du téléchargement", 323, 177, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR
	; le téléchargement peut se terminer :
	; 		soit en erreur, et un pop-up "Fenêtre d'erreur" apparait,
	; 		soit avec le statut "terminé" et il suffit d'acquitter la fenêtre état du téléchargement
	; par conséquent, il faut attendre tant que le statut du téléchargement n'est pas terminé, et tant qu'il n'y a pas eu de fenêtre d'erreur
	; TO DO : gérer le cas du téléchargement en erreur, pour l'instant on traite uniquement le cas nominal
	T_0_Log("attendre que le status du téléchargement soit terminé", @ScriptLineNumber)

	$code_retour = T_0_Wait_Partial_Window("Etat du téléchargement", 93, 90, 251, 106, "D9C4DFEC59056757F237176D1D9E58E6", @ScriptLineNumber); 5_declarer_em_Etat du téléchargement.bmp
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_Send("{ENTER}") ; appui sur OK
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_WinWaitActive("Synoptique EM", 808, 729, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_0_Log("fermer le synoptique EM", @ScriptLineNumber)


	$code_retour = T_0_MouseClick("left", 793, 12)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	Return $T_OK
EndFunc   ;==>telechargement_em

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : fin_demarrage_TC2
	Objectif : on attend que le bureau NMC du $PC_1 s'ouvre
	Entrée(s) :
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------
Func fin_demarrage_TC2()
	T_1_Log("Nous attendons la fin de l'initialisation de la TC", @ScriptLineNumber)
	Local $code_retour = T_1_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR
	Return $T_OK
EndFunc   ;==>fin_demarrage_TC2


#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Titre : demarrage_station
	Objectif : Démarre la station NMC ($PC_0) en fonction du mode
	Entrée(s) :
	$mode : 	mode de démarrage de la station (valeurs possibles : raz, mnv, cur, td, tlc
	$code_em :	code opérateur du commutateur de l'EM (valeur par défaut : 1234)
	Sortie(s) :
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func demarrage_station($mode, $code_em = "1234", $fichier_manoeuvre = "")
	Local $code_retour
	T_0_Log("Entering function demarrage_station(" & $mode & ", " & $code_em & ")", @ScriptLineNumber)
	If $DEBUG Then MsgBox(0, "Info", "Entering function demarrage_station(" & $mode & ", " & $code_em & ")", $TIMEOUT_INFO_SEC)

	; le code à 4 chiffres n'est utile que dans les cas suivants :
	; 	- démarrage de la TC en RAZ,
	;	- en restauration de manoeuvre,
	; 	- et en téléchargement d'une autre EM (TO DO)

	If $mode <> $RAZ And $mode <> $MNV And $mode <> $CUR And $mode <> $TD And $mode <> $TLC Then
		T_0_Log("Erreur ! Valeur du mode inattendue : " & $mode, @ScriptLineNumber)
		T_0_Log("Les valeurs de mode possibles sont : " & @CRLF & _
				$RAZ & " : " & "démarrage en première TC du réseau avec RAZ" & @CRLF & _
				$MNV & " : " & "démarrage en première TC du réseau avec restauration d'une manoeuvre" & @CRLF & _
				$CUR & " : " & "démarrage de la TC en données courantes" & @CRLF & _
				$TLC & " : " & "démarrage de la TC en téléchargement" & @CRLF & _
				$TD & " : " & "démarrage de la TD" & @CRLF, @ScriptLineNumber)


	EndIf
	Local $code
	If Not StringRegExp($code_em, "[0-9]{4}") Then
		T_0_Log("Erreur ! Valeur du code inattendue : " & $code_em, @ScriptLineNumber)
		T_0_Log("Le code doit être un entier positif à 4 chiffres", @ScriptLineNumber)
		$code = "1234" ; on remplace le mauvais code par un bon code
	Else
		$code = $code_em
	EndIf


	T_0_Log("Utiliser le raccourci windows+R", @ScriptLineNumber)
	$code_retour = T_0_Send("#r")
	If $code_retour <> $T_OK Then Return $T_ERREUR

	;$commandes = "$returnCode = WinWaitActive( ""Exécuter"", """" , 30)" & @CRLF
	;Local $resultat = T_RemoteCommandsBlock($commandes, 0)
	;T_0_Log("Résultat du windows+R : " & $resultat, @ScriptLineNumber)
	;*********** Exécuter on PC_0 ***********

	$width_executer = 363
	$height_executer = 179
	$code_retour = T_0_WinWaitActive("Exécuter", $width_executer, $height_executer, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	T_0_Send("{BS}")
	Local $raccourci = "D:\nmc\Raccourcis NMC\NMC (CMX).lnk"
	;Local $raccourci = "D:\nmc\application\commun\exe\launch_with_hide_window.exe d:\nmc\Application\Commun\Cmd\nmc_environ.cmd call d:\nmc\Application\Commun\Cmd\environ.cmd call d:\nmc\Application\lcecore2\cmd\startcecore_cmx.cmd"
	$code_retour = T_0_Send($raccourci)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	$code_retour = T_0_Send("{ENTER}") ; appui sur entrée pour exécuter le raccourci nmc
	If $code_retour <> $T_OK Then Return $T_ERREUR
	;T_0_MouseClick("left", 155, 151) ; clic sur OK
	;;;T_0_WinWaitClose("Exécuter", @ScriptLineNumber)


	Sleep(100)
	; Faire un NetSend de la commande WinExists
	;If WinExists("Problème d'installations") Then
	;	T_0_Log("La procédure d'installation du tome 2 n'est pas respectée !", @ScriptLineNumber)
	;	T_0_WinWaitActive("Problème d'installations", 386, 119, @ScriptLineNumber)
	;	T_0_Log("appui sur Entrée", @ScriptLineNumber)
	;	T_0_Send("{ENTER}")
	;	;;T_0_WinWaitClose("Problème d'installations", @ScriptLineNumber)
	;EndIf
	$TEST_PB_INSTALL = True
	If $TEST_PB_INSTALL Then
		$commandes = @CRLF & _
				"Sleep(200)" & @CRLF & _
				"If WinExists(""Problème d'installations"") Then" & @CRLF & _
				"    T_WinWaitActive(""Problème d'installations"",386,119,@ScriptLineNumber)" & @CRLF & _
				"    T_Send(""{ENTER}"")" & @CRLF & _
				"    Sleep(200)" & @CRLF & _
				"Endif" & @CRLF & @CRLF
		$code_retour = T_RemoteCommandsBlock($commandes, 0)
		T_0_Log("Info " & $PC_0 & " : " & @CRLF & "Le résultat des commandes : " & $commandes & @CRLF & " est " & $code_retour, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR
	EndIf

	;*********** LGCONF on PC_0 ***********
	$code_retour = T_0_WinWaitActive("LGCONF", 523, 459, @ScriptLineNumber)
	If $code_retour <> $T_OK Then Return $T_ERREUR

	If $RAZ == $mode Or $MNV == $mode Then
		T_0_Log("clic sur démarrage première TC", @ScriptLineNumber)

		$code_retour = T_0_MouseClick("left", 384, 128) ; clic sur démarrage première TC
		If $code_retour <> $T_OK Then Return $T_ERREUR

		;*********** Première TC on PC_0 ***********
		$code_retour = T_0_WinWaitActive("Première TC", 266, 397, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("clic dans le champs valeur", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 159, 203) ; clic dans le champ valeur
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("entrer le code : " & $code, @ScriptLineNumber)

		$code_retour = T_0_Send($code)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("accéder au champ confirmation", @ScriptLineNumber)

		$code_retour = T_0_Send("{TAB}")
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("confirmer le code : " & $code, @ScriptLineNumber)

		$code_retour = T_0_Send($code)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		If $RAZ == $mode Then
			T_0_Log("clic sur l'option Démarrage en RAZ", @ScriptLineNumber)
			$code_retour = T_0_MouseClick("left", 67, 305) ; clic sur Démarrage en RAZ
			If $code_retour <> $T_OK Then Return $T_ERREUR

		ElseIf $MNV == $mode Then
			T_0_Log("clic sur l'option Démarrage depuis sauvegarde", @ScriptLineNumber)
			$code_retour = T_0_MouseClick("left", 64, 332)
			If $code_retour <> $T_OK Then Return $T_ERREUR

		EndIf
		T_0_Log("clic sur OK", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 42, 376) ; clic sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		;*********** Fenêtre d'interrogation on PC_0 ***********
		$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 317, 118, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("clic sur OK confirmant le démarrage de la première TC", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 51, 91)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		;;T_0_WinWaitClose("Fenêtre d'interrogation", @ScriptLineNumber)
		If $MNV == $mode Then
			;*********** Démarrage de la TC depuis sauvegarde on PC_0 ***********
			$code_retour = T_0_WinWaitActive("Démarrage de la TC depuis sauvegarde", 666, 635, @ScriptLineNumber)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("clic sur le bouton pour parcourir les fichiers", @ScriptLineNumber)
			$code_retour = T_0_MouseClick("left", 597, 310)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			;*********** Fichier à restaurer on PC_0 ***********
			$code_retour = T_0_WinWaitActive("Fichier à restaurer", 563, 409, @ScriptLineNumber)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("clic dans la zone du nom de fichier", @ScriptLineNumber)

			$code_retour = T_0_MouseClick("left", 261, 335)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("renseigner le nom de la manoeuvre à restaurer : " & $fichier_manoeuvre, @ScriptLineNumber)
			$code_retour = T_0_Send($fichier_manoeuvre)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("appui 3 fois sur TAB pour accéder au bouton Ouvrir", @ScriptLineNumber)
			$code_retour = T_0_Send("{TAB}{TAB}{TAB}")
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("appui sur Entrée", @ScriptLineNumber)
			$code_retour = T_0_Send("{ENTER}")
			If $code_retour <> $T_OK Then Return $T_ERREUR

			;*********** Démarrage de la TC depuis sauvegarde on PC_0 ***********
			$code_retour = T_0_WinWaitActive("Démarrage de la TC depuis sauvegarde", 666, 635, @ScriptLineNumber)
			If $code_retour <> $T_OK Then Return $T_ERREUR

			T_0_Log("clic sur restaurer", @ScriptLineNumber)
			$code_retour = T_0_MouseClick("left", 472, 440)
			If $code_retour <> $T_OK Then Return $T_ERREUR

		EndIf
	ElseIf $CUR == $mode Then
		T_0_Log("Démarrage TC depuis données courantes", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 380, 250) ; clic sur "Démarrage TC depuis données courantes"
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("TC données courantes", 266, 224, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{TAB}") ; pour avoir le focus sur le bouton OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 417, 125, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		; Confirmez-vous le démarrage de la TC en données courantes ?
		T_0_Log("Confirmez le démarrage en données courantes", @ScriptLineNumber)

		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

	ElseIf $TD == $mode Then
		T_0_Log("Démarrage de la TD", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 400, 315) ; clic sur "Démarrage TD"
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("Démarrage d'une TD/TI", 312, 300, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{TAB}") ; pour avoir le focus sur le bouton OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("Choix de la TD", @ScriptLineNumber)
		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 286, 125, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("Confirmez le démarrage", @ScriptLineNumber)
		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

	ElseIf $TLC == $mode Then

		T_0_Log("clic sur démarrage en téléchargement", @ScriptLineNumber)
		$code_retour = T_0_MouseClick("left", 270, 50) ; clic sur LGCONF pour avoir le focus sur le premier bouton
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{TAB}")
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{TAB}") ; focus sur "Démarrage en téléchargement"
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{ENTER}")
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("TC téléchargement", 266, 312, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_MouseClick("left", 160, 200) ; clic sur valeur code opérateur
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("entrer le code : " & $code, @ScriptLineNumber)

		$code_retour = T_0_Send($code)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("accéder au champ confirmation", @ScriptLineNumber)

		$code_retour = T_0_Send("{TAB}")
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("confirmer le code : " & $code, @ScriptLineNumber)

		$code_retour = T_0_Send($code)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{TAB}")
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		$code_retour = T_0_WinWaitActive("Fenêtre d'interrogation", 365, 118, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

		; Confirmez-vous le démarrage de la TC en téléchargement ?

		T_0_Log("Confirmez le démarrage de la TC en téléchargement", @ScriptLineNumber)

		$code_retour = T_0_Send("{ENTER}") ; appui sur OK
		If $code_retour <> $T_OK Then Return $T_ERREUR

		T_0_Log("Nous attendons l'apparition de la fenetre de téléchargement", @ScriptLineNumber)

		$code_retour = T_0_WinWaitActive("Téléchargement de la TC", 666, 635, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

	EndIf

	If $mode <> $TLC Then
		T_0_Log("Nous attendons la fin de l'initialisation du bureau NMC", @ScriptLineNumber)
		$code_retour = T_0_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
		If $code_retour <> $T_OK Then Return $T_ERREUR

	EndIf
	T_0_Log("Exiting function demarrage_station", @ScriptLineNumber)
	Return $T_OK
EndFunc   ;==>demarrage_station
