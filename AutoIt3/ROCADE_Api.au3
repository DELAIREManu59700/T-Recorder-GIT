#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         DELAIRE Emmanuel

 Script Function:
	API de fonctions AutoIt utiles à la création de scripts AutoIt sur des manipulations des applications du système ROCADE.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <GUIConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>

;~-----------------------------------------------------------------------------------------------------------------------------------------------
;~-----------------------------------------------------------------------------------------------------------------------------------------------

Dim $cle="Felix le chat"						;La clé de chiffrement
Dim $cleDef=False								;Flag qui signal si une cle a été définie par l'opérateur (si False, c'est la clé par défaut qui est conservée)

Const $cryptoActif=True						;Flag d'activation du cryptage (True : actif; False : inactif)

Global $arretUrgence=False						;Flag d'arrêt d'urgence

Global $dll_crypto


;--------------------------------------------------------------------------------------------------------------------------------

;Définition de la clé de chiffrement par l'opérateur
Func R_SetCle($cleChiffrement)

	If $cleChiffrement <> "" Then
		$cle = $cleChiffrement
		$cleDef = True
	EndIf

EndFunc

;Retourne le texte chiffré pour un texte en clair fourni en argument
; ->par défaut l'algo de chiffrement est RC4
Func R_CrypterTexte($texte)

	;L'argument est le texte en clair : une chaine de caractères
	$texteChiffre = $texte
	$texteLen = StringLen($texte)

	If $cryptoActif Then

		;chiffrement du texte en clair à l'aide de la DLL crypto.dll
		$dll_crypto = DllOpen("crypto.dll")

		;Définition de la clé de chiffrement, ou utilisation de la clé par défaut
		If $cleDef Then
			; la clé de chiffrement a été définie par l'opérateur : on la donne à l'algo avant l'opération de chiffrement
			$lgcle = StringLen($cle)
			$result = DllCall($dll_crypto, "short:cdecl", "Cr4Init", "str", $cle, "int", $lgcle)
			Call_Error("Cr4Init",@error)
		EndIf

		; Structure de données du texte chiffré : un tableau de bytes pour recevoir le résultat
		$strChiffre = "byte textChiffre[20000]"
		$structChiffre = DllStructCreate($strChiffre)

		;Execution du chiffrement
		$result = DllCall($dll_crypto, "short:cdecl", "Cr4Chiffrer", "str", $texte, "ptr", DllStructGetPtr($structChiffre))
		Call_Error("Cr4Chiffrer",@error)

		DllClose($dll_crypto)

		;Résultat du chiffrement :
		;Définition d'une chaine de caractères copmposée des codes ACSII (au format hexadecimal) de chaque caractère chiffré, séparés d'un caractère blanc
		$texteChiffre = ""
		$byte_array = DllStructGetData($structChiffre, "textChiffre")

		;construit la chaine de caractères avec les codes ASCII au format hexadecimal qui constituent le chiffre
		$preTexteChiffre = StringMid($byte_array, 3, 2 * $texteLen)
 		For $i=0 To $texteLen - 1
			$texteChiffre = $texteChiffre & StringMid($preTexteChiffre, 2 * $i  + 1, 2)

 			If ($i < $texteLen - 1) Then
				$texteChiffre = $texteChiffre & ' '
			EndIf
		Next

	EndIf

	return $texteChiffre
EndFunc

