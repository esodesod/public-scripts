@echo off
rem
rem Import registry files from current directory into registry.
rem Also do some logging. Cause it's cool.
rem
rem
rem

rem #################
rem setting variables
rem #################
:: vars > paths and filenames
set runpath=%~dp0
set scriptname=%~n0
set log=%runpath%\%scriptname%.log

:: vars > time
set _datestr=%date:~6,4%-%date:~3,2%-%date:~0,2%
set _tmpvar=%time:~0,8%
set _tmpvar=%_tmpvar: =0%
set _timefriendly=%_tmpvar%
set _tmpvar=%_tmpvar::=%
set _timestr=%_tmpvar%


rem #############
rem starting jobs
rem #############
:: Start logging.
echo. >> %log%
echo %_datestr% %_timefriendly%: Script reporting: *** Starting new job, master *** >> %log%

:: List registry files.
echo %_datestr% %_timefriendly%: Script reporting: Looking for *.reg files in folder %runpath% >> %log%
for /f %%i in ('dir /b %runpath%\*.reg') do echo %_datestr% %_timefriendly%: FOUND file: %%i >> %log%

:: Import .reg files into registry.
echo %_datestr% %_timefriendly%: Script reporting: I will now import the *.reg files into registry >> %log%
for /f %%i in ('dir /b %runpath%\*.reg') do echo %_datestr% %_timefriendly%: IMPORTING file: %%i >> %log% && reg import %runpath%\%%i >nul

:: Report that I'm done.
echo %_datestr% %_timefriendly%: Script reporting: I'm done. Get me out of here! >> %log%

rem ####
rem exit
rem ####
exit 0