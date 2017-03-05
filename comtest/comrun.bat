@ECHO off
ECHO.
ECHO ComponentRunner for MiCloud Telepo   version 0.0.1
ECHO Copyright (c) 2017 Abhishek Kumar (kumarab@hcl.com), HCL Tech
ECHO.

CD "%Destination%"
ECHO.
ECHO Authenticating user
CALL npm run login:repo
ECHO.
ECHO Installing required node-modules
CALL npm install
ECHO.
ECHO Starting application
CALL npm start