#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         DELAIRE Emmanuel

 Script Function:
	API de fonctions AutoIt utiles � la cr�ation de scripts AutoIt sur des manipulations des applications du syst�me ROCADE.

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

Dim $cle="Felix le chat"						;La cl� de chiffrement
Dim $cleDef=False								;Flag qui signal si une cle a �t� d�finie par l'op�rateur (si False, c'est la cl� par d�faut qui est conserv�e)

Const $cryptoActif=True						;Flag d'activation du cryptage (True : actif; False : inactif)

Global $arretUrgence=False						;Flag d'arr�t d'urgence

Global $dll_crypto


;--------------------------------------------------------------------------------------------------------------------------------

;D�finition de la cl� de chiffrement par l'op�rateur
Func R_SetCle($cleChiffrement)

	If $cleChiffrement <> "" Then
		$cle = $cleChiffrement
		$cleDef = True
	EndIf

EndFunc

;Retourne le texte chiffr� pour un texte en clair fourni en argument
; ->par d�faut l'algo de chiffrement est RC4
Func R_CrypterTexte($texte)

	;L'argument est le texte en clair : une chaine de caract�res
	$texteChiffre = $texte
	$texteLen = StringLen($texte)

	If $cryptoActif Then

		;chiffrement du texte en clair � l'aide de la DLL crypto.dll
		$dll_crypto = DllOpen("crypto.dll")

		;D�finition de la cl� de chiffrement, ou utilisation de la cl� par d�faut
		If $cleDef Then
			; la cl� de chiffrement a �t� d�finie par l'op�rateur : on la donne � l'algo avant l'op�ration de chiffrement
			$lgcle = StringLen($cle)
			$result = DllCall($dll_crypto, "short:cdecl", "Cr4Init", "str", $cle, "int", $lgcle)
			Call_Error("Cr4Init",@error)
		EndIf

		; Structure de donn�es du texte chiffr� : un tableau de bytes pour recevoir le r�sultat
		$strChiffre = "byte textChiffre[20000]"
		$structChiffre = DllStructCreate($strChiffre)

		;Execution du chiffrement
		$result = DllCall($dll_crypto, "short:cdecl", "Cr4Chiffrer", "str", $texte, "ptr", DllStructGetPtr($structChiffre))
		Call_Error("Cr4Chiffrer",@error)

		DllClose($dll_crypto)

		;R�sultat du chiffrement :
		;D�finition d'une chaine de caract�res copmpos�e des codes ACSII (au format hexadecimal) de chaque caract�re chiffr�, s�par�s d'un caract�re blanc
		$texteChiffre = ""
		$byte_array = DllStructGetData($structChiffre, "textChiffre")

		;construit la chaine de caract�res avec les codes ASCII au format hexadecimal qui constituent le chiffre
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

;Retourne le texte d�chiffr� pour un texte chiffr� fourni en argument
; ->par d�faut l'algo de chiffrement est RC4
Func R_DecrypterTexte($texteChiffre)

	$textDechiffre = $texteChiffre

	If $cryptoActif Then

		;Quand le mode CRYPTO est actif, l'argument est une chaine de caract�res compos�es de codes ASCII au format hexadecimal (sans le prefixe '0x') s�par�s par un caract�re blanc
		; exemple de texteChiffre re�u : "41 42 43"

		;D�chiffrement deu texte chiffr� � l'aide de la DLL crypto.dll
		$dll_crypto = DllOpen("crypto.dll")

		;D�finition de la cl� de chiffrement, ou utilisation de la cl� par d�faut
		If $cleDef Then
			; la cl� de chiffrement a �t� d�finie par l'op�rateur : on la donne � l'algo avant l'op�ration de d�chiffrement
			$lgcle = StringLen($cle)
			$result = DllCall($dll_crypto, "short:cdecl", "Cr4Init", "str", $cle, "int", $lgcle)
			Call_Error("Cr4Init",@error)
		EndIf

		;Pr�paration du tableau de bytes des caract�res chiffr�s � fournir � la fonction de d�chiffrement
		;Eclatement de la chaine de caract�res en un tableau des chaines de caract�res qui contiennent chacune un code ASCII au format hexadecimal
		Local $aHexChars = StringSplit($texteChiffre, " ");	 ' ' est le caract�re s�parateur de chaque code ASCII au format hexadecimal
		$strLen = $aHexChars[0];	//Indice 0 : pointe sur le nombre de chaines �clat�es (i.e. correspond au nombre de caract�res chiffr�s): Les autres indices pointent sur chaque caract�re chiffr�, dans l'ordre de gauche � droite de la chaine chiffr�e

		;Cr�ation d'un tableau de bytes compos� des valeurs des codes ASCII interpr�t�s du tableaux de code ASCII au format hexadecimal
		Local $aByteChiffre[$strLen];
		For $i=1 To $strLen
 			$aByteChiffre[$i - 1] = Number("0x" & $aHexChars[$i])	;convertit la chaine de caract�res en un nombre entier qui correspond � la valeur du code ASCII
		Next

		; Structure de donn�es pour le texte chiffr�
		$strChiffre = "byte textChiffre[" & $strLen & "]"
		$structChiffre = DllStructCreate($strChiffre)

		; On remplit cette structure avec le tableau de bytes cr�� ci-dessus
		For $i=0 To $strLen - 1
 			DllStructSetData($structChiffre, "textChiffre", $aByteChiffre[$i], $i + 1)
		Next

		; Structure de donn�es pour le texte en clair (i.e. d�chiffr�)
		$strTextClair = "char textClair[20000]"
		$structTextClair = DllStructCreate($strTextClair)

		;D�chiffrement du texte chiffr�
		$result = DllCall($dll_crypto, "short:cdecl", "Cr4Dechiffrer", "ptr", DllStructGetPtr($structChiffre), "int", $strLen, "ptr", DllStructGetPtr($structTextClair))
		Call_Error("Cr4Dechiffrer",@error)

		DllClose($dll_crypto)

		;R�sultat du d�chiffrement:
		; R�cup�ration du r�sultat $structTextClair et mise en forme dans une chaine de caract�re qui d�finit le texte en clair
		$textDechiffre = ""
		$char_array = DllStructGetData ($structTextClair, "textClair")
		$textDechiffre = BinaryToString($char_array)

	EndIf

	return $textDechiffre
