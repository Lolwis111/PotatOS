#include "fs.h"
#include "floppy.h"
#include "string.h"
#include "printk.h"

void readFileSystem(FLOPPY_DISK_STRUCTURE* fds)
{
    floppyRead(0, 0);

    memcpy(fds, (void*)0x1000, sizeof(FLOPPY_DISK_STRUCTURE));
}

void readRoot(const FLOPPY_DISK_STRUCTURE *fds)
{
    int lba = ((fds->NumberOfFATS * fds->SectorsPerFAT) + fds->ReservedSectors);

    unsigned char sector[512];

    size_t sectorOffset = 512;

    for(unsigned short i = 0; i < fds->RootEntries; i++)
    {
        unsigned char buffer[32];

        FILE_ENTRY entry;

        entry.name[0] = 0;

        if(sectorOffset == 512)        
        {
            sectorOffset = 0;
            floppyRead(lba, 0);
            memcpy(sector, (void*)0x1000, sizeof(unsigned char) * 512);
            lba++;
        }

        memcpy(buffer, &sector[sectorOffset], 32);
        sectorOffset += 32;

        if(buffer[0] == 0xe5) continue;

        if(buffer[0] == 0x00) break;

        memcpy(entry.name, buffer, 8);
        entry.name[8] = '\0';
        memcpy(entry.ext, buffer + 8, 3);
        entry.ext[3] = '\0';

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

        // addFile(root, &entry);

        printk("%10s%5s%8d\r\n", entry.name, entry.ext, entry.size);
    }
}