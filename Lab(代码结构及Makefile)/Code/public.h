CompSt : error RC {
  struct TreeNode *temp;
  temp = bindSibling(&$2, NULL);
  $$.token = "Compt";
  bindParent(&$$, temp);
}
;
Exp : Exp LB error RB {
    struct TreeNode *temp;
    temp = bindSibling(&$4, NULL);
    temp = bindSibling(&$2, temp);
    temp = bindSibling(&$1, temp);
    $$.token = "Exp";
    bindParent(&$$, temp);
  }
  | error LP {
    struct TreeNode *temp;
    temp = bindSibling(&$2, NULL);
    $$.token = "Exp";
    bindParent(&$$, temp);
  }
  ;
Stmt : error SEMI {
    struct TreeNode *temp;
    temp = bindSibling(&$2, NULL);
    $$.token = "Stmt";
    bindParent(&$$, temp);
  }
