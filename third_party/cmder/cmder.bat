@echo off
set CMDER_ROOT=C:\Other\cmder
start %CMDER_ROOT%\vendor\conemu-maximus5\ConEmu.exe /icon "%CMDER_ROOT%\cmder.exe" /title "Homestead VM" /loadcfgfile "%CMDER_ROOT%\config\ConEmu.xml" /cmd cmd /k "%CMDER_ROOT%\vendor\init.bat cd %CD% && %~1"