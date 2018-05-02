CC=g++
CFLAGS=-Wall -O2
LFLAGS=

all: main link

main: cpp/main.cpp
	$(CC) $(CFLAGS) -o obj/main.o -c cpp/main.cpp

link: obj/main.o
	$(CC) $(LFLAGS) -o bin/mklocale obj/main.o