;Retourne le texte déchiffré pour un texte chiffré fourni en argument
; ->par défaut l'algo de chiffrement est RC4
Func R_DecrypterTexte($texteChiffre)

	$textDechiffre = $texteChiffre

	If $cryptoActif Then

		;Quand le mode CRYPTO est actif, l'argument est une chaine de caractères composées de codes ASCII au format hexadecimal (sans le prefixe '0x') séparés par un caractère blanc
		; exemple de texteChiffre reçu : "41 42 43"

		;Déchiffrement deu texte chiffré à l'aide de la DLL crypto.dll
		$dll_crypto = DllOpen("crypto.dll")

		;Définition de la clé de chiffrement, ou utilisation de la clé par défaut
		If $cleDef Then
			; la clé de chiffrement a été définie par l'opérateur : on la donne à l'algo avant l'opération de déchiffrement
			$lgcle = StringLen($cle)
			$result = DllCall($dll_crypto, "short:cdecl", "Cr4Init", "str", $cle, "int", $lgcle)
			Call_Error("Cr4Init",@error)
		EndIf

		;Préparation du tableau de bytes des caractères chiffrés à fournir à la fonction de déchiffrement
		;Eclatement de la chaine de caractères en un tableau des chaines de caractères qui contiennent chacune un code ASCII au format hexadecimal
		Local $aHexChars = StringSplit($texteChiffre, " ");	 ' ' est le caractère séparateur de chaque code ASCII au format hexadecimal
		$strLen = $aHexChars[0];	//Indice 0 : pointe sur le nombre de chaines éclatées (i.e. correspond au nombre de caractères chiffrés): Les autres indices pointent sur chaque caractère chiffré, dans l'ordre de gauche à droite de la chaine chiffrée

		;Création d'un tableau de bytes composé des valeurs des codes ASCII interprétés du tableaux de code ASCII au format hexadecimal
		Local $aByteChiffre[$strLen];
		For $i=1 To $strLen
 			$aByteChiffre[$i - 1] = Number("0x" & $aHexChars[$i])	;convertit la chaine de caractères en un nombre entier qui correspond à la valeur du code ASCII
		Next

		; Structure de données pour le texte chiffré
		$strChiffre = "byte textChiffre[" & $strLen & "]"
		$structChiffre = DllStructCreate($strChiffre)

		; On remplit cette structure avec le tableau de bytes créé ci-dessus
		For $i=0 To $strLen - 1
 			DllStructSetData($structChiffre, "textChiffre", $aByteChiffre[$i], $i + 1)
		Next

		; Structure de données pour le texte en clair (i.e. déchiffré)
		$strTextClair = "char textClair[20000]"
		$structTextClair = DllStructCreate($strTextClair)

		;Déchiffrement du texte chiffré
		$result = DllCall($dll_crypto, "short:cdecl", "Cr4Dechiffrer", "ptr", DllStructGetPtr($structChiffre), "int", $strLen, "ptr", DllStructGetPtr($structTextClair))
		Call_Error("Cr4Dechiffrer",@error)

		DllClose($dll_crypto)

		;Résultat du déchiffrement:
		; Récupération du résultat $structTextClair et mise en forme dans une chaine de caractère qui définit le texte en clair
		$textDechiffre = ""
		$char_array = DllStructGetData ($structTextClair, "textClair")
		$textDechiffre = BinaryToString($char_array)

	EndIf

	return $textDechiffre
EndFunc

;Gère une boite de dialogue de saisie (Question sur donnée à saisir, valeur saisie)
; --> Retourne la valeur saisie
Func R_SaisieUtilisateur($titre="Demande de saisie", $question="Valeur : ", $default=0)
	Local $rep = InputBox($titre, $question, $default);
	If $rep = "" Then
		switch @error
			Case 0
				;~Pas d'erreur
			Case 1
				MsgBox(0, "Annulation", "Demande de saisie annulée !");
			Case 3
 				MsgBox(0, "Erreur", "Func SaisieUtilisateur( " & $titre & ", " & $question & " ) -> Erreur à l'ouverture de la boite de dialogue !");
			Case Else
				MsgBox(0, "Erreur", "Func SaisieUtilisateur( " & $titre & ", " & $question & " ) -> Erreur " & @error);
		EndSwitch
	EndIf
	Return $rep;
EndFunc

;Lance l'exécution d'un programme et retourne le handle de la fenêtre qui présente son IHM
Func R_Run($program, $titre, $synchrone=False)
	$hdlBN = ""
	$pid = ""
	If ($program <> "") Then

		If Not $synchrone Then
			$pid=Run($program)
		Else
			$pid=RunWait($program)
		EndIf

		If ($titre <> "") Then
			$hdlBN=WinWaitActive($titre)
		EndIf

	EndIf

	return $hdlBN
EndFunc

;Gère l'arrêt d'urgence armé depuis l'en-tête du script AutoIt joué
Func R_ArretUrgence()

	R_SetArretUrgence(True)	; Arrêt d'urgence demandé

	PopUp("STOP", "Arrêt d'urgence !!!", "Arial", 800, 300, 100, Default, Default, 10, 800)
	Exit(10);	Déclenche l'arrêt immédiat du script AutoIt en cours d'exécution
EndFunc

;Gère l'arrêt d'urgence armé depuis l'en-tête du script AutoIt joué
Func R_ArretDemande()

	R_SetArretUrgence(True)	; Arrêt d'urgence demandé

	PopUp("STOP", "Arrêt demandé !!!", "Arial", 800, 300, 100, Default, Default, 10, 800)
EndFunc

; Retourne l'état du flag de demande d'arret d'urgence
Func R_IsArretUrgenceDemande()
	return $arretUrgence
EndFunc

