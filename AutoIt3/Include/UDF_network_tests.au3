#include-once

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 UDF NETWORK TESTS
 Auteur:	A. Barféty
		Ph. Garrigue

 Objet de l'essai : Bibliothèque de fonctions pour le lancement de tests en réseau
 Pré-requis : #include <UDF_tests> ; le script UDF_tests.au3 doit être présent dans le dossier "includes"
			de AutoIt3.

#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

;!!!!!!A CHANGER DOSSIER PAR DEFAUT !!!!!!
#Include "UDF_tests.au3"

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	WinWaitActive functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,0)
EndFunc

Func T_1_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,1)
EndFunc

Func T_2_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,2)
EndFunc

Func T_3_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,3)
EndFunc

Func T_4_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,4)
EndFunc

Func T_5_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,5)
EndFunc

Func T_6_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,6)
EndFunc

Func T_7_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,7)
EndFunc

Func T_8_WinWaitActive($windowTitle,$length,$height,$lineNb,$timeout=300000)
	T_WinWaitActive('"'&$windowTitle&'"',$length,$height,$lineNb,True,$timeout,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	WinWaitClose functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 0)
EndFunc

Func T_1_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 1)
EndFunc

Func T_2_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 2)
EndFunc

Func T_3_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 3)
EndFunc

Func T_4_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 4)
EndFunc

Func T_5_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 5)
EndFunc

Func T_6_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 6)
EndFunc

Func T_7_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 7)
EndFunc

Func T_8_WinWaitClose($windowTitle, $lineNb, $timeout=300000)
	T_WinWaitClose('"'&$windowTitle&'"', @ScriptLineNumber, $timeout, True, 8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	MouseClick functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,0)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,0)
	EndIf
EndFunc

Func T_1_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,1)
		ConsoleWrite('T_1_MouseClick'&@CRLF)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,1)
		ConsoleWrite('T_1_MouseClick'&@CRLF)
	EndIf
EndFunc

Func T_2_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,2)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,2)
	EndIf
EndFunc

Func T_3_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,3)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,3)
	EndIf
EndFunc

Func T_4_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,4)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,4)
	EndIf
EndFunc

Func T_5_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,5)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,5)
	EndIf
EndFunc

Func T_6_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,6)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,6)
	EndIf
EndFunc

Func T_7_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,7)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,7)
	EndIf
EndFunc

Func T_8_MouseClick($mouseButton,$x,$y,$xx=-1,$yy=-1,$speed=-1)
	If $xx<>-1 AND $yy<>-1 Then
		T_MouseClick('"'&$mouseButton&'"',$x,$y,$xx,$yy,$speed,8)
	Else
		T_MouseClick('"'&$mouseButton&'"',$x,$y,-1,-1,$speed,8)
	EndIf
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	WinGetPos functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 0)
EndFunc

Func T_1_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 1)
EndFunc

Func T_2_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 2)
EndFunc

Func T_3_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 3)
EndFunc

Func T_4_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 4)
EndFunc

Func T_5_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 5)
EndFunc

Func T_6_WinGetPos($titre,$ligne)
     T_WinGetPos($titre, $ligne, 6)
EndFunc

Func T_7_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 7)
EndFunc

Func T_8_WinGetPos($titre,$ligne)
	T_WinGetPos($titre, $ligne, 8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	RefreshPos functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_RefreshPos()
	T_RefreshPos(0)
EndFunc

Func T_1_RefreshPos()
	T_RefreshPos(1)
EndFunc

Func T_2_RefreshPos()
	T_RefreshPos(2)
EndFunc

Func T_3_RefreshPos()
	T_RefreshPos(3)
EndFunc

Func T_4_RefreshPos()
	T_RefreshPos(4)
EndFunc

Func T_5_RefreshPos()
	T_RefreshPos(5)
EndFunc

Func T_6_RefreshPos()
	T_RefreshPos(6)
EndFunc

Func T_7_RefreshPos()
	T_RefreshPos(7)
EndFunc

Func T_8_RefreshPos()
	T_RefreshPos(8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_Full_Window functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	ConsoleWrite('T_0_Assert_Full_Window')
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,0)
EndFunc

Func T_1_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,1)
EndFunc

Func T_2_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,2)
EndFunc

Func T_3_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,3)
EndFunc

Func T_4_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,4)
EndFunc

Func T_5_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,5)
EndFunc

Func T_6_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,6)
EndFunc

Func T_7_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,7)
EndFunc

Func T_8_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber)
	T_Assert_Full_Window($windowTitle,$recorded_checksum,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_Partial_Window functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,0)
EndFunc

Func T_1_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,1)
EndFunc

Func T_2_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,2)
EndFunc

Func T_3_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,3)
EndFunc

Func T_4_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,4)
EndFunc

Func T_5_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,5)
EndFunc

Func T_6_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,6)
EndFunc

Func T_7_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,7)
EndFunc

Func T_8_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Assert_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Function_Partial_Window functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,0)
EndFunc