EndFunc

;G�re une boite de dialogue de saisie (Question sur donn�e � saisir, valeur saisie)
; --> Retourne la valeur saisie
Func R_SaisieUtilisateur($titre="Demande de saisie", $question="Valeur : ", $default=0)
	Local $rep = InputBox($titre, $question, $default);
	If $rep = "" Then
		switch @error
			Case 0
				;~Pas d'erreur
			Case 1
				MsgBox(0, "Annulation", "Demande de saisie annul�e !");
			Case 3
 				MsgBox(0, "Erreur", "Func SaisieUtilisateur( " & $titre & ", " & $question & " ) -> Erreur � l'ouverture de la boite de dialogue !");
			Case Else
				MsgBox(0, "Erreur", "Func SaisieUtilisateur( " & $titre & ", " & $question & " ) -> Erreur " & @error);
		EndSwitch
	EndIf
	Return $rep;
EndFunc

;Lance l'ex�cution d'un programme et retourne le handle de la fen�tre qui pr�sente son IHM
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

;G�re l'arr�t d'urgence arm� depuis l'en-t�te du script AutoIt jou�
Func R_ArretUrgence()

	R_SetArretUrgence(True)	; Arr�t d'urgence demand�

	PopUp("STOP", "Arr�t d'urgence !!!", "Arial", 800, 300, 100, Default, Default, 10, 800)
	Exit(10);	D�clenche l'arr�t imm�diat du script AutoIt en cours d'ex�cution
EndFunc

;G�re l'arr�t d'urgence arm� depuis l'en-t�te du script AutoIt jou�
Func R_ArretDemande()

	R_SetArretUrgence(True)	; Arr�t d'urgence demand�

	PopUp("STOP", "Arr�t demand� !!!", "Arial", 800, 300, 100, Default, Default, 10, 800)
EndFunc

; Retourne l'�tat du flag de demande d'arret d'urgence
Func R_IsArretUrgenceDemande()
	return $arretUrgence
EndFunc

;Affecte l'�tat de l'arret d'urgence
; $etat : True : arr�t d'urgence demand�; False : arr�t d'urgence non-demand�
Func R_SetArretUrgence($etat)
	$arretUrgence = $etat
EndFunc

;Arme un timer d'attente d'une dur�e exprim�e en secondes
Func R_Timer($dureeSecondes)

	If ($dureeSecondes > 0) Then
		Sleep($dureeSecondes * 1000)
	EndIf

EndFunc
;Arme un timer d'attente d'une dur�e exprim�e en secondes
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
		; cr�er le fichier temporary.au3 : $pathRejeu & "\" & $temporaryScript :: si le fichier existe on l'�crase !!
		If (FileExists($pathToResultat)) Then
			FileDelete($pathToResultat)
		EndIf

		FileWrite($pathToResultat, "")
		$file = FileOpen($pathToResultat, 1)
		FileWriteLine($file, "")
		FileWriteLine($file, "******************************* RESULTAT DES TESTS de REJEU ***********************************")
 		FileWriteLine($file, " Le " & @MDAY & "/" & @MON & "/" & @YEAR & " , � " & @HOUR & ":" & @MIN & ":" & @SEC & " .")
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
			;On ouvre le fichier texte et on l'ajoute (i.e append) � la suite dans le fichier de r�sultat du rejeu
			$fileTxt = FileOpen($pathTofichierText, 0)	;Ouverture du fichier texte en lecture seulement

			;On parcours le fichier texte et on copie son contenu � la suite
			$contenu = FileRead($fileTxt)

			;Ajout dans le fichier r�sultat du rejeu du texte extrait du fichier texte
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


;Retourne le nombre de minutes �coul�es depuis 0h00mn ce jour
Func NombreMinutesDepuisMinuit()
	return (@HOUR*60)+@MIN;
EndFunc

;--------------------------------------------------------------------------------------------------------------------------------

;Fait le reset des donn�es de chiffrement
Func ResetData()
	$sFilePath=""
	$text=""
EndFunc

;Affiche un popup pour pr�senter un texte pendant une dur�e donn�e, puis se termine automatiquement
Func PopUp($titre="", $text="", $font="Times New Roman", $timeout=3000, $w=Default, $h=Default, $xPos=Default, $yPos=Default, $size=12, $fontw=800)
	SplashTextOn($titre, $text, $w, $h, $xPos, $yPos, 0+1+16+32, $font, $size, $fontw)
	Sleep($timeout)
	SplashOff()
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Titre : Call_Error
 Objectif : Traite les �ventuelles erreur suite � DllCall
 Entr�e(s) : - nom de la fonction appel�e (pour le message d'erreur)
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
 Objectif : Traite les �ventuelles erreur suite � DllStructGetData
 Entr�e(s) : aucune
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


