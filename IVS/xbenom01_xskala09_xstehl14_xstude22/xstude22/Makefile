#
# IVS2016 Project makefile
# Authors: Marek Beňo (xbenom01), Milan Skála (xskala09), Peter Stehlík(xstehl14), Zuzana Studená (xstude22)
# 
# Spustenie aplikacie:
# make run
# 
# Spustenie testov
# make test
# 
# Vygenerovanie programovej dokumentacie
# make doxy
# 
# Vygenerovanie uzivatelskej prirucky
# make doc
# 
# Zabalanie archivu pre odovzdanie
# make pack
# 
# Zmazanie nepotrebnych suborov
# make clean
#
# Instalacia aplikacie
# make install
# 
# Odinstalovanie aplikacie
# make uninstall

JC=javac
CFLAGS=-d bin/

PACKAGENAME=ivskalkulacka
VERSION=1.2
RELEASE=1_amd64
PACKAGEDIR=$(PACKAGENAME)-$(VERSION)

SOURCEFILES=$(wildcard src/*.java)4
CLASSFILES=$(sourcefiles:.java=.class)

ALLFILES=$(SOURCEFILES) $(MOCKUPS) $(DEBUGS) Makefile docs/dokumentace.pdf docs/skutecnost.txt docs/body.txt
ARCHIVENAME=xbenom01_xskala09_xstehl14_xstude22


all: run

compile:
	ant compile

run:
	ant run

test: 
	ant test

install:
	sudo dpkg -i $(PACKAGENAME)_$(VERSION)-$(RELEASE).deb
uninstall:
	sudo dpkg -r $(PACKAGENAME)

doxy:
	cd doc; \
	doxygen; \
	zip dokumentace.zip html/*

doc: doxy
	@cd doc; \
	make; \
	cd -;

pack: doc
	mkdir -pv ../$(ARCHIVENAME)
	mkdir -pv ../$(ARCHIVENAME)/xstude22
	mkdir -pv ../$(ARCHIVENAME)/xstude22/doc
	cp -r mockups ../$(ARCHIVENAME)/
	cp -r debugs ../$(ARCHIVENAME)/
	cp -r screenshots ../$(ARCHIVENAME)/
	cp doc/userguide.pdf ../$(ARCHIVENAME)/
	cp data/body.txt ../$(ARCHIVENAME)/
	cp data/skutecnost.txt ../$(ARCHIVENAME)/
	cp ivskalkulacka_1.2-1_amd64.deb ../$(ARCHIVENAME)/
	cp -r src ../$(ARCHIVENAME)/xstude22
	cp -r tests ../$(ARCHIVENAME)/xstude22
	cp -r .git ../$(ARCHIVENAME)/xstude22
	cp -r lib ../$(ARCHIVENAME)/xstude22
	cp Makefile ../$(ARCHIVENAME)/xstude22
	cp build.xml ../$(ARCHIVENAME)/xstude22
	cp doc/Doxyfile ../$(ARCHIVENAME)/xstude22/doc
	cp doc/dokumentace.zip ../$(ARCHIVENAME)/xstude22/doc


clean:
	# Remove bin, jar
	ant clean

	# Remove archive
	rm -f $(ARCHIVENAME).zip
	rm -rf $(ARCHIVENAME)/
	
	#Doxy
	rm -rf doc/html/

	#Documentation
	rm -f userguide.log
	rm -f userguide.aux
	rm -f doc/userguide.pdf
	rm -f doc/texput.log

	#Deb package obsolete
	rm -rf $(PACKAGEDIR)
	rm -f $(PACKAGEDIR).tar.gz
	rm -f $(PACKAGENAME)_$(VERSION).orig.tar.gz
	rm -rf $(PACKAGENAME)_$(VERSION)-*

package: doc compile
	mkdir -pv $(PACKAGEDIR)/src
	mkdir -pv $(PACKAGEDIR)/doc

	cp data/ivskalkulacka.desktop $(PACKAGEDIR)/src
	cp doc/userguide.pdf $(PACKAGEDIR)/doc
	cp ivskalkulacka.jar $(PACKAGEDIR)/src
	cp data/ivskalkulacka.ico $(PACKAGEDIR)/src
	#cp build.xml $(PACKAGEDIR)
	#cp Makefile $(PACKAGEDIR)/
	tar cvzf $(PACKAGEDIR).tar.gz $(PACKAGEDIR)
	cd $(PACKAGEDIR); \
	dh_make -C=s -e xbenom01@stud.fit.vutbr.cz -f ../$(PACKAGEDIR).tar.gz
	cp data/ivskalkulacka.install $(PACKAGEDIR)/debian
	
addfiles:
	#mkdir $(PACKAGEDIR)/debian/tmp
	#cp data/$(PACKAGENAME).desktop $(PACKAGEDIR)/debian/tmp/$(PACKAGENAME).desktop
	#cp data/$(PACKAGENAME).install $(PACKAGEDIR)/debian/tmp/$(PACKAGENAME).install
	#cp data/include-binaries $(PACKAGEDIR)/debian/source/include-binaries

deb:
	cd $(PACKAGEDIR); \
	dpkg-buildpackage -rfakeroot



.PHONY: run test doc clean pack install uninstall package
