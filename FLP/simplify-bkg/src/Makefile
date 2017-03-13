NAME=simplify

#all: main

all: parsefile.hs params.hs models.hs
	ghc --make parsefile.hs params.hs models.hs -o simplify


clean:
	rm simplify params.hi params.o models.o models.hi parsefile.hi parsefile.o
