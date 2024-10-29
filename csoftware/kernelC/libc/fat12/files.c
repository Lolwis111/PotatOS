#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "files.h"
#include "util.h"

void clusterChain(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, const unsigned char* fat, const FILE_ENTRY* entry)
{
    size_t rootSizeB = 32 * fds->RootEntries;
    size_t fatSizeB = fds->NumberOfFATS * fds->SectorsPerFAT * fds->BytesPerSector;

    size_t offset = rootSizeB + fatSizeB + (fds->ReservedSectors * fds->BytesPerSector);

    unsigned short next = entry->cluster;
    while(next < 0x0FF0)
    {
        int lba = cluster2lba(next, fds);

        printf("%d\n", next);

        fseek(ptr, lba + offset, 0);

        unsigned short addr = next + (next / 2);

        unsigned short temp = (fat[addr + 1] << 8) | fat[addr];

        if(next % 2 == 0)
        {
            next = temp & 0x0FFF;
        }
        else
        {
            next = (temp >> 4) & 0x0FFF;
        }
    }
}

int readFile(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, const unsigned char* fat, FILE_ENTRY* entry)
{
    size_t limit = 0;

    size_t dataoffset = 0;

    size_t rootSizeB = 32 * fds->RootEntries;
    size_t fatSizeB = fds->NumberOfFATS * fds->SectorsPerFAT * fds->BytesPerSector;

    size_t offset = rootSizeB + fatSizeB + (fds->ReservedSectors * fds->BytesPerSector);

    unsigned short clustersize = fds->SectorsPerCluster * fds->BytesPerSector;

    entry->data = NULL;

    unsigned short next = entry->cluster;
    while(next < 0x0FF0)
    {
        int lba = cluster2lba(next, fds);

        fseek(ptr, lba + offset, 0);

        limit += clustersize;
        unsigned char* tmp = realloc(entry->data, limit);

        if(tmp == NULL)
        {
            printf("ERROR :(");
            free(entry->data);
            return -1;
        }

        entry->data = tmp;

        fread(entry->data + dataoffset, clustersize, 1, ptr);
        dataoffset += clustersize;

        unsigned short addr = next + (next / 2);

        unsigned short temp = (fat[addr + 1] << 8) | fat[addr];

        if(next % 2 == 0)
        {
            next = temp & 0x0FFF;
        }
        else
        {
            next = (temp >> 4) & 0x0FFF;
        }
    }

    return limit;
}