SRC=src

all:
	cd $(SRC) && ghc --make Main.hs -o ../simplify-bkg -hidir tmp -odir tmp

clean:
	rm -r simplify-bkg $(SRC)/tmp
