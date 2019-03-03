#!/bin/bash

build_home=$(pwd)  # copy working directory
include_system="${build_home}/include/" # globaly available include files
include_software="${build_home}/software/include/" # program internal include files
include_driver="${build_home}/driver/include/" # os internal include files
output_image_name="potatos.img" # output file name
language="english" # language to create this in, check Lang/ for available languages
language_string_list="lang/stringlist"
mount_point="/tmp/tmp-loop"

LIST_FILE=true
NASM_FLAGS=" -Ox -f bin " # just flags for assembler, make sure you keep '-f bin'

if [ ! "$1" == "clean"  ] && [ "`whoami`" != "root" ] ; then # check if script has root rights
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

for i in bin/*.bin list/*.lst
do
    rm -f "$i"
done

cd ../include/
if [ -e "language.asm" ] ; then # delete language.asm 
    rm -f language.asm 
fi;

cd ..

make clean -C csoftware/kernelC/

if [ "$1" = "clean" ] ; then
    echo -e "\e[92mDone!\e[39m"
    exit
fi;

echo "creating language.asm"

if [ ! -e "./lang/$language" ] ; then
    echo "The Language `$language` was not found in `lang/` !";
    echo -e "\e[91mError while assembling\e[39m"
    exit
fi;

# generate the language files
./tools/MkLocale/bin/mklocale ${language} ${build_home} ${language_string_list}

# copy the generated language file
if [ ! -e "./include/language.asm" ];
then
    echo -e "\e[91mError while generating language.asm!\e[39m"
    
    exit
fi;

# create an empty floppy image with 1.44 MB
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
        list=" -l list/`basename $i .asm`.lst "
    fi

    nasm $NASM_FLAGS $list -d "$language" -i $include_system\
        -i $include_software $i -o bin/`basename $i .asm`.bin || exit

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

make -C csoftware/kernelC/ || exit # compile c programms

echo "" # newLine
echo "> installing bootloader"

# overwrite first sector in floppy with boot loader
dd status=noxfer conv=notrunc if=boot/boot.bin of=$output_image_name || exit

echo "> installing components"

rm -rf $mount_point/ # delete old mount point

mkdir $mount_point/ || exit # create new mount point

# mount the floopy image
sudo mount -o loop -t msdos $output_image_name $mount_point || exit

# build the folder structure
mkdir $mount_point/system/
mkdir $mount_point/tests/
mkdir $mount_point/images/
mkdir $mount_point/c-tests/

mkdir $mount_point/testdir1/ # create some random directories for testing purposes
mkdir $mount_point/testdir1/TEST1/
mkdir $mount_point/testdir1/TEST1/ABC/
mkdir $mount_point/testdir1/TEST1/DEF/
mkdir $mount_point/testdir1/TEST2/
mkdir $mount_point/testdir1/TEST3/
mkdir $mount_point/testdir1/TEST3/DIR12
mkdir $mount_point/testdir1/TEST3/TEST13
mkdir $mount_point/testdir1/TEST4/

cp loader/loader.sys $mount_point/ # copy system

cp README $mount_point/system/readme.txt
cp LICENSE $mount_point/system/license.txt

# copy the system files
for file in driver/*.sys
do
    echo "installing $file"
    cp $file $mount_point/system/
done;

# copy the programs
for file in software/bin/*.bin
do
    echo "installing $file"
    cp $file $mount_point/system/
done;

# cp csoftware/*.bin $mount_point/c-tests/ # copy the c software
cp csoftware/kernelC/kernel.sys $mount_point/c-tests/
cp csoftware/kernelC/pmtest.bin $mount_point/c-tests/

# viewer + images are in an extra directory
mv $mount_point/system/viewer.bin /tmp/tmp-loop/images/viewer.bin

cp tests/*.bin $mount_point/tests/

echo "> copying resources"
cp -r misc/* $mount_point/ # copy resources

# move the images
mv $mount_point/*.llp $mount_point/images/

mv $mount_point/strings.sys $mount_point/system/

for file in $mount_point/system/*.* ;
do
    ./tools/Attributes/bin/attributes $file d
done;

# set the attributes of the system files
./tools/Attributes/bin/attributes $mount_point/system/strings.sys sh
./tools/Attributes/bin/attributes $mount_point/system/system.sys sh
./tools/Attributes/bin/attributes $mount_point/system/sysinit.sys sh
./tools/Attributes/bin/attributes $mount_point/loader.sys sh

sleep 0.2 # wait a moment to make sure everything is written

echo "> release image"

umount $mount_point/ || exit # release floppy
rm -rf $mount_point/

# adjust rights
chmod a+rw $output_image_name

echo -e "\e[92m> Done $(date +"%H:%M:%S")!\e[39m"

exit
