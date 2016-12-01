#ifndef _COLOR_H_
#define _COLOR_H_

#include "../EasyBMP/EasyBMP.h"

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

/*struct COLOR
{
    char r;
    char g;
    char b;
};*/

ebmpBYTE getColor(ebmpBYTE r, ebmpBYTE g, ebmpBYTE b);

#endif
