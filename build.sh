#!/bin/bash

cleanListFiles()
{
    rm -f boot/boot.lst
    rm -f loader/loader.lst
    rm -f driver/*.lst
    rm -f software/list/*.lst
    rm -f tests/list/*.lst
}

cleanBinaries()
{
    rm -f boot/boot.bin
    rm -f loader/loader.sys
    rm -f driver/*.sys driver/*.bin
    rm -f software/bin/*bin
    rm -f tests/bin/*.bin
}

buildSoftware()
{
    cd ./software/

    # assemble the software
    for file in *.asm
    do
        if [ $LIST_FILE = true ] ; then
            list=" -l list/`basename $file .asm`.lst "
        fi

        nasm $NASM_FLAGS $dbg $list $a20 -d "$language" -i $include_system\
            -i $include_software $file -o bin/`basename $file .asm`.bin || exit

        echo -ne "." # print a dot on success for each program
    done;

    cd ..
}

buildDriver()
{
    # assemble the drivers
    cd ./driver/

    for file in *.asm
    do
        if [ $LIST_FILE = true ] ; then
            list=" -l `basename $file .asm`.lst "
        fi
        
        nasm $NASM_FLAGS $dbg $list $a20 -i $include_system\
            -i $include_driver $file -o `basename $file .asm`.sys || exit
        echo -ne "." # print a dot on success for each driver
    done;

    # the current layout does not allow system.sys to be bigger
    # than 12 KiBytes (12288 Bytes). This we check here
    systemSysSize=$(wc -c system.sys | awk '{print $1}')
    if (( systemSysSize > systemSysLimit )) ;
    then
        echo "FATAL ERROR"
        echo "System.sys is bigger than 12KiByte!"
        echo ""
        exit
    fi;

    cd ..
}

buildTests()
{
    # assemble the tests 
    cd ./tests/
    for file in *.asm
    do
        if [ $LIST_FILE = true ] ; then
            list=" -l `basename $file .asm`.lst "
        fi;
        nasm $NASM_FLAGS $dbg $list $a20 -i $include_system $file\
            -o `basename $i .asm`.bin || exit
        echo -ne "." # print a dot on success for each driver
    done;

    cd ..
}

build_home=$(pwd)  # copy working directory
include_system="${build_home}/include/" # globaly available include files
include_software="${build_home}/software/include/" # program internal include files
include_driver="${build_home}/driver/include/" # os internal include files
output_image_name="potatos.img" # output file name
language="english" # language to create this in, check Lang/ for available languages
language_string_list="lang/stringlist"
mount_point="/tmp/tmp-loop"

systemSysLimit=12288

A20=false       # assemble the code to enable the A20 gate, this allows to 
                # access the segment just over 1 MB resulting in 1MB+64KB available RAM
                # This also enables the ALLOC/FREE routines which allow programs
                # to request pages of 512 Byte in this upper segment
DEBUG=false     # assemble the debug code
LIST_FILE=true  # Generate list files 
NASM_FLAGS=" -Ox -f bin " # just flags for assembler, make sure you keep '-f bin'

if [ ! "$1" == "clean"  ] && [ "`whoami`" != "root" ] ; then # check if script has root rights
    echo "  You have to lunch this as root!"
    echo "  (loopback mounting is a root-only service!)"
    exit
fi

cleanListFiles
cleanBinaries

# delete the old files
rm -f ${output_image_name}

# delete the old generated language files
rm -f "misc/strings.sys"
rm -f include/language.asm 

# clean the 32 bit kernel software
make clean -C csoftware/kernelC/

# exit here if only clean was asked
if [ "$1" = "clean" ] ; then
    echo -e "\e[92mDone!\e[39m"
    exit
fi;

# parse the arguments
# d - disabe debug
# D - enable debug
# h - disable high memory (A20 gate)
# H - enable high memory (A20 gate)
# l - disable list file generation
# L - enable list file generation
while getopts "hHdDlL" opt;
do
    case "$opt" in
        H)
            A20=true
        ;;
        h)
            A20=false
        ;;
        D)
            DEBUG=true
        ;;
        d)
            DEBUG=false
        ;;
        L)
            LIST_FILE=true
        ;;
        l)
            LIST_FILE=false
        ;;
    esac;
done;

# generate the language files
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

echo "> testing defines.asm"

# assemble defines.asm
# this should result in a binary of size 0
# because defines.asm is supposed to only contain
# macros and %defines, but should not generate any code
nasm $NASM_FLAGS -o include/defines.bin include/defines.asm
definesBinSize=$(wc -c include/defines.bin | awk '{print $1}')
rm -f include/defines.bin
if (( definesBinSize > 0 )) ;
then
    echo "FATAL ERROR"
    echo "defines.asm should only contain macros and defines!"
    echo ""
    exit
fi;

echo "> building bootloader"

list=""
if [ $LIST_FILE = true ] ;
then
    echo "> Generate list files"
    list=" -l boot/boot.lst "
else
    echo "> Do not generate list files"
fi;

# craft the commands that enable/disable the selected features
dbg=""
a20=""
if [ $DEBUG = true ] ;
then
    echo "> Assemble debug code"
    dbg=" -d DEBUG "
else
    echo "> Do not assemble debug code"
fi;
if [ $A20 = true ] ;
then
    echo "> Assemble high memory features"
    a20=" -d A20 "
else
    echo "> Do not assemble high memory features"
fi;
# assemble the stage 1 bootloader
nasm $NASM_FLAGS $list $dbg $a20 -i $include_system -o boot/boot.bin boot/boot.asm || exit

# assemble the stage 2 bootloader
if [ $LIST_FILE = true ] ; 
then
    list=" -l loader/loader.lst "
fi;
nasm $NASM_FLAGS $dbg $list $a20 -i $include_system\
        -o loader/loader.sys loader/loader.asm || exit

echo ""
echo "> building programms"
buildSoftware

echo ""
echo "> building drivers"
buildDriver

echo "" # newLine
echo "> building tests"
buildTests

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

echo "> release image"

# unmount the image
umount $mount_point/ || exit # release floppy
rm -rf $mount_point/

# adjust rights
chmod a+rw $output_image_name

# print success message
echo -e "\e[92m> Done $(date +"%H:%M:%S")!\e[39m"

exit
