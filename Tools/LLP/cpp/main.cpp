#include <iostream>
#include <string>
#include <cstring>
#include <fstream>

#include "../EasyBMP/EasyBMP.h"
#include "../header/Color.h"

int main(int argc, char **argv)
{
    if(argc < 3)
    {
        std::cout << "Not enough arguments!" << std::endl;
        return 0;
    }
    
    std::string outputFilename = argv[2];
    std::ofstream outfile(outputFilename.c_str());

    outfile.put((unsigned char)0x4C); // L
    outfile.put((unsigned char)0x4C); // L 
    outfile.put((unsigned char)0x50); // P

    BMP bitmap;
    bitmap.ReadFromFile(argv[1]);
    int w = bitmap.TellWidth();
    int h = bitmap.TellHeight();
    for(int y = 0; y < h; y++)
    {
        for(int x = 0; x < w; x++)
        {
            ebmpBYTE r1 = bitmap(x, y)->Red;
            ebmpBYTE g1 = bitmap(x, y)->Green;
            ebmpBYTE b1 = bitmap(x, y)->Blue;
            ebmpBYTE r2 = r1;
            ebmpBYTE g2 = g1;
            ebmpBYTE b2 = b1;
            unsigned char counter = 1;
            while(r1 == r2 && g1 == g2 && b1 == b2)
            {
                counter++;
                x++;
                //if(x == w || counter == 255) break;
                if(counter == 255) break;
                r2 = bitmap(x, y)->Red;
                g2 = bitmap(x, y)->Green;
                b2 = bitmap(x, y)->Blue;
            }
            x--;
           
            outfile.put(counter);
            outfile.put((unsigned char)getColor(r1, g1, b1));
        }
    }

    outfile.close();

    return 0;
}
