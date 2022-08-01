::============================================
:: Purpose: deletes the extraneous things that uninstalling doesn't delete.
:: 	Must run as admin for privileges.
:: You still need to run uninstall under add/remove programs.
::============================================

:: remove dir iCoreConnect, /s to delete all subfolders and subfiles
rmdir C:\iCoreConnect /s

:: delete installer log
del C:\iCoreConnectInstaller.log

:: delete reg keys
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\iCoreConnect\

:: pause window to see everything that was done
pause