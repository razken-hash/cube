%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define YYDEBUG 1
%}

%token PROGRAM VARIABLES INTEGER_DECLARE REAL_DECLARE BOOLEAN_DECLARE CHAR_DECLARE STRING_DECLARE STRUCT_DECLARE
%token INTEGER REAL BOOLEAN CHAR TEXT
%token IDENTIFIER
%token OPEN_CURLY_BRACE CLOSE_CURLY_BRACE OPEN_SQUARE_BRACE CLOSE_SQUARE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token SEMICOLON COLON COMMA DOT ASSIGNMENT EQUAL DIFFERENT AND OR NOT LESS GREATER LESSEQUAL GREATEREQUAL ADD SUB MULT DIV MOD
%token IF ELSE WHILE LOOP OUTPUT INPUT

%start Program

%{
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern int yylex();

char* file = "input.cube";

int currentColumn = 1;

void yysuccess(char *s);
void yyerror(const char *s);
void showLexicalError();
%}

%%

Program: PROGRAM IDENTIFIER SEMICOLON Variables DeclarationBlock

Variables: VARIABLES COLON Declaration SEMICOLON

Declaration:  IdentifierList COLON INTEGER_DECLARE
        | IdentifierList COLON REAL_DECLARE
        | IdentifierList COLON BOOLEAN_DECLARE
        | IdentifierList COLON CHAR_DECLARE
        | IdentifierList COLON STRING_DECLARE

IdentifierList: IDENTIFIER | IdentifierList COMMA IDENTIFIER

DeclarationBlock: OPEN_CURLY_BRACE StatementList CLOSE_CURLY_BRACE

StatementList:  StatementList Statement | %empty

Statement: IF Expression OPEN_CURLY_BRACE StatementList CLOSE_CURLY_BRACE ELSE OPEN_CURLY_BRACE StatementList CLOSE_CURLY_BRACE
          | IF Expression OPEN_CURLY_BRACE StatementList CLOSE_CURLY_BRACE
         | WHILE Expression OPEN_CURLY_BRACE StatementList CLOSE_CURLY_BRACE
         | OUTPUT Expression SEMICOLON
         | INPUT IDENTIFIER SEMICOLON
         | IDENTIFIER ASSIGNMENT Expression SEMICOLON

Expression: OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS
          | IDENTIFIER
          | INTEGER
          | REAL
          | BOOLEAN
          | CHAR
          | TEXT
          | Expression ADD Expression
          | Expression SUB Expression
          | Expression MULT Expression
          | Expression DIV Expression
          | Expression MOD Expression
          | Expression EQUAL Expression
          | Expression DIFFERENT Expression
          | Expression AND Expression
          | Expression OR Expression
          | NOT Expression
          | LESS Expression
          | GREATER Expression
          | LESSEQUAL Expression
          | GREATEREQUAL Expression
          | LESSEQUAL Expression
%%

void yysuccess(char *s){
    // fprintf(stdout, "%d: %s\n", yylineno, s);
    currentColumn+=yyleng;
}

void yyerror(const char *s) {
  fprintf(stdout, "File '%s', line %d, character %d :  %s \n", file, yylineno, currentColumn, s);
}

int main (void)
{
    // yydebug = 1;
    yyin=fopen(file, "r");
    if(yyin==NULL){
        printf("erreur dans l'ouverture du fichier");
        return 1;
    }
    yyparse();  

// printf("succ\n");

    return 0;
}

void showLexicalError() {

    char line[256], introError[80]; 

    fseek(yyin, 0, SEEK_SET);
    
    int i = 0; 

    while (fgets(line, sizeof(line), yyin)) { 
        i++; 
        if(i == yylineno) break;  
    } 
        
    sprintf(introError, "Lexical error in Line %d : Unrecognized character : ", yylineno);
    printf("%s%s", introError, line);  
    int j=1;
    while(j<currentColumn+strlen(introError)) { printf(" "); j++; }
    printf("^\n");


}