%{
#include "problemA.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
number     (0|[1-9][0-9]*)

%%
"("          { return Left; }
")"          { return Right; }
"+"          { yylval.s.exp = strdup(yytext); return Add; }
"-"          { yylval.s.exp = strdup(yytext); return Sub; }
"*"          { yylval.s.exp = strdup(yytext); return Mul; }
"/"          { yylval.s.exp = strdup(yytext); return Div; }
{number}     { yylval.s.exp = strdup(yytext);
			   yylval.s.val = atoi(yytext); return Number; }
\n           {return 0;}
.            {;}
%%
