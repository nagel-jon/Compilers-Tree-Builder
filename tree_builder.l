%{
//***************
// File: tree_builder.l
// Purpose: To scan through a tree builder file and tokenize tree builder language
// build instructions
// flex tree_builder.l
// g++ -o tree_builder lex.yy.c
// ./tree_builder < examples/ex1.tb
// **************  
#include <stdio.h>
#include <stdlib.h>
//#include "y.tab.h"

#include <iostream>
#include <fstream>
#include <string>
using namespace std;   




// #define BUILD 1
// #define NAME 2
// #define STRING 3
// #define WEIGHT 4
// #define INT 5
// #define FOR 6
// #define BASIC 7
// #define CHILD 8
// #define IN 10
// #define JUNK 11
// #define PARENT 9
// #define LBRACE 12
// #define RBRACE 13
// #define LBRACKET 14
// #define RBRACKET 15
// #define EQUAL 16
// #define SEMICOLON 17
// #define COLON 18
// #define COMMA 19
// #define PLUS 20
// #define IDENTIFIER 21
// #define UNMATCHED 255



%}

%%

"buildnode"     {return BUILD; }
"name"          {return NAME;}
"weight"       {return WEIGHT;}
"for"           {return FOR;}
"isachildof"    {return PARENT;}
"in"            {return IN;}




"{"             {return LBRACE;}
"}"             {return RBRACE;}
"["             {return LBRACKET;}
"]"             {return RBRACKET;}
"="             {return EQUAL;}
";"             {return SEMICOLON;}
":"             {return COLON;}
"+"             {return PLUS;}
","             {return COMMA;}



\"[^\"\n]*\"    {
    //Store the string in yylval
    //Need to remove the quotes and trailing space
   // yylval.string = strdup(yytext + 1, yyleng - 2);
    return STRING;
 }

[0-9]+      {
    //Store the integer in yylval
   // yylval.integer = atoi(yytext);
    return INT;
    }


[a-zA-Z_][a-zA-Z0-9_]*      {
    //Store the identifier in yylval
   // yylval.string = strdup(yytext);
    return IDENTIFIER;
}

[ \t\n]     { /* ignore whitespace */ }
.          { printf("Unmatched character: %s\n", yytext);}




%%

int yywrap(){
    return true;
}


/* 
int main() {
    int token = 0;
    token = yylex();
	ofstream outputFile("lexer_output.txt", ios::app);
    while(token){
        switch(token) {
            case BUILD:
                outputFile << "BUILD" << endl;
                break;
            case NAME:
                outputFile << "NAME" << endl;
                break;
            case STRING:
                outputFile << "STRING: " << yytext << endl;
                break;
            case WEIGHT:
                outputFile << "WEIGHT" << endl;
                break;
            case INT:
                outputFile << "INT: " << atoi(yytext) << endl;
                break;
            case FOR:
                outputFile << "FOR" << endl;
                break;
            case BASIC:
                outputFile << "BASIC" << endl;
                break;
            case CHILD:
                outputFile << "CHILD" << endl;
                break;
            case IN:
                outputFile << "IN" << endl;
                break;
            case JUNK:
                outputFile << "JUNK" << endl;
                break;
            case PARENT:
                outputFile << "PARENT" << endl;
                break;
            case LBRACE:
                outputFile << "LBRACE" << endl;
                break;
            case RBRACE:
                outputFile << "RBRACE" << endl;
                break;
            case LBRACKET:
                outputFile << "LBRACKET" << endl;
                break;
            case RBRACKET:
                outputFile << "RBRACKET" << endl;
                break;
            case EQUAL:
                outputFile << "EQUAL" << endl;
                break;
            case SEMICOLON:
                outputFile << "SEMICOLON" << endl;
                break;
            case COLON:
                outputFile << "COLON" << endl;
                break;
            case PLUS:
                outputFile << "PLUS" << endl;
                break;
            case IDENTIFIER:
                outputFile << "IDENTIFIER: " << yytext << endl;
                break;
            case UNMATCHED:
                outputFile << "UNMATCHED" << endl;
                break;
            case COMMA:
                outputFile << "COMMA" << endl;
                break;
            default:
                outputFile << "Unknown token" << endl;
                break;
        }

        token = yylex();
    }
    outputFile << "\n"; // Insert newline character
	outputFile.close();
    return 0;
}
 */
