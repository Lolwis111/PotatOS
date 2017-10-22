CC=g++
CFLAGS=-Wall -O2
LFLAGS=

all: string main link

string: cpp/Strings.cpp
	$(CC) $(CFLAGS) -o obj/Strings.o -c cpp/Strings.cpp

main: cpp/main.cpp
	$(CC) $(CFLAGS) -o obj/main.o -c cpp/main.cpp

link: obj/Strings.o obj/main.o
	$(CC) $(LFLAGS) -o bin/mklocale obj/Strings.o obj/main.o
