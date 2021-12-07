%{
#include "stdio.h"

int yylex();
int flag=0;

void yyerror(const char* message) {
    printf("Invaild format\n");
};
%}
%union {
    int intVal;
}

%token <intVal> starttag
%token <intVal> selftag
%token endtag

%type <intVal> tagstream
%type <intVal> expstream
%type <intVal> expression
%%
line 
	: expression {
		if($1==1)
			printf("true");
		else
			printf("false");
	}
	;
expression
	: tagstream{
		if($1==1)
			$$=1;
		else
			$$=2;
	}
	| starttag endtag{
		if($1%10==1) //and
			$$=1;
		else if($1%10==2) //or
			$$=2;
	}
	| starttag tagstream endtag{
		if($1%10==1){ //and
			if($2==1){
				$$=1;
				flag=0;}
			else{
				$$=2;
				flag=0;}
		}
		else if($1%10==2){ //or
			if($2==1||flag==1){
				$$=1;
				flag=0;}
			else{
				$$=2;
				flag=0;}
		}
		else if($1%10==3){ //not
			if($2==1)
				$$=2;
			else
				$$=1;
		}
	}
	| starttag expstream endtag{
		if($1%10==1){ //and
			if($2==1){
				$$=1;
				flag=0;}
			else{
				$$=2;
				flag=0;}
		}
		else if($1%10==2){ //or
			if($2==1||flag==1){
				$$=1;
				flag=0;}
			else{
				$$=2;
				flag=0;}
		}
	}
	;
expstream
	: expression{
		if($1==2) //任一false
			$$=2;
		else //皆是true
			$$=1;
		if(flag==1||$1==1)
			flag=1;
	}
	| expression expression{
		if($1==2||$2==2) //任一false
			$$=2;
		else //皆是true
			$$=1;
		if(flag==1||$1==1||$2==1)
			flag=1;
	}
	| expression expression expression{
		if($1==2||$2==2||$3==2) //任一false
			$$=2;
		else //皆是true
			$$=1;
		if(flag==1||$1==1||$2==1||$3==1)
			flag=1;
	}
	;
tagstream
	: selftag tagstream{
		if($1==2||$2==2) //任一false
			$$=2;
		else //皆是true
			$$=1;
		if($1==1||$2==1)
			flag=1;
	}
	| selftag{
		if($1==2) //false
			$$=2;
		else{ //true
			$$=1;
		}
	}
	;

%%

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}