# ---------------------------------------------------------
# makefile for lpeg lua module
# modified from the original by Joe DF for MinGW / TDM-GCC
# Created 2025/12/19
# ---------------------------------------------------------

LIBNAME = lpeg

# Path to Lua source code to use...
LUADIR = ./../../../../src/lua-5.5.1-rc1/src

# Path to LuaXX.dll file (exclude the file extension)
LUADLL = ./../../../../builds/lua-5.5.1-rc1/x64/lua55
# Path to Lua executable (exclude the file extension)
LUABIN = ./../../../../builds/lua-5.5.1-rc1/x64/lua

# ... and the paths for 32 bit (x86) builds
LUADLL32 = ./../../../../builds/lua-5.5.1-rc1/x86/lua55
LUABIN32 = ./../../../../builds/lua-5.5.1-rc1/x86/lua

# ---------------------------------------------------------

BUILD32 ?= off

CCBIT = -m64
ifeq "$(BUILD32)" "true"
    CCBIT = -m32
    LUADLL = $(LUADLL32)
    LUABIN = $(LUABIN32)
endif

WINDLLFLAGS = -shared -l$(LUADLL) -I$(LUADIR) -L$(LUADIR)

COPT = -O2 -DNDEBUG
# COPT = -O0 -DLPEG_DEBUG -g

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wredundant-decls \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wmissing-declarations \
	-Wnested-externs \
	-Wstrict-prototypes \
	-Wc++-compat \
# -Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) -std=c99 -I$(LUADIR) -fPIC
CC = gcc $(CCBIT)

FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o lpcset.o

# For Linux
linux:
	$(MAKE) lpeg.so "DLLFLAGS = -shared -fPIC"

# For Mac OS
macosx:
	$(MAKE) lpeg.so "DLLFLAGS = -bundle -undefined dynamic_lookup"

# for MinGW / MS Windows
mingw:
	$(MAKE) $(FILES)
	$(CC) $(WINDLLFLAGS) $(FILES) -o lpeg.dll

mingwtest:
	$(LUABIN) test.lua

lpeg.so: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -o lpeg.so

$(FILES): makefile

test: test.lua re.lua lpeg.so
	./test.lua

clean:
	rm -f $(FILES) lpeg.so lpeg.dll


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h lpcset.h
lpcset.o: lpcset.c lptypes.h lpcset.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h lpcode.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h \
 lpcset.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h
