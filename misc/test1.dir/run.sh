#!/bin/bash

image_name="potatos.img"

if [ ! -e $image_name ] ; then
    echo "'$image_name' nicht gefunden!"
    echo "Wurde das System gebaut?"
    exit
fi

if [ -e "/usr/bin/qemu-system-i386" ] ; then
    qemu-system-i386 -drive format=raw,file=potatos.img,index=0,if=floppy
elif [ -e "/usr/bin/qemu-system-x86_64" ] ; then
    qemu-system-x86_64 -drive format=raw,file=potatos.img,index=0,if=floppy
else
    echo "Qemu für x86 oder x86_64 muss installiert sein."
fi
