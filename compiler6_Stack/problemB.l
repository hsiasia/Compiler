%{
	#include "problemB.tab.h"
	int depth = 0;
%}
Stag "<"
Etag ">"
selfStag "</"
selfEtag "/>"

and "and"
or "or"
not "not"
true "true"
false "false"

starttag_A ({Stag}{and}{Etag})
starttag_O ({Stag}{or}{Etag})
starttag_N ({Stag}{not}{Etag})
endtag ({selfStag}({and}|{or}|{not}){Etag})
selftag_T ({Stag}{true}{selfEtag})
selftag_F ({Stag}{false}{selfEtag})

%%
{starttag_A}	{ depth++; yylval.intVal = depth*10 + 1; return starttag; }
{starttag_O}	{ depth++; yylval.intVal = depth*10 + 2; return starttag; }
{starttag_N}    { depth++; yylval.intVal = depth*10 + 3; return starttag; }
{endtag}	{ return endtag; }
{selftag_T}	{ yylval.intVal = 1; return selftag; }
{selftag_F}	{ yylval.intVal = 2; return selftag; }

\n      {;}
[ \t]+  {;}
.       { return(yytext[0]); }

%%
