#!/bin/bash

lex cube-lexer.l
bison -d cube-parser.y 

gcc lex.yy.c cube-parser.tab.c

./a.out
