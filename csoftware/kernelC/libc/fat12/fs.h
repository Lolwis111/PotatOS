#ifndef _FS_H_
#define _FS_H_

#include <stdio.h>
#include <time.h>

typedef struct FLOPPY_DISK_STRUCTURE {
    unsigned char bootjump[3];
    unsigned char oem_name[8];
    unsigned short BytesPerSector;
    unsigned char SectorsPerCluster;
    unsigned short ReservedSectors;
    unsigned char NumberOfFATS;
    unsigned short RootEntries;
    unsigned short TotalSectors;
    unsigned char MediaDescriptor;
    unsigned short SectorsPerFAT;
    unsigned short SectorsPerTrack;
    unsigned short HeadsPerCylinder;
    unsigned int HiddenSectors;
    unsigned int TotalSectorsBig;
}__attribute__((packed)) FLOPPY_DISK_STRUCTURE;

typedef struct FILE_ENTRY
{
    char name[9];
    unsigned int size;
    char ext[4];
    unsigned char* data; 
    char attr;
    unsigned short cluster;
    bool isDirectory;
} FILE_ENTRY;

typedef struct DIRECTORY {
    FILE_ENTRY* files;
    size_t size;
    size_t limit;
} DIRECTORY;


void initDirectory(DIRECTORY* dir);
void clearDirectory(DIRECTORY* dir);
void freeDirectory(DIRECTORY* dir);
void addFile(DIRECTORY* dir, const FILE_ENTRY* file);

void readFileSystem(FILE* ptr, FLOPPY_DISK_STRUCTURE* fds);

void readRoot(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, DIRECTORY* root);
unsigned char* readFat(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds);
void readDirectory(const unsigned char* data, DIRECTORY* dir);

FILE_ENTRY* findDir(const char* name, DIRECTORY* dir);
FILE_ENTRY* findFile(const char* name, DIRECTORY* dir);

void processPath(char* path, const char* dirname);

#endif