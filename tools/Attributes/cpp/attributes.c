#include <fcntl.h>
#include <linux/msdos_fs.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

/*
* Read file attributes of a file on a FAT filesystem.
* Output the state of the archive flag.
*/
/*static uint32_t
readattr(int fd)
{
    uint32_t attr;
    int ret;

    ret = ioctl(fd, FAT_IOCTL_GET_ATTRIBUTES, &attr);
    if (ret == -1) 
    {
        perror("ioctl");
        exit(EXIT_FAILURE);
    }

    if (attr & ATTR_ARCH)
        printf("Archive flag is set\n");
    else
        printf("Archive flag is not set\n");

    return attr;
}*/

int main(int argc, char *argv[])
{
    uint32_t attr = 0;
    int fd;
    int ret;

    if (argc != 3) 
    {
        printf("Usage: %s FILENAME ATTRIBUTE\n", argv[0]);
        puts("r - readonly\nh - hidden\ns - system\na - archive\n");
        exit(EXIT_FAILURE);
    }

    fd = open(argv[1], O_RDONLY);
    if (fd == -1) 
    {
        perror("open");
        exit(EXIT_FAILURE);
    }

    int i;
    for(i = 0; i < strlen(argv[1]); i++)
    {
        switch(argv[1][i])
        {
            case 'r':
            {
                attr |= ATTR_RO;
                break;
            }
            case 'h':
            {
                attr |= ATTR_HIDDEN;
                break;
            }
            case 's':
            {
                attr |= ATTR_SYS;
                break;
            }
            case 'a':
            {
                attr |= ATTR_ARCH;
                break;
            }
            case 'd':
            default:
            {
                attr = ATTR_NONE;
            }
        }
    }

    /*
     * Read and display the FAT file attributes.
     */
    // attr = readattr(fd);

    /*
     * Invert archive attribute.
     */
    // printf("Toggling archive flag\n");
    // attr ^= ATTR_ARCH;

    /*
     * Write the changed FAT file attributes.
     */
    ret = ioctl(fd, FAT_IOCTL_SET_ATTRIBUTES, &attr);
    if (ret == -1) 
    {
        perror("ioctl");
        exit(EXIT_FAILURE);
    }

    /*
     * Read and display the FAT file attributes.
     */
    // readattr(fd);

    close(fd);

    exit(EXIT_SUCCESS);
}
