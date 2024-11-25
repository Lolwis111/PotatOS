#ifndef _FS_H_
#define _FS_H_

#include "stdint.h"
#include "stdbool.h"

typedef struct __attribute__((packed)) FLOPPY_DISK_STRUCTURE {
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
} FLOPPY_DISK_STRUCTURE;

typedef struct __attribute__((packed)) FILE_ENTRY
{
    char name[9];
    unsigned int size;
    char ext[4];
    unsigned char* data; 
    char attr;
    unsigned short cluster;
    bool isDirectory;
} FILE_ENTRY;

void readFileSystem(FLOPPY_DISK_STRUCTURE* fds);

void readRoot(const FLOPPY_DISK_STRUCTURE *fds);

#endif