
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int currentColumnNumber = 1;

    void yysuccess(char *, char *, int); 
    void yyerror(char *);
%}

%option yylineno 
%option noyywrap 


ANYTHING .*
SPACE  "\ "
TAB \t
DIGIT [0-9]
NUMBER {DIGIT}+

DOT \.
LINEBREAK "\n"|"\r"
COLON :
SEMICOLON ;
COMMA \,

PROGRAM program{SPACE}+{ANYTHING}{SEMICOLON}
VARIABLES Variables{COLON}

OPEN_PARENTHESIS \(
CLOSE_PARENTHESIS \)
OPEN_CURLY_BRACE \{
CLOSE_CURLY_BRACE \}
OPEN_SQUARE_BRACE \[
CLOSE_SQUARE_BRACE \]

COMMENT #{ANYTHING}

INTEGER_DECLARE Integer
REAL_DECLARE Real
BOOLEAN_DECLARE Bool
CHAR_DECLARE Char
STRING_DECLARE Text
STRUCT_DECLARE Record

INTEGER {NUMBER}
REAL {NUMBER}{DOT}{NUMBER}
BOOLEAN True|False
CHAR \'.\'
STRING \"({ANYTHING})\"

ASSIGNMENT =


EQUAL ==
DIFFERENT <>
AND and
OR or
NOT not
LESS \<
GREATER \>
LESSEQUAL \<\=
GREATEREQUAL \>\=
ADD \+
SUB -
MULT \*
DIV \/\/
MOD \%

IF if
ELSE else

WHILE while
LOOP loop

OUTPUT Output
INPUT Input

IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*


%%


{PROGRAM} {
    yysuccess("PROGRAM",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{VARIABLES} {
    yysuccess("VARIABLES",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{DOT} {
    yysuccess("DOT",yytext,yyleng);
    currentColumnNumber+=yyleng;
}

{COLON} {
    yysuccess("COLON",yytext,yyleng);
    currentColumnNumber+=yyleng;

}

{INTEGER_DECLARE} {
    yysuccess("INTEGER_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{REAL_DECLARE} {
    yysuccess("REAL_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{BOOLEAN_DECLARE} {
    yysuccess("BOOLEAN_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{CHAR_DECLARE} {
    yysuccess("CHAR_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{STRING_DECLARE} {
    yysuccess("STRING_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{STRUCT_DECLARE} {
    yysuccess("STRUCT_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{INTEGER} {
    yysuccess("INTEGER",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{REAL} {
    yysuccess("REAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{BOOLEAN} {
    yysuccess("BOOLEAN",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{CHAR} {
    yysuccess("CHAR",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{STRING} {
    yysuccess("STRING",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{ASSIGNMENT} {
    yysuccess("ASSIGNMENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{EQUAL} {
    yysuccess("EQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{DIFFERENT} {
    yysuccess("DIFFERENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{AND} {
    yysuccess("AND",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OR} {
    yysuccess("OR",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{NOT} {
    yysuccess("NOT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{LESS} {
    yysuccess("LESS",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{GREATER} {
    yysuccess("GREATER",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{LESSEQUAL} {
    yysuccess("LESSEQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{GREATEREQUAL} {
    yysuccess("GREATEREQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{ADD} {
    yysuccess("ADD",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{SUB} {
    yysuccess("SUB",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{MULT} {
    yysuccess("MULT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{DIV} {
    yysuccess("DIV",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{MOD} {
    yysuccess("MOD",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{IF} {
    yysuccess("IF",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{ELSE} {
    yysuccess("ELSE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{WHILE} {
    yysuccess("WHILE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{LOOP} {
    yysuccess("LOOP",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OUTPUT} {
    yysuccess("OUTPUT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{INPUT} {
    yysuccess("INPUT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{COMMENT} {
    yysuccess("COMMENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OPEN_PARENTHESIS} {
    yysuccess("OPEN_PARENTHESIS",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{CLOSE_PARENTHESIS} {
    yysuccess("CLOSE_PARENTHESIS",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OPEN_CURLY_BRACE} {
    yysuccess("OPEN_CURLY_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{CLOSE_CURLY_BRACE} {
    yysuccess("CLOSE_CURLY_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OPEN_SQUARE_BRACE} {
    yysuccess("OPEN_SQUARE_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{CLOSE_SQUARE_BRACE} {
    yysuccess("CLOSE_SQUARE_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{SEMICOLON} {
    yysuccess("SEMICOLON",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{COMMA} {
    yysuccess("COMMA",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{SPACE}+|{TAB}+ {
    currentColumnNumber+=yyleng;
}

{LINEBREAK} {
    currentColumnNumber = 1;
}

{IDENTIFIER} {
    yysuccess("IDENTIFIER",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

. {
    printf("Unrecognized character %s in line %d column %d\n", yytext, yylineno, currentColumnNumber);
    exit(1);
}

%%

int main(int argc, char **argv) {

    extern FILE *yyin;
  
    yyin = fopen("input.cube", "r");
  
    yylex();

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
    printf("Lexical error in Line %d Column %d : Unrecognized character: %s \n", yylineno, currentColumnNumber, yytext);
    printf("\033[0m"); 
}
