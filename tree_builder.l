%{
//*****************************************************************************************
// File: tree_builder.l
// Purpose: To scan through a tree builder file and tokenize tree builder language
// build instructions
// flex tree_builder.l
// g++ -o tree_builder lex.yy.x
// ./tree_builder < data_file.txt
// **************  
#include <iostream>
#include <fstream>
#include <string>
using namespace std;   

#define TKBUILD 1
#define TKNAME 2
#define TKSTRING 3
#define TKWEIGHT 4
#define TKINT 5
#define TKFOR 6
#define BASIC 7
#define TKCHILD 8
#define TKVAR 9
#define TKUNMATCHED 255

%}

%%

"buildnode"     {return TKBUILD; }
"name"          {return TKNAME;}
"weight"       {return TKWEIGHT;}
"for"           {return TKFOR;}
"isachildof"    {return TKCHILD;}

\"[^\"\n]*\"    { return TKSTRING; }

[0-9]+      {return TKINT;}



"{"             {return BASIC;}
"}"             {return BASIC;}
"["             {return BASIC;}
"]"             {return BASIC;}
"="             {return BASIC;}
";"             {return BASIC;}
":"             {return BASIC;}






%%

int yywrap(){
    return true;
}

int main() {
    int token = 0;
    token = yylex();
	ofstream outputFile("lexer_output.txt", ios::app);
    while(token){
        switch (token) {
            case TKBUILD:
                outputFile << "TKBUILD ";
                break;;
            case TKNAME:
                outputFile << "TKNAME ";
                break;
            case TKWEIGHT:
                outputFile << "TKWEIGHT ";
                break;
            case BASIC:
                outputFile << yytext << " ";
                break;
            case TKFOR:
                outputFile << "TKFOR ";
                break; 
            case TKCHILD:
            outputFile << "TKCHILD ";
            break;
            case TKSTRING:
            outputFile << "TKSTRING ";
            break;
            case TKINT:
            outputFile << "TKINT ";
            break;

        }  
        token = yylex();
    }
    outputFile << "\n"; // Insert newline character
	outputFile.close();
    return 0;
}