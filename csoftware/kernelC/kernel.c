#include "stdio.h"
#include "string.h"
#include "time.h"

void clearscreen()
{
    /* sketchy way of doing it */
    setCursorPosition(0, 0);
    
    for(int i = 0; i < 80*25; i++)
    {
        putchar(' ', 0x07);
    }

    setCursorPosition(0, 0);
}

int main()
{
    initKeyboard();
    // initSerial();
    
    char* str = "Welcome to TomatOS. The PotatOS fork written in C\r\n\n";
    puts(str);

    char buffer[40];
    while(1)
    {
        memset(buffer, 0, 40);
        printf("\r\nCMD> ");
        readLine(buffer, 40);
        printf("\r\n");

        if(0 == strcmp(buffer, "colors"))
        {
            unsigned char c = 0;
            for(int i = 0; i < 16; i++)
            {
                for(int j = 0; j < 16; j++)
                {
                    setColor(c);
                    printf("%x ", c);
                    c++;
                }
                printf("\r\n");
            }

            setColor(0x07);
        }
        else if(0 == strcmp(buffer, "printf"))
        {
            int i = 123;

            char* str2 = "test123";

            printf("printf:\r\nbase 8:%o\r\nbase 10:%d\r\nbase 16:%x\r\nAnd some string:%s\r\n", i, i, i, str2);
        }
        else if(0 == strcmp(buffer, "clear"))
        {
            clearscreen();
        }
        // else if(0 == strcmp(buffer, "date"))
        // {
        //     time_t t = time(NULL);
        //     struct tm time;
        //     time = mktime(&time);

        //     const char* months[12] = {
        //         "January", "February", "March", 
        //         "April", "May", "June", 
        //         "July", "August", "September", 
        //         "October", "November", "December"
        //     };

        //     printf("%s %d, %d: %d:%d:%d",
        //         months[time.tm_mon], time.tm_mday, time.tm_year,
        //         time.tm_hour, time.tm_min, time.tm_sec);
        // }
        else if(0 == strcmp(buffer, "test"))
        {
            char* str1 = "test123";
            char* str2 = "Some Text";
            char* str3 = "EPIC HARDCORE SHOOBIE DOG MEMES";
            int l1 = strlen(str1);
            int l2 = strlen(str2);
            int l3 = strlen(str3);

            printf("%d: %s\r\n%d: %s\r\n%d: %s\r\n", l1, str1, l2, str2, l3, str3);
        }
        else if(0 == strncmp(buffer, "args", 4))
        {
            printf("args: %s", buffer + 4);
        }
        else if(0 == strncmp(buffer, "cat", 4))
        {
            char a[] = "Hallo ";
            char b[] = "Welt";

            char c[50];
            strcpy(c, a);
            strcat(c, b);

            printf("%s\r\n%s\r\n%s\r\n", a, b, c);
        }
        else
        {
            printf("Unrecognized command '%s'! Try help to list all commands.\r\n", buffer);
        }
    }

    return 0;
    
}
