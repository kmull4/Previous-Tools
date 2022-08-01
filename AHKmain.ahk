/*
Welome to Kyle's AHK script for easily copying/pasting
multiple demographics from Sugar.

This was previously a script for ICE provisioning as well.
That script is now called "AHK for ICE".

Use F1 helpme to see hotstrings and subroutines
*/

;~~~~~~~~~~Settings~~~~~~~~~~
; #Warn  ; Enable warnings to assist with detecting common errors.
SetTitleMatchMode, 2
^F5::Reload
+F5::Edit
; Esc::ExitApp ; disabled for now as it probably doesn't need an "oh shoooooot" button


;~~~~~~~~~~Functions/Subroutines~~~~~~~~~~
helpme:		; shows the current hot keys in use and the current variables stored
MsgBox, -Hotstrings in use-`nF1 : Help`n``d : copy Demos from Sugar`n`nphone (``p): %phone%`nfax (``x): %fax%`naddress (``a): %address%`ncity (``c): %city%`nstate (``s): %state%`nzip (``z): %zip%`nregEmail (``e): %regEmail%`npracticeName (``pn): %practiceName%`n`nCurrent Clipboard: %clipboard%
return

copyDemosFromSugar:	; copies all the demos from Sugar's edit tab
SetKeyDelay, 10
fax= ;sometimes a practice doesn't have a fax number, don't want to accidentally take one from previous run
Send, ^a^c
practiceName= %clipboard%
Send, {tab}^a^c
phone= %clipboard%
Send, {tab 3}^a^c
fax= %clipboard%
Send, {tab}^a^c
address= %clipboard%
RegExReplace(address, "#") ; gets rid of the pound symbol from addresses, which causes errors elsewhere
Send, {tab}^a^c
city= %clipboard%
Send, {tab}^a^c
state= %clipboard%
Send, {tab}^a^c
zip= %clipboard%
Send, {tab 9}^a^c
regEmail= %clipboard%
; this is where the ICE version asks for provider first and last name and does all that good stuff
return


;~~~~~~~~~~Scripts~~~~~~~~~~
F1::
Gosub, helpme
return

::``d::	; d for Demos
Gosub, copyDemosFromSugar
return						

;Paste Individual Demos hotstrings
::``f::
Send, %firstName%
return

::``l::
Send, %lastName%
return

::``p::
Send, %phone%
return

::``x::
Send, %fax%
return

::``a::
Send, %address%
return

::``c::
Send, %city%
return

::``s::
Send, %state%
return

::``z::
Send, %zip%
return

::``e::
Send, %regEmail%
return

::``pn::
Send, %practiceName%
return


;~~~~~~~~~~Testing Grounds~~~~~~~~~~
F4::
MsgBox, no tests here
return
