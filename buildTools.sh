cd Tools/MkLocale/bin # Tool: MkLocale bereinigen
rm -f mklocale
cd ..
cd obj
for i in *.o
do
    rm -f "$i"
done
cd ../../../

cd Tools/LLP/bin # Tool: MkLocale bereinigen
rm -f llp
cd ..
cd obj
for i in *.o
do
    rm -f "$i"
done
cd ../../../

echo "Erzeuge Tools..."
make -C Tools/MkLocale
make -C Tools/LLP
