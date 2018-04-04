%{
/*definitions of manifest constants LT,LE,EQ,NE,GT,GE,IF,THEN,ELSE,ID,NUMBER,RELOP*/
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
{ws} {printf("ws\n");}
";" {printf("SEMI\n");}
","	{printf("COMMA\n");}
"="	{printf("ASSIGNOP\n");}
">"	{printf("RELOP\n");}
"<"	{printf("RELOP\n");}
">="	{printf("RELOP\n");}
"<="	{printf("RELOP\n");}
"=="	{printf("RELOP\n");}
"!="	{printf("RELOP\n");}
"+"	{printf("PLUS\n");}
"-"	{printf("MINUS\n");}
"*"	{printf("STAR\n");}
"/"	{printf("DIV\n");}
"&&"	{printf("AND\n");}
"||" {printf("OR\n");}
"."	{printf("DOT\n");}
"!"	{printf("NOT\n");}
"int"	{printf("int\n");}
"float"	{printf("float\n");}
"("	{printf("LP\n");}
")"	{printf("RP\n");}
"["	{printf("LB\n");}
"]"	{printf("RB\n");}
"{"	{printf("LC\n");}
"}"	{printf("RC\n");}
{INT} {printf("INT\n");}
{FLOAT} {printf("FLOAT\n");}
"struct"	{printf("STRUCT\n");}
"return" {printf("RETURN\n");}
"if"	{printf("IF\n");}
"then" {printf("THEN\n");}
"else" {printf("ELSE\n");}
while	{printf("WHILE\n");}
{ID} {printf("ID\n");}
. {printf("error type A at Line %d: Mysterious characters \'%s\'\n",yylineno, yytext);}
%%
