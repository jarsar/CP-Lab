#include<stdio.h>
#include<ctype.h>
#include<stdbool.h>
struct TreeData {
    double dnum;
    char *value;
    char *token;
    struct TreeData *Child;
    struct TreeData *nextnode;
    int lineno;
};
struct TreeData *head;

bool is_token(char *name){
  if(isupper(name[1])==true){
    return true;
  }else{
    return false;
  }
}

int traverse(struct TreeData *head,int depth,int num){
  struct TreeData *child;
  if(head->token!=NULL){
    num++;
    printf("%d  ",num);
    for(int i=0;i<depth;i++){
      printf("  ");
    }
    if(is_token(head->token)==true){
      if(head->token == "INT"){
        printf("%s:%d\n", head->token, atoi(head->value));
      }else if(head->token == "FLOAT"){
        printf("%s:%.6f\n", head->token, head->dnum);
      }else if(head->token == "ID"){
        printf("%s: %s\n", head->token, head->value);
      }else if(head->token == "TYPE"){
        printf("%s: %s\n",head->token, head->value);
      }else{
        printf("%s\n", head->token);
      }
    }else{
      printf("%s(%d)\n", head->token, head->lineno);
    }
    }
    if (head->Child!=NULL){
      num=traverse(head->Child,depth+1,num);
    }
    if(head->nextnode!=NULL){
      num=traverse(head->nextnode,depth,num);
  }
  return num;
}
struct TreeData* buildNode(struct TreeData * left, struct TreeData * right){
  struct TreeData *temp = (struct TreeData *)malloc(sizeof(struct TreeData ));
   *temp = *left;
   temp->nextnode = right;
   return temp;
}

struct TreeData* buildParent(struct TreeData *parent, struct TreeData *child){
  parent->Child = child;
  return parent;
}
