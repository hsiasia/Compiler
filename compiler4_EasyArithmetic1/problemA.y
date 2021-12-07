%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex();
void yyerror (const char *message);

char *concat( const char* s1, const char* s2, const char*s3)
{
    int len = strlen(s1) + strlen(s2) + strlen(s3) + 1;
    char *s = malloc(sizeof(char)*len);

    int i=0;
    int j=0;
    for( j=0; s1[j]!='\0'; j++)
        s[i++] = s1[j];
  
    for(j=0; s2[j]!='\0'; j++)
        s[i++] = s2[j];

    for(j=0; s3[j]!='\0'; j++)
        s[i++] = s3[j];

    s[i] = '\0';

    return s;
}

%}
%union{
	struct{
		char* exp;
		int val;
	} s;
}
%token <s> Number
%token <s> Left Right
%token <s> Add Sub Mul Div

%%
line 
	:expression{
		printf("the preorder expression is : %s\nthe result is : %d\n",$<s.exp>1,$<s.val>1);}
	;
expression 
	: MDexpression
	| expression Add MDexpression{
		$<s.val>$ = $<s.val>1 + $<s.val>3;
		$<s.exp>$ = concat(strcat($<s.exp>2," "),$<s.exp>1,$<s.exp>3);
	}
	| expression Sub MDexpression{
		$<s.val>$ = $<s.val>1 - $<s.val>3;
		$<s.exp>$ = concat(strcat($<s.exp>2," "),$<s.exp>1,$<s.exp>3);
	}
	;
MDexpression
	: primary
	| MDexpression Mul primary{
		$<s.val>$ = $<s.val>1 * $<s.val>3; 
		$<s.exp>$ = concat(strcat($<s.exp>2," "),$<s.exp>1,$<s.exp>3);
	}
	| MDexpression Div primary{
		$<s.val>$ = $<s.val>1 / $<s.val>3;
		$<s.exp>$ = concat(strcat($<s.exp>2," "),$<s.exp>1,$<s.exp>3);
	}
	;
primary
	: Number{
		$<s.exp>$ = strcat($<s.exp>1," ");
	}
	| Left expression Right{
		$<s.val>$ = $<s.val>2;
		$<s.exp>$ = $<s.exp>2;
	}
	;	
%%
void yyerror(const char *message){
        printf (stderr, "%s\n",message);
}
int main(){
        yyparse();
        return(0);
}

