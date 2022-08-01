/*
Welome to Kyle's AHK script for demo copying and ICE provisions.

Current goal to automate ICE provisions.
	✔ make section for pasting into ICE first
	✔ then a section for copying variables from Sugar
		✔ and a check at some point (on user req) to present all demos
	✔ add winactivates to be useful. Can these switch tabs in Chrome?
	✔ use replacement keys (hotstrings) to imitate phrase express instead of individual combos
	✔ add an F1 help menu that gives all the current hotkey&hotstring assignments and shows current variables
	- further add winactivates when the Chrome window name changes after signing in. Note you can also use a WinWait instead of a default timer of 3 seconds! Then it should work no matter what and save time when it's less than 3s. Nice.
	✔ change the input box prompt to cancel the routine if you hit cancel
	- have it send the provisioning emails too. but maybe when there are more ICE cases.
bugs:
	✔ addresses with "#" is messing stuff up, RegExReplace is good friend
	✔ multiple variables not initializing in the same line

Subroutines below (use F1 helpme to see hotstrings)
helpme	- shows hotstrings in use and stored variables
copyDemosFromSugar	- copies all the demos from Sugar's edit tab
iceAdminAddUser	- use this when adding demos on ice admin page
iceUserLogin, iceAccounts, iceMailMessages	- use this from ice login page and beyond
*/

;~~~~~~~~~~Settings~~~~~~~~~~
SetTitleMatchMode, 2
^F5::Reload
+F5::Edit
Esc::ExitApp

;~~~~~~~~~~Cancel Label~~~~~~~~~~
cancel_me: ; used to cancel the current script without crashing everything
cancelMeTriggered := 1
return

;~~~~~~~~~~Functions/Subroutines~~~~~~~~~~
helpme:	; shows the current hot keys in use and the current variables stored
MsgBox, -Hotstrings in use-`nF1 : Help`n``d : copy Demos from Sugar`n``a1 : Automated ICE step 1 (iceAdminAddUser)`n``a2 : Automated ICE steps 2-4 (iceUserLogin, iceAccounts, iceMailMessages)`n`nfirstName (``f): %firstName%`nlastName (``l): %lastName%`nphone (``p): %phone%`nfax (``x): %fax%`naddress (``a): %address%`ncity (``c): %city%`nstate (``s): %state%`nzip (``z): %zip%`nregEmail (``e): %regEmail%`npracticeName (``pn): %practiceName%`nCurrent Clipboard: %clipboard%
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
; for some reason, Sugar doesn't actually have a consistent spot for first and last name.
InputBox, firstName, Enter provider's first name
InputBox, lastName, Enter provider's last name
; capitalize first letters of each name
StringUpper,firstName,firstName,T
StringUpper,lastName,lastName,T
; we can get the signinUN from this info as well
StringLower,signinFirst,firstName
StringLower,signinLast,lastName
signinUN= %signinFirst%.%signinLast%
return

iceAdminAddUser:	; use this when adding demos on ice admin page
if WinExist("iCoreExchange - A HIPAA Compliant") {
	WinActivate
	Send, %firstName%{tab}%lastName%{tab}%phone%{tab}%fax%{tab}%address%{tab}{tab}%city%{tab}%state%{tab}%zip%{tab 2}%regEmail%{tab}%practiceName%{tab 2}{Down}
	}
else
	MsgBox, Make sure you have the right tab open!
; manually click add user, having trouble finding where it is
return

iceUserLogin:	; use this from ice login page and beyond. added winexist to stop a previous user error from happening again
SetKeyDelay, 100
if WinExist("iCoreExchange :: Welcome to iCoreExchange") {
	WinActivate
	InputBox, signinPW, Enter the ICE password sent via email.
	if ErrorLevel {
		MsgBox, Reloading the whole thing, sorry.
		Reload
		}
	Send, %signinUN%{tab}%signinPW%{tab}{enter}
	Sleep, 3000
	Send, {tab 15}{enter}
	Sleep, 1000
	Send, {tab 14}{enter}
	Sleep, 500
	Send {enter}
	Sleep, 500
	}
else {
	MsgBox, Make sure you have the right tab open!
	cancelMeTriggered := 1
	}
return

