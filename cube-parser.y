%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define YYDEBUG 1

%}


%token  OUTPUT  VARIABLES
%token  IF  ELSE 
%token  COMMA  SEMICOLON  DOT COLON
%token  INTEGER  REAL  TEXT  BOOL  TABLEAU  
%token  LOOP  WHILE
%token  OPEN_PARENTHESIS  CLOSE_PARENTHESIS  CURLY_OPEN_BRACKET  CURLY_CLOSE_BRACKET  OPEN_BRACKET  CLOSE_BRACKET
%token  STRUCT_DECLARE
%token  EQUAL  DIFFERENT  AND  OR  NOT  LESS  GREATER  LESSEQUAL  GREATEREQUAL
%token  ADD  SUB  MULT  DIV  MOD  
%token  ASSIGNMENT SPACE
%token PROGRAM ANYTHING IDENTIFIER
%left  ADD  SUB  MULT  DIV  MOD 
%right   NOT
%left  AND  OR  LESS  GREATER   LESSEQUAL  GREATEREQUAL  EQUAL  DIFFERENT

%start START
%{
extern int yylineno;
extern int yyleng;
extern int currentColumnNumber;
extern int yylex();
extern void yysuccess(char *s, char *lexeme, int length);
extern void yyerror(char *s);

char* file = "input.cube";


%}

%%

START : ELSE;

%%
main(int argc, char **argv)
{  
  extern FILE *yyin;

  yyin = fopen("input.cube", "r");

  if(yyin==NULL){
      printf("File not found\n");
      return 1;
    }

  yyparse();
  
  fclose(yyin);
  
  return 0;
}


