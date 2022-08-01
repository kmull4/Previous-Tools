::===============================================================
:: problem: Eaglesoft will shut down for some weird backup situation and our API won't stop, causes issues.
:: purpose: batch file to quickly create a Task Scheduler task for restarting HuddleAPIService
::
:: schtasks /create /sc <scheduletype> /tn <taskname> /tr <taskrun> [/s <computer> [/u [<domain>\]<user> [/p <password>]]] [/ru {[<domain>\]<user> | system}] [/rp <password>] [/mo <modifier>] [/d <day>[,<day>...] | *] [/m <month>[,<month>...]] [/i <idletime>] [/st <starttime>] [/ri <interval>] [{/et <endtime> | /du <duration>} [/k]] [/sd <startdate>] [/ed <enddate>] [/it] [/z] [/f]
:: display current tasks (filter by 'huddle' to just show ours), give options to delete any of our tasks that have already been scheduled
:: ask user what times they would like to create the task
:: 
:: schtasks /end /tn <taskname> [/s <computer> [/u [<domain>\]<user> [/p <password>]]]
:: 
:: future additions:
:: add in something that will let them see the current tasks scheduled, or the current tasks in iCoreConnect folder
:: add in option to delete our tasks
::===============================================================

@ECHO off
SET timeToDown=06:00
SET timeToUp=06:10

:start
ECHO Schedule default is set for 6am down and 6:10 up. Needs to run with admin priveleges.
ECHO Y to schedule default, or N for nah. T to change times, V to view, D to delete, or S to pull up TaskScheduler itself.
SET /p menu=
IF /i "%menu%" == "t" GOTO t
IF /i "%menu%" == "y" GOTO y
IF /i "%menu%" == "n" GOTO n
IF /i "%menu%" == "v" GOTO v
IF /i "%menu%" == "d" GOTO d
IF /i "%menu%" == "s" GOTO s
ECHO Invalid Option
GOTO start
GOTO end

:s
ECHO Warning: this will freeze until Task Scheduler is closed.
taskschd
GOTO start

:v
schtasks /query /tn "iCoreConnect\BringHuddleAPIup"
schtasks /query /tn "iCoreConnect\ForceHuddleAPIdown"
ECHO .
ECHO .
GOTO start

:d
schtasks /delete /tn "iCoreConnect\BringHuddleAPIup"
schtasks /delete /tn "iCoreConnect\ForceHuddleAPIdown"
GOTO end

:t
ECHO What time to stop HuddleAPI? Format must be 24hr xx:xx
ECHO Example: 6am is 06:00, 11:30pm is 23:30
SET /p timeToDown=
ECHO What time to start HuddleAPI? Same format
SET /p timeToUp=

:y
schtasks /create /sc DAILY /tn "iCoreConnect\ForceHuddleAPIdown" /tr "NET Stop 'HuddleAPIService'" /st %timeToDown% /ru system
schtasks /create /sc DAILY /tn "iCoreConnect\BringHuddleAPIup" /tr "NET Start 'HuddleAPIService'" /st %timeToUp% /ru system
goto end

:n
ECHO okay then

:end
pause