#include <iostream>
#include <string>
#include <cstring>
#include <fstream>
#include <sys/stat.h>

#include "../EasyBMP/EasyBMP.h"
#include "../header/Color.h"

int main(int argc, char **argv)
{
    if(argc < 3)
    {
        std::cout << "Not enough arguments!" << std::endl
                  << "format: llp input.bmp output.llp" << std::endl;
        return 1;
    }
    
    
    struct stat buffer;
    if(stat(argv[1], &buffer) != 0) // check if image exists
    {
        std::cerr << "Inputfile '" << argv[2] 
                  << "' not found!" << std::endl;
                  
        return 1;
    }

    std::ofstream outfile(argv[2]);

    outfile.put((unsigned char)0x4C); // L
    outfile.put((unsigned char)0x4C); // L 
    outfile.put((unsigned char)0x50); // P

    BMP bitmap;
    bitmap.ReadFromFile(argv[1]);
    
    int w = bitmap.TellWidth();
    int h = bitmap.TellHeight();
    
    std::cout << "Size: [" << w << "x" << h << "]" << std::endl;
    
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
                
                if(counter == 255 || x == w) break;
                
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
