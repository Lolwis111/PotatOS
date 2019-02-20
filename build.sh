#!/bin/bash

build_home=$(pwd)  # copy working directory
include_system="${build_home}/include/" # globaly available include files
include_software="${build_home}/software/include/" # program internal include files
include_driver="${build_home}/driver/include/" # os internal include files
output_image_name="potatos.img" # output file name
language="english" # language to create this in, check Lang/ for available languages
language_string_list="lang/stringlist"

LIST_FILE=false
NASM_FLAGS=" -Ox -f bin " # just flags for assembler, make sure you keep '-f bin'

if [ "`whoami`" != "root" ] ; then # check if script has root rights
    echo "  You have to lunch this as root!"
    echo "  (loopback mounting is a root-only service!)"
    exit
fi

# cleaning process:
rm -f ${output_image_name}  # delete old image

cd misc # delete old strings.sys

rm -f "strings.sys"

cd ../boot/ # delte old bootloader
for i in *.bin *.lst
do
    rm -f "$i"
done

cd ../driver/ # delete old system drivers

for i in *.sys *.lst
do
    rm -f "$i"
done

cd ../loader/ # delte stage2 boot loader

for i in *.sys *.lst
do
    rm -f "$i"
done

cd ../software/ # delete old programms

for i in *.bin *.lst
do
    rm -f "$i"
done

cd ../include/
if [ -e "language.asm" ] ; then # delete language.asm 
    rm -f language.asm 
fi

cd ..

if [ "$1" = "clean" ] ; then
    echo -e "\e[92mDone!\e[39m"
    exit
fi

echo "creating language.asm"

if [ ! -e "./lang/$language" ] ; then
    echo "The Language `$language` was not found in `lang/` !";
    echo -e "\e[91mError while assembling\e[39m"
    exit
fi

./tools/MkLocale/bin/mklocale ${language} ${build_home} ${language_string_list}

if [ ! -e "./include/language.asm" ];
then
    echo -e "\e[91mError while generating language.asm!\e[39m"
    
    exit
fi

if [ ! -e $output_image_name ]
then
    echo "> create floppy image"
    mkdosfs -C $output_image_name 1440 || exit
fi
if [ $LIST_FILE = true ] ; then
    echo "create listing files"
fi

echo "> building bootloader"

list=""
if [ $LIST_FILE = true ] ; then
    list=" -l boot/boot.lst "
fi
nasm $NASM_FLAGS $list -i $include_system -o boot/boot.bin boot/boot.asm || exit

if [ $LIST_FILE = true ] ; then
    list=" -l loader/loader.lst "
fi
nasm $NASM_FLAGS $list -i $include_system -o loader/loader.sys loader/loader.asm || exit

echo "> building programms"
cd ./software/

for i in *.asm
do
    if [ $LIST_FILE = true ] ; then
        list=" -l `basename $i .asm`.lst "
    fi
    nasm $NASM_FLAGS $list -d "$language" -i $include_system -i $include_software $i -o `basename $i .asm`.bin || exit
    echo -ne "." # print a dot on success for each program
done

echo "" # newLine
echo "> building drivers"

cd ../driver/
for i in *.asm
do
    if [ $LIST_FILE = true ] ; then
        list=" -l `basename $i .asm`.lst "
    fi
    nasm $NASM_FLAGS $list -i $include_system -i $include_driver $i -o `basename $i .asm`.sys || exit
    echo -ne "." # print a dot on success for each driver
done

echo "" # newLine
echo "> building tests"

cd ../tests/
for i in *.asm
do
    if [ $LIST_FILE = true ] ; then
        list=" -l `basename $i .asm`.lst "
    fi
    nasm $NASM_FLAGS $list -i $include_system $i -o `basename $i .asm`.bin || exit
    echo -ne "." # print a dot on success for each driver
done

cd ..

echo ""
echo "> building c software"

make -C csoftware/ || exit # compile c programms

echo "" # newLine
echo "> installing bootloader"

# overwrite first sector in floppy with boot loader
dd status=noxfer conv=notrunc if=boot/boot.bin of=$output_image_name || exit

echo "> installing components"

rm -rf /tmp/tmp-loop/ # delete old mount point

mkdir /tmp/tmp-loop/ || exit # create new mount point

# mount the floopy image
sudo mount -o loop -t msdos $output_image_name /tmp/tmp-loop/ || exit

# build the folder structure
mkdir /tmp/tmp-loop/system/
mkdir /tmp/tmp-loop/tests/
mkdir /tmp/tmp-loop/images/
mkdir /tmp/tmp-loop/c-tests/

mkdir /tmp/tmp-loop/testdir1/ # create some random directories for testing purposes
mkdir /tmp/tmp-loop/testdir1/TEST1/
mkdir /tmp/tmp-loop/testdir1/TEST1/ABC/
mkdir /tmp/tmp-loop/testdir1/TEST1/DEF/
mkdir /tmp/tmp-loop/testdir1/TEST2/
mkdir /tmp/tmp-loop/testdir1/TEST3/
mkdir /tmp/tmp-loop/testdir1/TEST3/DIR12
mkdir /tmp/tmp-loop/testdir1/TEST3/TEST13
mkdir /tmp/tmp-loop/testdir1/TEST4/

cp loader/loader.sys /tmp/tmp-loop/ # copy system
cp README /tmp/tmp-loop/system/readme.txt
cp LICENSE /tmp/tmp-loop/system/license.txt
cp driver/*.sys /tmp/tmp-loop/system/ # copy the drivers
cp software/*.bin /tmp/tmp-loop/system/ # copy programms
cp csoftware/*.bin /tmp/tmp-loop/c-tests/ # copy the c software

# viewer + images are in an extra directory
mv /tmp/tmp-loop/system/viewer.bin /tmp/tmp-loop/images/viewer.bin

cp tests/*.bin /tmp/tmp-loop/tests/

echo "> copying resources"
cp -r misc/* /tmp/tmp-loop/ # copy resources

# move the images
mv /tmp/tmp-loop/*.llp /tmp/tmp-loop/images/

mv /tmp/tmp-loop/strings.sys /tmp/tmp-loop/system/

for file in /tmp/tmp-loop/system/*.* ;
do
    ./tools/Attributes/bin/attributes $file d
done;

#./archive /tmp/tmp-loop/system/strings.sys
./tools/Attributes/bin/attributes /tmp/tmp-loop/system/strings.sys sh
./tools/Attributes/bin/attributes /tmp/tmp-loop/system/system.sys sh
./tools/Attributes/bin/attributes /tmp/tmp-loop/system/sysinit.sys sh
./tools/Attributes/bin/attributes /tmp/tmp-loop/loader.sys sh

sleep 0.2 # wait a moment to make sure everything is written

echo "> release image"

umount /tmp/tmp-loop/ || exit # release floppy
rm -rf /tmp/tmp-loop/

# adjust rights
chmod a+rw $output_image_name

echo -e "\e[92m> Done $(date +"%H:%M:%S")!\e[39m"

exit
