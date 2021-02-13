@echo off

REM Procédure GenererMakefiles.bat
REM ----------------------------
REM %1 : commande de make (rebuild, clean, help) ; help pour demander la syntaxe de la procedure
REM %2 : le module à regénérer : all pour tout regénérer ; sinon un des choix : md5, tinyxML, snapshot, hook, asscolor, assfull, asspartial, assocr, t_interpreter, t_recorder, learnpolice
REM -----------------------------------

echo.
echo Procedure : GenererMakefiles.bat
echo (pour demander de l'aide : GenererMakefiles help) 
echo ------------------------------
echo Paramètres d'appel
echo 1-Commande de génération (help pour demander de l'aide) : %1
echo 2-Module à générer : %2
echo.

REM Analyse des paramètres d'entrée
REM -------------------------------
set commande=%~1
set module=%~2
set /a errExec=0
if "%commande%"=="" (
	echo Le paramètre 1 ne doit pas être vide !
	set /a errExec=1
)
if "%commande%" NEQ "help" (
	if "%module%"=="" (
		echo Le paramètre 2 ne doit pas être vide !
		set /a errExec=1
	)
) else (
	set /a errExec=0
)

if %errExec% EQU 1 (
	pause
	goto :eof
)

REM Définition des modules à regénérer
REM ----------------------------------
set /a MD5=0
set /a TinyXML=0
set /a Snapshot=0
set /a hook=0
set /a crypto=0
set /a assColorW=0
set /a assFullW=0
set /a assPartW=0
set /a assOCR=0
set /a T_Interpreter=0
set /a T_recorder=0
set /a LearnPolice=0
set /a SimpleOCR=0

if %1 NEQ rebuild (
	if %1 NEQ clean (
		if %1 NEQ help (
			echo Batch GenererMakefiles lancé en erreur !
			echo ERREUR : commande de régénération : %1 , inconnue !
			pause
			goto :eof
		) else (
			REM Exemple sur la façon de lancer la procédure

			echo Syntaxe du Batch GenererMakefiles:
			echo Pour regénérer tous les modules:
			echo GenererMakefiles rebuild all
			echo.
			echo Pour nettoyer tous les modules
			echo GenererMakefiles clean all
			echo.
			echo Pour nettoyer un seul module, parmi : md5, tinyxML, snapshot, crypto, hook, asscolor, assfull, asspartial, assocr, t_interpreter, t_recorder, learnpolice, simpleocr.
			echo Exemple : GenererMakefiles clean hook 
			echo.
			echo Pour regénérer un seul module, parmi :  md5, tinyxML, snapshot, crypto, hook, asscolor, assfull, asspartial, assocr, t_interpreter, t_recorder, learnpolice, simpleocr.
			echo Exemple : GenererMakefiles rebuild md5
			echo.
			pause
			goto :eof
		)
	)
)

if %2 EQU all (
	set /a MD5=1
	set /a TinyXML=1
	set /a Snapshot=1
	set /a crypto=1
	set /a hook=1
	set /a assColorW=1
	set /a assFullW=1
	set /a assPartW=1
	set /a assOCR=1
	set /a T_Interpreter=1
	set /a T_recorder=1
	set /a LearnPolice=1
	set /a SimpleOCR=1
) else (
	if %2 EQU md5 (
		set /a MD5=1
	) else (
		if %2 EQU tinyxml (
			set /a TinyXML=1
		) else (
			if %2 EQU snapshot (
				set /a Snapshot=1
			) else (
				if %2 EQU crypto (
					set /a crypto=1
				) else (
					if %2 EQU hook (
						set /a hook=1
					) else (
						if %2 EQU asscolor (
							set /a assColorW=1
						) else (
							if %2 EQU assfull (
								set /a assFullW=1
							) else (
								if %2 EQU asspartial (
									set /a assPartW=1
								) else (
									if %2 EQU assocr (
										set /a assOCR=1
									) else (
										if %2 EQU t_interpreter (
											set /a T_Interpreter=1
										) else (
											if %2 EQU t_recorder (
												set /a T_recorder=1
											) else (
												if %2 EQU learnpolice (
													set /a LearnPolice=1
												) else (
													if %2 EQU simpleocr (
														set /a SimpleOCR=1
													) else (
														echo Batch GenererMakefiles lancé en erreur !
														echo ERREUR : module à régénérer: %2 , inconnu !
														pause
														goto :eof
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
)

echo **************************************************************************
echo
echo -----------------------------------------------------
echo 			D E B U T
echo -----------------------------------------------------
echo.

set /a totalErreur=0

echo ------------------------------------------------------------
echo Generation des Makefile de l'application T-recorder ET AutoIt
echo ------------------------------------------------------------
echo Mode de regeneration :  %1
echo Le module à regénérer : %2

echo ------------------------------------------------------------		1> Generation-output.log 	2>&1
echo Generation des Makefile de l'application T-recorder ET AutoIt		1>> Generation-output.log 	2>&1
echo ------------------------------------------------------------		1>> Generation-output.log	2>&1
echo Mode de regeneration :  %1							1>> Generation-output.log	2>&1
echo Le module à regénérer : %2							1>> Generation-output.log	2>&1

echo.
echo 1- Generation des librairies statiques
echo ---------------------------------------
echo 1.1- Generation de OCR\ASSERTS\03-Static_Library\01-TinyXML 

if %TinyXML% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 1- Generation des librairies statiques					1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	echo 1.1- Generation de OCR\ASSERTS\03-Static_Library\01-TinyXML		1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\03-Static_Library\01-TinyXML		%1	1> Generation-output-01-TinyXML.log	2>&1
	call :AnalyseErr Generation-output-01-TinyXML.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 1.2- Generation de OCR\ASSERTS\03-Static_Library\ChecksumMD5 
if %MD5% EQU 1 (

	echo.										1>> Generation-output.log	2>&1
	echo 1.2- Generation de OCR\ASSERTS\03-Static_Library\ChecksumMD5 		1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\03-Static_Library\ChecksumMD5		%1	1> Generation-output-ChecksumMD5.log	2>&1
	call :AnalyseErr Generation-output-ChecksumMD5.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.										
echo 2- Generation de CRYPTO 
echo ---------------------------------------
echo 2.1- Generation de CRYPTO 

if %crypto% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 2- Generation de CRYPTO							1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	echo 2.1- Generation de OCR\ASSERTS\CRYPTO					1>> Generation-output.log	2>&1
	
	mingw32-make -C .\OCR\ASSERTS\CRYPTO					%1	1> Generation-output-CRYPTO.log	2>&1
	call :AnalyseErr Generation-output-CRYPTO.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 3- Generation de HOOK
echo ---------------------------------------
echo 3.1- Generation de HOOK-DLL\HOOK 

if %hook% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 3- Generation de HOOK							1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	echo 3.1- Generation de HOOK-DLL\HOOK						1>> Generation-output.log	2>&1

	mingw32-make -C .\HOOK-DLL\HOOK						%1	1> Generation-output-HOOK.log	2>&1
	call :AnalyseErr Generation-output-HOOK.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 4- Generation des ASSERTS
echo ---------------------------------------
echo.
echo 4.1- Generation de OCR\ASSERTS\CHECK_FULL_WINDOW 

if %assFullW% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 4.1- Generation de OCR\ASSERTS\CHECK_FULL_WINDOW				1>> Generation-output.log	2>&1
	
	mingw32-make -C .\OCR\ASSERTS\CHECK_FULL_WINDOW				%1	1> Generation-output-CHECK_FULL_WINDOW.log	2>&1
	call :AnalyseErr Generation-output-CHECK_FULL_WINDOW.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 4.2- Generation de OCR\ASSERTS\CHECK_PARTIAL_WINDOW 
if %assPartW% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 4.2- Generation de OCR\ASSERTS\CHECK_PARTIAL_WINDOW			1>> Generation-output.log	2>&1
	
	mingw32-make -C .\OCR\ASSERTS\CHECK_PARTIAL_WINDOW			%1	1> Generation-output-CHECK_PARTIAL_WINDOW.log	2>&1
	call :AnalyseErr Generation-output-CHECK_PARTIAL_WINDOW.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.										
echo 4.3- Generation de OCR\ASSERTS\ASSERT_COLOR_WINDOW				
if %assColorW% EQU 1 (	
	echo.										1>> Generation-output.log	2>&1
	echo 4.3- Generation de OCR\ASSERTS\ASSERT_COLOR_WINDOW				1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\ASSERT_COLOR_WINDOW			%1	1> Generation-output-ASSERT_COLOR_WINDOW.log	2>&1
	call :AnalyseErr Generation-output-ASSERT_COLOR_WINDOW.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 4.4- Generation de OCR\ASSERTS\T_Assert_OCR 
if %assOCR% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 4.4- Generation de OCR\ASSERTS\T_Assert_OCR				1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\T_Assert_OCR				%1	1> Generation-output-T_Assert_OCR.log	2>&1
	call :AnalyseErr Generation-output-T_Assert_OCR.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.										
echo 4.5- Generation de OCR\ASSERTS\SNAPSHOT 
if %Snapshot% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 4.5- Generation de OCR\ASSERTS\SNAPSHOT					1>> Generation-output.log	2>&1
	
	mingw32-make -C .\OCR\ASSERTS\SNAPSHOT					%1	1> Generation-output-SNAPSHOT.log	2>&1
	call :AnalyseErr Generation-output-SNAPSHOT.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 5- Generation de LearnPolice
echo ---------------------------------------
echo 5.1- Generation de OCR\ASSERTS\01-Projets_Console\LearnPolice 

if %LearnPolice% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 5- Generation de LearnPolice						1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	echo 5.1- Generation de OCR\ASSERTS\01-Projets_Console\LearnPolice		1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\01-Projets_Console\LearnPolice		%1	1> Generation-output-LearnPolice.log	2>&1
	call :AnalyseErr Generation-output-LearnPolice.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 6- Generation de SimpleOCR
echo ---------------------------------------
echo 6.1- Generation de OCR\ASSERTS\01-Projets_Console\SimpleOCR 

if %simpleOCR% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 6- Generation de SimpleOCR							1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	echo 6.1- Generation de OCR\ASSERTS\01-Projets_Console\SimpleOCR		1>> Generation-output.log	2>&1

	mingw32-make -C .\OCR\ASSERTS\01-Projets_Console\SimpleOCR		%1	1> Generation-output-SimpleOCR.log	2>&1
	call :AnalyseErr Generation-output-SimpleOCR.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 7- Generation de T-INTERPRETER
echo ---------------------------------------

if %T_Interpreter% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 7- Generation de T-INTERPRETER						1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1
	
	mingw32-make -C .\T-INTERPRETER						%1	1> Generation-output-T-INTERPRETER.log	2>&1
	call :AnalyseErr Generation-output-T-INTERPRETER.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo 8- Generation de T-RecorderScript\GUI
echo ---------------------------------------

if %T_recorder% EQU 1 (
	echo.										1>> Generation-output.log	2>&1
	echo 8- Generation de T-RecorderScript\GUI					1>> Generation-output.log	2>&1
	echo ---------------------------------------					1>> Generation-output.log	2>&1

	mingw32-make -C .\T-RecorderScript\GUI					%1	1> Generation-output-GUI.log	2>&1
	call :AnalyseErr Generation-output-GUI.log
) else (
	echo -- Ce module ne doit pas être régénéré ! --
)

echo.
echo ........................
echo Bilan de la generation: 
echo ........................

echo.										1>> Generation-output.log	2>&1
echo ........................				1>> Generation-output.log	2>&1
echo Bilan de la generation: 				1>> Generation-output.log	2>&1
echo ........................				1>> Generation-output.log	2>&1

echo.										1>> Generation-output.log	2>&1
if %totalErreur% NEQ 0 (
	if %totalErreur% EQU 1 (
		echo %totalErreur% erreur trouvee lors de la regeneration !
		echo %totalErreur% erreur trouvee lors de la regeneration !			1>> Generation-output.log	2>&1
	) else (
		echo %totalErreur% erreurs trouvees lors de la regeneration !
		echo %totalErreur% erreurs trouvees lors de la regeneration !		1>> Generation-output.log	2>&1
	)
	echo Lisez les documents '.log' qui mentionnent des erreurs ci-dessus.
	echo Lisez les documents '.log' qui mentionnent des erreurs ci-dessus.	1>> Generation-output.log	2>&1

) else ( 
	if %1 NEQ clean (
		echo Pas d'erreur trouvee lors de la generation !
		echo.
		echo **************************************************************************
		echo ---- Fin de la generation du T-Recorder------------
		echo Il faut maintenant creer un kit d'installation !!!
		echo **************************************************************************

		echo Pas d'erreur trouvee lors de la generation !				1>> Generation-output.log	2>&1
		echo.										1>> Generation-output.log	2>&1
		echo **************************************************************************	1>> Generation-output.log	2>&1
		echo ---- Fin de la generation du T-Recorder------------			1>> Generation-output.log	2>&1
		echo Il faut maintenant creer un kit d'installation !!!				1>> Generation-output.log	2>&1
		echo **************************************************************************	1>> Generation-output.log	2>&1

		echo.
		echo ------------------------------------------------------------------------
		echo Copie des livrables dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation 
		echo puis dans C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools 
		echo ------------------------------------------------------------------------
		echo.																										1>> Generation-output.log	2>&1
		echo ------------------------------------------------------------------------								1>> Generation-output.log	2>&1
		echo Copie des livrables dans un répertoire C:\T-Recorder-GIT\LIVRABLES\Generation							1>> Generation-output.log	2>&1
		echo puis dans C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools 		1>> Generation-output.log	2>&1
		echo ------------------------------------------------------------------------								1>> Generation-output.log	2>&1

		REM copie de nmc_hook.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1
		Copy C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll	"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1
		Copy C:\T-Recorder-GIT\HOOK-DLL\HOOK\nmc_hook.dll	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"			1>> Generation-output.log	2>&1

		REM copie de scb_hook.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll	"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\HOOK-DLL\HOOK\scb_hook.dll	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"			1>> Generation-output.log	2>&1

		REM copie de assert_color_window.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll		"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\ASSERT_COLOR_WINDOW\assert_color_window.dll		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"  1>> Generation-output.log	2>&1

		REM copie de assert_full_window.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1		
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll		"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1		
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_FULL_WINDOW\assert_full_window.dll		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1

		REM copie de assert_partial_window.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"	1>> Generation-output.log	2>&1		
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll	"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1		
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CHECK_PARTIAL_WINDOW\assert_partial_window.dll	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1

		REM copie de snapshot.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"				
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll	"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"				
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"				1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\SNAPSHOT\snapshot.dll	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"			1>> Generation-output.log	2>&1

		REM copie de crypto.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"				
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"					1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll		"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"				
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\CRYPTO\crypto.dll		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"			1>> Generation-output.log	2>&1

		REM copie de T_Assert_OCR.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll	"C:\T-Recorder-GIT\LIVRABLES\Generation"				1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\T_Assert_OCR\T_Assert_OCR.dll	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1

		REM copie de WmCpyDta.dll  ------------------------------------------------------------------
REM		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
REM		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1	
REM		Copy C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll		"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

REM		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
REM		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1	
REM		Copy C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.dll		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1

		echo "Copie de C:\T-Recorder-GIT\DLL\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\DLL\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\DLL\WmCpyDta.dll		"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		echo "Copie de C:\T-Recorder-GIT\DLL\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie de C:\T-Recorder-GIT\DLL\WmCpyDta.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\DLL\WmCpyDta.dll		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1

		REM copie de WmCpyDta.def  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.def dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.def dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\WmCpyDta\WmCpyDta\Release\WmCpyDta.def		"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		REM copie de T-INTERPRETER.exe  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe		"C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER"		
		echo "Copie C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\T-INTERPRETER\T-INTERPRETER.exe		"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER"		1>> Generation-output.log	2>&1

		REM copie de libgcc_s_dw2-1.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"		
		echo "Copie C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"					1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll"	"C:\T-Recorder-GIT\LIVRABLES\DLL"											1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\libgcc_s_dw2-1.dll"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1

		REM copie de libstdc++-6.dll  ------------------------------------------------------------------
		echo "Copie C:\T-Recorder-GIT\DLL\libstdc++-6.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"		
		echo "Copie C:\T-Recorder-GIT\DLL\libstdc++-6.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"					1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\libstdc++-6.dll"	"C:\T-Recorder-GIT\LIVRABLES\DLL"										1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\DLL\libstdc++-6.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\DLL\libstdc++-6.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\libstdc++-6.dll"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1
		
		REM AutoItX3.dll
		echo "Copie C:\T-Recorder-GIT\DLL\AutoItX3.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"		
		echo "Copie C:\T-Recorder-GIT\DLL\AutoItX3.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"					1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\AutoItX3.dll"	"C:\T-Recorder-GIT\LIVRABLES\DLL"										1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\DLL\AutoItX3.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\DLL\AutoItX3.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\AutoItX3.dll"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1

		REM mingwm10.dll
		echo "Copie C:\T-Recorder-GIT\DLL\mingwm10.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"		
		echo "Copie C:\T-Recorder-GIT\DLL\mingwm10.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"					1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\mingwm10.dll"	"C:\T-Recorder-GIT\LIVRABLES\DLL"										1>> Generation-output.log	2>&1

		echo "Copie C:\T-Recorder-GIT\DLL\mingwm10.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "Copie C:\T-Recorder-GIT\DLL\mingwm10.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\mingwm10.dll"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1
		
		REM wxmsw293_xxx
		echo "Copie C:\T-Recorder-GIT\DLL\wx*.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"		
		echo "Copie C:\T-Recorder-GIT\DLL\wx*.dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\DLL"					1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\wx*.dll"	"C:\T-Recorder-GIT\LIVRABLES\DLL"										1>> Generation-output.log	2>&1

		echo "C:\T-Recorder-GIT\DLL\wx*.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		
		echo "C:\T-Recorder-GIT\DLL\wx*.dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\DLL\wx*.dll"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"		1>> Generation-output.log	2>&1
		
		REM copie de T-RECORDER.exe  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe	"C:\T-Recorder-GIT\LIVRABLES\Generation"		1>> Generation-output.log	2>&1

		echo "Copie de C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"		
		echo "Copie de C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"		1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\T-RecorderScript\GUI\T-Recorder.exe	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"		1>> Generation-output.log	2>&1

		REM copie de LearnPolice.exe  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\LearnPolice.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\LearnPolice.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\LearnPolice\LearnPolice.exe	"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		REM copie de SimpleOCR.exe  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\SimpleOCR.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\SimpleOCR.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"	1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\OCR\ASSERTS\01-Projets_Console\SimpleOCR\SimpleOCR.exe		"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		REM copie de hash_map.exe  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\HOOK-DLL\HOOK\hash_map.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"		
		echo "Copie de C:\T-Recorder-GIT\HOOK-DLL\HOOK\hash_map.exe dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation"					1>> Generation-output.log	2>&1	
		Copy C:\T-Recorder-GIT\HOOK-DLL\HOOK\hash_map.exe									"C:\T-Recorder-GIT\LIVRABLES\Generation"			1>> Generation-output.log	2>&1

		echo -----------------------------------------------
		echo.

		REM ****************************************** Copie des fichiers de config '.ini' depuis envdev vers env de build *************************************
		echo .
			REM copie de C:\T-Recorder-GIT\*.ini  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\*.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"		
		echo "Copie de C:\T-Recorder-GIT\*.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"	1>> Generation-output.log	2>&1		
		copy "C:\T-Recorder-GIT\*.ini"	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder"  							1>> Generation-output.log	2>&1

		REM ****************************************** Copie des scripts et programmes AutoIt depuis l'env de Dev vers l'env de Build *************************************
		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\function  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\function dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\function dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function"							1>> Generation-output.log	2>&1		
		copy "C:\T-Recorder-GIT\AutoIt3\Include\function\*.au3" "C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\function dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\function"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\function dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\function"	1>> Generation-output.log	2>&1		
		copy "C:\T-Recorder-GIT\AutoIt3\Include\function\*.au3" "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\function"  1>> Generation-output.log	2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1		
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3" 	"C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  	1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1		
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\UDF_tests.au3" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  	1>> Generation-output.log 2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3" 	"C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\UDF_network_tests.au3" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  1>> Generation-output.log	2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3" 	"C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\error_return_code.au3" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  1>> Generation-output.log	2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3" 	"C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\NMC_Api.au3" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  1>> Generation-output.log	2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3" "C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3 dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\ROCADE_Api.au3" "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  1>> Generation-output.log	2>&1

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.*  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.* dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.* dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.*" "C:\T-Recorder-GIT\LIVRABLES\AutoIt3"  1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.* dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.* dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.*" "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"  1>> Generation-output.log	2>&1

		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.exe" "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"  	1>> Generation-output.log	2>&1

		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"	1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TExecTRecorder.ini" "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"  	1>> Generation-output.log	2>&1
		echo .

		echo .
			REM copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.*  ------------------------------------------------------------------
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.* dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.* dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3"		1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.*" 	"C:\T-Recorder-GIT\LIVRABLES\AutoIt3"	1>> Generation-output.log	2>&1
		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.* dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.* dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"		1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.*" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\AutoIt3\Include\"	1>> Generation-output.log	2>&1

		echo .
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER\"		1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.exe" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER"	1>> Generation-output.log	2>&1

		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER\"		
		echo "Copie de C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER\"		1>> Generation-output.log	2>&1	
		Copy "C:\T-Recorder-GIT\AutoIt3\Include\TPlayScr.ini" 	"C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-PLAYER"	1>> Generation-output.log	2>&1

		echo .

		REM ****************************************** Copie des scripts et programmes AutoIt depuis l'env de Dev vers l'env de Build *************************************
	) else (
		echo "Suppression des fichiers générés dans les répertoires C:\T-Recorder-GIT\LIVRABLES\Generation et C:\T-Recorder-GIT\T-RECORDER-exe\build\Automated Testing Tools"
		echo "Suppression des fichiers générés dans les répertoires C:\T-Recorder-GIT\LIVRABLES\Generation et C:\T-Recorder-GIT\T-RECORDER-exe\build\Automated Testing Tools"	1>> Generation-output.log	2>&1
		echo .
		echo "1. Suppression des fichiers générés .exe et .dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation\" 
		echo "1. Suppression des fichiers générés .exe et .dll dans le répertoire C:\T-Recorder-GIT\LIVRABLES\Generation\"	1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\LIVRABLES\Generation\*.*"																1>> Generation-output.log	2>&1

		echo .
		echo "2. Suppression des fichiers générés .exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER" 
		echo "2. Suppression des fichiers générés .exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER"	1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-INTERPRETER\*.exe"													1>> Generation-output.log	2>&1
		echo .
		echo "3. Suppression des fichiers générés .exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder" 
		echo "3. Suppression des fichiers générés .exe dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder" 	1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Recorder\*.exe"														1>> Generation-output.log	2>&1
		echo .
		echo "4. Suppression des fichiers générés .dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll" 
		echo "4. Suppression des fichiers générés .dll dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll"			1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\dll\*.*"																1>> Generation-output.log	2>&1
		echo .	
		echo "5. Suppression des fichiers .exe et .ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Player" 
		echo "5. Suppression des fichiers .exe et .ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Player"		1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Player\*.exe"														1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\T-Player\*.ini"														1>> Generation-output.log	2>&1
		echo .
		echo "6. Suppression des fichiers .exe et .ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode" 
		echo "6. Suppression des fichiers .exe et .ini dans le répertoire C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode"		1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode\*.exe"														1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\T-RECORDER-Exe\build\Automated Testing Tools\Automated Testing Tools\ExecMode\*.ini"														1>> Generation-output.log	2>&1
		echo .
		echo "7. Suppression des fichiers .exe, .ini, et .au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3" 
		echo "7. Suppression des fichiers .exe, .ini, et .au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3" 															1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\LIVRABLES\AutoIt3\*.exe"																													1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\LIVRABLES\AutoIt3\*.ini"																													1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\LIVRABLES\AutoIt3\*.au3"																													1>> Generation-output.log	2>&1
		echo .
		echo "8. Suppression des fichiers .au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function" 
		echo "8. Suppression des fichiers .au3 dans le répertoire C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function" 																1>> Generation-output.log	2>&1
		erase /Q "C:\T-Recorder-GIT\LIVRABLES\AutoIt3\function\*.au3"																											1>> Generation-output.log	2>&1
		echo .
	
		echo Nettoyage terminé !
		echo Nettoyage terminé !							1>> Generation-output.log	2>&1
	)
)

echo.
echo -----------------------------------------------------
echo 			F I N
echo -----------------------------------------------------
echo.
echo **************************************************************************

echo.											1>> Generation-output.log	2>&1
echo -----------------------------------------------------				1>> Generation-output.log	2>&1
echo 			F I N								1>> Generation-output.log	2>&1
echo -----------------------------------------------------				1>> Generation-output.log	2>&1
echo.											1>> Generation-output.log	2>&1
echo **************************************************************************		1>> Generation-output.log	2>&1

pause
goto :eof


REM ******************************************************* ERREURS *******************************************************************************************

:AnalyseErr

for /F "usebackq tokens=3 delims= " %%i IN (`find /c ": error:" %1`) DO set nbErreurs1=%%i
for /F "usebackq tokens=3 delims= " %%i IN (`find /c " Error " %1`) DO set nbErreurs2=%%i
for /F "usebackq tokens=3 delims= " %%i IN (`find /c "*** No rule to make target" %1`) DO set nbErreurs3=%%i

set /a nbErreurs= nbErreurs1 + nbErreurs2 + nbErreurs3

echo.
if %nbErreurs% NEQ 0 (

	set /a totalErreur = totalErreur + nbErreurs

	if %nbErreurs3% NEQ 0 (
		if %nbErreurs3% EQU 1 (
			echo Une anomalie trouvée dans le Makefile !
			echo Une anomalie trouvée dans le Makefile !						1>> Generation-output.log	2>&1
		) else (
			echo %nbErreurs3" anomalies trouvées dans le Makefile !
			echo %nbErreurs3" anomalies trouvées dans le Makefile !				1>> Generation-output.log	2>&1
		)
	)

	if %nbErreurs1% EQU 0 (
		if %nbErreurs2% EQU 1 (
			echo %nbErreurs2% erreur trouvee lors de la regeneration !
			echo %nbErreurs2% erreur trouvee lors de la regeneration !			1>> Generation-output.log	2>&1
		) else (
			if %nbErreurs2%	NEQ 0 (
				echo %nbErreurs2% erreurs trouvees lors de la regeneration !
				echo %nbErreurs2% erreurs trouvees lors de la regeneration !	1>> Generation-output.log	2>&1
			)
		)
	) else (
		if %nbErreurs1% EQU 1 (
			echo %nbErreurs1% erreur trouvee lors de la regeneration !
			echo %nbErreurs1% erreur trouvee lors de la regeneration !			1>> Generation-output.log	2>&1
		) else (		
			echo %nbErreurs1% erreurs trouvees lors de la regeneration !
			echo %nbErreurs1% erreurs trouvees lors de la regeneration !		1>> Generation-output.log	2>&1
		)
	)
	echo Lisez le document %1
	echo Lisez le document %1													1>> Generation-output.log	2>&1

) else ( 
	echo Pas d'erreur trouvee lors de la generation !
	echo Pas d'erreur trouvee lors de la generation !							1>> Generation-output.log	2>&1
)

REM **************************************************************************************************************************************************************
