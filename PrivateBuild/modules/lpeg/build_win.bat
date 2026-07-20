@echo off
echo setting up TDM / MinGW...
@PATH=.;C:\MinGW\msys\1.0\local\bin;C:\MinGW\bin;C:\MinGW\msys\1.0\bin;%PATH%
@PATH=.;C:\TDM-GCC-64\bin;%PATH%
rem set make_exe=make
set make_exe=mingw32-make
echo TDM / MinGW Shell Paths have been added successfully.

rem ----------------------------------------------------------------------

set "orig_folder=%cd%"
set "srcdir=v1.1.0\src"

echo Entering folder: %srcdir%
cd %srcdir%

echo ensure x86/ and x64/ subfolders
if not exist "../x86" mkdir "../x86"
if not exist "../x64" mkdir "../x64"

call :CleanStep

echo Running command: make mingw BUILD32=true
%make_exe% mingw BUILD32=true

echo Copying x86 version to output folder
cp *.dll ../x86/

call :CleanStep

echo Running command: make mingw
%make_exe% mingw

echo copying x64 version to output folder
cp *.dll ../x64/


cd /d "%orig_folder%"
goto :eof
rem ----------------------------------------------------------------------

:CleanStep
echo clean *.o and *.dll files ...
rm *.o  2>NUL
rm *.dll 2>NUL
goto :eof