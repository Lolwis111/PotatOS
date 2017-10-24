#include <string>
#include "language.h"

struct find_string
{
    std::string name;
    find_string(std::string name) : name(name) {}
    
    bool operator() ( const struct SYS_STRING& str ) const
    {
        return (str.name.compare(name) == 0);
    }
};
