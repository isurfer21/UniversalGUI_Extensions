@ECHO off
ECHO.
ECHO ComponentTester for MiCloud Telepo   version 0.0.5
ECHO Copyright (c) 2017 Abhishek Kumar (kumarab@hcl.com), HCL Tech
ECHO.

SET argSwitch=%1
SET argComName=%2
SET argComVer=%3
SET argComBld=%4

SET Base="D:\Users\kumarab\Documents\Workshop\Telepo\Workspace"
SET Source="%Base%\component-tester"
SET Destination="%Base%\component-%argComName%-tester"
SET Cache="%Destination%\node_modules\@mitel\component-%argComName%"

IF "%argSwitch%"=="-help" CALL :menu & GOTO end
IF "%argSwitch%"=="-run" CALL :clone & GOTO end

GOTO aborted

:menu
	ECHO Usage:
	ECHO   comtest -help
	ECHO   comtest dashboard 1.0.1 2
	ECHO   comtest agent-availability 1.0.2 3
	GOTO done

:clone
	IF %argComName%=="" (
		ECHO Component's name is not provided
		GOTO aborted
	) ELSE (
		ECHO Creating new repository for component-tester at
		ECHO ... %Destination%
		IF NOT EXIST "%Destination%" (
			MKDIR "%Destination%"
		) ELSE (
			ECHO.
			ECHO Removing old config and package files
			DEL /q "%Destination%\*.*"
			ECHO.
			ECHO Checking if previous version of component-%argComName% exist
			IF EXIST "%Cache%" (
				ECHO Removing previous version of component-%argComName%
				RMDIR "%Cache%" /S /Q
			)
		)
		ROBOCOPY %Source% %Destination% /S /E
	  	GOTO config
  	)

:config
	ECHO Configuring component-tester
	IF "%argComName%"=="" (
		ECHO Component's name is not provided
		GOTO aborted
	) ELSE (
		fnr --cl --find "[template]" --replace "%argComName%" --caseSensitive --dir %Destination% --fileMask "*.json"
	)
	IF "%argComName%"=="" (
		ECHO Component's version is not provided
		GOTO aborted
	) ELSE (
		fnr --cl --find "[version]" --replace "%argComVer%" --caseSensitive --dir %Destination% --fileMask "package.json"
	)
	IF "%argComBld%"=="" (
		ECHO Component's build is not provided
		GOTO aborted
	) ELSE (
		fnr --cl --find "[build]" --replace "%argComBld%" --caseSensitive --dir %Destination% --fileMask "package.json"
	)
	GOTO process

:process
	START CMD /C comrun
	
:aborted
	ECHO.
	ECHO Aborted!
	GOTO end

:done
	ECHO.
	ECHO Done!
	GOTO end

:end
  	EXIT /B
