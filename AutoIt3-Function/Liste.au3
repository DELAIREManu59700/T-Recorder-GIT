;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Version : 1.0
;Date : Jeudi 23 Juin 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Opt("MouseCoordMode",0)
Opt("PixelCoordMode",0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Près-requis :
;Cliquer sur le carré noir : Permet de sélectionner toute la liste.
;Edition -> Copier
;Sélectionner le premier de la liste.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;$label,$label2="",$label3="";;;;;;;;;;
;$label -> Un label obligatoire.
;$label2 -> Un label obligatoire pour liaison ou jonction sinon rien mettre pour un pion.
;$label3 -> Un label obligatoire pour liaison ou jonction sinon rien mettre pour un pion.

Func Liste($label,$label2="",$label3="")

Local $labelComplet,$action,$countLine

$j = 1

	If ($label <> "" And $label2 <> "" And $label3 <> "") Then
		Local $identifiantreseau = StringLeft($label,1)
		Local $identifiantreseau2 = StringLeft($label2,1)
		$labelComplet = $identifiantreseau & $label & " /" & $identifiantreseau2 & $label2 & " /" & $label3
		$action = "liaisonjonction"
	ElseIf ($label <> "" And $label2 = "" And $label3 = "") Then
		$labelComplet = $label
		$action = "pion"
	Else
		MsgBox(4096,"Erreur","Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $label3,10)
		T_Log("Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
		Exit
	EndIf

	$countLine = StringSplit(ClipGet(), @CRLF)
	$countLine = Int((UBound($countLine))) - 1

Dim $gettitle[$countLine]

	For $i = 2 To $countLine

	   $gettitle = StringSplit(ClipGet(), @CRLF)
	   If($action = "liaisonjonction") Then
		$gettitle[$i] = StringMid($gettitle[$i],1,15)	;Read 15 character
	   ElseIf($action = "pion") Then
		$gettitle[$i] = StringMid($gettitle[$i],1,StringLen($labelComplet))	;Read Label character
	   EndIf
	   If($gettitle[$i] = $labelComplet) Then
		   If($countLine <> "2") Then
			   While $j <> $i
				   T_Send("{DOWN}")
					$j = $j + 1
				WEnd
			EndIf
			Return
		EndIf

	Next

If($action = "liaisonjonction") Then
	MsgBox(4096,"Erreur","La liaison ou jonction : " & $labelComplet & " n'a pas été trouvée dans la liste",10)
	T_Log("La liaison ou la jonction : " & $labelComplet & " n'a pas été trouvée dans la liste",@ScriptLineNumber)
ElseIf($action = "pion") Then
	MsgBox(4096,"Erreur","Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",10)
	T_Log("Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",@ScriptLineNumber)
EndIf

Exit(1)

EndFunc

;;;;;;;;;;$label,$label2="",$labelindice="";;;;;;;;;;
;$label -> Un label obligatoire.
;$label2 -> Un label obligatoire pour liaison ou jonction sinon rien mettre pour un pion.
;$labelindice -> Un label : l'indice, obligatoire pour liaison ou jonction sinon rien mettre pour un pion.

Func ListeManfut($label,$label2="",$labelindice="")

Local $labelComplet,$labelComplet2,$action,$countLine,$identifiantreseau,$identifiantreseau2,$identifiantreseau3,$identifiantreseau4

$j = 2

	If ($label <> "" And $label2 = "" And $labelindice = "") Then
		$identifiantreseau = StringLeft($label,1)
		$identifiantreseau2 = StringMid($label,2,1)
		$labelComplet = $identifiantreseau & "/" & $identifiantreseau2 & "/" & $label
	ElseIf($label2 <> "" And $labelindice <> "") Then
		$identifiantreseau = StringLeft($label,1)
		$identifiantreseau2 = StringMid($label,2,1)
		$labelComplet = $identifiantreseau & "/" & $identifiantreseau2 & "/" & $label
		$identifiantreseau3 = StringLeft($label2,1)
		$identifiantreseau4 = StringMid($label2,2,1)
		$labelComplet2 = $labelComplet & "	" & $identifiantreseau3 & "/" & $identifiantreseau4 & "/" & $label2 & "	" & $labelindice
	Else
		MsgBox(4096,"Erreur","Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $labelindice,10)
		T_Log("Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $labelindice,@ScriptLineNumber)
		Exit
	EndIf

	$countLine = StringSplit(ClipGet(), @CRLF)
	$countLine = Int((UBound($countLine))) - 1

Dim $gettitle[$countLine]

	For $i = 2 To $countLine

	   $gettitle = StringSplit(ClipGet(), @CRLF)


	   If($label2 <> "" And $labelindice <> "") Then
		$gettitle[$i] = StringMid($gettitle[$i],1,19)	;Read 19 character
	   Else
		$gettitle[$i] = StringMid($gettitle[$i],1,8)	;Read 8 character
	   EndIf

	   If(($gettitle[$i] = $labelComplet) Or ($gettitle[$i] = $labelComplet2)) Then
			If($countLine <> "2") Then
			   While $j <> $i
				   T_Send("{DOWN}")
					$j = $j + 1
				WEnd
			EndIf
			Return
		EndIf

	Next

If($label2 <> "" And $labelindice <> "") Then
	MsgBox(4096,"Erreur","La liaison ou jonction : " & $labelComplet2 & " n'a pas été trouvée dans la liste",10)
	T_Log("La liaison ou la jonction : " & $labelComplet & " n'a pas été trouvée dans la liste",@ScriptLineNumber)
Else
	MsgBox(4096,"Erreur","Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",10)
	T_Log("Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",@ScriptLineNumber)
EndIf

Exit(1)

EndFunc




#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: FindLineInList
 Goal	: Find a line in the array of the window's name : [Liste des objets planifiés 1]. Fine for the objects (Pions,laisons,jonctions)
		  Don't use it for (Pions externes, jonctions inter-réseau IP, zone de mobilité)
 Input	: The identification name of the component to look for (Mandatory).
		  "1/A/1A01", "1/A/1A01	1/B/B01", "1/F/1F05	1/F/1F02	1" ...
 Output	: None. It will simply by a T_MouseClick select the right component
 Request: In the clipboard, copy all the array (black square + copy)
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func FindLineInList($identifiant)
	$found = False
	const $NB_LIGNES_VISIBLES = 13;
	const $NB_PIXEL_LIGNE_TABLEAU = 26;
	Local $clipboard,$cptLigne,$array, $cptLigne

	; On s'assure que l'ascenseur est en haut
	$isAscenceurEnHaut = False;
	T_WinWaitActive("Liste des objets planifiés 1",948,688,@ScriptLineNumber)
	$isAscenceurEnHaut = T_Function_Partial_Window("Liste des objets planifiés 1",902,302,915,323,"5A969EB265C61F83744B521DE050F14A",@ScriptLineNumber);
	$gardeFou = 25
	while ( $isAscenceurEnHaut == False and $gardefou > 0)
		T_MouseClick("left",909,309) ; ascenseur ^
		$gardeFou = $gardeFou - 1
	WEnd

	; On sélectionne le 1er élément de la liste
	;T_MouseClick("left",44,307) ; 1er de la liste

	; On détermine la ligne ou se trouve l'identifiant dans le tableau
	$clipboard = ClipGet()
	$cptLigne = 0;
	$array = StringSplit($clipboard, @CRLF)
	; indice = 0 : nombre d'éléments dans le tableau
	; indice = 1 : La première ligne n'est pas lue, car il s'agit des noms des colonnes
	; Donc on commence par l'indice 2
	For $cptLigne = 2 to $array[0]
		ConsoleWrite("$line("&$cptLigne&") = [" & $array[$cptLigne] & "]" & @CRLF)
		if( StringInStr($array[$cptLigne], $identifiant) <> 0) Then
			ConsoleWrite("Trouvé : ligne("&$cptLigne&") = " & $cptLigne & @CRLF)
			$found = True
			ExitLoop
		Endif
	Next

	ConsoleWrite("$cptLigne = [" & $cptLigne & "]"&@CRLF)
	; On sélectionne le bon élément dans le tableau
	If $cptLigne <= $NB_LIGNES_VISIBLES then
		; L'élément est visible immédiatement
		T_MouseClick("left",44,307+$NB_PIXEL_LIGNE_TABLEAU*($cptLigne-2)) ; On sélectionne l'élement dans le tableau
	Else
		; L'élément n'est pas visible immédiatement, il faut utiliser l'ascenseur !
		For $k = 1 To ($cptLigne-$NB_LIGNES_VISIBLES)
			T_MouseClick("left",909,619) ; ascenseur v
		Next
		T_MouseClick("left",44,593) ; On sélectionne l'élement dans le tableau
	Endif
	return $found
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Liste2 permet d'éviter les {DOWN} en faisant des clicks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Près-requis :
;Cliquer sur le carré noir : Permet de sélectionner toute la liste.
;Edition -> Copier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;$label,$label2="",$label3="";;;;;;;;;;
;$label -> Un label obligatoire.
;$label2 -> Un label obligatoire pour liaison ou jonction sinon mettre pour un pion "".
;$label3 -> Un label obligatoire pour liaison ou jonction sinon mettre pour un pion "".
;$xliste -> Une coordonnée obligatoire pour indiquer le x du premier de la liste.
;$yliste -> Une coordonnée obligatoire pour indiquer le y du premier de la liste.
;$xdescend -> Une coordonnée obligatoire pour indiquer le x de la flèche du bas de la liste déroulante.
;$ydescend -> Une coordonnée obligatoire pour indiquer le y de la flèche du bas de la liste déroulante.
;$xmonter -> Une coordonnée non obligatoire pour indiquer le x de la flèche du haut de la liste déroulante.
;$ymonter -> Une coordonnée non obligatoire pour indiquer le y de la flèche du haut de la liste déroulante.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Exemple :
;	Liste2("1A01","","","10","500","300","1000") ; Pour pion
;	Liste2("1A01","1A02","1","10","500","300","1000") ; Pour liaison ou jonction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Local $nbclickdescend = 0 ;Permet de savoir si on doit remonter en haut de la liste

Func Liste2($label,$label2,$label3,$xliste,$yliste,$xdescend,$ydescend,$xmonter=0,$ymonter=0)

Local $labelComplet,$action,$countLine,$vardefault,$finListe=False,$pos,$var,$k,$nbLigne

$j = 2
	If ($xliste <> "" And $yliste <> "" And $xdescend <> "" And $ydescend <> "") Then

		If ($label <> "" And $label2 <> "" And $label3 <> "") Then
			Local $identifiantreseau = StringLeft($label,1)
			Local $identifiantreseau2 = StringLeft($label2,1)
			$labelComplet = $identifiantreseau & $label & " /" & $identifiantreseau2 & $label2 & " /" & $label3
			$action = "liaisonjonction"
		ElseIf ($label <> "" And $label2 = "" And $label3 = "") Then
			$labelComplet = $label
			$action = "pion"
		Else
			MsgBox(4096,"Erreur","Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $label3,10)
			T_Log("Le pion ou la liaison ou la jonction ne correspond pas aux paramètres entrées pour être trouver dans la liste : " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
			Exit
		EndIf

		T_MouseClick("left",$xliste,$yliste) ;Click sur le premier de la liste
		$countLine = StringSplit(ClipGet(), @CRLF)
		$countLine = Int((UBound($countLine))) - 1
		$pos = MouseGetPos() ;On récupère les coordonnées du curseur
		$vardefault = PixelGetColor( $pos[0] , $pos[1] ) ;On regarde la couleur sous le curseur

		If($nbclickdescend <> 0) Then
			$nbclickdescend = $nbclickdescend+3 ;+3 si on crée trois pions,liaisons ou jonctions car la liste se décale de 1 automatiquement (valeur à incrémenter à son souhait)
			While $nbclickdescend <> 0
				T_MouseClick("left",$xmonter,$ymonter)
				Sleep(250)
				$nbclickdescend = $nbclickdescend - 1
			WEnd
			T_MouseClick("left",$xliste,$yliste) ;Click sur le premier de la liste
		EndIf

		Dim $gettitle[$countLine]

			For $i = 2 To $countLine

			   $gettitle = StringSplit(ClipGet(), @CRLF)
			   If($action = "liaisonjonction") Then
				$gettitle[$i] = StringMid($gettitle[$i],1,15)	;Read 15 character
			   ElseIf($action = "pion") Then
				$gettitle[$i] = StringMid($gettitle[$i],1,StringLen($labelComplet))	;Read Label character
			   EndIf
			   If($gettitle[$i] = $labelComplet) Then
				   If($countLine <> "2") Then
					   While $j <> $i
							$yliste = $yliste + 26
							T_MouseClick("left", $xliste, $yliste)
							$pos = MouseGetPos() ;On récupère les coordonnées du curseur
							$var = PixelGetColor( $pos[0] , $pos[1] ) ;On regarde la couleur sous le curseur
							$nbLigne = $nbLigne + 1 ;Permet de compter le nombre de ligne.

							If($var <> $vardefault) Then ;Si il est différent de bleu alors on descend la liste
								$yliste = $yliste - 26
								;For $k = 0 To $nbLigne - 2 ;Cela me permet de descendre de nbLigne.
									T_MouseClick("left", $xdescend, $ydescend)
									$yliste = $yliste - 26
									$nbclickdescend = $nbclickdescend + 1
								;Next
								;$nbLigne = 0
								$j = $j - 1
							EndIf

							$j = $j + 1
						WEnd
					EndIf

					Return
				EndIf

			Next

		If($action = "liaisonjonction") Then
			MsgBox(4096,"Erreur","La liaison ou jonction : " & $labelComplet & " n'a pas été trouvée dans la liste",10)
			T_Log("La liaison ou la jonction : " & $labelComplet & " n'a pas été trouvée dans la liste",@ScriptLineNumber)
		ElseIf($action = "pion") Then
			MsgBox(4096,"Erreur","Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",10)
			T_Log("Le pion : " & $labelComplet & " n'a pas été trouvé dans la liste",@ScriptLineNumber)
		EndIf
	Else
		If($xliste = "") Then
			MsgBox(4096,"Erreur","La coordonnée x de la liste est vide : ",10)
			T_Log("La coordonnée x de la liste est vide : ",@ScriptLineNumber)
		ElseIf($yliste = "") Then
			MsgBox(4096,"Erreur","La coordonnée y de la liste est vide : ",10)
			T_Log("La coordonnée y de la liste est vide : ",@ScriptLineNumber)
		ElseIf($xdescend = "") Then
			MsgBox(4096,"Erreur","La coordonnée x de la flèche du bas de la liste déroulante est vide : ",10)
			T_Log("La coordonnée x de la flèche du bas de la liste déroulante est vide : ",@ScriptLineNumber)
		ElseIf($ydescend = "") Then
			MsgBox(4096,"Erreur","La coordonnée y de la flèche du bas de la liste déroulante est vide : ",10)
			T_Log("La coordonnée y de la flèche du bas de la liste déroulante est vide : ",@ScriptLineNumber)
		EndIf
	EndIf
Exit(1)

EndFunc