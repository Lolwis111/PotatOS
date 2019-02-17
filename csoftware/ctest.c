#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

#define WIDTH 320
#define HEIGHT 200
#define CENTERX (WIDTH / 2)
#define CENTERY (HEIGHT / 2)

#define COLOR_BLACK 0
#define COLOR_BLUE 1
#define COLOR_GREEN 2
#define COLOR_TURQUOISE 3
#define COLOR_RED 4
#define COLOR_PURPLE 5
#define COLOR_ORANGE 6
#define COLOR_WHITE 7
#define COLOR_GRAY 8
#define COLOR_LIGHT_BLUE 9
#define COLOR_LIGHT_GREEN 10
#define COLOR_YELLOW 14

asm("jmp $0, $main");

float degreeToRadians(float x)
{
    return x * (180.0f / 3.14159265f);
}

float radianToDegree(float x)
{
   return x * (180.0f / 3.14159265f);
}

int abs(int x)
{
    if(x < 0)
        return -x;
    return x;
}

void sleep(int time)
{
    asm("mov $0x19, %%ah;"
        "int $0x21;"
        : :"b"(time)
    );
}

void fsincos(float x, float* sin, float* cos)
{
    asm(
        "FLD %2;"
        "FSINCOS;"
        "FSTP %0;"
        "FSTP %1"
        : "=m"(*sin), "=m"(*cos)
        : "m"(x)
    );
}

void putPixel(int x, int y, char color)
{
    if(x < 0) x = 0;
    else if(x > WIDTH) x = WIDTH - 1;

    if(y < 0) y = 0;
    else if(y > HEIGHT) y = HEIGHT - 1;

    char* ptr = (char*)(0xA0000);

    ptr += (y * WIDTH) + x;
    *ptr = color;
}

void cls(char color)
{
    char* ptr = (char*)0xA0000;

    for(int i = 0; i < WIDTH*HEIGHT; i++)
    {
        *ptr = color;
        ptr++;
    }
}

void drawLine(int x0, int y0, int x1, int y1, char color)
{
    int dx = abs(x1 - x0);
    int sx = x0 < x1 ? 1 : -1;
    int dy = -abs(y1 - y0);
    int sy = y0 < y1 ? 1 : -1;

    int err = dx + dy;
    int e2 = 0;

    while(1)
    {
        putPixel(x0, y0, color);

        if(x0 == x1 && y0 == y1)
        {
            break;
        }

        e2 = 2 * err;

        if(e2 > dy)
        {
            err += dy;
            x0 += sx;
        }

        if(e2 < dx)
        {
            err += dx;
            y0 += sy;
        }
    }
}

void drawCircle(int x, int y, float radius, char color)
{
    for(int degree = 0; degree < 360; degree++)
    {
        float sin;
        float cos;
        fsincos(degree, &sin, &cos);

        putPixel(x + (int)(cos * radius), y + (int)(sin * radius), color);
    }
}


void main(void)
{
    asm("mov $0x0013, %ax; int $0x10;");

    int offset = 0;
    while(1)
    {
        cls(COLOR_BLACK);

        int colorI = 0;
        for(int i = offset; i < (offset + 6); i++)
        {
            for(int degree = i; degree < (i + 360); degree += 6)
            {
                float sin;
                float cos;
                fsincos(degree, &sin, &cos);

                char color;
                switch(colorI)
                {
                    case 0:
                        color = COLOR_RED;
                        break;
                    case 1:
                        color = COLOR_YELLOW;
                        break;
                    case 2:
                        color = COLOR_WHITE;
                        break;
                    case 3:
                        color = COLOR_GREEN;
                        break;
                    case 4:
                        color = COLOR_BLUE;
                        break;
                    case 5:
                        color = COLOR_TURQUOISE;
                        break;
                    default:
                        color = 0;
                        break;
                }

                drawLine(CENTERX, CENTERY, CENTERX + (int)(cos * 200), CENTERY + (int)(sin * 200), color);
            }

            colorI++;
        }

        drawCircle(CENTERX, CENTERY, 25, COLOR_RED);
        drawCircle(CENTERX, CENTERY, 50, COLOR_GREEN);
        drawCircle(CENTERX, CENTERY, 100, COLOR_YELLOW);

        sleep(20);

        offset++;
    }

    asm("xor %ax, %ax;int $0x16;");

    asm("mov $0x0003, %ax; int $0x10;");

    asm("xor %ax, %ax; xor %bx, %bx; int $0x21;");
}
