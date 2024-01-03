#!/bin/bash

lex cube-lexer.l

bison -dy cube-parser.y

gcc lex.yy.c y.tab.c

./a.out
