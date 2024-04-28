

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse_tree.h"
#include "y.tab.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

%}

%token ERROR
%start S

%union{
    char* string;
    int integer;
    class Expression* exp;
    class IntegerExpression* int_ptr;
    class Statement* s_ptr;
    class CompoundStatement* c_ptr;
    class StringList* string_list;
}

//Token Definitions
%token BUILD FOR 
IN 
NAME
WEIGHT
PARENT
PLUS
EQUAL
COMMA
LBRACKET RBRACKET 
LBRACE RBRACE 
SEMICOLON 
COLON 

%left PLUS
%left EQUAL
//Typed-Token Definitions

%token <string> IDENTIFIER STRING
%token <integer> INT

//Type Definitions for Non-Terminals

%type <exp> exp name parent
%type <c_ptr> prog S
%type <s_ptr> Statement ForStatement node BuildStatement
%type <int_ptr> weight int_expr
%type <string_list> StringList
%%

//Grammar Rules

//Start Rule: S -> program
S: 
prog {
    //Program is done constructing and needs to evaluate

    map<string, string> symbol_table;
    ParseTree tree;
    $$=$1;
    $$ -> evaluate_statement(symbol_table, tree);
    //print the resulting tree
    tree.printTree();
}

//Program Rule: prog -> statement prog | statement
prog: 
Statement prog {$$ = new CompoundStatement($1, $2);}
    | {$$ = NULL;}
    ;

//Statement Rule: statement -> ForStatement BuildStatement
Statement: 
    BuildStatement {$$ = $1;}
    |ForStatement {$$ = $1;}
    ;


//For Statement Rule: ForStatement -> FOR IDENTIFIER IN LBRACKET string_list RBRACKET LBRACE prog RBRACE
ForStatement: 
FOR IDENTIFIER IN LBRACKET INT COLON INT RBRACKET LBRACE prog RBRACE {
    $$ = new ForStatement($2, $5, $7, $10);
}
| FOR IDENTIFIER IN LBRACKET StringList RBRACKET LBRACE prog RBRACE {
    $$ = new ForStatement($5->string, 0, 0, $8);
}
//for some reason the stringlist tpye will not work here
;

//String List Rule: string_list -> STRING COMMA string_list | STRING
StringList: IDENTIFIER
{
    $$ = new StringList();
    $$->string = $1;
    $$->next = NULL;
}
| StringList COMMA IDENTIFIER
{
    StringList* temp = new StringList();
    temp->string = $3;
    temp->next = $1;
    $$ = temp;
}
;

//Build Statement Rule: BuildStatement -> BUILD LBRACE node RBRACE SEMICOLON
BuildStatement:
BUILD LBRACE node RBRACE SEMICOLON {
    $$ = ($3);
}
;

//Node Rule: node -> NAME WEIGHT | NAME WEIGHT PARENT
node:
name weight{
    $$ = new BuildStatement($1, $2);
    //printf("Node: %s %d\n", $1, $2);

}
| name weight parent {
    $$ = new BuildStatement($1, $2, $3);
    //printf("Node: %s %d %s\n", $1, $2, $3);
}
;

//expression Rule: exp -> STRING | IDENTIFIER | exp PLUS exp
exp:
STRING {$$ = new StringConstant($1);}
| IDENTIFIER {$$ = new Variable($1);}
| exp PLUS exp {$$ = new ConcatenationOperator($1, $3);}


//Integer Expression Rule: int_expr -> INT | IDENTIFIER | int_expr PLUS int_expr
int_expr:
INT {$$ = new IntegerConstant($1);}
| IDENTIFIER {$$ = new IntegerVariable($1);}
| int_expr PLUS int_expr {$$ = new AdditionOperator($1, $3);};

//Weight Rule: weight -> WEIGHT EQUAL int_expr SEMICOLON
weight:
WEIGHT EQUAL int_expr SEMICOLON {
    $$ =$3;
};

//Parent Rule: parent -> PARENT EQUAL exp SEMICOLON
parent:
PARENT EQUAL exp SEMICOLON {
    $$ = $3;
};

name:
NAME EQUAL exp SEMICOLON {
    $$ = $3;
};



%%

void yyerror(const char* s){
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char** argv){
    if(argc > 1){
        yyin = fopen(argv[1], "r");
    }
    else{
        yyin = stdin;
    }
    yyparse();
    if(yyin != stdin){
        fclose(yyin);
    }
    return 0;
}