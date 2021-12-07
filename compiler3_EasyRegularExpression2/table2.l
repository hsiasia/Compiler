%{
#include<string.h>
%}
ATM (?:\$(0|100000|[1-9][0-9]?[0-9]?[0-9]?[0-9]?))[^0-9]
Day (?:\+(36[0-5]|3[0-5][0-9]|[12][0-9][0-9]|[0-9]|[1-9][0-9]))[^0-9]
Time (?:(2[0-3]|[01][0-9])\:[0-5][0-9])
Place (?:[A-Z][a-z\.\-]+[A-Z])
%%
{Time}  {
     	printf("at %s\n",yytext);
        }
{Day}   {yytext[strlen(yytext)-1]='\0';    
        printf("after %s days\n",yytext);
        }
{Place} {
        printf("at %s\n",yytext);
        }
{ATM}   {yytext[strlen(yytext)-1]='\0';
        printf("transfer %s\n",yytext);
        }
.|[\n\r]	{}
%%
int main(int argc,char *argv[]){
	yylex();
	return(0);
}


