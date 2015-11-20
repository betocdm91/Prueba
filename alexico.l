%{
 /*
ESCUELA POLITECNICA NACIONAL
COMPILADORES
INTEGRANTES:
-Diaz Esteban
-Osorio Carlos
*/
#include "asintactico.tab.h"
int lineas=1;
char errorCont;

%}

%%

"//".* 

"/*"[^´]*"*/"|"/*".*"*/" { 
	int i;
	for(i = 0 ; yytext[i]!='\0' ; i ++ )
		if(yytext[i] == '\n') {
			lineas++;
		}
	};

int|float|bool|char|string {return TIPO_DE_DATO;}

if {return IF;}

then {return THEN;}

else {return ELSE;}

while {return WHILE;}

do {return DO;}

input|output|return {return STREAM;}

"#include"[ ]*"<"[a-z]+\.[a-z]+">" {return INCLUDE;}

true|false {return BOOL;}

[:] {return DosPuntos;}

[;] {return PuntoyComa;}

[,] {return Coma;}

[\!\&\$] {return Caracter_Especial;}

\= {return Igual;}

[\+\-\*\/] {return Operador;}

[\<\>]|"<="|">="|"=="|"!=" {return OperadorB;}

"&&"|"||" {return OperadorS;}

\[ {return Corchete_A;}

\] {return Corchete_C;}

\( {return Parentesis_A;}

\) {return Parentesis_C;}

\{ {return Llave_A;}

\} {return Llave_C;}

[0-9]+ {return Entero_Positivo;}

-[0-9]+ {return Entero;}

[0-9]+"."[0-9]+ {return Float;}

_*[A-Za-z]+_*[A-Za-z0-9]* {return Identificador;}

\'.\' {return Char;}

\"[^"]+\" {return String;}

\n	{
		lineas++;
		return ('\n');
}

[\t ]

<<EOF>> {return END;}

. 	 {printf("%s: Error Lexico en la linea %d.\n",yytext,lineas);}

%%

