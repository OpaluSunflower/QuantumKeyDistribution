#!/bin/bash

suma=0
sumb=0
a=0
d=$(date +%s) 
read iter
read keylength
counter=$iter 
while [ $counter -gt 0 ]
do
	d=$(( $d + 1 ))
	printf $keylength | ./qcl BB84/v2/BB84_new_IaR.qcl -s $d -o logi
	IFS=' ' read -r -a array <<< $(tail -2 logi | head -n 1)
	suma=$(echo $suma + ${array[1]} | bc)
	IFS=' ' read -r -a array <<< $(tail -1 logi)
	sumb=$(echo $sumb + ${array[1]} | bc)
	counter=$(( $counter - 1 ))
done
echo "Odtworzenie klucza" $(echo "scale=3; $suma / $iter" | bc) 
echo "Wykryte podsłuchy" $(echo "scale=3; $sumb / $iter" | bc)
