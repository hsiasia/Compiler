%{
	#include "MiniLisp.tab.h"
    #include <stdio.h>
	#include <stdlib.h>
%}
separator  [ \t\f\r]+
letter     [a-z]
digit      [0-9]

number     (0|[1-9]{digit}*|-[1-9]{digit}*)
id         {letter}({letter}|{digit}|'-')*
bool-val   #t|#f
%%
"mod"        { return Mod; }
"and"        { return And; }
"or"         { return Or; }
"not"        { return Not; }

"define"     { return Define; }
"if"         { return If; }

"print-num"  { return Print_num; }
"print-bool" { return Print_bool; }

{number}     { yylval.intVal = atoi(yytext); return(Number); }
{id}         { yylval.String = strdup(yytext); return(ID); }
{bool-val}   { yylval.String = strdup(yytext); return(Bool_val); }

"("          { return Left_P; }
")"          { return Right_P; }
"+"          { return Add; }
"-"          { return Sub; }
"*"          { return Mul; }
"/"          { return Div; }

">"          { return Bigger; }
"<"          { return Smaller; }
"="          { return Equal; }

{separator}  { return Sep; }
\n           { ; }
.            { ; }
%%