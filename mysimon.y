%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
void yyerror(char*);
extern FILE *yyin;
extern FILE *yyout;
extern int yyval;
extern int n;
int errNum=0;
%}

%token INCLUDE
%token FILENAME
%token CHAR
%token ELSE
%token IF
%token INTEGER
%token CLASS
%token NEW
%token RETURN
%token VOID
%token WHILE
%token INT
%token CHARACTER
%token ID

%token ADD
%token SUB
%token DIV
%token MUL
%token MOD
%token LP
%token RP
%token LSB
%token RSB
%token LB
%token RB
%token EQ
%token UN
%token GT
%token LT
%token GEQ
%token LEQ
%token AND
%token OR
%token NOT
%token COMMA

%token NL
%token TAB
%token DQ
%token Z
%token BS
%token SEMICOLON
%token SPACE
%token ISON

%right '='
%left '>''<'
%left '+''-'
%left '*''/''%'

%error-verbose

%%
program:
         gen_statement NL
		 |gen_statement NL program
		 |INCLUDE SPACE DQ FILENAME gen_statement NL program
		 |DQ NL
		 |DQ NL program
		 |NL
		 |NL program
		  ;
gen_statement:
              statement
			  |GTstatement
			  ;
statement:
         assignment SEMICOLON
		 |declaration SEMICOLON
		 |error SEMICOLON {errNum++;}
          ;
GTstatement:
		 if_cmd RB
		 |while_cmd RB
		 |class_dec RB
		 |method_def RB
		 |constructor_def RB
		 |error RB{errNum++;}
		 ;
expression:
				   oros
				   |oros ADD expression
				   |oros SUB expression
				   |ID
				   |ID LSB INT RSB
				   ;
char_expression:
                 CHARACTER
				 |TAB
				 |Z
				 |BS
				 |DQ
				 |NL 
				 ;
				   
assignment:
             num_assignment
			 |char_assignment
			 ;
declaration:
            num_decAndassign 
			|char_decAndassign 
			|array_dec  
			|method_dec 
			|constructor_dec 
             ;
num_assignment:
             ID ISON expression 
			 |ID LSB INT RSB ISON expression 
             ;
			 
char_assignment:
             ID ISON  char_expression
			 |ID LSB INT RSB ISON char_expression 
			 ;
declaration:
			 INTEGER SPACE ID
             |CHAR SPACE ID
			 ;
parameters:
             /*nothing*/
			 |INTEGER SPACE ID parameters
             |CHAR SPACE ID parameters
			 |COMMA SPACE parameters
			 ;
num_decAndassign:
             INTEGER SPACE ID ISON expression
			 ;
char_decAndassign:
                 CHAR SPACE ID ISON char_expression
			     ; 
array_dec:
             ID ISON NEW SPACE INTEGER LSB INT RSB
			 |ID ISON NEW SPACE CHAR LSB INT RSB
			 ;
oros:
     paragontas
	 |paragontas MUL oros
	 |paragontas DIV oros
	 |paragontas MOD oros
	 ;
paragontas:
			 INT
			 |LP expression RP
			 ;
bool_expression:
                 LP bool_expression RP
				 |NOT LP bool_expression RP
				 |expression EQ expression
				 |expression UN expression
				 |expression GT expression
				 |expression LT expression
				 |expression GEQ expression
				 |expression LEQ expression
				 |CHARACTER EQ CHARACTER
				 |CHARACTER UN CHARACTER
				 |CHARACTER GT CHARACTER
				 |CHARACTER LT CHARACTER
				 |CHARACTER GEQ CHARACTER
				 |CHARACTER LEQ CHARACTER
				 ;
bool_greaterEXP:
				 bool_expression
				 |bool_expression  AND  bool_expression 
				 |bool_expression  OR  bool_expression
				 ;
if_cmd:
		 IF LP bool_greaterEXP RP SPACE statement SPACE  ELSE  LB NL method_statements NL 
		 |IF LP bool_greaterEXP RP LB NL method_statements NL 
		 |IF LP bool_greaterEXP RP SPACE LB NL method_statements NL RB NL ELSE LB NL method_statements NL 
		 ;
while_cmd:
             WHILE LP bool_greaterEXP RP LB NL method_statements NL 
			 ;
method_dec:
             VOID SPACE ID LP parameters RP
			 |INTEGER SPACE ID LP parameters RP
			 |CHAR SPACE ID LP parameters RP
			 ;
constructor_dec:
               ID LP parameters RP
                ;			   
class_dec:
             CLASS SPACE ID LB NL method_statements NL
			 ;   
method_statements:
				 statement
				 |method_statements NL statement
				 |GTstatement
				 |method_statements NL GTstatement
				 ;
method_def:
         VOID SPACE ID LP parameters RP LB NL method_statements NL RETURN SEMICOLON NL 
		 |CHAR SPACE ID LP parameters RP LB NL method_statements NL RETURN SPACE char_expression SEMICOLON NL 
		 |INTEGER SPACE ID LP parameters RP LB NL method_statements NL RETURN SPACE expression SEMICOLON NL 
         ;	
constructor_def:
             	ID LP parameters RP LB NL method_statements NL
                 ;				
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}		

int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  int a=yyparse();
  if(a==0)
	printf("Done parsing!\n");
  else 	printf("filaraki exeis la8os sth grammh: %d\n", n);
  printf("Estimated number of errors in file: %d\n", errNum);
  return 0;
  }   				 