CC = gcc
CFLAGS = -Wall -O3 -g -fPIC
CPPFLAGS = -I. -I/vol/mgx-sw/include/htslib -I/vol/mgx-sw/include
LDFLAGS = -fPIC -pthread 

all:	bamstats

clean:
	$(RM) *.o bamstats

OBJS = bamstats.o

bamstats:	$(OBJS) *.h
	$(CC) -g -o $@ $(OBJS) $(LDFLAGS) /vol/mgx-sw/lib/libhts.a -ldl -lz

%.o: %.c *.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

