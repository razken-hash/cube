#!/bin/bash

rm -f lex.yy.c cube-parser.tab.c cube-parser.tab.h a.out

lex cube-lexer.l
bison -d cube-parser.y 

gcc lex.yy.c cube-parser.tab.c

./a.out
