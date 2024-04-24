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

extern int yylex();
etern int yyparse();
extern FILE* yyin;

%}


%start S

%union {

    
}