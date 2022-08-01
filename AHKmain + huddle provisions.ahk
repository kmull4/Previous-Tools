/*
Welome to one of Kyle's AHK scripts for easily copying/pasting
multiple demographics from Sugar.
I defaulted to camelCase since AHK has a lot of camel built in.

This one is for huddle provisions. Either creating huddle pages or
provisioning users.

Use F1 helpme to see hotstrings and subroutines
*/

;~~~~~~~~~~Settings~~~~~~~~~~
#Warn  ; Enable warnings to assist with detecting common errors.
SetTitleMatchMode, 2
^F5::Reload
+F5::Edit
; Esc::ExitApp ; disabled for now as it probably doesn't need an "oh shoooooot" button


;~~~~~~~~~~Functions/Subroutines~~~~~~~~~~
helpme:		; shows the current hot keys in use and the current variables stored
MsgBox, -Hotstrings in use-`nF1 : Help`n``d : copy Demos from Sugar`n`nphone (``p): %phone%`nfax (``x): %fax%`naddress (``a): %address%`ncity (``c): %city%`nstate (``s): %state%`nzip (``z): %zip%`nregEmail (``e): %regEmail%`npracticeName (``pn): %practiceName%`n`nCurrent Clipboard: %clipboard%
return

copyDemosFromSugar:	; copies all the demos from Sugar's edit tab
SetKeyDelay, 40
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
return

addFacility: ; manually click add facility and click facility name field
SetKeyDelay, 200 ; slow the key entries down a bit
Send, %practiceName%{tab}%practiceName%{tab}%phone%{tab}%fax%{tab 5} ; enters creds and saves
Sleep, 3000 ; wait for Huddle to load up
Send, {enter} ; when asks if new email ok
Send, {tab 12}{enter} ; brings up adding location menu
Sleep, 1000
Send, {tab 24}{enter} ; hits "add location"
Send, {tab 40}%practiceName%{tab}%address%{tab}%state%{tab}%city%{tab}%zip%{tab} ; leaves off on tax id field. This is unreliable to pull from Sugar with AHK.
return

addDoctor: ; start from email (in cilpboard) and paste the necessary info
SetKeyDelay, 200
Send, %clipboard%{tab}%phone%{tab 5}%address%{tab 2}%city%{tab}%state%{enter}{tab}%zip%{tab}{down}{enter}{tab}
return

addStaff: ; start from email (in cilpboard) and paste the necessary info
SetKeyDelay, 200
Send, %clipboard%{tab}%phone%{tab 5}%address%{tab 2}%city%{tab}%state%{enter}{tab}%zip%{tab}{down}{enter}{tab}
; now at the point where we don't need federal tax ID, etc. this is where it leaves off
Send, {tab 9}staff{enter}{tab 2}active{enter}{tab}third{enter}{tab 2}admin{enter}
; then manually click switches, as this changes sometimes anyways. then save.
return


;~~~~~~~~~~Scripts~~~~~~~~~~
F1::
Gosub, helpme
return

::``d::	; d for Demos
Gosub, copyDemosFromSugar
return						

::``af:: ; add facility
Gosub, addFacility
return

::``ad:: ; add doctor
Gosub, addDoctor
return

::``as:: ; add staff
Gosub, addStaff
return

; Paste Individual Demos hotstrings
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
