# Makefile for srlua

LUA_TOPDIR= /usr/local
LUA_INCDIR= $(LUA_TOPDIR)/include
LUA_LIBDIR= $(LUA_TOPDIR)/lib
INSTALL_DIR= /usr/local/bin

CC= gcc -std=c99
CFLAGS= -Wall -Wextra -Wfatal-errors -O2
MYCFLAGS= $(CFLAGS) -I$(LUA_INCDIR)
MYLFLAGS= -Wl,-E
MYLIBS= -L$(LUA_LIBDIR) -llua -lm -ldl

all:	bin test

bin:
	@$(MAKE) `uname`

test:
	./srglue srlua test.lua a.out ; chmod +x a.out
	./a.out *

install:
	cp srglue srlua $(INSTALL_DIR)

clean:
	rm -f srglue srlua a.out

Linux build:
	$(CC) $(CFLAGS) -o srglue srglue.c
	$(CC) $(MYCFLAGS) -o srlua srlua.c $(MYLIBS) $(MYLFLAGS)

Darwin:
	$(MAKE) build MYLFLAGS=

.PHONY: all bin test install clean Linux Darwin build
