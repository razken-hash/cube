%{
#include <stdio.h>
#include "cube-parser.tab.h"

extern void yysuccess(char *s);
extern void yyerror(const char *s);
extern int currentColumnNumber;

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

PROGRAM program
VARIABLES Variables

OPEN_PARENTHESIS \(
CLOSE_PARENTHESIS \)
OPEN_CURLY_BRACE \{
CLOSE_CURLY_BRACE \}


COMMENT #{ANYTHING}

INTEGER_DECLARE Integer
REAL_DECLARE Real
BOOLEAN_DECLARE Bool
CHAR_DECLARE Char
STRING_DECLARE Text

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
yysuccess("PROGRAM");
return PROGRAM;
}

{VARIABLES} {
yysuccess("VARIABLES");

return VARIABLES;
}


{COLON} {
yysuccess("COLON");

return COLON;
}

{INTEGER_DECLARE} {
yysuccess("INTEGER_DECLARE");

strcpy( yylval.string ,"Integer");

return INTEGER_DECLARE;
}

{REAL_DECLARE} {
yysuccess("REAL_DECLARE");

strcpy( yylval.string , "Real");

return REAL_DECLARE;
}

{BOOLEAN_DECLARE} {
yysuccess("BOOLEAN_DECLARE");

strcpy( yylval.string , "Bool");

return BOOLEAN_DECLARE;
}

{CHAR_DECLARE} {
yysuccess("CHAR_DECLARE");

strcpy( yylval.string , "Char");

return CHAR_DECLARE;
}

{STRING_DECLARE} {
yysuccess("STRING_DECLARE");

strcpy( yylval.string , "Text");

return STRING_DECLARE;
}


{INTEGER} {
yysuccess("INTEGER");

yylval.int_val = atoi(yytext);

return INTEGER;
}

{REAL} {
yysuccess("REAL");

yylval.real_val = atof(yytext);

return REAL;
}

{BOOLEAN} {
yysuccess("BOOLEAN");

if(strcmp(yytext,"True") == 0)
    yylval.bool_val = 1;
else
    yylval.bool_val = 0;

return BOOLEAN;
}

{CHAR} {
yysuccess("CHAR");

yylval.char_val = yytext[1];

return CHAR;
}

{TEXT} {
yysuccess("TEXT");

strcpy( yylval.string , yytext);

return TEXT;
}

{ASSIGNMENT} {
yysuccess("ASSIGNMENT");

return ASSIGNMENT;
}

{EQUAL} {
yysuccess("EQUAL");

return EQUAL;
}

{DIFFERENT} {
yysuccess("DIFFERENT");

return DIFFERENT;
}

{AND} {
yysuccess("AND");

return AND;
}

{OR} {
yysuccess("OR");

return OR;
}

{NOT} {
yysuccess("NOT");

return NOT;
}

{LESS} {
yysuccess("LESS");

return LESS;
}

{GREATER} {
yysuccess("GREATER");

return GREATER;
}

{LESSEQUAL} {
yysuccess("LESSEQUAL");

return LESSEQUAL;
}

{GREATEREQUAL} {
yysuccess("GREATEREQUAL");

return GREATEREQUAL;
}

{ADD} {
yysuccess("ADD");

return ADD;
}

{SUB} {
yysuccess("SUB");

return SUB;
}

{MULT} {
yysuccess("MULT");

return MULT;
}

{DIV} {
yysuccess("DIV");

return DIV;
}

{MOD} {
yysuccess("MOD");

return MOD;
}

{IF} {
yysuccess("IF");

return IF;
}

{ELSE} {
yysuccess("ELSE");

return ELSE;
}

{WHILE} {
yysuccess("WHILE");

return WHILE;
}

{LOOP} {
yysuccess("LOOP");

return LOOP;
}

{OUTPUT} {
yysuccess("OUTPUT");

return OUTPUT;
}

{INPUT} {
yysuccess("INPUT");

return INPUT;
}

{COMMENT} {
yysuccess("COMMENT");

}

{OPEN_PARENTHESIS} {
yysuccess("OPEN_PARENTHESIS");

return OPEN_PARENTHESIS;
}

{CLOSE_PARENTHESIS} {
yysuccess("CLOSE_PARENTHESIS");

return CLOSE_PARENTHESIS;
}

{OPEN_CURLY_BRACE} {
yysuccess("OPEN_CURLY_BRACE");

return OPEN_CURLY_BRACE;
}

{CLOSE_CURLY_BRACE} {
yysuccess("CLOSE_CURLY_BRACE");

return CLOSE_CURLY_BRACE;
}

{SEMICOLON} {
yysuccess("SEMICOLON");

return SEMICOLON;
}

{COMMA} {
yysuccess("COMMA");

return COMMA;
}

{SPACE}+|{TAB}+ {
    yysuccess("");
}

{LINEBREAK} {
currentColumnNumber = 1;
}

{IDENTIFIER} {
yysuccess("IDENTIFIER");

strcpy( yylval.string,yytext);

return IDENTIFIER;
}

. {
printf("Unrecognized character %s in line %d column %d\n", yytext, yylineno, currentColumnNumber);
exit(1);
}

%%

