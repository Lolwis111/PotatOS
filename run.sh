#!/bin/bash

# launches potatos.img in qemu
# additional parameters can be passed as arguments

image_name="potatos.img" # image file

if [ ! -e $image_name ] ; then # check if the image exists
    echo "'$image_name' not found!"
    echo "Make sure to run buildTools.sh and build.sh prior to run.sh"
    exit
fi

args="-m 4M -serial stdio"
floppy="-blockdev driver=file,node-name=f0,filename=${image_name} -device floppy,drive=f0"

if [ -e "/usr/bin/qemu-system-i386" ] ; then # check if qemu exists
    qemu-system-i386 "$@" ${args} ${floppy}
elif [ -e "/usr/bin/qemu-system-x86_64" ] ; then
    qemu-system-x86_64 "$@" ${args} ${floppy}
else
    echo "Please install qemu x86/x64 for this to work!"
fi
