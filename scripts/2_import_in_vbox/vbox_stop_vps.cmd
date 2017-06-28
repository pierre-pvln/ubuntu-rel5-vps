:: Name:     vbox_stop_vps.cmd
:: Purpose:  import vps in virtualbox
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2016 09 23 - initial version

@ECHO off
SETLOCAL ENABLEEXTENSIONS

:: BASIC SETTINGS
:: ==============
:: Setting the name of the script
SET me=%~n0
:: Setting the name of the directory
SET parent=%~p0

SET vboxm="C:\Program Files\Oracle\VirtualBox\VBoxManage"

cd ..
call vps-settings.cmd
cd %parent%

:: Stop the VPS
%vboxm% controlvm %vps-hostname% acpipowerbutton  

timeout /T 3
