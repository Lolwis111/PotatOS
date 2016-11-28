#ifndef _STRING_MANIPULATE_H_
#define _STRING_MANIPULATE_H_

#include <string>

// ersetzt alle Vorkommen von <search> durch <replace> in <str>.
int StringReplace(std::string& str, const std::string& search, const std::string& replace);

#endif
