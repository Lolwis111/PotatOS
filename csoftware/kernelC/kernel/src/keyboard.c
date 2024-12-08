#include "keyboard.h"
#include "pic.h"
#include "asm.h"
#include "ps2.h"

static volatile char kbBuffer[KB_BUFFER_SIZE];
static volatile int start = 0;
static volatile int end = 0;

static volatile int shift = 0;

static char lowerCaseMap[256] = {
    0x00, 0x00, '1','2','3','4','5','6','7','8','9','0','-','=', 
    0x08, 0x09, 'q','w','e','r','t','y','u','i','o','p','[',']', 
    0x0A, 0x00, 'a','s','d','f','g','h','j','k','l', 0x3B, 0x27, 
    '`', 0x00, '\\','z','x','c','v','b','n','m',',','.','/'
};

static char upperCaseMap[256] = {
    0x00, 0x00, '!', '@', '#', '$', '\%', '^', '&', '*', '(', ')', '_', '+', 0x08, 0x09,
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0x0A, 0x00, 'A','S',
    'D','F','G','H','J','K','L',':', 0x22, '~', 0x00, 0x7C, 'Z','X','C',
    'V','B','N','M','<','>','?'
};

__attribute__((interrupt)) void keyboard_isr(struct interrupt_frame* frame)
{
    unsigned char c = (char)inportb(0x60);

    //
    if((c & 0b10000000) == 0)
    {
        char ascii = 0;

        switch (c)
        {
            case LEFT_SHIFT_DOWN:
            case RIGHT_SHIFT_DOWN:
            {
                shift = 1;
                break;
            }
            case LEFT_SHIFT_UP:
            case RIGHT_SHIFT_UP:
            {
                shift = 0;
                break;
            }
            case 0x39:
            {
                ascii = ' ';
                break;
            }
            default:
            {
                if(shift == 1)
                {
                    ascii = upperCaseMap[c];
                }
                else
                {
                    ascii = lowerCaseMap[c];
                }
                break;
            }
        }

        if(start != ((end - 1 + KB_BUFFER_SIZE) % KB_BUFFER_SIZE))
        {
            kbBuffer[start] = ascii;
            start = (start + 1) % KB_BUFFER_SIZE;
        }
    }

    PIC_sendEOI(1);
}

char getch(void)
{
    while(start == end)
    {
        // halt CPU here, the keyboard interrupt will wake the system up again
        // and then we check again, if start == end!
        hlt();
    }

    char c = kbBuffer[end];

    end = (end + 1) % KB_BUFFER_SIZE;

    return c;
}

char getch2(void)
{
    while(start == end)
    {
        return 0;
    }

    char c = kbBuffer[end];

    end = (end + 1) % KB_BUFFER_SIZE;

    return c;
}

void initKeyboard()
{
    sendPS2Command(0xAD);

    inportb(DATA_PORT);

    sendPS2Command(0xAE);
}