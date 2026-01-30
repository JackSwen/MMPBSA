cat /dev/null > sol_energy_$2.txt
cat /dev/null > sol_energy_$3.txt
cat /dev/null > sol_energy_complex.txt
cat /dev/null > ele_energy_$2.txt
cat /dev/null > ele_energy_$3.txt
cat /dev/null > ele_energy_complex.txt
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
head -$sep_file_num New$1| tail -$num_atom > $i/$i.pdb

##seperate chain $2 means the chain to grep
##awk -v C=$2 '{if(substr($0,22,1)==C){print $0}}' $i/$i.pdb > $i/$i$2.pdb
##awk -v C=$2 '{if(substr($0,22,1)!=C){print $0}}' $i/$i.pdb > $i/no$2.pdb
~/Documents/pdb2pqr/pdb2pqr.py --ff=charmm --chain $i/$i.pdb $i/$i.pqr
cd $i/
awk -v C=$2 '{if(substr($0,22,1)==C){print $0}}' $i.pqr > $i$2.pqr
awk -v C=$2 '{if(substr($0,22,1)!=C){print $0}}' $i.pqr > $i$3.pqr


../Delphi_Writing.sh $i$2.pqr param$i$2.txt
../Delphi_Writing.sh $i$3.pqr param$i$3.txt
../Delphi_Writing.sh $i.pqr paramcomplex$i.txt

Delphi85 param$i$2.txt > out$i$2.txt
Delphi85 param$i$3.txt > out$i$3.txt
Delphi85 paramcomplex$i.txt > outcomplex$i.txt

##/home/shengjie/Desktop/Biophysics/Delphi_backup/delphi param$i$2.txt > out$i$2.txt
##/home/shengjie/Desktop/Biophysics/Delphi_backup/delphi paramno$2.txt > outno$2.txt
##/home/shengjie/Desktop/Biophysics/Delphi_backup/delphi paramcomplex$i.txt > outcomplex$i.txt
cd ../
grep Coulombic $i/out$i$2.txt >> ele_energy_$2.txt
grep Coulombic $i/out$i$3.txt >> ele_energy_$3.txt
grep Coulombic $i/outcomplex$i.txt >> ele_energy_complex.txt

grep "Corrected reaction field energy" $i/out$i$2.txt >> sol_energy_$2.txt
grep "Corrected reaction field energy" $i/out$i$3.txt >> sol_energy_$3.txt
grep "Corrected reaction field energy" $i/outcomplex$i.txt >> sol_energy_complex.txt

done

rm New$1
rm END.Position

