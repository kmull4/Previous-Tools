/*
Author: Kyle Mullen
Created: 2022
Acknowledgements:
	Made possible by Suresh 'Sam' Somwaru.

Script Purpose:
Make AHK to start up chrome, display the gsheet on the windows
microcomputer, adjust view settings.
Refreshes the process every 6 hours.

Ancillary:
Google Chrome has the Subscription Revenue gsheet as the home page and set to
 only open this page on startup.

Changelog:
In response to user request, set an automated process to log out and log back
 in on startup and every week subseqently.
Making a new subroutine and a counter to do this on startup and then every x
 iterations, then resetting the counter.

	April 2022 BUG:
	Google is signing all the way out and requiring email. Last sign out was 4/28.
	FIX: do a full sign out and remove account instead of just the little i
	Update: 5/5 signed out again. It appears it's every week, not every two.
*/

#warn ; shows common errors
SetTitleMatchMode, 2 ; sets titleMatch to match any part of the title
logMeInCounter := 99 ; sets logMeIn to run on startup in case of whole computer restarting
preferredViewPerc := 100 ; if using the viewZoom subroutine, pick the view% you want it on
;							; options are 100, 125, 150


; the main run, waits 10 seconds for the computer to start up then runs automatically
Sleep, 10000 ; wait for the computer to load up
While 1 {
	Gosub, logMeIn
	Gosub, openRunAndWait
}

;~~~~~~~~~~Access~~~~~~~~~~
^F5::Reload
+F5::Edit

;~~~~~~~~~~Functions/Subroutines~~~~~~~~~~
logMeIn:
; first check to see if it's needed
if (logMeInCounter < 24) {
	logMeInCounter += 1
	return
}
else
	logMeInCounter := 0 ; if it is, then reset counter and proceed
; close and reopen chrome just to be safe. copied from below
IfWinExist, Subscription Revenue
	WinClose
IfWinExist, ahk_exe chrome.exe
	WinClose
Sleep, 1000
Run, chrome.exe
Sleep, 6000
Click, 3666, 180 ; clicks on the google i
Sleep, 1000
Send, {tab 7}{enter} ; signs out
Sleep, 6000
Send, {tab 3}{enter} ; hits "remove account"
Sleep, 3000
Send, +{tab 2}{enter} ; selects account
Sleep, 1000
Send, {enter} ; confirms removing
Sleep, 3000
Send, [redacted]{enter} ; signs in with the username
Sleep, 3000
Send, [redacted]{enter} ; then signs in.
; yes, this is a password in plain text. it has access to nothing but this spreadsheet.
; user requested, manager approved
Sleep, 6000
Send, ^w ; closes the accounts window that was pulled up
return


openRunAndWait:
IfWinExist, Subscription Revenue
	WinClose
IfWinExist, ahk_exe chrome.exe
	WinClose
Sleep, 1000
Run, chrome.exe
Sleep, 6000
Send, #{Up}
Sleep, 6000
Send, ^+{PgUp} ; goes to last tab made
Sleep, 3000
Send, {F11} ; F11 to fullscreen
MouseMove, 3839, 420 ; just move the mouse out of the way
Sleep, 21600000 ; waits 6 hours
return


viewZoom:
; can only click on zoom and view > fullscreen, but this may not even be needed
; saving here to call later if ever needed
; assume F11 has already been hit
;;;;
; different values from the preferredViewPerc above
if (preferredViewPerc = 100)
	viewPercY := 650
else if (preferredViewPerc = 125)
	viewPercY := 750
else if (preferredViewPerc = 150)
	viewPercY := 850
Send, ^+f ; opens up view menu
Sleep, 1000
Click, 620, 250 ; view% dropdown
Sleep, 1000
Click, 620, %viewPercY% ; obtained from above
Sleep, 1000
Click, 480, 150 ; view menu
Sleep, 1000
Click, 480, 850 ; fullscreen
Sleep, 1000
Send, ^+f ; closes view menu
return


;~~~~~~~~~~Test~~~~~~~~~~
^q::
Click, 480, 150
return

;~~~~~~~~~~Reload the whole script ez-pz shortcut~~~~~~~~~~
F4::
Reload
return