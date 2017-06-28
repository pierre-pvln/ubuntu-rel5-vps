:: Name:     vps_putty.cmd
:: Purpose:  Create a the Virtual Machine image
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2016 09 25 - initial version
::           2017 05 24 - comments added
::                      - check added if file with vps-settings exists
::                      - check added if host is reachable
::

@ECHO off
SETLOCAL ENABLEEXTENSIONS

:: BASIC SETTINGS
:: ==============
:: Setting the name of the script
SET me=%~n0
:: Setting the name of the directory
SET parent=%~p0
:: Setting for Error messages
SET error_message=errorfree

:: GET SETTINGS
:: ============
cd ..
IF EXIST vps-settings.cmd (
   call vps-settings.cmd
) ELSE (
   SET error_message=File with VPS settings doesn't exist
)
cd %parent%
IF %error_message% NEQ errorfree GOTO ERROR_EXIT

:: Check if VPS server is available based on vps-hostname
::
:: A successful PING does NOT always return an %errorlevel% of 0
:: Therefore to reliably detect a successful ping - pipe the output into FIND and look for the text "TTL" 
:: https://ss64.com/nt/ping.html
:: Also use ping over IP v4; default ping not always returns a TTL in the response.

PING -4 -n 1 %vps-hostname% |find "TTL=" && GOTO DO_SOMETHING
SET error_message=%vps-hostname% not available on vps-hostname
SET vps-hostname=localhost

:DO_SOMETHING
ECHO *******************
ECHO %vps-hostname%
ECHO *******************
:: THE ACTUAL THING TO DO
:: ======================
:: -ssh     use SSH protocol
:: -pw      use password
:: -P 2222  use port 2222 (since it is NAT)
::
:: For test puposes
:: -v     show verbose messages

:: -ssh -P 2222 connects to NAT port 2222 -> 22 on server
::
"C:\_internet_download\35. Putty\putty" -ssh -P 2222 -pw the-admin the-admin@%vps-hostname%


GOTO CLEAN_EXIT

:ERROR_EXIT
   ECHO *******************
   ECHO %error_message%
   ECHO *******************
   
:CLEAN_EXIT   
timeout /T 3