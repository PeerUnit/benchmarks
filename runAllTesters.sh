#!/bin/bash

HOST_FILE=hosts.txt

if [ $# -ne 4 ] 
then 
	echo Usage: runAllTesters.sh test testers testersByMachine OAR_JOB_ID
	echo Ex: runAllTesters.sh test.SimpleTest 30 15 280147
else 

	i=1
	while read line;
	do
		echo found host: $line
        address[$i]=$line
		i=$((${i} + 1))
	done< ${HOST_FILE}

	j=0
	cpt=1
	while [ $j -lt $2 ]
	do 
		nb=$3
		diff=`expr $2 - $j`
		if [ $diff -lt $nb ]
		then
			nb=`expr $diff`
		fi
		export OAR_JOB_ID=$4
		echo  oarsh ${address[${cpt}]} cd ${PWD} \; ./runTesters.sh $1 $4 $nb
		nohup oarsh ${address[${cpt}]} cd ${PWD} \; ./runTesters.sh $1 $4 $nb &
		j=`expr $j + $nb`
		cpt=`expr $cpt + 1`
	done
fi
