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
%token PROGRAM ANYTHING
%left  ADD  SUB  MULT  DIV  MOD 
%right   NOT
%left  AND  OR  LESS  GREATER   LESSEQUAL  GREATEREQUAL  EQUAL  DIFFERENT

%start START
%{
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern int yylex();

char* file = "input.cube";

int currentColumnNumber = 1;

void yysuccess(char *s, char *lexeme, int length);
void yyerror(char *s);
%}

%%

START : ANYTHING
;

%%
main(int argc, char **argv)
{  
  yyin = fopen("input.cube", "r");

  if(yyin==NULL){
      printf("File not found\n");
      return 1;
    }

  yyparse();
  
  fclose(yyin);
  return 0;
}

void yysuccess(char *s, char *lexeme, int length) {
    printf("%s : ", s);
    printf("\033[0;32m");
    printf("'%s'", lexeme); 
    printf("\033[0m"); 
    printf(" at Ln %d Col %d \n", yylineno, currentColumnNumber);
}
void yyerror(char *s) {
    printf("\033[0;31m"); 
    printf("error in Line %d Column %d : %s \n", yylineno, currentColumnNumber,s);
    printf("\033[0m"); 
}
