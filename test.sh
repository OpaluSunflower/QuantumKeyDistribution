#!/bin/bash
files=("IaR" "PNS" "Ent")
for f in ${files[@]}; do
	#suma=0
	#sumb=0
	#MAXa=0
	#MAXb=0
	#a=0
	#d=$(date +%s)
	keylengths=(8 16 64 256 1024) 
	#read iter
	iter=1000
	for k in ${keylengths[@]};do
		suma=0
		sumb=0
		MAXa=0
		MAXb=0
		MINb=1
		a=0
		d=$(date +%s)
		#read keylength
		keylength=$k
		counter=$iter 
		while [ $counter -gt 0 ]
		do
			d=$(( $d + 1 ))
			printf $keylength | ./qcl SARG04/v2/SARG04_new_$f.qcl -s $d -o logi
			IFS=' ' read -r -a array <<< $(tail -2 logi | head -n 1)
			suma=$(echo $suma + ${array[1]} | bc)
			if (( $(echo "${array[1]} > $MAXa" |bc -l) )); then
				MAXa=${array[1]}
			fi
			IFS=' ' read -r -a array <<< $(tail -1 logi)
			sumb=$(echo $sumb + ${array[1]} | bc)
			if (( $(echo "${array[1]} > $MAXb" |bc -l) )); then
				MAXb=${array[1]}
			fi
			if (( $(echo "${array[1]} < $MINb" |bc -l) )); then
				MINb=${array[1]}
			fi
			counter=$(( $counter - 1 ))
		done
		echo "SARG04_"$f " " $keylength>> resultsSARG04_2.txt
		echo "Odtworzenie klucza" $(echo "scale=3; $suma / $iter" | bc) >> resultsSARG04_2.txt 
		echo "Wykryte podsłuchy" $(echo "scale=3; $sumb / $iter" | bc) >> resultsSARG04_2.txt
		echo "Maksymalny odtworzenie klucza" $MAXa >> resultsSARG04_2.txt
		echo "Maksymalne wykrycie podsłuchów" $MAXb >> resultsSARG04_2.txt
		echo "Minimalne wykrycie podsłuchów" $MINb >> resultsSARG04_2.txt
		echo " " >> resultsSARG04_2.txt
	done
done
