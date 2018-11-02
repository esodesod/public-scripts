@echo off
rem
rem Copy from %src% to %dst%.
rem Also do some logging. Because it's cool.
rem
rem
rem

rem #################
rem setting variables
rem #################
:: vars > time
set _datestr=%date:~6,4%-%date:~3,2%-%date:~0,2%
set _tmpvar=%time:~0,8%
set _tmpvar=%_tmpvar: =0%
set _timefriendly=%_tmpvar%
set _tmpvar=%_tmpvar::=%
set _timestr=%_tmpvar%

:: vars > paths and filenames
set runpath=%~dp0
set scriptname=%~n0
set log="%runpath%%scriptname%-%_datestr%_%_timestr%.log"

:: vars > robocopy
set src="\\file-01.domain.tld\foldername"
set dst="\\file-02.domain.tld\foldername"
set robovars=/MIR /COPY:DATSOU /MT:10 /R:3 /W:10 /NP /TEE /log+:%log%
rem that's mirror, data, attributes - timestamps, security/ntfs/acl, owner, auditing info
rem multi thread, retries, wait between retries & log

echo Question: You sure? I'll run this command
echo.
echo.
echo COMMAND: robocopy %src% %dst% %robovars%
echo.
echo.
echo Just press the "anykey" to continue...
pause >nul

robocopy %src% %dst% %robovars%

echo.
echo.
echo I'm done (phew!).
echo Just press the "anykey" to exit (with a zero, which means success.. or 0, or nothing).
pause >nul
rem ####
rem exit
rem ####
exit 0