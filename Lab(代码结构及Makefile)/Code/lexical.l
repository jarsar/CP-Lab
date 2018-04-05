%{
/*definitions of manifest constants LT,LE,EQ,NE,GT,GE,IF,THEN,ELSE,ID,NUMBER,RELOP*/
#include"syntax.tab.h"
int errorJudge = 0;
struct TreeNode initial(int lineno, char* value, char* token);
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
int yylineno = 1;
%%
[ \t] {}
[\r] {yylineno++;}
";" {yylval.node = initial((int)yylineno,(char*)yytext,"SEMI");return SEMI;}
","	{yylval.node=initial((int)yylineno,(char*)yytext,"COMMA");return COMMA;}
"="	{yylval.node=initial((int)yylineno,(char*)yytext,"ASSIGNOP");return ASSIGNOP;}
">"	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"<"	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
">="	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"<="	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"=="	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"!="	{yylval.node=initial((int)yylineno,(char*)yytext,"RELOP");return RELOP;}
"+"	{yylval.node=initial((int)yylineno,(char*)yytext,"PLUS");return PLUS;}
"-"	{yylval.node=initial((int)yylineno,(char*)yytext,"MINUS");return MINUS;}
"*"	{yylval.node=initial((int)yylineno,(char*)yytext,"STAR");return STAR;}
"/"	{yylval.node=initial((int)yylineno,(char*)yytext,"DIV");return DIV;}
"&&"	{yylval.node=initial((int)yylineno,(char*)yytext,"AND");return AND;}
"||" {yylval.node=initial((int)yylineno,(char*)yytext,"OR");return OR;}
"."	{yylval.node=initial((int)yylineno,(char*)yytext,"DOT");return DOT;}
"!"	{yylval.node=initial((int)yylineno,(char*)yytext,"NOTI");return NOT;}
"int"	{yylval.node=initial((int)yylineno,(char*)yytext,"TYPE");return TYPE;}
"float"	{yylval.node=initial((int)yylineno,(char*)yytext,"TYPE");return TYPE;}
"("	{yylval.node=initial((int)yylineno,(char*)yytext,"LP");return LP;}
")"	{yylval.node=initial((int)yylineno,(char*)yytext,"RP");return RP;}
"["	{yylval.node=initial((int)yylineno,(char*)yytext,"LB");return LB;}
"]"	{yylval.node=initial((int)yylineno,(char*)yytext,"RB");return RB;}
"{"	{yylval.node=initial((int)yylineno,(char*)yytext,"LC");return LC;}
"}"	{yylval.node=initial((int)yylineno,(char*)yytext,"RC");return RC;}
{INT} {yylval.node=initial((int)yylineno,(char*)yytext,"INT");yylval.node.ival = atoi(yytext);return INT;}
{FLOAT} {yylval.node=initial((int)yylineno,(char*)yytext,"INT");yylval.node.dval = atof(yytext);return FLOAT;}
"struct"	{yylval.node=initial((int)yylineno,(char*)yytext,"STRUCT");return STRUCT;}
"return" {yylval.node=initial((int)yylineno,(char*)yytext,"RETURN");return RETURN;}
"if"	{yylval.node=initial((int)yylineno,(char*)yytext,"IF");return IF;}
"else" {yylval.node=initial((int)yylineno,(char*)yytext,"ELSE");return ELSE;}
while	{yylval.node=initial((int)yylineno,(char*)yytext,"WHILE");return WHILE;}
{ID} {yylval.node=initial((int)yylineno,(char*)yytext,"ID");return ID;}
"//"  {
        char c = input();
        while(c != '\n' && c != EOF) c = input();
        }
"/*"    {
          int succFinish = 0;
          char c = input();
          while(c != EOF) {
            if( c == '/' ){
              char next = input();
                if( next != EOF && next == '*'){
                  printf("Error type 3 at line: %d Mysterious charater: %c\n", yylineno, c);
                  errorJudge = 1;
                  }
                  }
          if( c == '*' ){
            char next = input();
            if( next != EOF && next == '/'){
              succFinish = 1;
              break;
              }
              }
            c = input();
            }
            errorJudge = 1;
            if( succFinish != 1)
              printf("Error type 3 at line %d \n", yylineno);
              }
. {errorJudge = 1;printf("Error type 1 at line: %d Mysterious charater: %s\n", yylineno, yytext);}
%%
struct TreeNode initial(int lineno, char* value, char* token){
  struct TreeNode node;
    if( token != "INT" || token != "FLOAT") {
        node.value = malloc(32);
        memcpy(node.value, value +'\0', 32);
    }
    node.token = token;
    node.nextSibling = NULL;
    node.firstChild = NULL;
    node.lineno = lineno;
    return node;
}
