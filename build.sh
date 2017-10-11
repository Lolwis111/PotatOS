#!/bin/bash

build_home=$PWD  # copy working directory
include_system="$build_home/include/" # globaly available include files
include_software="$build_home/software/include/" # program internal include files
include_driver="$build_home/driver/include/" # os internal include files
output_image_name="potatos.img" # output file name
language="english" # language to create this in, check Lang/ for available languages

LIST_FILE=false
NASM_FLAGS=" -Ox -f bin " # just flags for assembler, make sure you keep '-f bin'

if [ "`whoami`" != "root" ] ; then # check if script has root rights
	echo "  You have to lunch this as root!"
    echo "  (loopback mounting is a root-only service!)"
	exit
fi

buildCounter=$(cat .builds)
echo "${buildCounter} builds since 6th October 2017"

# cleaning process:
rm -f $output_image_name  # delete old image

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

if [ "$1" == "experimental" ] ; then
    echo "compiling experimental 32-bit components"
    make -C experimental/
fi

echo "creating language.asm"
if [ ! -e "./lang/$language" ] ; then
    echo "The Language `$language` was not found in `lang/` !";
    echo -e "\e[91mError while assembling\e[39m"
    exit
fi

./tools/MkLocale/bin/mklocale $language $build_home || exit

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
echo "" # newLine

echo "> installing bootloader"
# overwrite first sector in floppy with boot loader
dd status=noxfer conv=notrunc if=boot/boot.bin of=$output_image_name || exit

echo "> installing components"
rm -rf tmp-loop/ # delete old mount point
mkdir tmp-loop/ || exit # create new mount point
mount -o loop -t msdos $output_image_name tmp-loop/ || exit

mkdir tmp-loop/system/

cp loader/loader.sys tmp-loop/ # copy system
cp README tmp-loop/readme.txt

cp driver/*.sys tmp-loop/system/ # copy the drivers
cp software/*.bin tmp-loop/system/ # copy programms

echo "> copying resources"
cp -r misc/* tmp-loop/ # copy resources
mv tmp-loop/strings.sys tmp-loop/system/

if [ "$1" == "experimental" ] ; then
    echo "> installing 32-bit components"
    cp experimental/*.bin tmp-loop/system/
fi

sleep 0.2 # wait a moment to make sure everything is written

echo "> release image"
umount tmp-loop/ || exit # release floppy

rm -rf tmp-loop/

# adjust rights
chmod a+rw $output_image_name

echo -e "\e[92m> Done $(date +"%H:%M:%S")!\e[39m"

((buildCounter++))
echo ${buildCounter} > .builds

exit
