NAME=simplify

#all: main
FILES=parsefile.hs params.hs models.hs reachable.hs
SRC=src

all:
	cd $(SRC) && ghc --make Main.hs -o ../simplify-bkg -hidir tmp -odir tmp

clean:
	rm -r simplify-bkg $(SRC)/tmp