Func T_1_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,1)
EndFunc

Func T_2_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,2)
EndFunc

Func T_3_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,3)
EndFunc

Func T_4_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,4)
EndFunc

Func T_5_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,5)
EndFunc

Func T_6_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,6)
EndFunc

Func T_7_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,7)
EndFunc

Func T_8_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber)
	T_Function_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_Menu functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,0)
EndFunc

Func T_1_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,1)
EndFunc

Func T_2_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,2)
EndFunc

Func T_3_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,3)
EndFunc

Func T_4_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,4)
EndFunc

Func T_5_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,5)
EndFunc

Func T_6_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,6)
EndFunc

Func T_7_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,7)
EndFunc

Func T_8_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber)
	T_Assert_Menu($recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_Color functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,0)
EndFunc

Func T_1_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,1)
EndFunc

Func T_2_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,2)
EndFunc

Func T_3_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,3)
EndFunc

Func T_4_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,4)
EndFunc

Func T_5_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,5)
EndFunc

Func T_6_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,6)
EndFunc

Func T_7_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,7)
EndFunc

Func T_8_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber=-2)
	T_Assert_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Wait_Full_Window functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,0)
EndFunc

Func T_1_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,1)
EndFunc

Func T_2_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,2)
EndFunc

Func T_3_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,3)
EndFunc

Func T_4_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,4)
EndFunc

Func T_5_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,5)
EndFunc

Func T_6_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,6)
EndFunc

Func T_7_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,7)
EndFunc

Func T_8_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Full_Window($windowTitle,$recorded_checksum,$lineNumber,$timeout,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Wait_Partial_Window functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,0)
EndFunc

Func T_1_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,1)
EndFunc

Func T_2_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,2)
EndFunc

Func T_3_Wait_Partial_Window($windowTitle,$recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$recorded_checksum,$posX1,$posY1,$posX2,$posY2,$lineNumber,$timeout,True,3)
EndFunc

Func T_4_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,4)
EndFunc

Func T_5_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,5)
EndFunc

Func T_6_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,6)
EndFunc

Func T_7_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,7)
EndFunc

Func T_8_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout=120000)
	T_Wait_Partial_Window($windowTitle,$posX1,$posY1,$posX2,$posY2,$recorded_checksum,$lineNumber,$timeout,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Wait_Color functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,0)
EndFunc

Func T_1_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,1)
EndFunc

Func T_2_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,2)
EndFunc

Func T_3_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,3)
EndFunc

Func T_4_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,4)
EndFunc

Func T_5_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,5)
EndFunc

Func T_6_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,6)
EndFunc

Func T_7_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,7)
EndFunc

Func T_8_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout=120000)
	T_Wait_Color($windowTitle,$posX,$posY,$recorded_rgb,$lineNumber,$timeout,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_Clipboard functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,0)
EndFunc

Func T_1_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,1)
EndFunc

Func T_2_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,2)
EndFunc

Func T_3_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,3)
EndFunc

Func T_4_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,4)
EndFunc

Func T_5_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,5)
EndFunc

Func T_6_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,6)
EndFunc

Func T_7_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,7)
EndFunc

Func T_8_Assert_Clipboard($regExp,$lineNumber=-2)
	T_Assert_Clipboard($regExp,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Send functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Send($keys)
	T_Send($keys,0)
EndFunc

Func T_1_Send($keys)
        T_Send($keys,1)
EndFunc

Func T_2_Send($keys)
        T_Send($keys,2)
EndFunc

Func T_3_Send($keys)
        T_Send($keys,3)
EndFunc

Func T_4_Send($keys)
        T_Send($keys,4)
EndFunc

Func T_5_Send($keys)
        T_Send($keys,5)
EndFunc

Func T_6_Send($keys)
        T_Send($keys,6)
EndFunc

Func T_7_Send($keys)
        T_Send($keys,7)
EndFunc

Func T_8_Send($keys)
        T_Send($keys,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_#_Log_Assert
 Goal	: Dump the assertion (used by T-Report)
 Input	: 	Description of the Assertion
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,0)
EndFunc

Func T_1_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,1)
EndFunc

Func T_2_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,2)
EndFunc

Func T_3_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,3)
EndFunc

Func T_4_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,4)
EndFunc

Func T_5_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,5)
EndFunc

Func T_6_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,6)
EndFunc

Func T_7_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,7)
EndFunc

Func T_8_Log_Assert($description,$lineNb)
		T_Log_Assert($description,$lineNb,8)
EndFunc



#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Title	: T_Log_Function
 Goal	: Dump the description of the function (used by T-Report)
 Input	: 	Description of the function
			the current line
 Output	: none
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,0)
EndFunc

Func T_1_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,1)
EndFunc

Func T_2_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,2)
EndFunc

Func T_3_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,3)
EndFunc

Func T_4_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,4)
EndFunc

Func T_5_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,5)
EndFunc

Func T_6_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,6)
EndFunc

