%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "structs/symboles_table.c"

#define YYDEBUG 1
%}

%union {
    char string[255];
    int int_val;
    double real_val;
    char char_val;
}

%token PROGRAM
%token VARIABLES 
%token <string> INTEGER_DECLARE 
%token <string> REAL_DECLARE 
%token <string> BOOLEAN_DECLARE 
%token <string> CHAR_DECLARE 
%token <string> STRING_DECLARE 
%token <int_val> INTEGER 
%token <real_val> REAL 
%token BOOLEAN 
%token <char_val> CHAR 
%token <string> TEXT
%token <string> IDENTIFIER
%token OPEN_CURLY_BRACE 
%token CLOSE_CURLY_BRACE   
%token OPEN_PARENTHESIS 
%token CLOSE_PARENTHESIS
%token SEMICOLON 
%token COLON 
%token COMMA  
%token ASSIGNMENT 
%token EQUAL 
%token DIFFERENT 
%token AND 
%token OR 
%token NOT 
%token LESS 
%token GREATER    
%token LESSEQUAL 
%token GREATEREQUAL 
%token ADD 
%token SUB 
%token MULT 
%token DIV 
%token MOD
%token IF 
%token ELSE 
%token WHILE 
%token LOOP 
%token OUTPUT 
%token INPUT

%left OR
%left AND
%nonassoc NOT
%nonassoc EQUAL DIFFERENT LESS GREATER LESSEQUAL GREATEREQUAL
%left ADD SUB
%left MULT DIV MOD
%left OPEN_PARENTHESIS

%start Program

%{
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern int yylex();

char* file = "input.cube";

int currentColumnNumber = 1;
Row *Table_sym;  


void yysuccess(char *s);
void yyerror(const char *s);
void showLexicalError();
%}

%%

Program: PROGRAM IDENTIFIER SEMICOLON VARIABLES COLON Declaration ProgramBody
Declaration:  IdentifierList COLON INTEGER_DECLARE SEMICOLON Declaration
        | IdentifierList COLON REAL_DECLARE SEMICOLON Declaration
        | IdentifierList COLON BOOLEAN_DECLARE SEMICOLON Declaration
        | IdentifierList COLON CHAR_DECLARE SEMICOLON Declaration
        | IdentifierList COLON STRING_DECLARE SEMICOLON Declaration  | %empty

IdentifierList: IDENTIFIER | IdentifierList COMMA IDENTIFIER

ProgramBody: OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE
Body:  Statement Body  | %empty
Statement: IF OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE 
         | IF OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE ELSE OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE
         | WHILE OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE
         | OUTPUT OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS SEMICOLON
         | INPUT OPEN_PARENTHESIS IDENTIFIER CLOSE_PARENTHESIS SEMICOLON 
         | IDENTIFIER ASSIGNMENT Expression SEMICOLON 
         | LOOP OPEN_PARENTHESIS Expression COMMA Expression COMMA Expression CLOSE_PARENTHESIS OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE

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
          | Expression LESS Expression
          | Expression GREATER Expression
          | Expression LESSEQUAL Expression
          | Expression GREATEREQUAL Expression
%%

void yysuccess(char *s){
    currentColumnNumber+=yyleng;
}

void yyerror(const char *s) {
  fprintf(stdout, "File '%s', line %d, character %d :  %s \n", file, yylineno, currentColumnNumber, s);
}

int main (void)
{
    yyin=fopen(file, "r");
    if(yyin==NULL){
        printf("erreur dans l'ouverture du fichier");
        return 1;
    }
    yyparse();  

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
    while(j<currentColumnNumber+strlen(introError)) { printf(" "); j++; }
    printf("^\n");


}