CFLAGS=-Wall -Werror -O2
LFLAGS=

all: attributes link

attributes: cpp/attributes.c
	$(CC) $(CFLAGS) -o obj/attributes.o -c cpp/attributes.c

link: obj/attributes.o
	$(CC) $(LFLAGS) -o bin/attributes obj/attributes.o
