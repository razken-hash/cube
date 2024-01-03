#!/bin/bash

lex cube-lexer.l
yacc -d cube-parser.y

gcc lex.yy.c y.tab.c

./a.out
