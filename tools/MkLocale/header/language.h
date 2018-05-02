#ifndef _LANGUAGE_H_
#define _LANGUAGE_H_
#include <string>

// Definiert ein SystemString
// welcher durch einen Bezeichner, einen Wert und
// seine Länge gekennzeichnet ist.
struct SYS_STRING
{
    std::string name;
    std::string value;
    int size;
};

#endif
