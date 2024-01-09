%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "structs/symboles_table.c"
#include "structs/quadruplets.c"

%}

%union {
    char string[255];
    int int_val;
    double real_val;
    char char_val;
    int bool_val;
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
%token <bool_val> BOOLEAN 
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
Quadruplet *Quad;
char currentRegister[255];
int currentRegisterIndex = 1;


void yysuccess(char *s);
void yyerror(const char *s);
void showLexicalError();
%}

%%

Program: | PROGRAM IDENTIFIER SEMICOLON VARIABLES COLON declarations OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE
declarations: | declaration declarations
declaration: IDENTIFIER COLON type SEMICOLON {
    if(get_id(Table_sym,$1)!=NULL){
        printf("File '%s', line %d: %s Variable already declared \n", file, yylineno,$1);
        YYERROR;
    }else{
        insertColumn(Table_sym,$<string>3,$1,"",1); 
    }
}
type: INTEGER_DECLARE | REAL_DECLARE | BOOLEAN_DECLARE | CHAR_DECLARE | STRING_DECLARE
Body: | statement Body
statement: assignment
assignment: IDENTIFIER ASSIGNMENT expression SEMICOLON {
    if(get_id(Table_sym,$1)==NULL){
        printf("File '%s', line %d: %s Variable not declared \n", file, yylineno,$1);
        YYERROR;
    }else{
        insert_quadruplet(&Quad, ":=", $<string>3, "", $1);
    }
}
expression: expression ADD expression {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "+", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression SUB expression 
    {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "-", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression MULT expression 
    {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "*", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression DIV expression  {
        if(strcmp($<string>3,"0")==0){
            printf("File '%s', line %d: Division by zero \n", file, yylineno);
            YYERROR;
        }else{
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "/", $<string>1, $<string>3, currentRegister);
            strcpy(currentRegister,$<string>$);
        }
    }
    | expression MOD expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "%", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression EQUAL expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "==", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression DIFFERENT expression 
    {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "!=", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression LESS expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "<", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression GREATER expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, ">", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression LESSEQUAL expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "<=", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression GREATEREQUAL expression  {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, ">=", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression AND expression {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "&&", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | expression OR expression {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "||", $<string>1, $<string>3, currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | NOT expression {
        sprintf(currentRegister, "R%d", currentRegisterIndex++);
        insert_quadruplet(&Quad, "!", $<string>2, "", currentRegister);
        strcpy(currentRegister,$<string>$);
    }
    | OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {
        strcpy($<string>2,$<string>$);
    }
    | INTEGER {
        sprintf($<string>$, "%d", $1);
    }
    | REAL  {
        sprintf($<string>$, "%f", $1);
    }
    | BOOLEAN  {
        sprintf($<string>$, "%d", $1);
    }
    | CHAR {
        sprintf($<string>$, "%c", $1);
    }
    | TEXT {
        sprintf($<string>$, "%s", $1);
    }
    | IDENTIFIER {
        if(get_id(Table_sym,$1)==NULL){
            printf("File '%s', line %d: %s Variable not declared \n", file, yylineno,$1);
            YYERROR;
        }else{
            sprintf($<string>$, "%s", $1);
        }
    }

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
    Table_sym = insertRow(&Table_sym ,1);

    yyparse();  

    save_quadruplets(Quad, "quadruplets.txt");

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