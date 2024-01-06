%define parse.error verbose

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define YYDEBUG 1


%}

// les terminaux only
%token IMPORT
%token FUN
%token CONST
%token INTTYPE
%token STRINGTYPE
%token FLOATTYPE
%token BOOLTYPE
%token LIST
%token TYPE
%token IF
%token ELSE
%token WHILE
%token FOR
%token IN
%token RETURN

%token ID

%token INT
%token STRING
%token BOOL
%token FLOAT

%token SEMICOLUMN
%token COLUMN
%token DOT
%token COMA

%token PARENTHESEOUVRANTE
%token PARENTHESEFERMANTE
%token ACCOLADEOUVRANTE
%token ACCOLADEFERMANTE

%token CROCHETOUVRANT
%token CROCHETFERMANT

%token EQUALS
%token ADD
%token SUB
%token MUL
%token MOD
%token DIV
%token POW
%token INC
%token DEC
%token NOTEQUALS
%token ADDEQUALS
%token SUBEQUALS
%token MULEQUALS
%token DIVEQUALS
%token MODEQUALS
%token NEG
%token LESS
%token LESSEQUALS
%token GREATER
%token GREATEREQUALS
%token DOUBLEEQUALS
%token AND
%token OR
%token CONTINUE
%token BREAK

%left COMA
%left OR
%left AND
%left NEG

%nonassoc EQUALS LESS GREATER LESSEQUALS GREATEREQUALS
%nonassoc NOTEQUALS ADDEQUALS SUBEQUALS MULEQUALS DIVEQUALS MODEQUALS
%left ADD SUB
%left MULT DIV MOD

%left DOT CROCHETOUVRANT CROCHETFERMANT
%left POW
%left PARENTHESEOUVRANTE

%start ProgrammePrincipal
%{
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern int yylex();

char* file = "prg.txt";

int currentColumn = 1;

void yysuccess(char *s);
void yyerror(const char *s);
void showLexicalError();
%}
%%

ProgrammePrincipal: %empty
    | Importation
    ;

Importation: %empty
    | IMPORT STRING SEMICOLUMN Importation Fonction
    ;

Fonction: %empty
    | FUN ID PARENTHESEOUVRANTE Parametres PARENTHESEFERMANTE FonctionReturnType ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE Fonction
    ;

Parametres: %empty
    | ReturnType ID Parametre
    ;

Parametre: %empty
    | COMA ReturnType ID Parametre
    ;

FonctionReturnType: %empty
    | COLUMN ReturnType 
    ;

Bloc: %empty
    | Statement Bloc
    ;

DeclarationStructure:
    TYPE ID COLUMN ACCOLADEOUVRANTE Declaration DeclarationLoopDeclarationStructure ACCOLADEFERMANTE
    ;

DeclarationLoopDeclarationStructure: %empty
    | SEMICOLUMN Declaration
    ;

SimpleType:
    INTTYPE
    | FLOATTYPE
    | STRINGTYPE
    | BOOLTYPE

Expression:
    PARENTHESEOUVRANTE Expression PARENTHESEFERMANTE
    | NEG Expression
    | SUB Expression
    | ADD Expression
    | Expression OperateurBinaire Expression
    | Valeur
    | Variable

OperateurBinaire:
    EQUALS
    | ADD
    | SUB
    | MUL
    | MOD
    | DIV
    | POW
    | ADDEQUALS
    | SUBEQUALS
    | MULEQUALS
    | DIVEQUALS
    | MODEQUALS
    | LESS
    | LESSEQUALS
    | GREATER
    | GREATEREQUALS
    | DOUBLEEQUALS
    | AND
    | OR
    
DeclarationInitialisation:
    DeclarationSimple PureAffectation
    | CONST DeclarationSimple PureAffectation
    ;

DeclarationSimple:
    SimpleType ID
    | List ID
    ;

Declaration:
    DeclarationSimple
    | DeclarationVarableStructure
    ;

DeclarationVarableStructure:
    ID ID
    ;
Tableau:
    ACCOLADEOUVRANTE Tableau ComaLoopTableau ACCOLADEFERMANTE
    | ACCOLADEOUVRANTE Expression ComaLoopExpression ACCOLADEFERMANTE
    ;
ComaLoopTableau: %empty
    | COMA Tableau
    ;
ComaLoopExpression: %empty
    | COMA Expression
    ;

PureAffectation:
    EQUALS Expression
    | EQUALS Tableau
    | DOT Affectation
    ;

Affectation:
    Variable PureAffectation
    | Variable RapidAffectation
    ;
RapidAffectation:
    OperateurUnaire
    | ADDEQUALS Expression
    | SUBEQUALS Expression
    | MULEQUALS Expression
    | DIVEQUALS Expression
    | MODEQUALS Expression
    ;
    
Statement:
    DeclarationInitialisation SEMICOLUMN
    | DeclarationStructure SEMICOLUMN
    | Declaration SEMICOLUMN
    | AppelFonction SEMICOLUMN
    | Affectation SEMICOLUMN
    | Boucle
    | Condition
    | BREAK SEMICOLUMN
    | CONTINUE SEMICOLUMN
    | RETURN SEMICOLUMN
    | RETURN Expression SEMICOLUMN
    ;

List:
    LIST SimpleType CROCHETOUVRANT Expression CROCHETFERMANT DimensionLoop
    | LIST ID CROCHETOUVRANT Expression CROCHETFERMANT DimensionLoop
    ;
DimensionLoop: %empty
    | CROCHETOUVRANT Expression CROCHETOUVRANT DimensionLoop
    ;
ReturnType:
    SimpleType
    | LIST SimpleType CROCHETOUVRANT CROCHETFERMANT CrochetLoop
    | LIST ID CROCHETOUVRANT CROCHETFERMANT CrochetLoop
    | ID
    ;
CrochetLoop: %empty
    | CROCHETOUVRANT CROCHETFERMANT CrochetLoop
    ;

OperateurUnaire:
    INC
    | DEC
    ;
ComplexType:
    List
    | ID
    ;
Type:
    SimpleType
    | ComplexType
    ;
Condition:
    IF PARENTHESEOUVRANTE Expression PARENTHESEFERMANTE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE ConditionELSE
    ;
ConditionELSE: %empty
    | ELSE Condition 
    | ELSE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE
    ;
While:
    WHILE PARENTHESEOUVRANTE Expression PARENTHESEFERMANTE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE
    ;

Valeur:
    INT
    | FLOAT
    | STRING
    | BOOL
    ;

For: 
    FOR PARENTHESEOUVRANTE DeclarationInitialisation SEMICOLUMN Expression SEMICOLUMN Affectation PARENTHESEFERMANTE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE
    | FOR PARENTHESEOUVRANTE Declaration IN Tableau PARENTHESEFERMANTE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE
    | FOR PARENTHESEOUVRANTE Declaration IN Variable PARENTHESEFERMANTE ACCOLADEOUVRANTE Bloc ACCOLADEFERMANTE
    ;

Boucle:
    While
    | For
    ;

AppelFonction:
    ID PARENTHESEOUVRANTE Arguments PARENTHESEFERMANTE
    | ID PARENTHESEOUVRANTE PARENTHESEFERMANTE
    ;

Variable:
    ID
    | ID DOT Variable
    | ID CROCHETOUVRANT Expression CROCHETFERMANT
    | AppelFonction
    ;

Arguments:
    Expression
    | Expression COMA Arguments
    ;

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