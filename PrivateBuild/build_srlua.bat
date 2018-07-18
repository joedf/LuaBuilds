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
rm -R srlua >nul 2>&1
echo Please select an archive to build from (i.e. without the '.tar.gz'):
ls *.tar.gz
set /p SOURCE=
echo Extracting: '%SOURCE%.tar.gz'
7za x -y %SOURCE%.tar.gz >NUL
7za x -y %SOURCE%.tar >NUL
del /s %SOURCE%.tar >nul 2>&1
echo Extraction done.
md srlua\luasrc
echo Please select dir to copy lua-src from:
ls -d *
set /p LUA_SRC=
echo copying lua source files...
cp %LUA_SRC%/src/*.c srlua/luasrc
cp %LUA_SRC%/src/*.h srlua/luasrc
cp %LUA_SRC%/src/*.hpp srlua/luasrc
echo copy successful.
echo Returning to parent folder:
cd ..
echo     ^> %cd%
echo Please select dir to copy x86 and x64 'lua5X.dll' to use (i.e. containing a x86 and x64 dir and use forward slashes! for example: builds/lua-5.3.2):
set /p LUA_DLL=
echo parameters saved.
echo Copying x86 config files...
cp -R cfg-srlua/* src\srlua
echo Creating output dirs...
md src\srlua\bin >nul 2>&1
md src\srlua\bin64 >nul 2>&1
echo setting up TDM / MinGW...
@PATH=.;C:\MinGW\msys\1.0\local\bin;C:\MinGW\bin;C:\MinGW\msys\1.0\bin;%PATH%
@PATH=.;C:\TDM-GCC-64\bin;%PATH%
@echo TDM / MinGW Shell Paths have been added successfully.
echo cleaning and preparing for x86 compilation
call :clean_tmp
echo copying lua5x.dll (x86) file...
cp %LUA_DLL%/x86/*.dll src/srlua
echo Moving to compilation dir...
cd src\srlua
echo running make for x86
rem set make_exe=make
set make_exe=mingw32-make
@mv makefile makefile.original.old
mv Makefile86 makefile
%make_exe%
cp *.dll bin
cp *.exe bin
echo x86 compilation done.
echo cleaning and preparing for x64 compilation
call :clean_tmp
cd ..\..
echo copying lua5x.dll (x64) file...
cp %LUA_DLL%/x64/*.dll src/srlua
cd src\srlua
echo running make for x64
mv makefile Makefile86
mv Makefile64 makefile
%make_exe%
cp *.dll bin64 >nul 2>&1
cp *.exe bin64 >nul 2>&1
echo x64 compilation done.
echo cleaning...
call :clean_tmp
echo returning to original dir
cd ..\..
echo     ^> %cd%
echo copying builds to '%LUA_DLL%/'...
cd %LUA_DLL%
md srlua >nul 2>&1
md srlua\x86 >nul 2>&1
md srlua\x64 >nul 2>&1
cd ..\..
cp src/srlua/bin/* %LUA_DLL%/srlua/x86
cp src/srlua/bin64/* %LUA_DLL%/srlua/x64
echo done.