CC=g++
CFLAGS=-Wall -O3 -fexpensive-optimizations
LFLAGS=

all: bmp color main link

bmp: EasyBMP/EasyBMP.cpp
	$(CC) $(CFLAGS) -o obj/EasyBMP.o -c EasyBMP/EasyBMP.cpp

color: cpp/Color.cpp
	$(CC) $(CFLAGS) -o obj/Color.o -c cpp/Color.cpp

main: cpp/main.cpp
	$(CC) $(CFLAGS) -o obj/main.o -c cpp/main.cpp

link: obj/EasyBMP.o obj/Color.o obj/main.o
	$(CC) $(LFLAGS) -o bin/llp obj/EasyBMP.o obj/Color.o obj/main.o
