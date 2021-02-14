; Variables pour les tailles des fenêtres

Local $xcreationliaisoncable = 959
Local $ycreationliaisoncable = 436
Local $xcreationliaisonFH = 959
Local $ycreationliaisonFH = 936
Local $xcreationliaisonsatellite = 959
Local $ycreationliaisonsatellite = 616
Local $xcreationliaisonconcession = 959
Local $ycreationliaisonconcession = 593
Local $xcreationliaisonsatelliteN4 = 959
Local $ycreationliaisonsatelliteN4 = 436
Local $sizey = $ycreationliaisonFH

; Création d'une liaison
; Près-requis : Fenêtre : Bureau
; Entrer :	Les 2 labels + 1 label d'identification du réseau (1 chiffre). Le type de liaison ainsi que son débit. Présence Oui ou Non du multiplexageBBE.
;			Indiquer le type de déport et l'équipement = Liste déroulante (label)
;			Indiquer le fournisseur, le nom du correspondant et le numéro du correspondant.
;			Indiquer le mode : désactiver pour ATPC et OLS.
;			Indiquer le type de climat.
; Sortie : Toutes les fenêtres sont fermées sauf les fenêtres : Bureau et Création d'un projet d'ouverture de liaison .
;		   Ouverture et Actif se lance.

