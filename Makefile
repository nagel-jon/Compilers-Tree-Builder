CC = gcc
CXX = g++
CFLAGS = -Wall
LEX = flex
YACC = yacc

parser: y.tab.c lex.yy.c
	$(CXX) $(CFLAGS) -o parser y.tab.c lex.yy.c -lfl

y.tab.c y.tab.h: tree_builder.y
	$(YACC) -d tree_builder.y

lex.yy.c: tree_builder.l
	$(LEX) tree_builder.l


test_lexer:
	flex tree_builder.l
	g++ -o tree_builder lex.yy.c
	./tree_builder < examples/ex1.tb
clean:
	rm -f *.o *.a *.so *.out *.exe *.dll *.dylib *.app *.dSYM *.yy.c *.tab.c *.tab.h
	rm tree_builder
	rm lexer_output.txt
