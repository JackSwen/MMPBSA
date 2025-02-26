cat /dev/null > $2
echo "scale=1.5" >> $2
echo "perfil=70.0" >> $2
echo "in(modpdb4,file=\"$1\",format = pqr)" >> $2
echo "indi=2.0" >> $2
echo "exdi=80.0" >> $2
echo "prbrad=1.4" >> $2
echo "salt=0.2" >> $2
echo "bndcon=2" >> $2
echo "maxc=0.001" >> $2
echo "linit=8000" >> $2
##echo "out(phi,file="useless.cube",format=cube)"
echo "energy(s,c,g)" >> $2