Func creationliaison($label,$label2,$label3,$type,$debit="",$multiplexageBBE="",$deport="",$equipement="",$fournisseur="",$nomcorrespondant="",$telcorrespondant="",$ATPC="",$OLS="",$climat="")

   ;*********** Bureau ***********
   T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
   T_MouseClick("left",137,89) ;Fonctions
   T_Send("{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;CONDUITE -> Liaisons
   ;*********** Liste des liaisons ***********
   T_WinWaitActive("Liste des liaisons",1207,756,@ScriptLineNumber)
   T_MouseClick("left",176,32) ;Projet
   T_Send("{DOWN}{ENTER}") ;Ouverture
   ;*********** Création d'un projet d'ouverture de liaison ***********
   T_WinWaitActive("Création d'un projet d'ouverture de liaison",959,936,@ScriptLineNumber)

   $identifiantreseau = StringLeft($label,1) ;On récupère le premier chiffre du label pion
   $identifiantreseau2 = StringLeft($label2,1) ;On récupère le premier chiffre du label pion

   T_MouseClick("left",82,117) ;Label identifiantreseau
   T_Send($identifiantreseau & "{TAB}" & $label)
   T_MouseClick("left",191,116) ;Label identifiantreseau
   T_Send($identifiantreseau2 & "{TAB}" & $label2 & "{TAB}")

   ;##### PARTIAL WINDOW FUNCTION ##### Cas particulier : Nature passe automatiquement à Câble
   T_Log_Function("Nature",@ScriptLineNumber)
   $verificationnaturecable = T_Function_Partial_Window("Création d'un projet d'ouverture de liaison",412,146,448,162,"2411603F67DA89D79721B472E7BE3594",@ScriptLineNumber) ; 6_test_Création d'un projet d'ouverture de liaison.bmp
   $verificationnaturecablesatelliteN4 = T_Function_Partial_Window("Création d'un projet d'ouverture de liaison",412,146,474,161,"E8E125F3BA9534E7D00ECA24716AAAD7",@ScriptLineNumber); 0_ESPI_CONDUITE07_el1_vp_Création d'un projet d'ouverture de liaison.bmp

   If($verificationnaturecable) Then
	  $sizey = $ycreationliaisoncable ;Obtenir la taille (en y) de la fenêtre : liaison câble
   ElseIf($verificationnaturecablesatelliteN4) Then
	  $sizey = $ycreationliaisonsatelliteN4 ;Obtenir la taille (en y) de la fenêtre : liaison satelliteN4
   EndIf

   If($type = "FH" AND $verificationnaturecable = False AND $verificationnaturecablesatelliteN4 = False AND $verificationnaturecablesatelliteN4 = False) Then
	  $sizey = $ycreationliaisonFH ;Obtenir la taille (en y) de la fenêtre : liaison FH
   EndIf

   If($type = "cable" AND $verificationnaturecable = False AND $verificationnaturecablesatelliteN4 = False) Then ;On change la nature, pour la mettre à câble
	  T_MouseClick("left",504,153) ;Nature
	  Sleep(3000)
	  T_Send("{UP}{ENTER}") ;Câble

	  ; attendre "prêt"
	  T_Wait_Partial_Window("Création d'un projet d'ouverture de liaison", 9, ($ycreationliaisoncable-19), 35, ($ycreationliaisoncable-6), "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

	  $sizey = $ycreationliaisoncable ;Obtenir la taille (en y) de la fenêtre : liaison câble
   EndIf

   If($type = "satellite" AND $verificationnaturecable = False AND $verificationnaturecablesatelliteN4 = False) Then	;On change la nature, pour la mettre à satellite
	  T_MouseClick("left",504,153) ;Nature
	  Sleep(3000)
	  T_Send("{DOWN}{ENTER}") ;Satellite

	  ; attendre "prêt"
	  T_Wait_Partial_Window("Création d'un projet d'ouverture de liaison", 9, ($ycreationliaisonsatellite-19), 35, ($ycreationliaisonsatellite - 6), "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

	  If($deport = "V11") Then
			T_MouseClick("left",243,478) ;Type de déport
			T_Send("{DOWN}{ENTER}")	;Type de déport = V11
	  EndIf

	  T_MouseClick("left",192,363) ;Paramètres du satellite
	  T_MouseClick("left",214,487) ;Bande de fréquence
	  T_Send("{DOWN}{ENTER}") ;C
	  T_MouseClick("left",319,364) ;Paramètres de l'extrémité 1
	  T_MouseClick("left",181,518) ; fréquence Emission
	  T_MouseClick("left",181,550) ; fréquence Réception
	  T_MouseClick("left",414,519) ; fréquence intermédiaire Emission
	  T_MouseClick("left",414,549) ; fréquence intermédiaire Réception
	  T_MouseClick("left",461,366) ;Paramètres de l'extrémité 2
	  T_MouseClick("left",181,518) ; fréquence Emission
	  T_MouseClick("left",181,550) ; fréquence Réception
	  T_MouseClick("left",414,519) ; fréquence intermédiaire Emission
	  T_MouseClick("left",414,549) ; fréquence intermédiaire Réception

	  $sizey = $ycreationliaisonsatellite ;Obtenir la taille (en y) de la fenêtre : liaison satellite
   EndIf

   If($type = "concession" AND $verificationnaturecable = False AND $verificationnaturecablesatelliteN4 = False) Then	;On change la nature, pour la mettre à concession
	  T_MouseClick("left",504,153) ;Nature
	  Sleep(3000)
	  T_Send("{DOWN}{DOWN}{ENTER}") ;Concession

	  ; attendre "prêt"
	  T_Wait_Partial_Window("Création d'un projet d'ouverture de liaison", 9, ($ycreationliaisonconcession-19), 35, ($ycreationliaisonconcession - 6), "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

	  T_MouseClick("left",248,381) ;Nom du réseau fournisseur
	  T_Send($fournisseur)
	  T_MouseClick("left",238,484) ;Nom du correspondant
	  T_Send($nomcorrespondant)
	  T_MouseClick("left",236,521) ;Tél du correspondant
	  T_Send($telcorrespondant)

	  $sizey = $ycreationliaisonconcession ;Obtenir la taille (en y) de la fenêtre : liaison concession
   EndIf

   If($type = "satelliteN4" AND $verificationnaturecable = False AND $verificationnaturecablesatelliteN4 = False) Then	;On change la nature, pour la mettre à satelliteN4
	  T_MouseClick("left",504,153) ;Nature
	  Sleep(3000)
	  T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;satelliteN4

	  ; attendre "prêt"
	  T_Wait_Partial_Window("Création d'un projet d'ouverture de liaison", 9, ($ycreationliaisonconcession-19), 35, ($ycreationliaisonconcession - 6), "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

	  $sizey = $ycreationliaisonsatelliteN4 ;Obtenir la taille (en y) de la fenêtre : liaison satelliteN4
   EndIf

   If($ATPC <> "" OR $OLS <> "" OR $climat <> "") Then
	  T_MouseClick("left",160,363)	;Fréquences
	  If($ATPC = "desactiver") Then
		 T_MouseClick("left",445,707)	;Mode ATPC
		 T_Send("{DOWN}{ENTER}")	;Désactiver
	  EndIf
	  If($OLS = "desactiver") Then
		 T_MouseClick("left",444,736)	;Mode OLS
		 T_Send("{DOWN}{ENTER}")	;Désactiver
	  EndIf
	  If($climat = "moyen") Then
		 T_MouseClick("left",695,707)	;Type de climat
		 T_Send("{DOWN}{ENTER}")	;Moyen
	  EndIf
   EndIf

   If($equipement <> "") Then
	  T_MouseClick("left",162,364)	;Fréquences
	  If($equipement = "CHF-G4-8p") Then
		 T_MouseClick("left",387,452)
		 T_Send("{DOWN}{DOWN}{ENTER}") ;CHF-G4-8p
	  EndIf
   EndIf

   If($debit <> "") Then
	  T_MouseClick("left",674,119,598,117)	;Sélectionne le débit
	  T_MouseClick("left",72,30)	;Edition
	  Sleep(3000)
	  T_Send("{DOWN}{ENTER}")	;Copier
	  If (ClipGet() <> $debit) Then
		 T_MouseClick("left",674,119,598,117) 	;Sélectionne le débit
		 T_Send("{BS}" & $debit) ;On supprime le débit actuel et on ajoute le nouveau débit
	  EndIf
   EndIf

   If($multiplexageBBE = "Oui") Then
	  T_MouseClick("left",892,152) ;multiplexageBBE
	  T_Send("{DOWN}{ENTER}") ;Oui
   EndIf

   ;*********** Création d'un projet d'ouverture de liaison ***********
   T_WinWaitActive("Création d'un projet d'ouverture de liaison", 959,$sizey, @ScriptLineNumber)
   T_MouseClick("left", 20, 60) ; Click sur enregistrer
   Sleep(1000)
   T_MouseClick("left", 20, 60) ; Click sur enregistrer

	Sleep(3000)
	If(WinExists("Fenêtre d'interrogation")) Then
		T_Send("{ENTER}") ;Valider
	EndIf

   ; attendre "prêt"
   T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de liaison", 9, ($sizey-19), 35, ($sizey - 6), "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

   Ouverture("liaison",$label,$label2,$label3,"959",$sizey) ;On fait une ouverture de la liaison
   Actif("liaison",$label,$label2,$label3) ;On passe la liaison en actif

   T_Log("fermer la liste des liaisons", @ScriptLineNumber)
   T_WinWaitActive("Liste des liaisons", 1207, 756, @ScriptLineNumber)
   T_MouseClick("left",29,37) ;Fenêtre
   T_Send("{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
   T_WinWaitClose("Liste des liaisons", @ScriptLineNumber)

EndFunc

; Création d'une jonction
; Près-requis : Fenêtre : Bureau
; Entrer :	Les 2 labels + 1 label d'identification du réseau (1 chiffre). Le nombre de liaison à ajouter ainsi que son débit.
;			Vérification : True pour savoir si le débit restant est à 0. L'erreur : Oui ou Non, pour savoir si la jonction est créer.
; Sortie : Toutes les fenêtres sont fermées sauf les fenêtres : Bureau et Création d'un projet d'ouverture de jonction .
;		   Ouverture et Actif se lance.

Func creationjonction($label,$label2,$label3,$nbliaison="",$debit="",$verification="False",$erreur="Non")

   ;*********** Bureau ***********
   T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
   T_MouseClick("left",133,88) ;Fonctions
   T_Send("{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;CONDUITE -> Jonctions
   ;*********** Liste des jonctions ***********
   T_WinWaitActive("Liste des jonctions",698,598,@ScriptLineNumber)
   T_MouseClick("left",188,33) ;Projet
   T_Send("{DOWN}{ENTER}") ;Ouverture
   ;*********** Création d'un projet d'ouverture de jonction ***********
   T_WinWaitActive("Création d'un projet d'ouverture de jonction",934,909,@ScriptLineNumber)

   $identifiantreseau = StringLeft($label,1) ;On récupère le premier chiffre du label pion
   $identifiantreseau2 = StringLeft($label2,1) ;On récupère le premier chiffre du label pion
   ;Label identifiantreseau
   T_Send($identifiantreseau & "{TAB}" & $label)
   T_MouseClick("left",183,122) ;Label identifiantreseau
   T_Send($identifiantreseau2 & "{TAB}" & $label2)
   T_MouseClick("left",116,155)	;Valider le contexte

   	; attendre "prêt"
	T_Wait_Partial_Window("Création d'un projet d'ouverture de jonction", 9, 890, 35, 903, "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

   If ($nbliaison <> "") Then
	  For $i = 1 To $nbliaison
		 T_MouseClick("left",48,713)	;Click dans la liste
		 T_MouseClick("left",853,688)	;Click sur Ajouter
	  Next
   EndIf

   If ($debit <> "") Then
	  T_MouseClick("left",226,430,174,429)	;Sélectionne le débit
	  T_MouseClick("left",72,30)	;Edition
	  Sleep(3000)
	  T_Send("{DOWN}{ENTER}")	;Copier
	  $i=ClipGet() ;On stocke ce que l'on a copier dans la variable $i
	  If ($i <> $debit) Then
		 T_MouseClick("left",226,430,174,429) 	;Sélectionne le débit
		 T_Send("{BS}" & $debit) ;On supprime le débit actuel et on ajoute le nouveau débit
	  EndIf
   EndIf

   ;*********** Création d'un projet d'ouverture de jonction ***********
   T_WinWaitActive("Création d'un projet d'ouverture de jonction", 934,909, @ScriptLineNumber)
   T_MouseClick("left", 20, 60) ; Click sur enregistrer

   If ($erreur = "Non") Then	;Cas particulier = "Oui"

	  ; attendre "prêt"
	  T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de jonction", 9, 890, 35, 903, "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp

	  T_MouseClick("left",299,122,284,122) ;Sélectionne le label identifiant réseau
	  T_MouseClick("left",70,32) ;Edition
	  Sleep(3000)
	  T_Send("{DOWN}{ENTER}")	;Copier
	  $label3 = ClipGet() ;On stocke ce que l'on a copier dans la variable $label3

	  If($verification = "True") Then
		 ;##### WAIT PARTIAL WINDOW #####
		 T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de jonction",447,482,459,497,"90625F26B87FA2FF169A8FDB48168FD2",@ScriptLineNumber); 4_test_Edition d'un projet créé d'ouverture de jonction.bmp
	  EndIf

	  Ouverture("jonction",$label,$label2,$label3,"934","909") ;On fait une ouverture de la jonction
	  Actif("jonction",$label,$label2,$label3) ;On passe la jonction en actif

  Else

	  T_Log("fermer la création d'un projet d'ouverture de jonction : " & $label & " " & $label2 & " " & $label3, @ScriptLineNumber)
	  T_WinWaitActive("Création d'un projet d'ouverture de jonction", 934,909, @ScriptLineNumber)
	  T_MouseClick("left",29,37) ;Fenêtre
	  T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
	  T_WinWaitClose("Création d'un projet d'ouverture de jonction", @ScriptLineNumber)

   EndIf

   T_Log("fermer la liste des jonctions", @ScriptLineNumber)
   T_WinWaitActive("Liste des jonctions", 698,598, @ScriptLineNumber)
   T_MouseClick("left",29,37) ;Fenêtre
   T_Send("{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
   T_WinWaitClose("Liste des jonctions", @ScriptLineNumber)

EndFunc

; Création d'un pion
; Près-requis : Fenêtre : Bureau
; Entrer :	Label : 1 label.
;			EPMIP : Label.
;			Etat administratif : Liste déroulante (label)
;			Localisation : Label
;			N.commandement : Liste déroulante (label)
;			FS : Liste déroulante (label)
;			Idstation : Chiffres
;			Naturestation : Liste déroulante (label)
;			LabelHUBredondant : 1 Chiffre : Pour les HUB.
;			AdressageIP : manuel
;			Typecommunication : Liste déroulante (label)
;			N°PNIA et N°PNIA2 : Les 2 labels de chiffres.
;			AdresseIP : Label
; Sortie : Toutes les fenêtres sont fermées sauf les fenêtres : Bureau et Création d'un projet d'ouverture de pion .
;		   Dans ce scénario : Ouverture et Actif ne se lance pas (en commentaire). Pour la création d'un pion.

Func creationpion($label,$EPMIP="",$etatadministratif="",$localisation="",$ncommandement="",$FS="",$idstation="",$naturestation="",$labelHUBredondant="",$adressageIP="",$typecommunication="",$nPNIA="",$nPNIA2="",$adresseIP="")

   ;*********** Bureau ***********
   T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
   T_MouseClick("left",137,89) ;Fonctions
   T_Send("{DOWN}{RIGHT}{DOWN}{ENTER}") ;CONDUITE -> Pions sous-commandement

   ;*********** Liste des pions sous-commandement ***********
   T_WinWaitActive("Liste des pions sous-commandement",1280,638,@ScriptLineNumber)
   T_MouseClick("left",134,32) ;Pion
   T_Send("{DOWN}{ENTER}") ;Créer
   ;*********** Création d'un pion sous-commandement ***********
   T_WinWaitActive("Création d'un pion sous-commandement",1093,870,@ScriptLineNumber)
   T_MouseClick("left",125,120) ;Label pion
   T_Send($label)

   If($naturestation <> "") Then
	  T_MouseClick("left",677,319) ;Nature de la station
	  Sleep(1000)
	  If($naturestation = "HubHD") Then
		 T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;HubHD
	  EndIf
	  If($naturestation = "HubTHD") Then
		 T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;HubTHD
	  EndIf
   EndIf

   ; attendre "prêt"
   T_Wait_Partial_Window("Création d'un pion sous-commandement", 9, 851, 35, 864, "DED63A5C8A23DEB7D4A3AAAF0152E936", @ScriptLineNumber); 5_pouet81_Edition d'un projet créé d'ouverture de liaison.bmp
   If($EPMIP <> "") Then
	   T_MouseClick("left",300,117) ;EPM-IP
	   T_Send($EPMIP)
   EndIf
   If($localisation <> "") Then
	   T_MouseClick("left",291,149) ;Localisation
	   T_Send($localisation)
   EndIf
   If($ncommandement <> "") Then
	  T_MouseClick("left",763,153) ;N°commandement
	  T_Send("{ENTER}")
   EndIf
   If($FS <> "") Then
	  T_MouseClick("left",109,201) ;FS
	  T_Send("{DOWN}{ENTER}")
  EndIf
	If($idstation <> "") Then
	   T_MouseClick("left",204,317) ;Id station
	   T_Send($idstation)
	EndIf
	If($labelHUBredondant <> "") Then
	   T_MouseClick("left",210,346) ;Label HUB redondant
	   T_Send($labelHUBredondant)
	EndIf
	T_MouseClick("left",188,259)	;Adressage
	If($adressageIP <> "") Then
	  T_MouseClick("left",319,320) ;Renseignement des adresses IP
	  T_Send("{DOWN}{ENTER}") ;Manuel
	EndIf
	If($typecommunication <> "") Then
	  T_MouseClick("left",329,374) ;Type de communication
	  T_Send("{DOWN}{ENTER}") ;Transfert
	EndIf
   	If($nPNIA <> "") Then
	   T_MouseClick("left",401,457) ;N°PNIA
	   T_Send($nPNIA)
   	EndIf
   	If($nPNIA2 <> "") Then
	   T_MouseClick("left",500,459) ;N°PNIA2
	   T_Send($nPNIA2)
   	EndIf
   	If($adresseIP <> "") Then
	   T_MouseClick("left",427,617) ;Adresse IP
	   T_Send($adresseIP)
   	EndIf
	If($etatadministratif <> "") Then
	  T_MouseClick("left",764,123) ;Etat administratif
	  T_Send("{DOWN}{ENTER}") ;Réserve
	EndIf

   ;*********** Création d'un pion sous-commandement ***********
   T_WinWaitActive("Création d'un pion sous-commandement", 1093, 870, @ScriptLineNumber)
   T_MouseClick("left", 20, 60) ; Click sur enregistrer

   ; Attend après le mot : prêt
   ;##### WAIT PARTIAL WINDOW #####
   T_Wait_Partial_Window("Edition d'un pion sous-commandement",9, 851, 35, 864,"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

   ;*********** Edition d'un pion sous-commandement ***********
   T_WinWaitActive("Edition d'un pion sous-commandement",1093,870,@ScriptLineNumber)
   T_MouseClick("left",104,34) ;Projet
   T_Send("{DOWN}{ENTER}") ;Ouverture
   Sleep(5000)

   ;Ouverture("pion",$label,"","","1090","927") ;On fait une ouverture du pion
   ;Actif("pion",$label) ;On passe le pion en actif

   ;*********** Création d'un projet d'ouverture de pion ***********
   T_WinWaitActive("Création d'un projet d'ouverture de pion",1090,927,@ScriptLineNumber)

   ;*********** Edition d'un pion sous-commandement ***********
   T_WinWaitActive("Edition d'un pion sous-commandement",1093,870,@ScriptLineNumber)
   T_MouseClick("left",26,33) ;Fenêtre
   T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
   T_WinWaitClose("Edition d'un pion sous-commandement",@ScriptLineNumber)

   T_Log("fermer la liste des pions sous-commandement", @ScriptLineNumber)
   T_WinWaitActive("Liste des pions sous-commandement", 1280,638, @ScriptLineNumber)
   T_MouseClick("left",29,37) ;Fenêtre
   T_Send("{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
   T_WinWaitClose("Liste des pions sous-commandement", @ScriptLineNumber)

EndFunc

; Variables pour les tailles des fenêtres

Local $xlistepion = 1280
Local $ylistepion = 638
Local $xlisteliaison = 1207
Local $ylisteliaison = 756
Local $xlistejonction = 698
Local $ylistejonction = 598
Local $yresultatanalyseoc = 428

; Ouverture
; Près-requis : Fenêtre : Bureau et Création d'un projet d'ouverture de ... : (Déjà ouvert si la function creation... est appelé précédamment).
; Entrer :	Action : pion ou liaison ou jonction.
;			Les 2 labels + 1 label d'identification du réseau (1 chiffre).
;			Xwindows et Ywindows : Taille de : Création d'un projet d'ouverture de ... .
; Sortie : Toutes les fenêtres sont fermées sauf les fenêtres : Bureau et Liste des ... .

Func Ouverture($action, $label, $label2, $label3, $xwindows, $ywindows)

	Local $pion = False
	Local $pion2 = False
	Local $pion3 = False

	If($action = "pion") Then

		;*********** Création d'un projet d'ouverture de pion ***********
		T_WinWaitActive("Création d'un projet d'ouverture de pion", $xwindows, $ywindows, @ScriptLineNumber)
		T_MouseClick("left", 20, 60) ; Click sur enregistrer

 		; Attend après le mot : prêt
	    ;##### WAIT PARTIAL WINDOW #####
	    T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de pion",9,($ywindows-19),35,($ywindows-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		;*********** Edition d'un projet créé d'ouverture de pion ***********
		T_WinWaitActive("Edition d'un projet créé d'ouverture de pion", $xwindows, $ywindows, @ScriptLineNumber)
		T_MouseClick("left", 139, 32) ;Motifs
		T_Send("{DOWN}{ENTER}") ;Allouer
		; Attend après le mot : prêt
		;##### WAIT PARTIAL WINDOW #####
	    T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de pion",9,($ywindows-19),35,($ywindows-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		;*********** Edition d'un projet créé d'ouverture de pion ***********
		T_WinWaitActive("Edition d'un projet créé d'ouverture de pion", $xwindows, $ywindows, @ScriptLineNumber)

		T_MouseClick("left", 193, 64) ;Approuver le projet
		Sleep(20000)
		T_WinWaitClose("Edition d'un projet créé d'ouverture de pion",$xwindows, $ywindows)

	    If (WinExists("Liste des pions sous-commandement")=False) Then
		 ;*********** Bureau ***********
		 T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
		 T_MouseClick("left",138,90)
		 T_Send("{DOWN}{RIGHT}{DOWN}{ENTER}")
	    EndIf

		If Not $SIMINS_PRESENCE Then

			;*********** Liste des pions sous-commandement ***********
			T_WinWaitActive("Liste des pions sous-commandement", $xlistepion,$ylistepion, @ScriptLineNumber)

			; Définir le filtre à Réserve
			T_MouseClick("left", 194, 62) ;Définir le filtre
			T_MouseClick("left", 224, 62) ;Réinitialiser le filtre
		    ; Attend après le mot : prêt
		    ;##### WAIT PARTIAL WINDOW #####
		    T_Wait_Partial_Window("Liste des pions sous-commandement",9,($ylistepion-19),35,($ylistepion-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
			T_MouseClick("left", 255, 141) ;Défini
			T_MouseClick("left", 256, 194) ;Actif
			T_MouseClick("left", 246, 61) ;Appliquer

			;##### WAIT PARTIAL WINDOW #####
			T_Wait_Partial_Window("Liste des pions sous-commandement",9,($ylistepion-19),35,($ylistepion-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

			T_MouseClick("left",1237,337)	;Sélectionne toute la liste
			T_MouseClick("left",71,30)	;Edition
			Sleep(3000)
			T_Send("{DOWN}{ENTER}")	;Copier

			; Click sur le premier de la liste
			T_MouseClick("left", 31, 368)

			Liste($label)

			While($pion = False)
				T_MouseClick("left", 168, 33) ;Projet
				T_Send("{DOWN}{ENTER}") ; Ouverture
				Sleep(5000)
				If(WinActive("Liste des pions sous-commandement")) Then
					MsgBox(4096, "Erreur", "CR NOK de pion " & $label & " " & $label2 & " " & $label3, 10)
					T_Log("CR NOK de pion " & $label,@ScriptLineNumber)
					Exit(1)
				Else
					;*********** Edition d'un projet créé d'ouverture de pion ***********
					If(WinGetTitle("Création d'un projet de fermeture de pion") Or WinGetTitle("Création d'un projet de changement de configuration de pion") Or WinGetTitle("Création d'un projet d'ouverture de pion")) Then
						; Close
						T_MouseClick("left", 31, 31) ;Fenêtre
						T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter

					Else
						T_WinWaitActive("Edition d'un projet approuvé d'ouverture de pion",$xwindows,$ywindows,@ScriptLineNumber)
						T_MouseClick("left", 128, 117, 90, 117) ;Sélectionne le pion
						T_MouseClick("left", 69, 33) ;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion = T_Function_Bool_Clipboard($label, @ScriptLineNumber)

						If($pion = True) Then
							T_MouseClick("left", 271, 61) ;Simuler le compte-rendu
							;*********** Simulation de compte-rendu de projet ***********
							T_WinWaitActive("Simulation de compte-rendu de projet", 443, 308, @ScriptLineNumber)
							T_Log("disquette", @ScriptLineNumber)
							T_MouseClick("left", 12, 63) ;Enregistrer
							Sleep(10000)
							T_WinWaitClose("Simulation de compte-rendu de projet", 443, 308)
						Else
							; Close
							T_MouseClick("left", 36, 34) ;Fenêtre
							T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter
							T_WinWaitClose("Edition d'un pion sous-commandement",$xwindows,$ywindows)
						EndIf
					EndIf

				EndIf

			WEnd

		EndIf

	EndIf

	If($action = "liaison") Then ; $action = "liaison"

;~ 		;*********** Création d'un projet d'ouverture de liaison ***********
;~ 		T_WinWaitActive("Création d'un projet d'ouverture de liaison", $xwindows, $ywindows, @ScriptLineNumber)
;~ 		T_MouseClick("left", 20, 60) ; Click sur enregistrer

;~ 		; Attend après le mot : prêt
;~ 	    ;##### WAIT PARTIAL WINDOW #####
;~ 	    T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de liaison",9,($ywindows-19),35,($ywindows-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		;*********** Edition d'un projet créé d'ouverture de liaison ***********
		T_WinWaitActive("Edition d'un projet créé d'ouverture de liaison", $xwindows, $ywindows, @ScriptLineNumber)

		;##### WAIT PARTIAL WINDOW #####
		If (T_Function_Partial_Window("Edition d'un projet créé d'ouverture de liaison",412,147,430,161,"365DAF51C313FA849AB8350402AF19DA",@ScriptLineNumber) Or T_Function_Partial_Window("Edition d'un projet créé d'ouverture de liaison",412,147,493,162,"803A03F94506A08CED4772D65A2C2CCB",@ScriptLineNumber)) Then	; 1_test_Edition d'un projet créé d'ouverture de liaison.bmp	; 4_test_Edition d'un projet créé d'ouverture de liaison.bmp
			;Allouer fréqeunces
			T_MouseClick("left", 149, 35)
			T_Send("{DOWN}{DOWN}{DOWN}{ENTER}")
			Sleep(6000)
			;*********** Edition d'un projet créé d'ouverture de liaison ***********
			T_WinWaitActive("Edition d'un projet créé d'ouverture de liaison", $xwindows, $ywindows, @ScriptLineNumber)
			; Attend après le mot : prêt
			;##### WAIT PARTIAL WINDOW #####
			T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de liaison",9,($ywindows-19),35,($ywindows-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
	    EndIf

		T_MouseClick("left", 195, 63) ;Approuver le projet
		Sleep(20000)
		T_WinWaitClose("Edition d'un projet créé d'ouverture de liaison",$xwindows, $ywindows)

	    If (WinExists("Liste des liaisons")=False) Then
		 ;*********** Bureau ***********
		 T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
		 T_MouseClick("left",138,90)
		 T_Send("{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	    EndIf

		If Not $SIMINS_PRESENCE Then

			;*********** Liste des liaisons ***********
			T_WinWaitActive("Liste des liaisons", $xlisteliaison,$ylisteliaison, @ScriptLineNumber)

			;Filtre
			T_MouseClick("left", 195, 64) ;Définir le filtre
			T_MouseClick("left", 221, 64) ;Réinitialiser
		    ; Attend après le mot : prêt
		    ;##### WAIT PARTIAL WINDOW #####
		    T_Wait_Partial_Window("Liste des liaisons",9,($ylisteliaison-19),35,($ylisteliaison-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
			T_MouseClick("left", 193, 296) ;Click sur le champ à rechercher
			T_Send("{BS}" & $label) ;Ecrit le pion à rechercher
			T_MouseClick("left", 243, 62) ;Appliquer

			; Attend après le mot : prêt
			;##### WAIT PARTIAL WINDOW #####
			T_Wait_Partial_Window("Liste des liaisons",9,($ylisteliaison-19),35,($ylisteliaison-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

			T_MouseClick("left",1182, 404)	;Sélectionne toute la liste
			T_MouseClick("left",71,30)	;Edition
			Sleep(3000)
			T_Send("{DOWN}{ENTER}")	;Copier

			; Click sur le premier de la liste
			T_MouseClick("left", 31, 436)

			Liste($label,$label2,$label3)

			While($pion = False And $pion2 = False And $pion3 = False)

				T_MouseClick("left", 182, 33) ;Projet
				T_Send("{DOWN}{ENTER}") ; Ouverture
				Sleep(5000)

				If(WinActive("Liste des liaisons")) Then
					MsgBox(4096, "Erreur", "CR NOK de liaison " & $label & " " & $label2 & " " & $label3, 10)
					T_Log("CR NOK de liaison " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
					Exit(1)
				Else
					;*********** Edition d'un projet créé d'ouverture de liaison ***********
					If(WinGetTitle("Création d'un projet de fermeture de liaison") Or WinGetTitle("Création d'un projet de changement de configuration de liaison") Or WinGetTitle("Création d'un projet d'ouverture de liaison")) Then
						; Close
						T_MouseClick("left", 31, 31) ;Fenêtre
						T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter

					Else
						;*********** Edition d'un projet approuvé d'ouverture de liaison ***********
						T_WinWaitActive("Edition d'un projet approuvé d'ouverture de liaison",$xwindows,$ywindows,@ScriptLineNumber)
						Sleep(5000)
						T_MouseClick("left", 121, 117, 88, 117) ;Sélectionne le pion
						T_MouseClick("left", 69, 33) ;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion = T_Function_Bool_Clipboard($label, @ScriptLineNumber)

						T_MouseClick("left", 233, 116, 188, 116) ;Sélectionne le pion
						T_MouseClick("left", 69, 33) ;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion2 = T_Function_Bool_Clipboard($label2, @ScriptLineNumber)

						T_MouseClick("left", 301, 116, 292, 117) ;Sélectionne le pion
						T_MouseClick("left", 69, 33) ;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion3 = T_Function_Bool_Clipboard($label3, @ScriptLineNumber)

						If($pion = True And $pion2 = True And $pion3 = True) Then
							T_MouseClick("left", 271, 61) ;Simuler le compte-rendu
							;*********** Simulation de compte-rendu de projet ***********
							T_WinWaitActive("Simulation de compte-rendu de projet", 443, 308, @ScriptLineNumber)
							T_Log("disquette", @ScriptLineNumber)
							T_MouseClick("left", 12, 63) ;Enregistrer
							Sleep(10000)
							T_WinWaitClose("Simulation de compte-rendu de projet", 443, 308)

						Else
							; Close
							T_MouseClick("left", 31, 31) ;Fenêtre
							T_Send("{DOWN}{DOWN}{DOWN}{ENTER}")

						EndIf

					EndIf

				EndIf

			WEnd

		EndIf

	EndIf

	If($action = "jonction") Then
;~ 		;*********** Création d'un projet d'ouverture de jonction ***********
;~ 		T_WinWaitActive("Création d'un projet d'ouverture de jonction", $xwindows, $ywindows, @ScriptLineNumber)
;~ 		T_MouseClick("left", 20, 60) ; Click sur enregistrer

;~ 		; Attend après le mot : prêt
;~ 		;##### WAIT PARTIAL WINDOW #####
;~ 		T_Wait_Partial_Window("Edition d'un projet créé d'ouverture de jonction",9,($ywindows-19),35,($ywindows-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		;*********** Edition d'un projet approuvé d'ouverture de jonction ***********
		T_WinWaitActive("Edition d'un projet créé d'ouverture de jonction", $xwindows, $ywindows, @ScriptLineNumber)

		T_MouseClick("left", 195, 63) ;Approuver le projet
		Sleep(20000)
		T_WinWaitClose("Edition d'un projet créé d'ouverture de jonction",$xwindows, $ywindows)

	    If (WinExists("Liste des jonctions")=False) Then
		 ;*********** Bureau ***********
		 T_WinWaitActive("Bureau",692,107,@ScriptLineNumber)
		 T_MouseClick("left",138,90)
		 T_Send("{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	    EndIf

		If Not $SIMINS_PRESENCE Then

			;*********** Liste des jonctions ***********
			T_WinWaitActive("Liste des jonctions", $xlistejonction,$ylistejonction, @ScriptLineNumber)

			;Filtre
			T_MouseClick("left", 196, 61) ;Définir le filtre
			T_MouseClick("left", 219, 61) ;Réinitialiser
			; Attend après le mot : prêt
			;##### WAIT PARTIAL WINDOW #####
			T_Wait_Partial_Window("Liste des jonctions",9,($ylistejonction-19),35,($ylistejonction-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
			T_MouseClick("left", 146, 269) ;Click sur le champ à rechercher
			T_Send("{BS}" & $label) ;Ecrit le pion à rechercher
			T_MouseClick("left", 250, 62) ;Appliquer

			; Attend après le mot : prêt
			;##### WAIT PARTIAL WINDOW #####
			T_Wait_Partial_Window("Liste des jonctions",9,($ylistejonction-19),35,($ylistejonction-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

			T_MouseClick("left",665, 339)	;Sélectionne toute la liste
			T_MouseClick("left",71,30)	;Edition
			Sleep(3000)
			T_Send("{DOWN}{ENTER}")	;Copier

			; Click sur le premier de la liste
			T_MouseClick("left", 31, 371)

			Liste($label,$label2,$label3)

			While($pion = False And $pion2 = False And $pion3 = False)

				; Ouverture
				T_MouseClick("left", 182, 33) ;Projet
				T_Send("{DOWN}{ENTER}") ; Ouverture
				Sleep(5000)

				If(WinActive("Liste des jonction")) Then
					MsgBox(4096, "Erreur", "CR NOK de jonction " & $label & " " & $label2 & " " & $label3, 10)
					T_Log("CR NOK de jonction " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
					Exit(1)
				Else
					If(WinGetTitle("Création d'un projet de fermeture de jonction") Or WinGetTitle("Création d'un projet de changement de configuration de jonction") Or WinGetTitle("Création d'un projet d'ouverture de jonction")) Then
						; Close
						T_MouseClick("left", 31, 31) ;Fenêtre
						T_Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter

					Else
						;*********** Edition d'un projet créé d'ouverture de jonction ***********
						T_WinWaitActive("Edition d'un projet approuvé d'ouverture de jonction",$xwindows,$ywindows,@ScriptLineNumber)
						Sleep(5000)
						T_MouseClick("left", 128, 118, 90, 118) ;Sélectionne le pion
						T_MouseClick("left", 69, 33)	;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion = T_Function_Bool_Clipboard($label, @ScriptLineNumber)

						T_MouseClick("left", 241, 118, 197, 118) ;Sélectionne le pion2
						T_MouseClick("left", 69, 33)	;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion2 = T_Function_Bool_Clipboard($label2, @ScriptLineNumber)

						T_MouseClick("left", 301, 118, 286, 118) ;Sélectionne le pion3
						T_MouseClick("left", 69, 33)	;Edition
						Sleep(1000)
						T_Send("{DOWN}{ENTER}") ;Copier

						;##### CLIPBOARD FUNCTION #####
						T_Log_Function("Verification du pion d'ouverture", @ScriptLineNumber)
						$pion3 = T_Function_Bool_Clipboard($label3, @ScriptLineNumber)

						If($pion = True And $pion2 = True And $pion3 = True) Then
							T_MouseClick("left", 271, 61) ;Simuler le compte-rendu
							;*********** Simulation de compte-rendu de projet ***********
							T_WinWaitActive("Simulation de compte-rendu de projet", 443, 308, @ScriptLineNumber)
							T_Log("disquette", @ScriptLineNumber)
							T_MouseClick("left", 12, 63) ;Enregistrer
							Sleep(10000)
							T_WinWaitClose("Simulation de compte-rendu de projet", 443, 308)

						Else
							; Close
							T_MouseClick("left", 31, 31) ;Fenêtre
							T_Send("{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter

						EndIf

					EndIf

				EndIf

			WEnd

		EndIf

	EndIf

EndFunc   ;==>Ouverture

; Actif
; Permet de savoir si elle (pion ou liaison ou jonction) est bien passer actif.
; Près-requis : Fenêtre : Bureau et Liste des ... : (Déjà ouvert si la function ouverture... est appelé précédamment).
; Entrer :	Action : pion ou liaison ou jonction.
;			Les 2 labels + 1 label d'identification du réseau (1 chiffre).
; Sortie : Toutes les fenêtres sont fermées sauf les fenêtres : Bureau et Liste des ... .

Func Actif($action, $label, $label2="", $label3="")

	Local $pion = False
	Local $liaisonbool = False
	Local $jonctionbool = False

	If($action = "pion") Then
		 ;*********** Liste des pions sous-commandement ***********
		 T_WinWaitActive("Liste des pions sous-commandement", $xlistepion,$ylistepion, @ScriptLineNumber)

		 ; Définir le filtre à Actif
		 T_MouseClick("left", 192, 63) ; Définir le filtre
		 T_MouseClick("left", 224, 62) ;Réinitialiser
		 ; Attend après le mot : prêt
		 ;##### WAIT PARTIAL WINDOW #####
		 T_Wait_Partial_Window("Liste des pions sous-commandement",9,($ylistepion-19),35,($ylistepion-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
		 T_MouseClick("left", 255, 141) ;Défini
		 T_MouseClick("left", 255, 167) ;Réserve
		 T_MouseClick("left", 244, 61) ;Appliquer

		 ; Attend après le mot : prêt
		 ;##### WAIT PARTIAL WINDOW #####
		 T_Wait_Partial_Window("Liste des pions sous-commandement",9,($ylistepion-19),35,($ylistepion-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		 T_MouseClick("left",1237,337)	;Sélectionne toute la liste
		 T_MouseClick("left",71,30)	;Edition
		 Sleep(3000)
		 T_Send("{DOWN}{ENTER}")	;Copier

		 ;##### CLIPBOARD FUNCTION #####
		 T_Log_Function("Verification du pion actif", @ScriptLineNumber)
		 $pion = T_Function_Bool_Clipboard($label, @ScriptLineNumber) ;On regarde s'il y a le pion dans notre liste copier

		 	If($pion = True) Then
		MsgBox(4096, "Actif", "Le pion est passé à l'état Actif : " & $label, 10)
			T_Log("La pion est passé à l'état Actif : " & $label,@ScriptLineNumber)
		 Else
			MsgBox(4096, "Erreur", "CR NOK du pion " & $label, 10)
			T_Log("CR NOK de pion " & $label,@ScriptLineNumber)
			Exit(1)
		 EndIf

	EndIf

	If($action = "liaison") Then ; $action = "liaison"
		;*********** Liste des liaisons ***********
		T_WinWaitActive("Liste des liaisons", $xlisteliaison,$ylisteliaison, @ScriptLineNumber)

		; Définir le filtre à Actif
		T_MouseClick("left", 195, 64) ; Définir le filtre
		T_MouseClick("left", 221, 64) ;Réinitialiser
		; Attend après le mot : prêt
		;##### WAIT PARTIAL WINDOW #####
		T_Wait_Partial_Window("Liste des liaisons",9,($ylisteliaison-19),35,($ylisteliaison-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
		T_MouseClick("left", 642, 214) ;Etat administratif
		T_Send("{UP}{ENTER}") ;Actif
		T_MouseClick("left", 243, 62) ;Appliquer

		; Attend après le mot : prêt
		;##### WAIT PARTIAL WINDOW #####
		T_Wait_Partial_Window("Liste des liaisons",9,($ylisteliaison-19),35,($ylisteliaison-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		 T_MouseClick("left",1182,404)	;Sélectionne toute la liste
		 T_MouseClick("left",71,30)	;Edition
		 Sleep(3000)
		 T_Send("{DOWN}{ENTER}")	;Copier

		 ;##### CLIPBOARD FUNCTION #####
		 T_Log_Function("Verification du pion d'ouverture : " & $label & " pour la liaison", @ScriptLineNumber)
		 $identifiantreseau = StringLeft($label,1) ;On récupère le premier chiffre du label pion
		 $identifiantreseau2 = StringLeft($label2,1) ;On récupère le premier chiffre du label pion
		 $liaisonstring = $identifiantreseau & $label & " /" & $identifiantreseau2 & $label2 & " /" & $label3
		 $liaisonbool = StringInStr(ClipGet(),$liaisonstring) ;On regarde s'il y a la liaison dans notre liste copier

		 If($liaisonbool = True) Then
			MsgBox(4096, "Actif", "La liaison est passée à l'état Actif : " & $label & " " & $label2 & " " & $label3, 10)
			T_Log("La liaison est passée à l'état Actif : " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
		 Else
			MsgBox(4096, "Erreur", "CR NOK de liaison " & $label & " " & $label2 & " " & $label3, 10)
			T_Log("CR NOK de liaison " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
			Exit(1)
		 EndIf

	EndIf

	If($action = "jonction") Then
		 ;*********** Liste des jonctions ***********
		 T_WinWaitActive("Liste des jonctions", $xlistejonction,$ylistejonction, @ScriptLineNumber)

		 ; Définir le filtre à Actif
		 T_MouseClick("left", 196, 61) ; Définir le filtre
		 T_MouseClick("left", 219, 61) ;Réinitialiser
		 ; Attend après le mot : prêt
		 ;##### WAIT PARTIAL WINDOW #####
		 T_Wait_Partial_Window("Liste des jonctions",9,($ylistejonction-19),35,($ylistejonction-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp
		 T_MouseClick("left", 617, 145) ;Etat administratif
		 T_Send("{UP}{ENTER}") ;Actif
		 T_MouseClick("left", 250, 62) ;Appliquer

		 ; Attend après le mot : prêt
		 ;##### WAIT PARTIAL WINDOW #####
		 T_Wait_Partial_Window("Liste des jonctions",9,($ylistejonction-19),35,($ylistejonction-6),"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

		 T_MouseClick("left",665,340)	;Sélectionne toute la liste
		 T_MouseClick("left",71,30)	;Edition
		 Sleep(3000)
		 T_Send("{DOWN}{ENTER}")	;Copier

		 ;##### CLIPBOARD FUNCTION #####
		 T_Log_Function("Verification du pion d'ouverture : " & $label & " pour la jonction", @ScriptLineNumber)
		 $identifiantreseau = StringLeft($label,1) ;On récupère le premier chiffre du label pion
		 $identifiantreseau2 = StringLeft($label2,1) ;On récupère le premier chiffre du label pion
		 $jonctionstring = $identifiantreseau & $label & " /" & $identifiantreseau2 & $label2 & " /" & $label3
		 $jonctionbool = StringInStr(ClipGet(),$jonctionstring) ;On regarde s'il y a la jonction dans notre liste copier

		 If($jonctionbool = True) Then
			MsgBox(4096, "Actif", "La jonction est passée à l'état Actif : " & $label & " " & $label2 & " " & $label3, 10)
			T_Log("La jonction est passée à l'état Actif : " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
		 Else
			MsgBox(4096, "Erreur", "CR NOK de jonction " & $label & " " & $label2 & " " & $label3, 10)
			T_Log("CR NOK de jonction " & $label & " " & $label2 & " " & $label3,@ScriptLineNumber)
			Exit(1)
		 EndIf

	EndIf

EndFunc   ;==>Actif

; Prise de contact

Func Contact()
   ;*********** Bureau ***********
   T_WinWaitActive("Bureau", 692, 107, @ScriptLineNumber)
   T_MouseClick("left", 138, 88) ;Fonctions
   T_Send("{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;CONDUITE -> Gestion fréquences
   ;*********** Accès au coordinateur de fréquences ***********
   T_WinWaitActive("Accès au coordinateur de fréquences", 508, 438, @ScriptLineNumber)
   T_MouseClick("left", 34, 152) ;Click sur le premier de la liste
   T_MouseClick("left", 110, 31) ;Contact
   T_Send("{DOWN}{ENTER}") ;Prendre contact

   ;##### WAIT PARTIAL WINDOW #####
   T_Wait_Partial_Window("Accès au coordinateur de fréquences",9,419,35,432,"DED63A5C8A23DEB7D4A3AAAF0152E936",@ScriptLineNumber); 7_test_Liste des pions sous-commandement.bmp

   T_MouseClick("left", 28, 35) ;Fenêtre
   T_Send("{DOWN}{DOWN}{DOWN}{ENTER}") ;Quitter

EndFunc   ;==>Contact
