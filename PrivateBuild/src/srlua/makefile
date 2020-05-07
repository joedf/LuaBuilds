# makefile for srlua

# change these to reflect your Lua installation
LUA=./luasrc
LUAINC= $(LUA)
LUALIB= $(LUA)
LUABIN= $(LUA)

# these will probably work if Lua has been installed globally
#LUA= /usr/local
#LUAINC= $(LUA)/include
#LUALIB= $(LUA)/lib
#LUABIN= $(LUA)/bin

# probably no need to change anything below here
CC= gcc -m64 -std=c99
CFLAGS= $(INCS) $(WARN) -O2 $G
WARN= -Wall -Wextra -Wfatal-errors -O2
INCS= -I$(LUAINC)
LIBS= -L$(LUALIB) "lua54.dll" -lm
EXPORT=
# for Mac OS X comment the previous line above or do 'make EXPORT='
T= a.exe
S= srlua.exe
OBJS= srlua.o
TEST= test.lua

all:	test

test:	$T
	./$T *

$T:	$S $(TEST) srglue
	./bin64/srglue bin64/$S $(TEST) $T
	chmod +x $T
	rm srglue.exe

$S:	$(OBJS)
	$(CC) -o $@ $(EXPORT) $(OBJS) $(LIBS)

# addicons:
	windres srglue.rc srgluerc.o
	windres srlua.rc srluarc.o
	$(CC) srglue.c srgluerc.o "lua54.dll" -o srglue
	$(CC) srlua.o srluarc.o "lua54.dll" -o srlua
	@cmd /c "copy lua54.dll bin64\lua54.dll"
	@mv srglue.exe bin64\srglue.exe
	@mv srlua.exe bin64\srlua.exe
	@rm *.o
	@rm *.dll

clean:
	rm -f $(OBJS) $T $S core core.* a.out *.o srglue

# eof