;Affecte l'état de l'arret d'urgence
; $etat : True : arrêt d'urgence demandé; False : arrêt d'urgence non-demandé
Func R_SetArretUrgence($etat)
	$arretUrgence = $etat
EndFunc

;Arme un timer d'attente d'une durée exprimée en secondes
Func R_Timer($dureeSecondes)

	If ($dureeSecondes > 0) Then
		Sleep($dureeSecondes * 1000)
	EndIf

EndFunc
;Arme un timer d'attente d'une durée exprimée en secondes
Func R_TimerInterruptible($dureeSecondes)

	If ($dureeSecondes > 0) Then
		$i=0
		$t= TimerInit()
		While (TimerDiff($t) <= ($dureeSecondes * 1000) And Not R_IsArretUrgenceDemande())
			$i = $i + 1
			;Sleep(10)
		WEnd
	EndIf

EndFunc

Func R_CreerFichierResultatRejeu($pathToResultat)
	Local $file = ""
	If ($pathToResultat <> "") Then
		; créer le fichier temporary.au3 : $pathRejeu & "\" & $temporaryScript :: si le fichier existe on l'écrase !!
		If (FileExists($pathToResultat)) Then
			FileDelete($pathToResultat)
		EndIf

		FileWrite($pathToResultat, "")
		$file = FileOpen($pathToResultat, 1)
		FileWriteLine($file, "")
		FileWriteLine($file, "******************************* RESULTAT DES TESTS de REJEU ***********************************")
 		FileWriteLine($file, " Le " & @MDAY & "/" & @MON & "/" & @YEAR & " , à " & @HOUR & ":" & @MIN & ":" & @SEC & " .")
		FileWriteLine($file, "***********************************************************************************************")
		FileWriteLine($file, "")
	EndIf
	return $file
EndFunc

Func R_FermerFichierResultatRejeu($file)
	If ($file) Then
		FileWriteLine($file, "")
		FileWriteLine($file, "***************** FIN DES TESTS de REJEU *********************")
		FileWriteLine($file, "")

		FileClose($file)
	EndIf
EndFunc

Func R_AddLigneDansFichierResultatRejeu($file, $ligne)
	If ($file) Then
		FileWriteLine($file, $ligne)
	EndIf
EndFunc

Func R_AddResultatsScriptDansFichierResultatRejeu($file, $pathTofichierText)
	If ($pathTofichierText <> "") Then
		If ($file) Then
			;On ouvre le fichier texte et on l'ajoute (i.e append) à la suite dans le fichier de résultat du rejeu
			$fileTxt = FileOpen($pathTofichierText, 0)	;Ouverture du fichier texte en lecture seulement

			;On parcours le fichier texte et on copie son contenu à la suite
			$contenu = FileRead($fileTxt)

			;Ajout dans le fichier résultat du rejeu du texte extrait du fichier texte
			FileWriteLine($file, "")
			FileWrite($file, $contenu)
			FileWriteLine($file, "")
			;

			;Fermeture du fichier texte
			FileClose($fileTxt)
			;
		EndIf
	EndIf
EndFunc


;Retourne le nombre de minutes écoulées depuis 0h00mn ce jour
Func NombreMinutesDepuisMinuit()
	return (@HOUR*60)+@MIN;
EndFunc

;--------------------------------------------------------------------------------------------------------------------------------

;Fait le reset des données de chiffrement
Func ResetData()
	$sFilePath=""
	$text=""
EndFunc

;Affiche un popup pour présenter un texte pendant une durée donnée, puis se termine automatiquement
Func PopUp($titre="", $text="", $font="Times New Roman", $timeout=3000, $w=Default, $h=Default, $xPos=Default, $yPos=Default, $size=12, $fontw=800)
	SplashTextOn($titre, $text, $w, $h, $xPos, $yPos, 0+1+16+32, $font, $size, $fontw)
	Sleep($timeout)
	SplashOff()
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : Call_Error
 Objectif : Traite les éventuelles erreur suite à DllCall
 Entrée(s) : - nom de la fonction appelée (pour le message d'erreur)
 Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func Call_Error ($func,$error)
	If ($error == 1) Then
			MsgBox(0, "Erreur", "Unable to use the DLL file")
	ElseIf($error == 2) Then
			MsgBox(0, "Erreur", "Unknown return type")
	ElseIf($error == 3) Then
			MsgBox(0, "Erreur", "Function not found in the DLL file")
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : DllStructGetData_Error
 Objectif : Traite les éventuelles erreur suite à DllStructGetData
 Entrée(s) : aucune
 Sortie(s) : aucune
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func StructGetData_Error($error)
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


