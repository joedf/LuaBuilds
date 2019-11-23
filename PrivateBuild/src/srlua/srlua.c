/*
* srlua.c
* Lua interpreter for self-running programs
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 14 Aug 2019 14:16:21
* This code is hereby placed in the public domain and also under the MIT license
*/

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "srglue.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#if LUA_VERSION_NUM <= 501

#define lua_load(L,r,d,n,m)	(lua_load)(L,r,d,n)
#define luaL_traceback(L,M,m,l)	traceback(L,m)

static void traceback(lua_State *L, const char *message)
{
 lua_getglobal(L,"debug");
 if (!lua_istable(L,-1)) { lua_pop(L,1); return; }
 lua_getfield(L,-1,"traceback");
 if (!lua_isfunction(L,-1)) { lua_pop(L,2); return; }
 lua_pushstring(L,message);
 lua_pushinteger(L,2);
 lua_call(L,2,1);
}

#endif

static const char* progname="srlua";

static void fatal(const char* message)
{
 fprintf(stderr,"%s: %s\n",progname,message);
 exit(EXIT_FAILURE);
}

static void cannot(lua_State *L, const char* what, const char* name)
{
 const char* why= memcmp(what,"find",4)==0 ? "no glue" : strerror(errno);
 const char* message=lua_pushfstring(L,"cannot %s %s: %s",what,name,why);
 fatal(message);
}

typedef struct { FILE *f; size_t size; char buff[512]; } State;

static const char *myget(lua_State *L, void *data, size_t *size)
{
 State* s=data;
 size_t n;
 (void)L;
 n=(sizeof(s->buff)<=s->size)? sizeof(s->buff) : s->size;
 n=fread(s->buff,1,n,s->f);
 s->size-=n;
 *size=n;
 return (n>0) ? s->buff : NULL;
}

static void load(lua_State *L, const char *name)
{
 Glue t;
 State S;
 FILE *f=fopen(name,"rb");
 int c;
 if (f==NULL) cannot(L,"open",name);
 if (fseek(f,-sizeof(t),SEEK_END)!=0) cannot(L,"seek",name);
 if (fread(&t,sizeof(t),1,f)!=1) cannot(L,"read",name);
 if (memcmp(t.sig,GLUESIG,GLUELEN)!=0) cannot(L,"find a Lua program in",name);
 if (fseek(f,t.size1,SEEK_SET)!=0) cannot(L,"seek",name);
 S.f=f; S.size=t.size2;
 c=getc(f);
 if (c=='#') while (--S.size>0 && c!='\n') c=getc(f);
 ungetc(c,f);
 if (lua_load(L,myget,&S,"=",NULL)!=0) fatal(lua_tostring(L,-1));
 fclose(f);
}

static int pmain(lua_State *L)
{
 int argc=lua_tointeger(L,1);
 char** argv=lua_touserdata(L,2);
 int i;
 luaL_openlibs(L);
 load(L,argv[0]);
 lua_createtable(L,argc,0);
 for (i=0; i<argc; i++)
 {
  lua_pushstring(L,argv[i]);
  lua_rawseti(L,-2,i);
 }
 lua_setglobal(L,"arg");
 luaL_checkstack(L,argc-1,"too many arguments to script");
 for (i=1; i<argc; i++)
 {
  lua_pushstring(L,argv[i]);
 }
 lua_call(L,argc-1,0);
 return 0;
}

static int msghandler(lua_State *L)
{
 const char *message=lua_tostring(L,1);
 if (message==NULL)
 {
  if (luaL_callmeta(L,1,"__tostring") && lua_type(L,-1)==LUA_TSTRING) return 1;
  message=lua_pushfstring(L,"(error object is a %s value)",luaL_typename(L,1));
 }
 luaL_traceback(L,L,message,1);
 return 1;
}

int main(int argc, char *argv[])
{
 lua_State *L;
 if (argv[0]==NULL) fatal("cannot locate this executable");
 progname=argv[0];
 L=luaL_newstate();
 if (L==NULL) fatal("cannot create state: not enough memory");
 lua_pushcfunction(L,msghandler);
 lua_pushcfunction(L,&pmain);
 lua_pushinteger(L,argc);
 lua_pushlightuserdata(L,argv);
 if (lua_pcall(L,2,0,1)!=0) fatal(lua_tostring(L,-1));
 lua_close(L);
 return EXIT_SUCCESS;
}