iceAccounts:	; use this from ice login page and beyond
Sleep, 1500
Send, Doctor Mail - %practiceName%{tab 2}%practiceName%{tab 6}{enter}
Sleep, 1500
Send, {tab 27}{Enter}
; now on to pt mail
Sleep, 1500
Send, Patient Mail - %practiceName%{tab}%signinUN%`@ice.icoresecure.com{tab}%practiceName%{tab 6}{Enter}
Sleep, 1500
SetKeyDelay, 100
Send, +{tab 5}{enter}
Sleep, 1500
return

iceMailMessages:	; use this from ice login page and beyond
SetKeyDelay, -1
Sleep, 1000
Send, {space}
Sleep, 1000
Send, {tab}HIPAA Compliant message from %practiceName%{tab 2}
Send, You have received a Secure message from %practiceName%.`n
Send, A link to a HIPAA Compliant message is provided below. Simply click the link labeled "View Secure Message" and follow the instructions to read your message. If you have created a password in the past and forgotten it, please call iCoreConnect Support @ 1-888-810-7706 Option 2 to have it reset.{tab}
Send, Confidentiality Notice`:`nThe information contained in this transmission may contain privileged and confidential information, including patient information protected by federal and state privacy laws. It is intended only for the use of the person(s) named above. If you are not the intended recipient, you are hereby notified that any review, dissemination, distribution, or duplication of this communication is strictly prohibited. If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.{tab}{enter}
Sleep, 1500
Send +{tab}{enter}
Sleep, 1500
Send, {space}
Sleep, 1000
Send, {tab}Secure Message from %practiceName%{tab 2}
Send, You have received a Secure message from %practiceName%.`nA link to a secure message is provided below. Simply click the link labeled "View Secure Message" and follow the instructions to read your message.{tab}
Send, Confidentiality Notice`:`nThe information contained in this transmission may contain privileged and confidential information, including patient information protected by federal and state privacy laws. It is intended only for the use of the person(s) named above. If you are not the intended recipient, you are hereby notified that any review, dissemination, distribution, or duplication of this communication is strictly prohibited. If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.{tab}{enter}
Sleep, 1500
; now log out
Send, +{tab 12}{enter}
return

sendProvisioningEmails:
Sleep, 1000 ; give user time to take their hands off the keys
Send, +{tab 16}{enter} ; hits "compose"
Sleep, 1500 ; wait for ICE to catch up
Send, %signinUN%
Sleep, 1000 ; wait for ICE to catch up
Send, {enter}{tab}Getting Started{!}{tab} ; after this, you land on the body
Send, Hello{!} To get started:{enter}- Click on the "Help" tab on the top right hand corner+{enter}- Watch the "Orientation" and "Compose an Email" videos{enter}You are now ready to start sending HIPAA-Compliant Secure Emails{!}+{enter 3}Thank you,{enter}The iCoreConnect Team{tab 3}{enter} ; this ends with sending it
; now send the second one
Sleep, 2000 ; wait for ICE to catch up
Send, +{tab 16}{enter} ; hits "compose"
Sleep, 1000 ; ICE again -_-
Send, +{tab}
Send, {Down}{tab} ; sets From field to ICE creds and gets back to To field
Send, %regEmail%
Sleep, 1000 ; wait for ICE
Send, {enter}{tab}Welcome to iCoreExchange{!}{tab} ; leaves at the body
Send, {enter}Please click the Settings tab in the upper right corner of the page. Then click Password on the left side of the page. You can now enter the current password, create a new one, and then click Save.{enter}Once you have logged into your iCoreExchange account, you will find a Getting Started email with instructions to locate training videos so you can begin sending secure emails.{enter}Sincerely;
return


;~~~~~~~~~~Scripts~~~~~~~~~~
F1::
Gosub, helpme
return

::``d::	; d for Demos
Gosub, copyDemosFromSugar
return						

::``a1::	; A for Auto - step 1
Gosub, iceAdminAddUser
return

::``a2::	; A for Auto - steps 2 to 4
cancelMeTriggered = 0
Gosub, iceUserLogin
if cancelMeTriggered = 1
	Goto cancel_me
Gosub, iceAccounts
Gosub, iceMailMessages
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
signinUN := "kyle.mullen" ; for testing
regEmail := "kmullen@icoreconnect.com" ; for testing
Gosub, sendProvisioningEmails
return
