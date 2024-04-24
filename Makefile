test_lexer:
	flex tree_builder.l
	g++ -o tree_builder lex.yy.c
	./tree_builder < examples/ex1.tb
clean:
	rm -f *.o *.a *.so *.out *.exe *.dll *.dylib *.app *.dSYM *.yy.c
	rm tree_builder
	rm lexer_output.txt