Func T_7_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,7)
EndFunc

Func T_8_Log_Function($description,$lineNb)
	T_Log_Function($description,$lineNb,8)
EndFunc

;~ Func T_0_Start_NMC()
;~ 	T_Start_NMC(0)
;~ EndFunc

;~ Func T_1_Start_NMC()
;~ 	T_Start_NMC(1)
;~ EndFunc

;~ Func T_2_Start_NMC()
;~ 	T_Start_NMC(2)
;~ EndFunc

;~ Func T_3_Start_NMC()
;~ 	T_Start_NMC(3)
;~ EndFunc

;~ Func T_4_Start_NMC()
;~ 	T_Start_NMC(4)
;~ EndFunc

;~ Func T_5_Start_NMC()
;~ 	T_Start_NMC(5)
;~ EndFunc

;~ Func T_6_Start_NMC()
;~ 	T_Start_NMC(6)
;~ EndFunc

;~ Func T_7_Start_NMC()
;~ 	T_Start_NMC(7)
;~ EndFunc

;~ Func T_8_Start_NMC()
;~ 	T_Start_NMC(8)
;~ EndFunc

Func T_0_Log($description,$lineNb)
	T_Log($description,$lineNb,0)
EndFunc

Func T_1_Log($description,$lineNb)
	T_Log($description,$lineNb,1)
EndFunc

Func T_2_Log($description,$lineNb)
	T_Log($description,$lineNb,2)
EndFunc

Func T_3_Log($description,$lineNb)
	T_Log($description,$lineNb,3)
EndFunc

Func T_4_Log($description,$lineNb)
	T_Log($description,$lineNb,4)
EndFunc

Func T_5_Log($description,$lineNb)
	T_Log($description,$lineNb,5)
EndFunc

Func T_6_Log($description,$lineNb)
	T_Log($description,$lineNb,6)
EndFunc

Func T_7_Log($description,$lineNb)
	T_Log($description,$lineNb,7)
EndFunc

Func T_8_Log($description,$lineNb)
	T_Log($description,$lineNb,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	WinWaitStatus functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,0)
EndFunc

Func T_1_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,1)
EndFunc

Func T_2_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,2)
EndFunc

Func T_3_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,3)
EndFunc

Func T_4_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,4)
EndFunc

Func T_5_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,5)
EndFunc

Func T_6_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,6)
EndFunc

Func T_7_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,7)
EndFunc

Func T_8_WinWaitStatus($title,$chaine,$lineNumber,$timeout=120000)
	T_WinWaitStatus($title,$chaine,$lineNumber,$timeout,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	SelectItemInComboBox functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,0)
EndFunc

Func T_1_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,1)
EndFunc

Func T_2_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,2)
EndFunc

Func T_3_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,3)
EndFunc

Func T_4_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,4)
EndFunc

Func T_5_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,5)
EndFunc

Func T_6_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,6)
EndFunc

Func T_7_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,7)
EndFunc

Func T_8_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement=1)
	T_SelectItemInComboBox($posX1,$posY1,$posX2,$posY2,$item,$enchainement,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	SelectItemInCB functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,0)
EndFunc

Func T_1_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,1)
EndFunc

Func T_2_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,2)
EndFunc

Func T_3_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,3)
EndFunc

Func T_4_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,4)
EndFunc

Func T_5_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,5)
EndFunc

Func T_6_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,6)
EndFunc

Func T_7_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,7)
EndFunc

Func T_8_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement=1)
	T_SelectItemInCB($posX,$posY,$item,$lineNumber,$enchainement,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Assert_OCR functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,0)
EndFunc

Func T_1_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,1)
EndFunc

Func T_2_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,2)
EndFunc

Func T_3_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,3)
EndFunc

Func T_4_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,4)
EndFunc

Func T_5_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,5)
EndFunc

Func T_6_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,6)
EndFunc

Func T_7_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,7)
EndFunc

Func T_8_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Assert_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	Function_OCR functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,0)
EndFunc

Func T_1_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,1)
EndFunc

Func T_2_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,2)
EndFunc

Func T_3_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,3)
EndFunc

Func T_4_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,4)
EndFunc

Func T_5_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,5)
EndFunc

Func T_6_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,6)
EndFunc

Func T_7_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,7)
EndFunc

Func T_8_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber)
	T_Function_OCR($title,$x1,$y1,$x2,$y2,$word,$lineNumber,True,8)
EndFunc

#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
	ClickWord functions
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

Func T_0_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,0)
EndFunc

Func T_1_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,1)
EndFunc

Func T_2_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,2)
EndFunc

Func T_3_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,3)
EndFunc

Func T_4_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,4)
EndFunc

Func T_5_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,5)
EndFunc

Func T_6_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,6)
EndFunc

Func T_7_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,7)
EndFunc

Func T_8_ClickWord($title,$word,$color,$offset,$lineNumber)
	T_ClickWord($title,$word,$color,$offset,$lineNumber,True,8)
EndFunc

