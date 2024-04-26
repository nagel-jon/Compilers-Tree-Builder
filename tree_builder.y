/*
tree_builder.y
Jonathan Nagel

Parser for Tree Builder
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse_tree.h"
ParseTree parse_tree;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

%}


%start S

%union{
    char* string;
    int integer;
    class expression* exp;
    class integer_exp *int_ptr;
    class statement *statement_ptr;
    class comp_statement *c_ptr;
    struct string_list *string_list;

}

//Token Definitions
%token 
BUILD
FOR 
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

//Typed-Token Definitions

%token <string> IDENTIFIER STRING
%token <integer> INT

//Type Definitions for Non-Terminals

%type <exp> exp name parent
%type <c_ptr> prog S
%type <statement_ptr> statement for_statement node build_statement
%type <int_ptr> weight int_expr
%type <string_list> string_list
%%

//Grammar Rules

//Start Rule: S -> program
S: 
prog {
    //Program is done constructing and needs to evaluate

    map<string, string> symbol_table;
    ParseTree tree;
    $$=$1;
    $$ -> evaluate(my_symbol_table, tree);
    //print the resulting tree
    tree.print();
}

//Program Rule: prog -> statement prog | statement
prog: 
statement prog {$$ = new comp_statement($1, $2);}
    | {$$ = NULL;}
    ;

//Statement Rule: statement -> for_statement build_statement
statement: 
for_statement {$$ = $1;}
    | build_statement {$$ = $1;}
    |for_statement build_statement {$$ = $1;}
    ;


//For Statement Rule: for_statement -> FOR IDENTIFIER IN LBRACKET string_list RBRACKET LBRACE prog RBRACE
for_statement: 
FOR IDENTIFIER IN LBRACKET string_list RBRACKET LBRACE prog RBRACE {
    $$ = new for_statement($2, $5, $8);
}
| FOR IDENTIFIER IN LBRACKET INT RBRACKET LBRACE prog RBRACE {
    $$ = new for_statement($2, $5, $7, $10);
}

;

//String List Rule: string_list -> STRING COMMA string_list | STRING
string_list: IDENTIFIER
{
    $$ = new string_list();
    $$->string = $1;
    $$->next = NULL;
}
| string_list COMMA IDENTIFIER
{
    string_list* temp = new string_list();
    temp->string = $3;
    temp->next = $1;
    $$ = new_node;
}
;

//Build Statement Rule: build_statement -> BUILD LBRACE node RBRACE SEMICOLON
build_statement:
BUILD LBRACE node RBRACE SEMICOLON {
    $$ = ($3);
}
;

//Node Rule: node -> NAME WEIGHT | NAME WEIGHT PARENT
node:
NAME WEIGHT {
    $$ = new build_statement($1, $2);
    //printf("Node: %s %d\n", $1, $2);

}
| NAME WEIGHT PARENT {
    $$ = new build_statement($1, $2, $3);
    //printf("Node: %s %d %s\n", $1, $2, $3);
}
;

//expression Rule: exp -> STRING | IDENTIFIER | exp PLUS exp
exp:
STRING {$$ = new string_constant($1);}
| IDENTIFIER {$$ = new variable($1);}
| exp PLUS exp {$$ = new concat($1, $3);}


//Integer Expression Rule: int_expr -> INT | IDENTIFIER | int_expr PLUS int_expr
int_expr:
INT {$$ = new int_constant($1);}
| IDENTIFIER {$$ = new int_variable($1);}
| int_expr PLUS int_expr {$$ = new int_add($1, $3);};

//Weight Rule: weight -> WEIGHT EQUAL int_expr SEMICOLON
weight:
WEIGHT EQUAL int_expr SEMICOLON {
    $$ = new weight($3);
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
    return 0;
}