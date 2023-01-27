CC = gcc
CFLAGS = -Wall -O3 -g -fPIC
CPPFLAGS = -I. `pkg-config --cflags htslib`
LDFLAGS = -fPIC -pthread

all:	bamstats

clean:
	$(RM) *.o bamstats

OBJS = bamstats.o

bamstats:	$(OBJS)
	$(CC) -g -o $@ $(OBJS) $(LDFLAGS) `pkg-config --libs htslib` -Wl,-rpath `pkg-config --variable=libdir htslib`

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

