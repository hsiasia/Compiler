%{
#include "problemC.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
number     (0|[1-9][0-9]*|-[1-9][0-9]*|[0-9]\.[0-9]+|-[0-9]\.[0-9]+)


%%
"+"          { yylval.exp = strdup(yytext); return OPT; }
"-"          { yylval.exp = strdup(yytext); return OPT; }
"*"          { yylval.exp = strdup(yytext); return OPT; }
"/"          { yylval.exp = strdup(yytext); return OPT; }
{number}     { yylval.val = atof(yytext); return Number; }
\n           {return 0;}
[ \t\f\t]+ {;}
.            {;}
%%
