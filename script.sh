#!/bin/bash

rm -f lex.yy.c cube-parser.tab.c cube-parser.tab.h a.out

bison -d cube-parser.y 
flex cube-lexer.l

gcc cube-parser.tab.c lex.yy.c  -lfl -lm

./a.out
