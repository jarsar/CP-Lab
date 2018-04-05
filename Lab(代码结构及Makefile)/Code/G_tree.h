#include<stdio.h>
#include<ctype.h>
#include<stdbool.h>
struct TreeNode {
    int ival;
    double dval;
    char *value;
    char *token;
    struct TreeNode *firstChild;
    struct TreeNode *nextSibling;
    int lineno;
};
struct TreeNode *head;

bool is_token(char *name){
  if(isupper(name[1])==true){
    return true;
  }else{
    return false;
  }
}

void traverse(struct TreeNode *head,int depth){
  struct TreeNode *child;
  if(head->token!=NULL){
    for(int i=0;i<depth;i++){
      printf("  ");
    }
    if(is_token(head->token)==true){
      printf("%s\n",head->token);
    }else{
      printf("%s(%d)\n", head->token, head->lineno);
    }
    if (head->firstChild!=NULL){
      traverse(head->firstChild,depth+1);
    }
    if(head->nextSibling!=NULL){
      traverse(head->nextSibling,depth);
    }
  }
}
struct TreeNode* bindSibling(struct TreeNode * left, struct TreeNode * right){
  struct TreeNode *temp = (struct TreeNode *)malloc(sizeof(struct TreeNode ));
   *temp = *left;
   temp->nextSibling = right;
   //printf("bind sibling");
   return temp;
}

struct TreeNode* bindParent(struct TreeNode *parent, struct TreeNode *child){
  parent->firstChild = child;
    return parent;
   // printf("bind parent ");
}
