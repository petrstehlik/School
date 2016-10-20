# Makefile for Cross Interleaved Reed Solomon encoder/decoder
#
# (c) Henry Minsky, Universal Access 1991-1996
#

RANLIB = ranlib
AR = ar


VERSION = 1.0
DIRNAME= rscode-$(VERSION)


CC = c++
# OPTIMIZE_FLAGS = -O69
DEBUG_FLAGS = -g
CFLAGS = -Wall -Wstrict-prototypes  $(OPTIMIZE_FLAGS) $(DEBUG_FLAGS) -I..
LDFLAGS = $(OPTIMIZE_FLAGS) $(DEBUG_FLAGS)

LIB_CSRC = rs.c galois.c berlekamp.c crcgen.c
LIB_HSRC = ecc.h
LIB_OBJS = rs.o galois.o berlekamp.o crcgen.o

TARGET_LIB = libecc.a
TEST_PROGS = proj1

TARGETS = $(TARGET_LIB) $(TEST_PROGS)

all: $(TARGETS)

$(TARGET_LIB): $(LIB_OBJS)
	$(RM) $@
	$(AR) cq $@ $(LIB_OBJS)
	if [ "$(RANLIB)" ]; then $(RANLIB) $@; fi

example: example.o galois.o berlekamp.o crcgen.o rs.o
	gcc -o example example.o -L. -lecc

test: test.o galois.o berlekamp.o crcgen.o rs.o
	gcc -o test test.o -L. -lecc

proj1: proj1.o galois.o berlekamp.o crcgen.o rs.o
	$(CC) -o proj1 proj1.o -L. -lecc

clean:
	rm -f *.o example libecc.a test
	rm -f *~

dist:
	(cd ..; tar -cvf rscode-$(VERSION).tar $(DIRNAME))

depend:
	makedepend $(SRCS)

# DO NOT DELETE THIS LINE -- make depend depends on it.

