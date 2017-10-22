#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include <string>
#include <cstring>
#include <sstream>
#include <vector>

#include "../header/language.h"
#include "../header/Strings.h"

#define MAX_CHAR_COUNT 4096 // strings.sys is limited to 4096 bytes

int main(int argc, char **argv)
{
    if(argc < 3) // there have to be two arguments
    {
        std::cout << "Not enough arguments given!" << std::endl;

        return 0;
    }

    if(argv[1] == NULL) // first argument describes the langauge
    {
        std::cout << "Language can't be NULL!" << std::endl;

        return 0;
    }

    if(argv[2] == NULL) // the second one is the current pwd
    {
        std::cout << "PotatOS-Root can't be NULL!" << std::endl;
    }

    std::string argument(argv[1]);
    std::string posRoot(argv[2]);

    std::string fileName = posRoot + "/lang/" + argument; // build the path

    struct stat buffer;
    if(stat(fileName.c_str(), &buffer) != 0) // check if the language exists
    {

        // if no -> its an error
        std::cerr << "Language " << fileName << " was not found!" << std::endl;

        return 0;
    }

    std::ifstream inFile(fileName.c_str());
    std::string line;

    std::vector<SYS_STRING> strings;

	std::vector<std::string> lines;

	while(std::getline(inFile, line)) // read in all the lines of the file
	{
		lines.push_back(line);
	}

	int charSum = 0;

	bool inBlock = false; 	// indicates if we're reading a BEGIN...END
							// block right now
	std::string currentName("");
	std::string currentString("\\r\\n");	
			
	for(size_t i = 0; i < lines.size(); i++) 
	{
		if(!inBlock)
		{
			// check if the line starts with BEGIN
			if(lines[i].compare(0, 6, "BEGIN ") == 0)
			{
				inBlock = true; // if yes we found a block
				currentName = lines[i].substr(6); // 
				currentString = "\\r\\n";
			}
			// else: ignore lines which are not in BEGIN...END blocks
		}
		else if(inBlock)
		{
			if(lines[i].compare(0, 3, "END") == 0)
			{
				inBlock = false;
				
				struct SYS_STRING str;
				str.size = currentString.length();
				str.value = currentString;
				str.name = currentName;
				
				charSum += str.size;
				
				strings.push_back(str);
			}
			else
			{
				currentString += lines[i];
				currentString += "\\r\\n";
			}
		}
	}
	
	struct SYS_STRING newLine; // hardcoded string: Newline
	newLine.size = 2;
	newLine.value = "\\r\\n";
	newLine.name = "NEWLINE";

	strings.push_back(newLine);

    inFile.close();

    if(charSum > MAX_CHAR_COUNT) // check if we reached size limit
    {
        std::cerr << "Length of " 
                  << MAX_CHAR_COUNT << " exceeded by " 
                  << (charSum - MAX_CHAR_COUNT) << " Bytes";

        return -1;
    }

    fileName = posRoot + "/include/language.asm"; // build path to output file
    std::string fileName2 = posRoot + "/misc/strings.sys"; // build path to second output file
    std::ofstream languageFile(fileName.c_str());
    std::ofstream stringsFile(fileName2.c_str());

    /*
     * The file language.asm only contains the absolut addresses to the
     * strings. Every program can include this file and use the defines
     * inside to address the system string.
     *
     * The strings itself are stored in strings.sys, which is loaded
     * by the OS. Software developers don't have to worry about
     * this file.
     */

    languageFile << "%ifndef _LANGUAGE_H_" << std::endl;
    languageFile << "%define _LANGUAGE_H_" << std::endl;

    int offset = 0x8000;

    for(unsigned i = 0; i < strings.size(); i++)
    {
		// define offset for that string in language.asm
		
        languageFile << "  %define " << strings[i].name
					 << " " << offset << std::endl;
					 
		// calculate offset of next string
        offset += strings[i].size + 1;

		// write the string itself
        const char *buffer = strings[i].value.c_str();
        stringsFile.write(buffer, strlen(buffer));
        // and zero terminate it
        stringsFile.put((char)0x00);
    }

    languageFile << "%endif";

    languageFile.close(); 
    stringsFile.close();
}
