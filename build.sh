#!/bin/bash

build_home=$PWD  # Das aktuelle Arbeitsverzeichnis
include_system="$build_home/include/" # Pfad zu den systemweiten Include-Dateien
include_software="$build_home/Software/include/" # softwarespezifische Include-Dateien
include_driver="$build_home/Treiber/include/" # systemspezifische Include-Dateien
output_image_name="potatos.img" # Name des Ausgabeimages
language="english" # zu erzeugende Sprache. Alle verfügbaren sind im Verzeichnis Lang/

LIST_FILE=false
NASM_FLAGS=" -Ox -w+oprhan-labels -f bin " # Mit Vorsicht verändern! -f bin ist wichtig! 
                                           # Ebenso die Leerzeichen an Anfang und Ende!!

if [ "`whoami`" != "root" ] ; then # Prüfen ob als root ausgeführt wird
	echo "  Der Build muss als root ausgeführt werden!"
    echo "  (Das loopback-mounting funktioniert sonst nicht!)"
	exit
fi

# Säuberungsprozess:
rm -f $output_image_name  # Image löschen
cd Misc # alte string-Datei löschen
rm -f "strings.sys"
cd ..
cd Boot # alten Bootloader löschen
for i in *.bin *.lst
do
    rm -f "$i"
done
cd ..
cd Treiber # alte Systemdateien löschen
for i in *.sys *.lst
do
    rm -f "$i"
done
cd ..
cd Loader # alte Stage2 Komponenten löschen
for i in *.sys *.lst
do
    rm -f "$i"
done
cd ..
cd Main # alte Komandozeilenkomponenten löschen
for i in *.sys *.lst
do
    rm -f "$i"
done
cd ..
cd Software # alte Programme löschen
for i in *.bin *.lst
do
    rm -f "$i"
done
cd ..

cd include
if [ -e "language.asm" ] ; then # language.asm löschen 
    rm -f language.asm 
fi
cd ..

if [ "$1" = "clean" ] ; then
    echo -e "\e[92mFertig!\e[39m"
    exit
fi

echo "Erzeuge experimentelle 32-Bit Komponenten..."
make -C Experimental/

echo "Erzeuge language.asm..."
if [ ! -e "./Lang/$language" ] ; then
    echo "Die Sprache `$language` wurde nicht im Verzeichnis `Lang/` gefunden!";
    echo -e "\e[91mFehler beim Build\e[39m"
    exit
fi

./Tools/MkLocale/bin/mklocale $language $build_home || exit

if [ ! -e $output_image_name ]
then
	echo "> Floppyimage erzeugen..."
	mkdosfs -C $output_image_name 1440 || exit
fi

if [ $LIST_FILE = true ] ; then
    echo "Erzeuge zusätzliche List-files"
fi

echo "> Bootloader erzeugen..."
list=""
if [ $LIST_FILE = true ] ; then
    list=" -l Boot/boot.lst "
fi
nasm $NASM_FLAGS $list -i $include_system -o Boot/boot.bin Boot/boot.asm || exit

if [ $LIST_FILE = true ] ; then
    list=" -l Loader/loader.lst "
fi
nasm $NASM_FLAGS $list -i $include_system -o Loader/loader.sys Loader/loader.asm || exit

echo "> CMD erzeugen..."
cd Main
if [ $LIST_FILE = true ] ; then
    list=" -l main.lst "
fi
nasm $NASM_FLAGS $list -i $include_system -o main.sys main.asm || exit
cd ..

echo "> Programme erzeugen..."
cd Software
for i in *.asm
do
    if [ $LIST_FILE = true ] ; then
        list=" -l `basename $i .asm`.lst "
    fi
	nasm $NASM_FLAGS $list -d "$language" -i $include_system -i $include_software $i -o `basename $i .asm`.bin || exit
    echo -ne "." # für jedes Programm einen Punkt ausgeben
done
cd ..

echo "" # newLine

echo "> System erzeugen..."
cd Treiber
for i in *.asm
do
    if [ $LIST_FILE = true ] ; then
        list=" -l `basename $i .asm`.lst "
    fi
    nasm $NASM_FLAGS $list -i $include_system -i $include_driver $i -o `basename $i .asm`.sys || exit
    echo -ne "." # für jeden Treiber einen Punkt ausgeben
done
cd ..

echo "" # newLine

echo "> Bootloader installieren..."
# die ersten 512 Bytes mit dem Bootloader überschreiben
dd status=noxfer conv=notrunc if=Boot/boot.bin of=$output_image_name || exit


echo "> Komponenten installieren..."
rm -rf tmp-loop # alten Mountpunkt löschen
mkdir tmp-loop || exit # neuen Mountpunkt anlegen
mount -o loop -t msdos $output_image_name tmp-loop || exit

cp Loader/loader.sys tmp-loop/ # System kopieren
cp Main/main.sys tmp-loop

cp Software/*.bin Treiber/*.sys tmp-loop # Alle Programme und Treiber kopieren

echo "> Resourcen installieren..."
cp Misc/*.* tmp-loop # Resourcen kopieren

sleep 0.2 # kurz warten (Abschluss der Schreibvorgänge)

echo "> Image freigeben"
umount tmp-loop || exit # floppy freigeben

rm -rf tmp-loop 

# Rechte anpassen
chmod a+rw $output_image_name

echo -e "\e[92m> Fertig!\e[39m"

exit
