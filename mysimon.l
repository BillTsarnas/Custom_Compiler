%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void comment ();
int n = 0;
%}

digit [0-9]
int {digit}+
letter [a-zA-Z]
id [a-z_][a-zA-Z0-9_]*
filename [a-zA-Z0-9_]+.txt
ws [ \t\n]
othercharacter [. ?  ; = * + _  - / ^ &  > % : )# | ~(  ! , } <]
character ({othercharacter}|{letter}|{digit})


%%
#include {printf("A keyword: %s\n", yytext); return INCLUDE;}
char { printf("A keyword: %s\n", yytext); return CHAR;}
else { printf("A keyword: %s\n", yytext); return ELSE;}
if { printf("A keyword: %s\n", yytext); return IF;}
integer { printf("A keyword: %s\n", yytext); return INTEGER;}
class { printf("A keyword: %s\n", yytext); return CLASS;}
new { printf("A keyword: %s\n", yytext); return NEW;}
return {printf("A keyword: %s\n", yytext); return RETURN;}
void {printf("A keyword: %s\n", yytext); return VOID;}
while {printf("A keyword: %s\n", yytext); return WHILE;}
{id} {printf("An id!!\n"); return ID;}
{int} {printf("An integer: %s (%d)\n", yytext, atoi(yytext )); return INT;}
"'"{character}"'" {printf("character detected: %s \n", yytext); return CHARACTER;}
{filename} {
                 printf("filename detected: %s \n", yytext);
				 yyin = fopen( yytext, "r" );
				 YY_BUFFER_STATE buf;
				 buf = YY_CURRENT_BUFFER;
				 buf = 0;
				 yypush_buffer_state(yy_create_buffer( yyin, YY_BUF_SIZE ));
				 BEGIN(INITIAL);
				 return FILENAME;
				 }
"+" {return ADD;}
"-" {return SUB;}
"/" {return DIV;}
"*" {return MUL;}
"%" {return MOD;}
"(" {return LP;}
")" {return RP;}
"[" {return LSB;}
"]" {return RSB;}
"{" {return LB;}
"}" {return RB;}
"==" {return EQ;}
"!=" {return UN;}
">" {return GT;}
"<" {return LT;}
">=" {return GEQ;}
"<=" {return LEQ;}
"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}
"," {return COMMA;}
"\n" {n++; return NL;}
"\t" {return TAB;}
"\0" {return Z;}
"\\" {return BS;}
"/*" {printf("sxolio anoigei!\n"); comment();}
"*/" {printf("sxolio kleinei!\n"); comment();}
"\"" {printf("double quote! \n"); return DQ;}
";" {printf("semi detected...\n");return SEMICOLON;}
" " {printf("space detected...\n"); return SPACE;}
"=" {printf("ison detected...\n");return ISON;}
<<EOF>> {
     			yypop_buffer_state();
     
                 if ( !YY_CURRENT_BUFFER )
                     {
                     yyterminate();
                     }
                 }
%%
void comment( )
{
	char c, prev = 0;
  
	while ((c = input()) != 0)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	error("unterminated comment");
}