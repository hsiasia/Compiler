%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex();
void yyerror(const char* message) {
    printf("Invaild format\n");
};

float opdstack[30]={-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000,-1000};
char* optstack[30]={};
int opdpointer=0;
int optpointer=0;
float ans=0.0;

float calulat(float opdstack[],char* optstack[]){
	int pointerx=0;
	int pointery=0;
	float temp_ans=0.0;
	while((opdstack[pointerx]!=-1000)&&(optstack[pointery]!='\0')){
		float x,y;
		char* opt;
		if(opdstack[pointerx+1]==-1000||(optstack[pointery+1]=='\0'&&opdstack[pointerx+2]!=-1000)){
			opdstack[pointerx]=-1000;
			break;
		}
		x=opdstack[pointerx++];
		y=opdstack[pointerx];
		opt=optstack[pointery++];
		if(*opt=='+'){
			opdstack[pointerx]=x+y;
			//printf("+ %f\n",opdstack[pointerx]);
		}
		else if(*opt=='-'){
			opdstack[pointerx]=x-y;
			//printf("- %f\n",opdstack[pointerx]);
		}
		else if(*opt=='*'){
			opdstack[pointerx]=x*y;
			//printf("* %f\n",opdstack[pointerx]);
		}
		else if(*opt=='/'){
			opdstack[pointerx]=x/y;
			//printf("/ %f\n",opdstack[pointerx]);
		}
	}
	temp_ans=opdstack[pointerx];
	return temp_ans;
}

%}
%union{
	char* exp;
	float val;
}
%token <val> Number
%token <exp> OPT

%%
line 
	:expressions{
		ans=calulat(opdstack, optstack);
		if(ans==-1000){
			printf("Wrong Formula");
		}
		else{
			if(ans>0.0)
				ans=(int)(ans*10+0.5)/10.0;
			else
				ans=(int)(ans*10-0.5)/10.0;
			printf("%0.1f",ans);
		}
	}
	;
expressions
	: expression{
	//printf("1\n");	
}
	
	| expression expression{
	//printf("2\n");	
}
	| expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression expression expression expression expression{
	//printf("3\n");	
}
	| expression expression expression expression expression expression expression expression expression expression{
	//printf("3\n");	
}
	;
	
expression
	:operadstream operatstream
{
	//printf("4\n");	
}
	;
operadstream
	:operadstream Number{
//printf("5\n");	
		opdstack[opdpointer++]=$2;
}
	|Number{
//printf("6\n");	
		opdstack[opdpointer++]=$1;
}
	;
operatstream
	:operatstream OPT{
//printf("7\n");	
		optstack[optpointer++]=$2;
}
	|OPT{
//printf("8\n");	
		optstack[optpointer++]=$1;
}
	;	
%%
int main(){
        yyparse();
        return(0);
}

