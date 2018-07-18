@echo off
goto debut

:clean_tmp
del *.o  >nul 2>&1
del *.a  >nul 2>&1
del *.dll  >nul 2>&1
del *.exe  >nul 2>&1
del src/*.o  >nul 2>&1
del src/*.a  >nul 2>&1
del src/*.dll  >nul 2>&1
del src/*.exe  >nul 2>&1
goto:eof

:debut
echo Moving scope to dir 'src/'
cd src/
echo Cleaning any tempfiles from 'src/'
del *.tar >nul 2>&1
echo Please select an archive to build from (i.e. without the '.tar.gz'):
ls *.tar.gz
set /p SOURCE=
echo Extracting: '%SOURCE%.tar.gz'
7za x -y %SOURCE%.tar.gz >NUL
7za x -y %SOURCE%.tar >NUL
del /s %SOURCE%.tar >nul 2>&1
echo Extraction done.
rem mv %SOURCE%.tar.gz %SOURCE%/%SOURCE%.tar.gz
echo Returning to parent folder:
cd ..
echo     ^> %cd%
echo Copying x86 config files...
cp -R cfg/* src\%SOURCE%
echo Moving to compilation dir...
cd src\%SOURCE%
echo Creating output dirs...
md src\bin >nul 2>&1
md src\bin64 >nul 2>&1
md src\o86 >nul 2>&1
md src\o64 >nul 2>&1
echo setting up TDM / MinGW...
@PATH=.;C:\MinGW\msys\1.0\local\bin;C:\MinGW\bin;C:\MinGW\msys\1.0\bin;%PATH%
@PATH=.;C:\TDM-GCC-64\bin;%PATH%
rem set make_exe=make
set make_exe=mingw32-make
@echo TDM / MinGW Shell Paths have been added successfully.
echo running make for x86
%make_exe%
cd src
%make_exe% -f Makefile_x86 mingw
echo backing up object x86 files
cp *.o o86
cd ..
echo Building with Win x86 Resources
call Lua_WinRes.bat
echo Compilation for x86: Complete.
echo .
echo cleaning and preparing for x64 compilation
call :clean_tmp
echo running make for x64
rem following doesnt work well
rem %make_exe% -f Makefile_x64 mingw
rem workaround, by replacing it:
mv makefile makefile.original.old
mv Makefile_x64 makefile
%make_exe% mingw
echo backing up object x86 files
cp *.o o64
cd ..
echo Building with Win x64 Resources
call Lua_WinRes64.bat
echo Compilation for x64: Complete.
echo .
echo Cleaning...
call :clean_tmp
echo returning to original dir
cd ..\..\..
echo     ^> %cd%
echo copying builds to 'builds/'...
md builds\%SOURCE% >nul 2>&1
md builds\%SOURCE%\x86 >nul 2>&1
md builds\%SOURCE%\x64 >nul 2>&1
cp src/%SOURCE%/src/bin/* builds/%SOURCE%/x86
cp src/%SOURCE%/src/bin64/* builds/%SOURCE%/x64
echo done.