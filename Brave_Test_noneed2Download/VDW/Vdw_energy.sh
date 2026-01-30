cat /dev/null > Vdw_energy_$2.txt
cat /dev/null > Vdw_energy_$3.txt
cat /dev/null > Vdw_energy_complex.txt
a=$(head -1 $1 | awk '{print $1}')
if [ $a != 'ATOM' ]
 then
 sed '1d' $1 > New$1 
 else
 cp $1 New$1
fi
grep -n END New$1 > END.Position
sed -i 's/:/ /g' END.Position
##get the number of frames
num_frame=$(wc END.Position|awk '{print $1}')

##create the folders and seperate the pdb file
for ((i=1;i<=$num_frame;i++)) 
do
##create folders
mkdir $i
##get the number of atom of every seperated pdb file
num_atom=$(head -1 END.Position| awk '{print $1}')
##seperate PDB file and save to 1 to num_frame folders
sep_file_num=$(head -$i END.Position| tail -1| awk '{print $1}')
head -$sep_file_num New$1| tail -$num_atom > $i/complex.pdb

##seperate chain 
awk -v C=$2 '{if(substr($0,22,1)==C){print $0}}' $i/complex.pdb > $i/$2.pdb
awk -v C=$2 '{if(substr($0,22,1)!=C){print $0}}' $i/complex.pdb > $i/$3.pdb


##copy the configure file and modification
cp complex.config $2.config $3.config  $i/
mkdir $i/out_complex/
mkdir $i/out_$2/
mkdir $i/out_$3/

cd $i/
namd2 complex.config > out_complex.txt
namd2 $2.config > out_$2.txt
namd2 $3.config > out_$3.txt

cd ../

grep ENERGY $i/out_complex.txt | tail -1 | awk '{print $8}' >> Vdw_energy_complex.txt
grep ENERGY $i/out_$2.txt | tail -1 | awk '{print $8}' >> Vdw_energy_$2.txt
grep ENERGY $i/out_$3.txt | tail -1 | awk '{print $8}' >> Vdw_energy_$3.txt

done

rm New$1
rm END.Position


