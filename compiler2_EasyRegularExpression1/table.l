%{
%}
Word  ^[A-Z][A-Za-z]*\n
IP ^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\n
Email ^[a-zA-Z0-9]+\@[a-zA-Z0-9]+[a-zA-Z0-9\.]+\.[a-zA-Z0-9]+\n
%%
{Word}	{char *tmp=NULL;
        if((tmp=strstr(yytext, "\n")))
        {
                *tmp='\0';
        }
 	printf("%s is a word\n",yytext);
	}
{IP} 	{char *tmp=NULL;
	if((tmp=strstr(yytext, "\n")))
	{
		*tmp='\0';
	}
	printf("%s is an IP address\n",yytext);
	}
{Email}	{char *tmp=NULL;
        if((tmp=strstr(yytext, "\n")))
        {
                *tmp='\0';
        }
	printf("%s is an email address\n",yytext);
	}
.|\n {}
%%
int main(int argc, char *argv[]){
	yylex();
	return(0);
}
