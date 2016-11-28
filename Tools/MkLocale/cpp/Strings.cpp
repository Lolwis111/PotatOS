#include <string>
#include "../header/Strings.h"

int StringReplace(std::string& str, const std::string& search, const std::string& replace)
{
    if(replace.length() == 0) // wenn der gesuchte String leer ist gibt es nichts zu tun
    {
        return 0;
    }

    int count = 0;

    size_t pos = 0;
    while((pos = str.find(search, pos)) != std::string::npos)
    {
        str.replace(pos, search.length(), replace);
        pos += replace.length();
        count++;
    }

    return count; // die Anzahl an Austauschungen zurückgeben
}
