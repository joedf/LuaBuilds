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
CC= gcc64
CFLAGS= $(INCS) $(WARN) -O2 $G
WARN= -ansi -pedantic -Wall -Wextra
INCS= -I$(LUAINC)
LIBS= -L$(LUALIB) "lua53.dll" -lm
EXPORT=
# for Mac OS X comment the previous line above or do 'make EXPORT='
T= a.exe
S= srlua.exe
OBJS= srlua.o
TEST= test.lua

all:	test

test:	$T
	./$T *

$T:	$S $(TEST) glue
	./bin64/glue bin64/$S $(TEST) $T
	chmod +x $T
	rm glue.exe

$S:	$(OBJS)
	$(CC) -o $@ $(EXPORT) $(OBJS) $(LIBS)

# addicons:
	windres64 glue.rc gluerc.o
	windres64 srlua.rc srluarc.o
	$(CC) glue.c gluerc.o "lua53.dll" -o glue
	$(CC) srlua.o srluarc.o "lua53.dll" -o srlua
	@cmd /c "copy lua53.dll bin64\lua53.dll"
	@mv glue.exe bin64\glue.exe
	@mv srlua.exe bin64\srlua.exe
	@rm *.o
	@rm *.dll

clean:
	rm -f $(OBJS) $T $S core core.* a.out *.o glue

# eof
