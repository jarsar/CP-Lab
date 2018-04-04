%{
/*definitions of manifest constants LT,LE,EQ,NE,GT,GE,IF,THEN,ELSE,ID,NUMBER,RELOP*/
#include"syntax.tab.h"
%}

/*regular definitions*/
%option yylineno
delim	[ \t\n\r]
ws	{delim}+
digit	[0-9]
letter	[_a-zA-Z]
ID	{letter}({letter}|{digit}){0,9}
INT ([1-9]{digit}*)|[0]
FLOAT {digit}+(\.{digit}+)?
int yylineno=1;
%%
{ws} {}
";" {return SEMI;}
","	{return COMMA;}
"="	{return ASSIGNOP;}
">"	{return RELOP;}
"<"	{return RELOP;}
">="	{return RELOP;}
"<="	{return RELOP;}
"=="	{return RELOP;}
"!="	{return RELOP;}
"+"	{return PLUS;}
"-"	{return MINUS;}
"*"	{return STAR;}
"/"	{return DIV;}
"&&"	{return AND;}
"||" {return OR;}
"."	{return DOT;}
"!"	{return NOT;}
"int"	{return TYPE;}
"float"	{return TYPE;}
"("	{return LP;}
")"	{return RP;}
"["	{return LB;}
"]"	{return RB;}
"{"	{return LC;}
"}"	{return RC;}
{INT} {return INT;}
{FLOAT} {return FLOAT;}
"struct"	{return STRUCT;}
"return" {return RETURN;}
"if"	{return IF;}
"else" {return ELSE;}
while	{return WHILE;}
{ID} {return ID;}
. {printf("error type A at Line %d: Mysterious characters \'%s\'\n",yylineno, yytext);}
%%
