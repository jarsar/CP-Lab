%{
  #include<stdio.h>
  #include"G_tree.h"
  int errorJudge = 0;
%}

%union {
    double dnum;
    struct TreeData node;
}

/*declared tokens*/
%token <node> INT FLOAT ID
%token <node> SEMI COMMA DOT
%token <node> ASSIGNOP PLUS MINUS STAR DIV
%token <node> RELOP AND OR NOT
%token <node> TYPE
%token <node> LP RP LB RB LC RC
%token <node> STRUCT RETURN IF ELSE WHILE

/*declared non-terminal*/
%type <node> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec  VarList ParamDec
%type <node> CompSt StmtList Stmt DefList Def DecList Dec Exp Args

/*binding*/
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LB RB LP RP DOT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
/*High-level Definitions*/
Program : ExtDefList {
    struct TreeData *temp;
    temp=buildNode(&$1,NULL);
    $$.token="Program";
    temp=buildParent(&$$,temp);
    if(errorJudge==0){
      traverse(temp,0,0);
    }
}
  ;
ExtDefList : ExtDef ExtDefList {
  struct TreeData *temp;
  temp=buildNode(&$2,NULL);
  temp=buildNode(&$1,temp);
  $$.token="ExtDefList";
  buildParent(&$$,temp);
}
  | /*empty*/ {$$.token=NULL;$$.Child=NULL;$$.nextnode=NULL;}
  ;
ExtDef : Specifier ExtDecList SEMI {
  struct TreeData *temp;
  temp=buildNode(&$3,NULL);
  temp=buildNode(&$2,temp);
  temp=buildNode(&$1,temp);
  $$.token="ExtDef";
  buildParent(&$$,temp);
}
  | Specifier SEMI {
    struct TreeData *temp;
    temp=buildNode(&$2,NULL);
    temp=buildNode(&$1,temp);
    $$.token="ExtDef";
    buildParent(&$$,temp);
  }
  | Specifier FunDec CompSt{
    struct TreeData *temp;
    temp=buildNode(&$3,NULL);
    temp=buildNode(&$2,temp);
    temp=buildNode(&$1,temp);
    $$.token="ExtDef";
    buildParent(&$$,temp);
  }
  ;
ExtDecList : VarDec {
  struct TreeData *temp;
  temp=buildNode(&$1,NULL);
  $$.token="ExtDecList";
  buildParent(&$$,temp);
}
  | VarDec COMMA ExtDecList {
    struct TreeData *temp;
    temp=buildNode(&$3,NULL);
    temp=buildNode(&$2,temp);
    temp=buildNode(&$1,temp);
    $$.token="ExtDecList";
    buildParent(&$$,temp);
  }
  ;

/*Specifiers*/
Specifier : TYPE {
  struct TreeData *temp;
  temp=buildNode(&$1,NULL);
  temp=buildParent(temp,NULL);
  $$.token="Specifier";
  buildParent(&$$,temp);
}
  | StructSpecifier {
    struct TreeData *temp;
    temp=buildNode(&$1,NULL);
    $$.token="Specifier";
    buildParent(&$$,temp);
  }
  ;
StructSpecifier : STRUCT OptTag LC DefList RC {
  struct TreeData *temp;
  temp=buildNode(&$5,NULL);
  temp=buildNode(&$4,temp);
  temp=buildNode(&$3,temp);
  temp=buildNode(&$2,temp);
  temp=buildNode(&$1,temp);
  $$.token="StructSpecifier";
  buildParent(&$$,temp);
}
  | STRUCT Tag {
    struct TreeData *temp;
    temp=buildNode(&$2,NULL);
    temp=buildNode(&$1,temp);
    $$.token="StructSpecifier";
    buildParent(&$$,temp);
  }
  ;
OptTag : ID {
  struct TreeData *temp;
  temp=buildNode(&$1,NULL);
  $$.token="OptTag";
  buildParent(&$$,temp);
}
  | /*empty*/ {$$.token=NULL;$$.Child=NULL;$$.nextnode=NULL;}
  ;
