cd tools/MkLocale/bin # Tool: clean MkLocale
rm -f mklocale
cd ..
cd obj
for i in *.o
do
    rm -f "$i"
done
cd ../../../

cd tools/LLP/bin # Tool: clean MkLocale
rm -f llp
cd ..
cd obj
for i in *.o
do
    rm -f "$i"
done
cd ../../../

cd tools/Attributes/bin # Tool: clean Attributes
rm -f attributes
cd ..
cd obj
for i in *.o
do
    rm -f "$i"
done
cd ../../../

echo "> building tools..."
make -C tools/MkLocale
make -C tools/LLP
make -C tools/Attributes
