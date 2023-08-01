#!/bin/bash

suma=0
iter=10
counter=$iter
a=0.1
b=0.2
echo "$a + $b" | bc 
while [ $counter -gt 0 ]
do
	./qcl git/SARG04NV/SARG04_new_IaR.qcl -o logi
	IFS=' ' read -r -a array <<< $(tail -1 logi)
	suma=$(echo "$suma + ${array[3]}" | bc) 
	echo $suma
	counter=$(( $counter - 1 ))
done
echo $(echo "$suma / $iter" | bc) 
