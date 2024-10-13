#!/bin/bash

# launches potatos.img in qemu
# additional parameters can be passed as arguments

image_name="potatos.img" # image file

if [ ! -e $image_name ] ; then # check if the image exists
    echo "'$image_name' not found!"
    echo "Make sure to run buildTools.sh and build.sh prior to run.sh"
    exit
fi

if [ -e "/usr/bin/qemu-system-i386" ] ; then # check if qemu exists
    qemu-system-i386 $1 -serial stdio -drive format=raw,file=potatos.img,index=0,if=floppy
elif [ -e "/usr/bin/qemu-system-x86_64" ] ; then
    qemu-system-x86_64 $1 -serial stdio -drive format=raw,file=potatos.img,index=0,if=floppy
else
    echo "Please install qemu x86/x64 for this to work!"
fi
