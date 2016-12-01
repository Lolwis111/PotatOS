#include "../header/Color.h"

ebmpBYTE getColor(ebmpBYTE r, ebmpBYTE g, ebmpBYTE b)
{
    if(r == 0 && g == 0 && b == 0)
    {
        return COLOR_BLACK;
    }
    else if(r == 0 && g == 0 && b == 255)
    {
        return COLOR_BLUE;
    }
    else if(r == 0 && g == 255 && b == 0)
    {
        return COLOR_GREEN;
    }
    else if(r == 0 && g == 128 && b == 128)
    {
        return COLOR_TURQUOISE;
    }
    else if(r == 255 && g == 0 && b == 0)
    {
        return COLOR_RED;
    }
    else if(r == 255 && g == 0 && b == 255)
    {
        return COLOR_PURPLE;
    }
    else if(r == 255 && g == 128 && b == 0)
    {
        return COLOR_ORANGE;
    }
    else if(r == 255 && g == 255 && b == 255)
    {
        return COLOR_WHITE;
    }
    else if(r == 128 && g == 128 && b == 128)
    {
        return COLOR_GRAY;
    }
    else if(r == 255 && g == 255 && b == 0)
    {
        return COLOR_YELLOW;
    }
    else
    {
        return COLOR_WHITE;
    }
}
