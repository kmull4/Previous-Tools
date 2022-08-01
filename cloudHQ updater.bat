::===============================================================
:: Purpose: to copy cloudHQ templates among all coworkers
:: process 1: change workflow to write and save them all from shared G:/.../CloudHQ folder
:: process 2: copy from above to %USERNAME%'s MyDrive
:: /mir MIRROR the file (deletes files no longer in source)
:: /mt allows multithreading
:: /z resarts if interrupted
:: /xf to exclude files
::
:: bug: skip gdoc files . fixed with /xf to exclude files
::===============================================================

robocopy "G:\Shared drives\Support & Install\Support Knowledge Base\Support Email Templates\CloudHQ" "C:\Users\%USERNAME%\My Drive\Gmail Templates" /xf "*.gdoc" /mir /mt /z
