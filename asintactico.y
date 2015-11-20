%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*

%}

%token TIPO_DE_DATO PALABRA_RESERVADA INSTRUCCION BOOL DOSPUNTOS CARACTER_ESPECIAL CORCHETE_A CORCHETE_C OPERADOR_COMPUESTO ENTERO FLOAT IDENTIFICADOR CHAR STRING ERRORLEXICO INCLUDE ENTERO_POS COMA PUNTOYCOMA LLAVE_A LLAVE_C OPERADOR OPERADORR OPERADORL IGUAL DO WHILE IF THEN ELSE PARENTESIS_A PARENTESIS_C STREAM END

%%

bloquecodigo : codigo END {exit(0);};

codigo : linea 
	| codigo linea  
;

linea : '\n'
	| sentencia '\n'
;

sentencia : declaracionvar
	| declaracionvector
	| declaracionfuncion
	| funcion
	| bloque
	| controlflujo
;

declaracionvar : TIPO_DE_DATO DOSPUNTOS variable
;

declaracionvector : TIPO_DE_DATO DOSPUNTOS vector
;

declaracionfuncion : encabezado declaracionlocal cuerpo
;

variable : IDENTIFICADOR 
	| IDENTIFICADOR COMA variable
;

vector : IDENTIFICADOR CORCHETE_A ENTERO_POS CORCHETE_C
;

funcion : IDENTIFICADOR PARENTESIS_A PARENTESIS_C
	| IDENTIFICADOR PARENTESIS_A variable PARENTESIS_C
;
 
encabezado : declaracionvar
	| declaracionvar COMA encabezado
;

declaracionlocal : declaracionvar
	| declaracionvar PUNTOYCOMA declaracionlocal
;

cuerpo : LLAVE_A LLAVE_C
	| LLAVE_A bloque LLAVE_C
;

bloque : comandosimple
	| comandosimple PUNTOYCOMA bloque
;

comandosimple : IDENTIFICADOR IGUAL expresion
	| IDENTIFICADOR IGUAL operacionaritmetica
	| vector IGUAL expresion
	| vector IGUAL operacionaritmetica
	| STREAM expresion
	| STREAM vector 
	| STREAM operacionaritmetica
	| STREAM operacionlogica
	| funcion
	| controlflujo
;

expresion : expresionnum
	| expresiontex
	| expresionlog
	| IDENTIFICADOR
;

expresionnum : ENTERO_POS
	| ENTERO
	| FLOAT
;

expresiontex : CHAR
	| STRING
;

expresionlog : BOOL
;

operacionaritmetica : expresion OPERADOR expresion
	| expresion OPERADOR operacionaritmetica
	| PARENTESIS_A operacionaritmetica PARENTESIS_C
;

operacionlogica : operacionaritmetica OPERADORR operacionaritmetica
	| expresion OPERADORR expresion
	| expresion OPERADORL expresion
	| expresion OPERADORL operacionaritmetica
	| operacionaritmetica OPERADORL expresion
	| operacionlogica OPERADORL operacionlogica
;

controlflujo : condicional
	| WHILE PARENTESIS_A operacionlogica PARENTESIS_C DO comandosimple
	| DO comandosimple WHILE PARENTESIS_A operacionlogica PARENTESIS_C
	| WHILE PARENTESIS_A expresion PARENTESIS_C DO comandosimple
	| DO comandosimple WHILE PARENTESIS_A expresion PARENTESIS_C
;

condicional : IF PARENTESIS_A expresion PARENTESIS_C THEN comandosimple
	| IF PARENTESIS_A operacionlogica PARENTESIS_C THEN comandosimple
	| IF PARENTESIS_A expresion PARENTESIS_C THEN comandosimple ELSE comandosimple
	| IF PARENTESIS_A operacionlogica PARENTESIS_C THEN comandosimple ELSE comandosimple
;

%%
int main() {
	extern FILE * yyin;
	FILE *archivo = fopen("code", "r");
	if (!archivo) {
		printf("No existe el archivo.\n");
		return -1;
	}
	yyin = archivo;
	yyparse();
}

yyerror (char *s)
{
	extern int lineas;
	printf("\nError en línea: %d\n",lineas);
	exit(1);
}

int yywrap()  
{  
   return 1;  
}  
