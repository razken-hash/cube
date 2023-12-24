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
TEXT \"({ANYTHING})\"

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
    return PROGRAM;
}

{VARIABLES} {
    yysuccess("VARIABLES",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return VARIABLES;
}

{DOT} {
    yysuccess("DOT",yytext,yyleng);
    currentColumnNumber+=yyleng;
    return DOT;
}

{COLON} {
    yysuccess("COLON",yytext,yyleng);
    currentColumnNumber+=yyleng;
    return COLON;
}

{INTEGER_DECLARE} {
    yysuccess("INTEGER_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return INTEGER_DECLARE;
}

{REAL_DECLARE} {
    yysuccess("REAL_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return REAL_DECLARE;
}

{BOOLEAN_DECLARE} {
    yysuccess("BOOLEAN_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return BOOLEAN_DECLARE;
}

{CHAR_DECLARE} {
    yysuccess("CHAR_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return CHAR_DECLARE;
}

{STRING_DECLARE} {
    yysuccess("STRING_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return STRING_DECLARE;
}

{STRUCT_DECLARE} {
    yysuccess("STRUCT_DECLARE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return STRUCT_DECLARE;
}

{INTEGER} {
    yysuccess("INTEGER",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return INTEGER;
}

{REAL} {
    yysuccess("REAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return REAL;
}

{BOOLEAN} {
    yysuccess("BOOLEAN",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return BOOLEAN;
}

{CHAR} {
    yysuccess("CHAR",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return CHAR;
}

{TEXT} {
    yysuccess("TEXT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return TEXT;
}

{ASSIGNMENT} {
    yysuccess("ASSIGNMENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return ASSIGNMENT;
}

{EQUAL} {
    yysuccess("EQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return EQUAL;
}

{DIFFERENT} {
    yysuccess("DIFFERENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return DIFFERENT;
}

{AND} {
    yysuccess("AND",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return AND;
}

{OR} {
    yysuccess("OR",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return OR;
}

{NOT} {
    yysuccess("NOT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return NOT;
}

{LESS} {
    yysuccess("LESS",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return LESS;
}

{GREATER} {
    yysuccess("GREATER",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return GREATER;
}

{LESSEQUAL} {
    yysuccess("LESSEQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return LESSEQUAL;
}

{GREATEREQUAL} {
    yysuccess("GREATEREQUAL",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return GREATEREQUAL;
}

{ADD} {
    yysuccess("ADD",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return ADD;
}

{SUB} {
    yysuccess("SUB",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return SUB;
}

{MULT} {
    yysuccess("MULT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return MULT;
}

{DIV} {
    yysuccess("DIV",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return DIV;
}

{MOD} {
    yysuccess("MOD",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return MOD;
}

{IF} {
    yysuccess("IF",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return IF;
}

{ELSE} {
    yysuccess("ELSE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return ELSE;
}

{WHILE} {
    yysuccess("WHILE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return WHILE;
}

{LOOP} {
    yysuccess("LOOP",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return LOOP;
}

{OUTPUT} {
    yysuccess("OUTPUT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return OUTPUT;
}

{INPUT} {
    yysuccess("INPUT",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return INPUT;
}

{COMMENT} {
    yysuccess("COMMENT",yytext, yyleng);
    currentColumnNumber+=yyleng;
}

{OPEN_PARENTHESIS} {
    yysuccess("OPEN_PARENTHESIS",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return OPEN_PARENTHESIS;
}

{CLOSE_PARENTHESIS} {
    yysuccess("CLOSE_PARENTHESIS",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return CLOSE_PARENTHESIS;
}

{OPEN_CURLY_BRACE} {
    yysuccess("OPEN_CURLY_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return OPEN_CURLY_BRACE;
}

{CLOSE_CURLY_BRACE} {
    yysuccess("CLOSE_CURLY_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return CLOSE_CURLY_BRACE;
}

{OPEN_SQUARE_BRACE} {
    yysuccess("OPEN_SQUARE_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return OPEN_SQUARE_BRACE;
}

{CLOSE_SQUARE_BRACE} {
    yysuccess("CLOSE_SQUARE_BRACE",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return CLOSE_SQUARE_BRACE;
}

{SEMICOLON} {
    yysuccess("SEMICOLON",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return SEMICOLON;
}

{COMMA} {
    yysuccess("COMMA",yytext, yyleng);
    currentColumnNumber+=yyleng;
    return COMMA;
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
    return IDENTIFIER;
}

. {
    printf("Unrecognized character %s in line %d column %d\n", yytext, yylineno, currentColumnNumber);
    exit(1);
}

%%

int main(int argc, char **argv) {

    extern FILE *yyin;
  
    yyin = fopen("input.cube", "r");
  
    int token;
    while ((token = yylex()) != 0) {
        // Process the token
    }

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