Tag : ID {
  struct TreeData *temp;
  temp=buildNode(&$1,NULL);
  $$.token="Tag";
  buildParent(&$$,temp);
}
  ;

/*Declarators*/
VarDec : ID {
  struct TreeData *temp;
  temp=buildNode(&$1,NULL);
  $$.token="VarDec";
  buildParent(&$$,temp);
}
  | VarDec LB INT RB {
    struct TreeData *temp;
    temp=buildNode(&$4,NULL);
    temp=buildNode(&$3,temp);
    temp=buildNode(&$2,temp);
    temp=buildNode(&$1,temp);
    $$.token="VarDec";
    buildParent(&$$,temp);
  }
  ;
FunDec : ID LP VarList RP{
  struct TreeData *temp;
  temp=buildNode(&$4,NULL);
  temp=buildNode(&$3,temp);
  temp=buildNode(&$2,temp);
  temp=buildNode(&$1,temp);
  $$.token="FunDec";
  buildParent(&$$,temp);
}
  | ID LP RP {
    struct TreeData *temp;
    temp=buildNode(&$3,NULL);
    temp=buildNode(&$2,temp);
    temp=buildNode(&$1,temp);
    $$.token="FunDec";
    buildParent(&$$,temp);
  }
  ;
VarList : ParamDec COMMA VarList {
  struct TreeData *temp;
  temp=buildNode(&$3,NULL);
  temp=buildNode(&$2,temp);
  temp=buildNode(&$1,temp);
  $$.token="VarList";
  buildParent(&$$,temp);
}
  | ParamDec{
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "VarList";
    buildParent(&$$, temp);
  }
  ;
ParamDec : Specifier VarDec{
  struct TreeData *temp;
  temp = buildNode(&$2, NULL);
  temp = buildNode(&$1, temp);
  $$.token = "ParamDec";
  buildParent(&$$, temp);
}
  ;

/*Statements*/
CompSt : LC DefList StmtList RC {
  struct TreeData *temp;
  temp = buildNode(&$4, NULL);
  temp = buildNode(&$3, temp);
  temp = buildNode(&$2, temp);
  temp = buildNode(&$1, temp);
  $$.token = "CompSt";
  buildParent(&$$, temp);
}
  ;
StmtList : Stmt StmtList {
  struct TreeData *temp;
  temp = buildNode(&$2, NULL);
  temp = buildNode(&$1, temp);
  $$.token = "StmtList";
  buildParent(&$$, temp);
}
  | /*empty*/ {$$.token=NULL;$$.Child=NULL;$$.nextnode=NULL;}
  ;
Stmt : Exp SEMI {
  struct TreeData *temp;
  temp = buildNode(&$2, NULL);
  temp = buildNode(&$1, temp);
  $$.token = "Stmt";
  buildParent(&$$, temp);
}
  | CompSt {
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "Stmt";
    buildParent(&$$, temp);
  }
  | RETURN Exp SEMI {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Stmt";
    buildParent(&$$, temp);
  }
  | IF LP Exp RP Stmt {
    struct TreeData *temp;
    temp = buildNode(&$4, NULL);
    temp = buildNode(&$3, temp);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Stmt";
    buildParent(&$$, temp);
  }
  | IF LP Exp RP Stmt ELSE Stmt {
    struct TreeData *temp;
    temp = buildNode(&$7, NULL);
    temp = buildNode(&$6, temp);
    temp = buildNode(&$5, temp);
    temp = buildNode(&$4, temp);
    temp = buildNode(&$3, temp);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Stmt";
    buildParent(&$$, temp);
  }
  | WHILE LP Exp RP Stmt {
    struct TreeData *temp;
    temp = buildNode(&$5, NULL);
    temp = buildNode(&$4, temp);
    temp = buildNode(&$3, temp);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Stmt";
    buildParent(&$$, temp);
  }
  ;

