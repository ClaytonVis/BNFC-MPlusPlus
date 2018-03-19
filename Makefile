all:
	happy -gca ParM.y
	alex -g LexM.x
	ghc --make TestM.hs -o TestM

clean:
	-rm -f *.log *.aux *.hi *.o *.dvi

distclean: clean
	-rm -f DocM.* LexM.* ParM.* LayoutM.* SkelM.* PrintM.* TestM.* AbsM.* TestM ErrM.* SharedString.* ComposOp.* m.dtd XMLM.* Makefile*
	
