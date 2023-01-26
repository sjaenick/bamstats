CC = gcc
CFLAGS = -Wall -O3 -g -fPIC
CPPFLAGS = -I. `pkg-config --cflags htslib`
LDFLAGS = -fPIC -pthread 

all:	bamstats

clean:
	$(RM) *.o bamstats

OBJS = bamstats.o

bamstats:	$(OBJS) *.h
	$(CC) -g -o $@ $(OBJS) $(LDFLAGS) `pkg-config --libs htslib`

%.o: %.c *.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

