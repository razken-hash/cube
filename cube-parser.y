%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "structs/symboles_table.c"
#include "structs/stack.c"

%}

%union {
    char string[255];
    int int_val;
    double real_val;
    char char_val;
    int bool_val;
    struct expression  {
        char type[256];
        char value[256];
    } expression;
}

%type <expression> expression;

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
Stack *stack;
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
        insertColumn(Table_sym,$<string>3,$1); 
    }
}
type: INTEGER_DECLARE | REAL_DECLARE | BOOLEAN_DECLARE | CHAR_DECLARE | STRING_DECLARE
Body: | statement Body
statement: assignment | input | output | condition | While
assignment: IDENTIFIER ASSIGNMENT expression SEMICOLON {
    Column *col = get_id(Table_sym,$1);
    if(col==NULL){
        printf("File '%s', line %d: %s Variable not declared \n", file, yylineno,$1);
        YYERROR;
    }else{
        if(strcmp(col->typeToken,$3.type)==0){
            insert_quadruplet(&Quad, ":=", $3.value, "", $1);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
}
expression: expression ADD expression {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "+", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Integer");
            sprintf($$.value, "%s", currentRegister); 
        }else if(
            (strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0)
        ){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "+", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Real");
            sprintf($$.value, "%s", currentRegister);
        }
        else if (strcmp($1.type,"Text")==0 && strcmp($3.type,"Text")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "+", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Text");
            sprintf($$.value, "%s", currentRegister);
        }
        else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression SUB expression 
    {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "-", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Integer");
            sprintf($$.value, "%s", currentRegister); 
        }else if(
            (strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0)
        ){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "-", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Real");
            sprintf($$.value, "%s", currentRegister);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | expression MULT expression 
    {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "*", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Integer");
            sprintf($$.value, "%s", currentRegister); 
        }else if(
            (strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0) 
            || (strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0)
        ){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "*", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Real");
            sprintf($$.value, "%s", currentRegister);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression DIV expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0){
            if(strcmp($3.value,"0")==0){
                printf("File '%s', line %d: Division by 0 \n", file, yylineno);
                YYERROR;
            }else{
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "/", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Real");
            sprintf($$.value, "%s", currentRegister);
            }
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression MOD expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "%", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Integer");
            sprintf($$.value, "%s", currentRegister);  
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }     
    }
    | expression EQUAL expression  {
        if(strcmp($1.type,$3.type)==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "==", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Bool");
            sprintf($$.value, "%s", currentRegister);  
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression DIFFERENT expression 
    {
        if(strcmp($1.type,$3.type)==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "!=", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Bool");
            sprintf($$.value, "%s", currentRegister);  
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }    
    }
    | expression LESS expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0){
            if(strcmp($3.value,"0")==0){
                printf("File '%s', line %d: Division by 0 \n", file, yylineno);
                YYERROR;
            }else{
                sprintf(currentRegister, "R%d", currentRegisterIndex++);
                insert_quadruplet(&Quad, "<", $1.value, $3.value, currentRegister);
                strcpy($$.type,"Bool");
                sprintf($$.value, "%s", currentRegister);
            }
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression GREATER expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0){
            if(strcmp($3.value,"0")==0){
                printf("File '%s', line %d: Division by 0 \n", file, yylineno);
                YYERROR;
            }else{
                sprintf(currentRegister, "R%d", currentRegisterIndex++);
                insert_quadruplet(&Quad, ">", $1.value, $3.value, currentRegister);
                strcpy($$.type,"Bool");
                sprintf($$.value, "%s", currentRegister);
            }
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | expression LESSEQUAL expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0){
            if(strcmp($3.value,"0")==0){
                printf("File '%s', line %d: Division by 0 \n", file, yylineno);
                YYERROR;
            }else{
                sprintf(currentRegister, "R%d", currentRegisterIndex++);
                insert_quadruplet(&Quad, "<=", $1.value, $3.value, currentRegister);
                strcpy($$.type,"Bool");
                sprintf($$.value, "%s", currentRegister);
            }
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | expression GREATEREQUAL expression  {
        if(strcmp($1.type,"Integer")==0 && strcmp($3.type,"Integer")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Integer")==0 && strcmp($3.type,"Real")==0 
        || strcmp($1.type,"Real")==0 && strcmp($3.type,"Integer")==0){
            if(strcmp($3.value,"0")==0){
                printf("File '%s', line %d: Division by 0 \n", file, yylineno);
                YYERROR;
            }else{
                sprintf(currentRegister, "R%d", currentRegisterIndex++);
                insert_quadruplet(&Quad, ">=", $1.value, $3.value, currentRegister);
                strcpy($$.type,"Bool");
                sprintf($$.value, "%s", currentRegister);
            }
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | expression AND expression {
        if(strcmp($1.type,"Bool")==0 && strcmp($3.type,"Bool")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "&&", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Bool");
            sprintf($$.value, "%s", currentRegister);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        }
    }
    | expression OR expression {
        if(strcmp($1.type,"Bool")==0 && strcmp($3.type,"Bool")==0){
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "||", $1.value, $3.value, currentRegister);
            strcpy($$.type,"Bool");
            sprintf($$.value, "%s", currentRegister);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | NOT expression {
        if(strcmp($2.type,"Bool")==0){
            
            sprintf(currentRegister, "R%d", currentRegisterIndex++);
            insert_quadruplet(&Quad, "!", $2.value, "", currentRegister);
            strcpy($$.type,"Bool");
            sprintf($$.value, "%s", currentRegister);
        }else{
            printf("File '%s', line %d: Type mismatch \n", file, yylineno);
            YYERROR;
        } 
    }
    | OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {
        strcpy($$.type,$2.type);
        strcpy($$.value,$2.value);
    }
    | INTEGER {
        strcpy($$.type,"Integer");
        sprintf($$.value, "%d", $1);
    }
    | REAL  {
        strcpy($$.type,"Real");
        sprintf($$.value, "%f", $1);
    }
    | BOOLEAN  {        
        strcpy($$.type,"Bool");
        sprintf($$.value, "%d", $1);
    }
    | CHAR {
        strcpy($$.type,"Char");
        sprintf($$.value, "%c", $1);
    }
    | TEXT {
        strcpy($$.type,"Text");
        sprintf($$.value, "%s", $1);
    }
    | IDENTIFIER {
        Column *col = get_id(Table_sym,$1);
        if(col == NULL){
            printf("File '%s', line %d: %s Variable not declared \n", file, yylineno,$1);
            YYERROR;
        }else{
            sprintf($$.value, "%s", $1);
            sprintf($$.type, "%s", col->typeToken);
        }
    }

input: INPUT OPEN_PARENTHESIS IDENTIFIER CLOSE_PARENTHESIS SEMICOLON {
    Column *col = get_id(Table_sym,$3);
    if(col==NULL){
        printf("File '%s', line %d: %s Variable not declared \n", file, yylineno,$3);
        YYERROR;
    }else{
        insert_quadruplet(&Quad, "input", "", "", $3);
    }    
}
output: OUTPUT OPEN_PARENTHESIS expression CLOSE_PARENTHESIS SEMICOLON {
    insert_quadruplet(&Quad, "output", $3.value, "", "");
}

condition:  BeginCondition OPEN_CURLY_BRACE Body CLOSE_CURLY_BRACE ElseCondition
BeginCondition: IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {
    if(strcmp($3.type,"Bool")==0){
        Quadruplet *newQuad = insert_quadruplet(&Quad, "BZ", "", $3.value, "");
        push(&stack, newQuad);
    }else{
        printf("File '%s', line %d: Type mismatch \n", file, yylineno);
        YYERROR;
    }
}
ElseCondition: {
    Quadruplet *poppedQuad = pop(&stack);
    Quadruplet *lastQuad = getLastQuad(Quad);
    char *num = (char*)malloc(sizeof(char)*10);
    sprintf(num, "%d", lastQuad->num + 1);
    update_quadruplet_arg1(poppedQuad, num);
} | BeginElse Body  CLOSE_CURLY_BRACE {
    Quadruplet *poppedQuad = pop(&stack);
    Quadruplet *lastQuad = getLastQuad(Quad);
    char *num = (char*)malloc(sizeof(char)*10);
    sprintf(num, "%d", lastQuad->num + 1);
    update_quadruplet_arg1(poppedQuad, num);
}

BeginElse: ELSE OPEN_CURLY_BRACE {
    Quadruplet *poppedQuad = pop(&stack);
    Quadruplet *newQuad = insert_quadruplet(&Quad, "BR", "", "", "");
    char *num = (char*)malloc(sizeof(char)*10);
    sprintf(num, "%d", newQuad->num + 1);
    update_quadruplet_arg1(poppedQuad, num);
    push(&stack, newQuad);
}

While: BeginWhile Body  CLOSE_CURLY_BRACE {
    Quadruplet *beginWhileQuad = pop(&stack);
    Quadruplet *conditionQuad = pop(&stack);

    char*num = (char*)malloc(sizeof(char)*10);
    sprintf(num, "%d", conditionQuad->num + 1);
    Quadruplet *newQuad = insert_quadruplet(&Quad, "BR", num, "","" );

    char*num2 = (char*)malloc(sizeof(char)*10);
    sprintf(num2, "%d", newQuad->num + 1);
    update_quadruplet_arg1(beginWhileQuad, num2);
}
BeginWhile: WhileCondition expression CLOSE_PARENTHESIS OPEN_CURLY_BRACE {
    if(strcmp($2.type,"Bool")==0){
        Quadruplet *newQuad = insert_quadruplet(&Quad, "BZ","" , $2.value,"" );
        push(&stack, newQuad);
    }else{
        printf("File '%s', line %d: Type mismatch \n", file, yylineno);
        YYERROR;
    }
}
WhileCondition: WHILE OPEN_PARENTHESIS {
    push(&stack, getLastQuad(Quad));
}
%%

void yysuccess(char *s){
    currentColumnNumber+=yyleng;
}

void yyerror(const char *s) {
  fprintf(stdout, "File '%s', line %d, character %d :  %s \n", file, yylineno, currentColumnNumber, s);
}

int main (int argc,char **argv)
{
    
    yyin=fopen(argv[1], "r");
    if(yyin==NULL){
        printf("File '%s' not found\n", argv[1]);
        return 1;
    }

    Table_sym = insertRow(&Table_sym );

    insert_quadruplet(&Quad, "START", "", "", "");

    yyparse();  

    save_quadruplets(Quad, "quadruplets.txt");

    saveSymboleTable(Table_sym, "symboles_table.txt");
    
    printf("File '%s' compiled successfully\n" , file);
    printf( "Quadruplets saved in 'quadruplets.txt'\n" );
    printf( "Symbols table saved in 'symbols_table.txt'\n" );

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