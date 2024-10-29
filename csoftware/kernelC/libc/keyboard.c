
// inline unsigned char readkey()
// {
//     while ((inportb(STATUS_PORT) & 1) == 0);

//     return inportb(DATA_PORT);
// }

// int shift = 0;
// char lowerCaseMap[256] = {
//     0x00, 0x00, '1','2','3','4','5','6','7','8','9','0','-','=', 
//     0x08, 0x09, 'q','w','e','r','t','y','u','i','o','p','[',']', 
//     0x0A, 0x00, 'a','s','d','f','g','h','j','k','l', 0x3B, 0x27, 
//     '`', 0x00, '\\','z','x','c','v','b','n','m',',','.','/'
// };
// char upperCaseMap[256] = {
//     0x00, 0x00, '!', '@', '#', '$', '\%', '^', '&', '*', '(', ')', '_', '+', 0x08, 0x09,
//     'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0x0A, 0x00, 'A','S',
//     'D','F','G','H','J','K','L',':', 0x22, '~', 0x00, 0x7C, 'Z','X','C',
//     'V','B','N','M','<','>','?'
// };

// inline void _readChar(KEY_S* k)
// {
//     unsigned char code = readkey();

//     k->scancode = code;
//     k->ascii = 0;

//     switch (k->scancode)
//     {
//         case LEFT_SHIFT_DOWN:
//         case RIGHT_SHIFT_DOWN:
//         {
//             shift = 1;
//             break;
//         }
//         case LEFT_SHIFT_UP:
//         case RIGHT_SHIFT_UP:
//         {
//             shift = 0;
//             break;
//         }
//         case 0x39:
//         {
//             k->ascii = ' ';
//             break;
//         }
//         default:
//         {
//             if(shift == 1)
//             {
//                 k->ascii = upperCaseMap[k->scancode];
//             }
//             else
//             {
//                 k->ascii = lowerCaseMap[k->scancode];
//             }
//             break;
//         }
//     }
// }

// inline char readChar()
// {
//     KEY_S k = { .ascii = 0, .scancode = 0 };
//     _readChar(&k);
//     return k.ascii;
// }

// int readLine(char* buffer, int length)
// {
//     int counter = 0;
//     while(1)
//     {
//         KEY_S k = { .ascii = 0, .scancode = 0 };
//         _readChar(&k);

//         if(k.scancode == KEY_ENTER)
//         {
//             *(buffer+counter) = 0;
//             return counter;
//         }

//         if(k.scancode == KEY_BACKSPACE)
//         {
//             if(counter > 0)
//             {
//                 counter--;
//                 screenX--;
//                 putchar(' ', 0x07);

//                 screenX--;
//                 setCursorPosition(screenX, screenY);

//                 *(buffer+counter) = 0;
//             }
//         }
//         else if(k.ascii == 0)
//         {
//             // ignore
//         }
//         else 
//         {
//             if(counter < length-1)
//             {
//                 *(buffer+counter) = k.ascii;
//                 counter++;
//                 putchar(k.ascii, 0x07);
//             }
//         }
//     }

//     return 0;
// }

// void setCursorPosition(int x, int y)
// {
//     if(x < 0) x = 0;
//     if(x > 79) x = 79;
//     if(y < 0) y = 0;
//     if(y > 24) y = 24;

//     screenX = x;
//     screenY = y;

//     short pos = y * 80 + x;

//     outportb(0x3D4, 0x0F);
//     outportb(0x3D5, (unsigned char)(pos & 0xFF));
//     outportb(0x3D4, 0x0E);
//     outportb(0x3D5, (unsigned char)((pos >> 8) & 0xFF));
// }