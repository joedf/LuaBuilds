/*
* srglue.c
* glue exe and script for srlua
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 13 Aug 2019 08:44:57
* This code is hereby placed in the public domain and also under the MIT license
*/

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "srglue.h"

static const char* progname="srglue";

static void cannot(const char* what, const char* name)
{
 fprintf(stderr,"%s: cannot %s %s: %s\n",progname,what,name,strerror(errno));
 exit(EXIT_FAILURE);
}

static FILE* open(const char* name, const char* mode, const char* outname)
{
 if (outname!=NULL && strcmp(name,outname)==0)
 {
  errno=EPERM;
  cannot("overwrite input file",name);
  return NULL;
 }
 else
 {
  FILE* f=fopen(name,mode);
  if (f==NULL) cannot("open",name);
  return f;
 }
}

static long copy(FILE* in, const char* name, FILE* out, const char* outname)
{
 long size;
 if (fseek(in,0,SEEK_END)!=0) cannot("seek",name);
 size=ftell(in);
 if (fseek(in,0,SEEK_SET)!=0) cannot("seek",name);
 for (;;)
 {
  char b[BUFSIZ];
  int n=fread(&b,1,sizeof(b),in);
  if (n==0) { if (ferror(in)) cannot("read",name); else break; }
  if (fwrite(&b,n,1,out)!=1)  cannot("write",outname);
 }
 fclose(in);
 return size;
}

int main(int argc, char* argv[])
{
 if (argv[0]!=NULL && *argv[0]!=0) progname=argv[0];
 if (argc!=4)
 {
  fprintf(stderr,"usage: %s in.exe in.lua out.exe\n",progname);
  return 1;
 }
 else
 {
  FILE* in1=open(argv[1],"rb",argv[3]);
  FILE* in2=open(argv[2],"rb",argv[3]);
  FILE* out=open(argv[3],"wb",NULL);
  Glue t={GLUESIG,0,0};
  t.size1=copy(in1,argv[1],out,argv[3]);
  t.size2=copy(in2,argv[2],out,argv[3]);
  if (fwrite(&t,sizeof(t),1,out)!=1) cannot("write",argv[3]);
  if (fclose(out)!=0) cannot("close",argv[3]);
  return 0;
 }
}
