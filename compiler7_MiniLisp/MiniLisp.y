%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex();
int equalflag = 1;
int Redefine = 0;

int VarArrayIndex = 0;
char Variables[100][100];
int VarValue[100];

void yyerror(const char* message) {
    printf("syntax error\n");
};
%}

%union {
    int intVal;
    char* String;
}

%token Mod And Or Not
%token Define If
%token Print_num Print_bool
%token Number ID Bool_val
%token Left_P Right_P Add Sub Mul Div
%token Bigger Smaller Equal
%token Sep

%type <intVal> EXP
%type <intVal> NUM_OP PLUS MINUS MULTIPLY DIVIDE MODULUS GREATER SMALLER EQUAL
%type <intVal> PLUS_EXPS MUL_EXPS EQUAL_EXPS
%type <intVal> LOGICAL_OP AND_OP OR_OP NOT_OP
%type <intVal> AND_EXPS OR_EXPS
%type <intVal> IF_EXP TEST_EXP THEN_EXP ELSE_EXP 

%type <String> Bool_val ID VARIABLE
%type <intVal> Number

%%
PROGRAM	: STMTS
		;

STMTS	: STMT STMTS
		| STMT
		;

STMT	: EXP
		| DEF_STMT
		| PRINT_STMT
		;
	
PRINT_STMT	: Left_P Print_num Sep EXP Right_P {
				printf("%d\n",$4); 
			}
			| Left_P Print_bool Sep EXP Right_P {
				if($4==1) 
					printf("#t\n");
				else 
					printf("#f\n"); 
			}
			;

EXP	: Bool_val {
		if( *(++$1) == 't' ) 
			$$ = 1;
		else $$ = 0; 
	}
    | Number { 
		$$ = $1; 
	}
    | VARIABLE {
		int i;
        for( i=0 ; i<=VarArrayIndex ; i++ ){
            if( !strcmp( Variables[i] , $1 ) ){
                $$ = VarValue[i];
                break;
            }
        }
    }
    | NUM_OP {
		$$ = $1; 
	}
    | LOGICAL_OP {
		$$ = $1; 
	}
    | IF_EXP { 
		$$ = $1; 
	}
    ;

NUM_OP	: PLUS        { $$ = $1; }
		| MINUS       { $$ = $1; }
		| MULTIPLY    { $$ = $1; }
		| DIVIDE      { $$ = $1; }
		| MODULUS     { $$ = $1; }
		| GREATER     { $$ = $1; }
		| SMALLER     { $$ = $1; }
		| EQUAL       { $$ = $1; }
		;
PLUS	: Left_P Add Sep EXP Sep PLUS_EXPS Right_P {
			$$ = $4 + $6; }
		;
PLUS_EXPS	: EXP Sep PLUS_EXPS { 
				$$ = $1 + $3; }
			| EXP {
				$$ = $1; }
			;
MINUS	: Left_P Sub Sep EXP Sep EXP Right_P {
			$$ = $4 - $6; }
		;
MULTIPLY: Left_P Mul Sep EXP Sep MUL_EXPS Right_P {
			$$ = $4 * $6; }
		;
MUL_EXPS: EXP Sep MUL_EXPS {
			$$ = $1 * $3; }
		| EXP {
			$$ = $1; }
		;
DIVIDE	: Left_P Div Sep EXP Sep EXP Right_P {
			$$ = $4 / $6; }
		;
MODULUS	: Left_P Mod Sep EXP Sep EXP Right_P {
			$$ = $4 % $6; }
		;

GREATER	: Left_P Bigger Sep EXP Sep EXP Right_P {
			if($4 > $6) 
				$$ = 1; 
			else 
				$$ = 0; }
		;
SMALLER	: Left_P Smaller Sep EXP Sep EXP Right_P {
			if($4 < $6) 
				$$ = 1; 
			else 
				$$ = 0; }
		;
EQUAL	: Left_P Equal Sep EXP Sep EQUAL_EXPS Right_P {
			if($4 == $6) 
				$$ = 1; 
			else 
				$$ = 0; 
			if(equalflag==0) 
				$$ = 0; }
		;
EQUAL_EXPS	: EXP Sep EQUAL_EXPS {
				if($1 != $3) 
					equalflag = 0;
				$$ = $1; }
			| EXP {
				$$ = $1; }
			;

LOGICAL_OP	: AND_OP    { $$ = $1; }
			| OR_OP     { $$ = $1; }
			| NOT_OP    { $$ = $1; }
			;
AND_OP	: Left_P And Sep EXP Sep AND_EXPS Right_P {
			$$ = ($4 & $6); }
		;
AND_EXPS: EXP Sep AND_EXPS {
			$$ = ($1 & $3); }
		| EXP {
			$$ = $1; }
		;
OR_OP	: Left_P Or Sep EXP Sep OR_EXPS Right_P {
			$$ = ($4 | $6); }
		;
OR_EXPS	: EXP Sep OR_EXPS {
			$$ = ($1 | $3); }
		| EXP {
			$$ = $1; }
		;
NOT_OP	: Left_P Not Sep EXP Right_P {
			if($4 == 0) 
				$$ = 1; 
			else 
				$$ = 0; }
		;

DEF_STMT: Left_P Define Sep VARIABLE Sep EXP Right_P  {
			if( VarArrayIndex!=0 ){
				int i;
				for( i=0 ; i<=VarArrayIndex-1 ; i++ ){
					if( !strcmp( Variables[i] , $4 ) ){
						printf("This variable has been defined!\n");
						Redefine = 1;
						break;				  
					}		  
				}
			}
			if( Redefine!=1 ){
				strcpy( Variables[VarArrayIndex] , $4 );
				VarValue[VarArrayIndex] = $6;
				VarArrayIndex++;
			}
			Redefine = 0;
		}
		;
VARIABLE	: ID { 
				strcpy( $$ , $1 ); }//複製
			;

IF_EXP	: Left_P If Sep TEST_EXP Sep THEN_EXP Sep ELSE_EXP Right_P  {
			if($4 == 1) 
				$$ = $6; 
			else 
				$$ = $8; }
		;
TEST_EXP	: EXP { 
				$$ = $1; }
			;
THEN_EXP	: EXP { 
				$$ = $1; }
			;
ELSE_EXP	: EXP { 
				$$ = $1; }
			;
%%

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}