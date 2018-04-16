@ECHO off
ECHO.
ECHO Automator for MiCloud Telepo   version 0.0.6
ECHO Copyright (c) 2017-18 Abhishek Kumar (kumarab@hcl.com), HCL Tech
ECHO.

SET argSwitch=%1
SET argSource=%2
SET argGarage=%3

IF "%~1"=="" CALL :blankSwitch & GOTO end
IF "%~2"=="" CALL :blankSource & GOTO end
IF "%~3"=="" CALL :blankGarage & GOTO end

IF "%argSwitch%"=="-copy" (
	ECHO Copying new repository
	IF NOT EXIST "%argGarage%" (
		git init "%argGarage%"
	)
	ROBOCOPY %argSource%\ %argGarage%\ /S /E /XD ".git" "node_modules"
  	GOTO done
)

IF "%argSwitch%"=="-sync" (
	ECHO Syncing the repository
	IF NOT EXIST "%argGarage%" (
		git init "%argGarage%"
	)
	ROBOCOPY %argSource%\ %argGarage%\ /MIR /FFT /Z /XA:H /W:5 /XD ".git" "node_modules"
  	GOTO done
)

IF "%argSwitch%"=="-rsync" (
	ECHO Reverse syncing the repository
	IF EXIST "%argSource%" (
		ROBOCOPY %argGarage%\ %argSource%\ /MIR /FFT /Z /XA:H /W:5 /XD ".git" "node_modules"
	)
  	GOTO done
)

IF "%argSwitch%"=="-merge" (
	ECHO Merging the repository
	IF NOT EXIST "%argGarage%" (
		git init "%argGarage%"
	)
	IF "%3"=="-preview" (
		ROBOCOPY %argSource%\ %argGarage%\ /MOVE /XC /XN /XO /XX /W:1 /R:1 /L /XD ".git" "node_modules"
	) ELSE (
		ROBOCOPY %argSource%\ %argGarage%\ /E /MOVE /XC /XN /XO /XX /W:1 /R:1 /XD ".git" "node_modules"
	)
  	GOTO done
)

IF "%argSwitch%"=="-diffsync" (
	ECHO Merging the repository
	IF NOT EXIST "%argGarage%" (
		git init "%argGarage%"
	)
	ROBOCOPY %argSource%\ %argGarage%\ /e /l /ns /njs /njh /ndl /fp /XD ".git" "node_modules"
  	GOTO done
)

IF "%argSwitch%"=="-diff" (
	ECHO Changes made in single commit
	IF EXIST "%argGarage%" (
		CD "%argGarage%"
		ECHO.
		SET /p commitId=Enter the commit-id: 
		ECHO.
		ECHO Preparing patch for commit %commitId%
		git diff -p %commitId% > patch_%commitId%.diff
		ECHO Generated patch file is saved as patch_%commitId%.diff 
		::DIR
		CD..
		GOTO done
	) 
	ECHO Destination directory does not exist
  	GOTO end
)

IF "%argSwitch%"=="-diffs" (
	ECHO Changes made in range of commits
	IF EXIST "%argGarage%" (
		CD "%argGarage%"
		ECHO.
		SET /p fromCommitId=Enter the from-commit-id: 
		ECHO.
		SET /p toCommitId=Enter the to-commit-id: 
		ECHO.
		ECHO Preparing patch for commit ranges from %fromCommitId% to %toCommitId%
		git diff-tree -p %fromCommitId%..%toCommitId% > patch_%fromCommitId%_%toCommitId%.diff
		ECHO Generated patch file is saved as patch_%fromCommitId%_%toCommitId%.diff
		::DIR
		CD..
		GOTO done
	) 
	ECHO Destination directory does not exist
  	GOTO end
)

IF "%argSwitch%"=="-setup" (
	ECHO Setting up environment

  	GOTO done
)

IF "%argSwitch%"=="-help" CALL :menu & GOTO end

GOTO default

:menu 
	ECHO Options:
	ECHO  -setup      to set up environment
  	ECHO  -copy       to copy new repository 
  	ECHO  -sync       to sync existing repository
  	ECHO  -rsync      to reverse sync existing repository
	ECHO  -merge      to merge existing repository
	ECHO  -diffsync   to merge the source changes into destination directory
  	ECHO  -diff       to get changes made in single commit 
	ECHO  -diffs      to get changes made in range of commits
	ECHO  -help       to see the menu
	ECHO.
	ECHO Usage:
	ECHO  automator -setup
	ECHO  automator -copy component-template
  	ECHO  automator -sync component-template
	ECHO  automator -rsync component-template
	ECHO  automator -merge component-template
	ECHO  automator -merge component-template -preview
  	ECHO  automator -diff component-template
  	ECHO  automator -diffs component-template
  	ECHO  automator -help
  	GOTO done

:default
	ECHO This command is not available.
	ECHO.
	CALL :menu
	GOTO end

:blankSwitch
	ECHO The switch command is missing in argument.
	ECHO.
	CALL :menu
	GOTO end

:blankSource
	ECHO The source directory path is missing in argument.
	ECHO.
	CALL :menu
	GOTO end

:blankGarage
	ECHO The garage directory path is missing in argument.
	ECHO.
	CALL :menu
	GOTO end

:done
	ECHO.
	ECHO Done!
	GOTO end

:end
  	EXIT /B
