/*
* srglue.h
* glue exe and script for srlua
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 14 Aug 2019 08:46:54
* This code is hereby placed in the public domain and also under the MIT license
*/

#define GLUESIG	"%%srglue"
#define GLUELEN	(sizeof(GLUESIG)-1)

typedef struct { char sig[GLUELEN]; long size1, size2; } Glue;
