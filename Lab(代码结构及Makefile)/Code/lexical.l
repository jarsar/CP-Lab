%{
/*definitions of manifest constants LT,LE,EQ,NE,GT,GE,IF,THEN,ELSE,ID,NUMBER,RELOP*/
#include"syntax.tab.h"
struct TreeData init(int lineno, char* value, char* token);
%}

/*regular definitions*/
%option yylineno
delim	[ \t\n]
ws	{delim}+
digit	[0-9]
letter	[_a-zA-Z]
ID	{letter}({letter}|{digit}){0,9}
INT ([1-9]{digit}*)|[0]
FLOAT {digit}+(\.{digit}+)?
COMMENT "/*"([^\*]|(\*)*[^\*/])*"*/"
%%
[ \t\n\r] {}
";" {yylval.node = init((int)yylineno,(char*)yytext,"SEMI");return SEMI;}
","	{yylval.node=init((int)yylineno,(char*)yytext,"COMMA");return COMMA;}
"="	{yylval.node=init((int)yylineno,(char*)yytext,"ASSIGNOP");return ASSIGNOP;}
">"	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"<"	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
">="	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"<="	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"=="	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"!="	{yylval.node=init((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"+"	{yylval.node=init((int)yylineno,(char*)yytext,"PLUS");return PLUS;}
"-"	{yylval.node=init((int)yylineno,(char*)yytext,"MINUS");return MINUS;}
"*"	{yylval.node=init((int)yylineno,(char*)yytext,"STAR");return STAR;}
"/"	{yylval.node=init((int)yylineno,(char*)yytext,"DIV");return DIV;}
"&&"	{yylval.node=init((int)yylineno,(char*)yytext,"AND");return AND;}
"||" {yylval.node=init((int)yylineno,(char*)yytext,"OR");return OR;}
"."	{yylval.node=init((int)yylineno,(char*)yytext,"DOT");return DOT;}
"!"	{yylval.node=init((int)yylineno,(char*)yytext,"NOTI");return NOT;}
"int"	{yylval.node=init((int)yylineno,(char*)yytext,"TYPE");return TYPE;}
"float"	{yylval.node=init((int)yylineno,(char*)yytext,"TYPE");return TYPE;}
"("	{yylval.node=init((int)yylineno,(char*)yytext,"LP");return LP;}
")"	{yylval.node=init((int)yylineno,(char*)yytext,"RP");return RP;}
"["	{yylval.node=init((int)yylineno,(char*)yytext,"LB");return LB;}
"]"	{yylval.node=init((int)yylineno,(char*)yytext,"RB");return RB;}
"{"	{yylval.node=init((int)yylineno,(char*)yytext,"LC");return LC;}
"}"	{yylval.node=init((int)yylineno,(char*)yytext,"RC");return RC;}
{INT} {yylval.node=init((int)yylineno,(char*)yytext,"INT");return INT;}
{FLOAT} {yylval.node=init((int)yylineno,(char*)yytext,"FLOAT");yylval.node.dnum = atof(yytext);return FLOAT;}
"struct"	{yylval.node=init((int)yylineno,(char*)yytext,"STRUCT");return STRUCT;}
"return" {yylval.node=init((int)yylineno,(char*)yytext,"RETURN");return RETURN;}
"if"	{yylval.node=init((int)yylineno,(char*)yytext,"IF");return IF;}
"else" {yylval.node=init((int)yylineno,(char*)yytext,"ELSE");return ELSE;}
while	{yylval.node=init((int)yylineno,(char*)yytext,"WHILE");return WHILE;}
{ID} {yylval.node=init((int)yylineno,(char*)yytext,"ID");return ID;}
"//"  {
  char c = input();
  while(c != '\n' && c != EOF)
    c = input();}
{COMMENT} {}
. {errorJudge = 1;printf("Error type 1 at line: %d Mysterious charater: %s\n", yylineno, yytext);}
%%
struct TreeData init(int lineno, char* value, char* token){
  struct TreeData node;
    if( token != "INT" || token != "FLOAT") {
        node.value = malloc(32);
        memcpy(node.value, value +'\0', 32);
    }
    node.token = token;
    node.nextnode = NULL;
    node.Child = NULL;
    node.lineno = lineno;
    return node;
}
