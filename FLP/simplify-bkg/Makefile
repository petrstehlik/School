NAME=simplify

#all: main
FILES=parsefile.hs params.hs models.hs reachable.hs
SRC=src

all:
	cd $(SRC) && ghc --make $(FILES) -o ../simplify-bkg

clean:
	cd $(SRC) && rm simplify-bkg params.{o,hi} models.{o,hi} parsefile.{hi,o} reachable.{hi,o}
