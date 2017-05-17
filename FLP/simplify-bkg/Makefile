SRC=src

all:
	cd $(SRC) && ghc --make Main.hs -o ../simplify-bkg -hidir tmp -odir tmp

docs: doc

doc:
	haddock -h -o docs/ src/Main.hs src/Type/* src/Parser/* src/Utils/*

test:
	cd tests/ && bash testrunner.sh

clean:
	rm -r simplify-bkg $(SRC)/tmp docs/
