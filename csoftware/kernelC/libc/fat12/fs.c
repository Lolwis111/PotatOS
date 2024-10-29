#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "files.h"
#include "fs.h"
#include "util.h"

// #define GET_WORD(i, buf) ((buf[i+1] << 8) | buf[i])

void initDirectory(DIRECTORY* dir)
{
    dir->size = 0;
    dir->limit = 4;
    dir->files = (FILE_ENTRY*)malloc(sizeof(FILE_ENTRY) * dir->limit);
}

void clearDirectory(DIRECTORY* dir)
{
    freeDirectory(dir);
    initDirectory(dir);
}

void freeDirectory(DIRECTORY* dir)
{
    for(size_t i = 0; i < dir->size; i++)
    {
        free(dir->files[i].data);
    }
    
    free(dir->files);
    dir->limit = 0;
    dir->size = 0;
}

static void resizeDir(DIRECTORY* dir)
{
    dir->limit += 4;
    FILE_ENTRY* tmp = (FILE_ENTRY*)realloc(dir->files, dir->limit * sizeof(FILE_ENTRY));
    dir->files = tmp;
}

void addFile(DIRECTORY* dir, const FILE_ENTRY* file)
{
    if(dir->size >= dir->limit)
    {
        resizeDir(dir);
    }

    memcpy(&dir->files[dir->size], file, sizeof(FILE_ENTRY));

    dir->size++;
}

void readDirectory(const unsigned char* data, DIRECTORY* dir)
{
    const unsigned char* ptr = data;
    while(*ptr != 0)
    {
        FILE_ENTRY entry;

        entry.name[0] = 0;

        if(ptr[0] == 0xe5) continue;

        memcpy(entry.name, ptr, 8);
        entry.name[8] = 0;
        memcpy(entry.ext, ptr + 8, 3);
        entry.ext[3] = 0;

        entry.attr = ptr[11];
        if(entry.attr & 0x10)
        {
            entry.isDirectory = true;
        }
        else
        {
            entry.isDirectory = false;
        }

        entry.size = (ptr[31] << 24) | (ptr[30] << 16) | (ptr[29] << 8) | ptr[28];

        entry.cluster = (ptr[27] << 8) | ptr[26];
        entry.data = NULL;

        addFile(dir, &entry);

        ptr += 32;
    }
}

void readRoot(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, DIRECTORY* root)
{
    fseek(ptr, 0, 0);
    unsigned short rootOffset = ((fds->NumberOfFATS * fds->SectorsPerFAT) + fds->ReservedSectors) * fds->BytesPerSector;

     fseek(ptr, rootOffset, 0);

    for(unsigned short i = 0; i < fds->RootEntries; i++)
    {
        unsigned char buffer[32];

        FILE_ENTRY entry;

        entry.name[0] = 0;

        fread(buffer, 32, 1, ptr);

        if(buffer[0] == 0 || buffer[0] == 0xe5) continue;

        memcpy(entry.name, buffer, 8);
        entry.name[8] = 0;
        memcpy(entry.ext, buffer + 8, 3);
        entry.ext[3] = 0;

        entry.attr = buffer[11];
        if(entry.attr & 0x10)
        {
            entry.isDirectory = true;
        }
        else
        {
            entry.isDirectory = false;
        }

        entry.size = (buffer[31] << 24) | (buffer[30] << 16) | (buffer[29] << 8) | buffer[28];

        entry.cluster = (buffer[27] << 8) | buffer[26];
        entry.data = NULL;

        addFile(root, &entry);
    }
}

unsigned char* readFat(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds)
{
    fseek(ptr, fds->ReservedSectors * fds->BytesPerSector, 0);

    int fatSize = fds->SectorsPerFAT * fds->BytesPerSector;

    unsigned char* fat = malloc(fatSize);

    fread(fat, fatSize, 1, ptr);

    return fat;
}

void readFileSystem(FILE* ptr, FLOPPY_DISK_STRUCTURE* fds)
{
    assert(sizeof(FLOPPY_DISK_STRUCTURE) == 36);

    fseek(ptr, 0, 0);
    fread(fds, sizeof(FLOPPY_DISK_STRUCTURE), 1, ptr);
}

FILE_ENTRY* findFile(const char* name, DIRECTORY* dir)
{
    char buf[12];

    convertName_f(buf, name);

    for(size_t i = 0; i < dir->size; i++)
    {
        if(dir->files[i].isDirectory == false)
        {
            if(strncmp(dir->files[i].name, buf, 8) == 0 && strncmp(dir->files[i].ext, buf + 8, 3) == 0)
            {
                return &dir->files[i];
            }
        }
    }

    return NULL;
}

FILE_ENTRY* findDir(const char* name, DIRECTORY* dir)
{
    char buf[12];

    convertName_d(buf, name);

    for(size_t i = 0; i < dir->size; i++)
    {
        if(dir->files[i].isDirectory == true)
        {
            // TODO: 
            size_t l = strlen(name);
            if(l > 8)
            {
                if(strncmp(dir->files[i].name, buf, 8) == 0 && strncmp(dir->files[i].ext, buf + 8, l - 8) == 0)
                {
                    return &dir->files[i];
                }
            }
            else
            {
                if(strncmp(dir->files[i].name, buf, 8) == 0)
                {
                    return &dir->files[i];
                }
            }
        }
    }

    return NULL;
}

void processPath(char* path, const char* dirname)
{
    if(strcmp(dirname, ".") == 0) return;

    if(strcmp(dirname, "..") == 0)
    {
        size_t len = strlen(path);
        char* end = path + len - 1;

        do
        {
            *end = 0;
            end--;
        }
        while(*end != '/');
    }
    else
    {
        strcat(path, dirname);
        strcat(path, "/");
    }
}