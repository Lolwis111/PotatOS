#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include <string>
#include <cstring>
#include <sstream>
#include <vector>

#include "../header/language.h"
#include "../header/Strings.h"

#define MAX_CHAR_COUNT 4096 // die Strings.sys kann aktuell maximal eine Größe von 4096 Bytes haben

int main(int argc, char **argv)
{
    if(argc < 3) // es müssen zwei Argumente angegeben werden
    {
        std::cout << "Not enough arguments given!" << std::endl;

        return 0;
    }

    if(argv[1] == NULL) // Argument 1 ist die Sprache
    {
        std::cout << "Language can't be NULL!" << std::endl;

        return 0;
    }

    if(argv[2] == NULL) // Argument 2 ist das Arbeitsverzeichnis (root von PotatOS)
    {
        std::cout << "PotatOS-Root can't be NULL!" << std::endl;
    }

    std::string argument(argv[1]);
    std::string posRoot(argv[2]);

    std::string fileName = posRoot + "/Lang/" + argument; // Pfad zur Sprache bauen

    struct stat buffer;
    if(stat(fileName.c_str(), &buffer) != 0) // Prüfen ob zur angegebnen Sprache 
    {                                        // eine Datei exisiert

        // wenn nein dann abbrechen
        std::cout << "Language " << fileName << " was not found!" << std::endl;

        return 0;
    }

    std::ifstream inFile(fileName.c_str());
    std::string line;

    std::vector<SYS_STRING> strings;

    int charSum = 0;
    while(std::getline(inFile, line)) // jede Zeile in der Datei entspricht einem String
    {
        size_t split = line.find("="); // welcher im Format NAME="WERT" vorliegen muss
        std::string attr = line.substr(0, split); // Name extrahieren
        
        size_t vStart = line.find("\"", split); // Start-
        size_t vEnd = line.find("\"", vStart+1); //und Endanführungszeichen suchen

        std::string value = line.substr(vStart + 1, vEnd - vStart - 1); // den Wert extrahieren
         
        StringReplace(value, "\\n", "\n\r"); // newLines erzeugen

        struct SYS_STRING str;     // einen neuen Systemstring mit den gerade
        str.size = value.length(); // extrahierten Werten erzeugen
        str.value = value;
        str.name = attr;

        charSum += str.size;    // die Länge in Bytes mitzählen

        strings.push_back(str); // den neuen SystemString in einer List ablegen
    }

    inFile.close();

    if(charSum > MAX_CHAR_COUNT) // Überprüfen ob die Maximalgröße eingehalten wurde
    {
        std::cout << "Length of " 
                  << MAX_CHAR_COUNT << " exceeded by " 
                  << (charSum - MAX_CHAR_COUNT) << " Bytes";

        return -1;
    }

    fileName = posRoot + "/include/language.asm"; // den Pfad zur language.asm bauen
    std::string fileName2 = posRoot + "/Misc/strings.sys"; // den Pfad zur strings.sys bauen
    std::ofstream languageFile(fileName.c_str());
    std::ofstream stringsFile(fileName2.c_str());

    /*
     * In der Datei language.asm werden nur die (absoluten) Adressen
     * zu den einzelnen Strings abgelegt. Diese Datei kann in jedes
     * Programm Problemlos eingebunden werden, da es die Größe der
     * Binärdatei nicht verändert.
     *
     * Die eigentlichen Strings werden alle hintereinander in die Strings.sys
     * geschrieben (\0-terminiert). 
     * Diese Datei muss von keinem Programm explizit eingebunden werden, denn
     * das System legt diese Automatisch in den Arbeitsspeicher.
     * Wichtig sind nur die Adresse aus language.asm.
     */

    languageFile << "%ifndef _LANGUAGE_H_" << std::endl;
    languageFile << "%define _LANGUAGE_H_" << std::endl;

    int offset = 0x8000;

    for(unsigned i = 0; i < strings.size(); i++)
    {
        languageFile << "  %define " << strings[i].name << " " << offset << std::endl;
        offset += strings[i].size + 1;

        const char *buffer = strings[i].value.c_str();
        stringsFile.write(buffer, strlen(buffer));
        stringsFile.put((char)0x00);
    }

    languageFile << "%endif";

    languageFile.close(); 
    stringsFile.close();
}
