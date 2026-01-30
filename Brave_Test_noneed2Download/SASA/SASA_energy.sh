cat /dev/null > SASA_energy_$2.txt
cat /dev/null > SASA_energy_$3.txt
cat /dev/null > SASA_energy_complex.txt
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
awk -v C=$2 '{if(substr($0,22,1)==C){print $0}}' $i/$i.pdb > $i/$i$2.pdb
awk -v C=$2 '{if(substr($0,22,1)!=C){print $0}}' $i/$i.pdb > $i/$i$3.pdb


~/Documents/Naccess/naccess $i/$i$2.pdb
~/Documents/Naccess/naccess $i/$i$3.pdb
~/Documents/Naccess/naccess $i/$i.pdb
awk '{if($1=="TOTAL")print $0}' $i$2.rsa >> SASA_energy_$2.txt
awk '{if($1=="TOTAL")print $0}' $i$3.rsa >> SASA_energy_$3.txt
awk '{if($1=="TOTAL")print $0}' $i.rsa >> SASA_energy_complex.txt

done
rm *.log
rm *.rsa
rm *.asa
rm New$1
rm END.Position


