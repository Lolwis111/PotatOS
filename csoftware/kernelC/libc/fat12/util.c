#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <ctype.h>

#include "util.h"

void printBuffer(const unsigned char* buffer, size_t size)
{
    size_t blockCount = size / 16;
    size_t rest = size % 16;

    unsigned char buf[17];
    buf[16] = 0;

    size_t i = 0;

    for(; i < blockCount; i++)
    {
        printf("%08lX: ", (i*16));
        for(size_t j = 0; j < 16; j++)
        {
            unsigned char c = buffer[(i * 16) + j];
            printf("%02X ", c);
            if(c >= 32)
            {
                buf[j] = c;
            }
            else
            {
                buf[j] = '.';
            }
        }

        printf(" | %s\n", buf);
    }

    printf("%08lX: ", (i*16));

    memset(buf, ' ', 16);

    for(size_t j = 0; j < rest; j++)
    {
        unsigned char c = buffer[(i * 16) + j];
        printf("%02X ", c);
        if(c >= 32)
        {
            buf[j] = c;
        }
        else
        {
            buf[j] = '.';
        }
    }

    for(size_t j = 0; j < 16 - rest; j++)
    {
        printf("   ");
    }

    printf(" | %s\n", buf);
}

int cluster2lba(unsigned short cluster, const FLOPPY_DISK_STRUCTURE* fds)
{
    return (cluster - 2) * fds->SectorsPerCluster * fds->BytesPerSector;
}

void convertName(char* fatName, const char* source, bool isDir)
{
    while(isspace(*source)) source++;

    memset(fatName, ' ', 11);
    fatName[11] = 0;

    if(source[0] == '.')
    {
        fatName[0] = '.';
        if(source[1] == '.')
        {
            fatName[1] = '.';
        }

        return;
    }

    char* ptr = strchr(source, '.');

    if(ptr == NULL)
    {
        size_t l = strlen(source);
        if(isDir)
        {
            memcpy(fatName, source, l > 11 ? 11 : l);
        }
        else
        {
            memcpy(fatName, source, l > 8 ? 8 : l);
        }
    }
    else
    {
        size_t extl = strlen(ptr + 1);

        size_t l = ptr - source;
        memcpy(fatName, source, l > 8 ? 8 : l);
        memcpy(fatName + 8, ptr + 1, extl > 3 ? 3 : extl);
    }

    while(*fatName)
    {
        *fatName = toupper(*fatName);
        fatName++;
    }
}

void convertName_d(char* fatName, const char* source) 
{ 
    convertName(fatName, source, true); 
}

void convertName_f(char* fatName, const char* source)
{
    convertName(fatName, source, false);
}

int saveFile(const unsigned char* buffer, size_t size, const char* fName)
{
    FILE* ptr;

    ptr = fopen(fName, "wb");

    if(NULL == ptr)
    {
        return -1;
    }

    fwrite(buffer, size, 1, ptr);

    fclose(ptr);

    return 0;
}

void printDir(const DIRECTORY* dir)
{
    for(size_t i = 0; i < dir->size; i++)
    {
        if(dir->files[i].isDirectory)
        {
            printf("%-8s%-3s%10s\n", dir->files[i].name, dir->files[i].ext, "<DIR>");
        }
        else
        {
            printf("%-9s%-4s%8d\n", dir->files[i].name, dir->files[i].ext, dir->files[i].size);
        }
    }
}