/*Local Definitions*/
DefList : Def DefList {
  struct TreeData *temp;
  temp = buildNode(&$2, NULL);
  temp = buildNode(&$1, temp);
  $$.token = "DefList";
  buildParent(&$$, temp);
}
  | /*empty*/ {$$.token=NULL,$$.Child=NULL,$$.nextnode=NULL;}
  ;
Def : Specifier DecList SEMI{
  struct TreeData *temp;
  temp = buildNode(&$3, NULL);
  temp = buildNode(&$2, temp);
  temp = buildNode(&$1, temp);
  $$.token = "Def";
  buildParent(&$$, temp);
}
  ;
DecList : Dec {
  struct TreeData *temp;
  temp = buildNode(&$1, NULL);
  $$.token = "DecList";
  buildParent(&$$, temp);
}
  | Dec COMMA DecList {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "DecList";
    buildParent(&$$, temp);
  }
  ;
Dec : VarDec {
  struct TreeData *temp;
  temp = buildNode(&$1, NULL);
  $$.token = "Dec";
  buildParent(&$$, temp);
}
  | VarDec ASSIGNOP Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Dec";
    buildParent(&$$, temp);
  }
  ;

/*Expressions*/
Exp : Exp ASSIGNOP Exp {
  struct TreeData *temp;
  temp = buildNode(&$3, NULL);
  temp = buildNode(&$2, temp);
  temp = buildNode(&$1, temp);
  $$.token = "Exp";
  buildParent(&$$, temp);
}
  | Exp AND Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp OR Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp RELOP Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp PLUS Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp MINUS Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp STAR Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp DIV Exp {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | LP Exp RP {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | MINUS Exp {
    struct TreeData *temp;
    temp = buildNode(&$2, NULL);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | NOT Exp{
    struct TreeData *temp;
    temp = buildNode(&$2, NULL);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | ID LP Args RP {
    struct TreeData *temp;
    temp = buildNode(&$4, NULL);
    temp = buildNode(&$3, temp);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | ID LP RP {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp LB Exp RB {
    struct TreeData *temp;
    temp = buildNode(&$4, NULL);
    temp = buildNode(&$3, temp);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | Exp DOT ID {
    struct TreeData *temp;
    temp = buildNode(&$3, NULL);
    temp = buildNode(&$2, temp);
    temp = buildNode(&$1, temp);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | ID {
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | INT {
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  | FLOAT {
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "Exp";
    buildParent(&$$, temp);
  }
  ;
Args : Exp COMMA Args {
  struct TreeData *temp;
  temp = buildNode(&$3, NULL);
  temp = buildNode(&$2, temp);
  temp = buildNode(&$1, temp);
  $$.token = "Args";
  buildParent(&$$, temp);
}
  | Exp {
    struct TreeData *temp;
    temp = buildNode(&$1, NULL);
    $$.token = "Args";
    buildParent(&$$, temp);
  }
  ;
  CompSt : error RC {
    struct TreeData *temp;
    temp = buildNode(&$2, NULL);
    $$.token = "CompSt";
    buildParent(&$$, temp);
  }
  ;
  Exp : Exp LB error RB {
      struct TreeData *temp;
      temp = buildNode(&$4, NULL);
      temp = buildNode(&$2, temp);
      temp = buildNode(&$1, temp);
      $$.token = "Exp";
      buildParent(&$$, temp);
    }
    | error LP {
      struct TreeData *temp;
      temp = buildNode(&$2, NULL);
      $$.token = "Exp";
      buildParent(&$$, temp);
    }
    ;
  Stmt : error SEMI {
      struct TreeData *temp;
      temp = buildNode(&$2, NULL);
      $$.token = "Stmt";
      buildParent(&$$, temp);
    }
%%
#include"lex.yy.c"
yyerror(char *msg)
{
  errorJudge = 1;
  printf(stderr, "Error type 2 at line %d:%s\n", yylineno, msg);
}
