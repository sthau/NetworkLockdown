#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for param in base low long smallpox measles flu high
do
	## run parameters
	for panel in global_a global_b 
	do	
		## copy in files
		for files in graph.mat jurisdiction_policy_new.m global_output.sh
		do
			cp $files $dir/$param/$panel
		done
	
		## navigate and run
		cd $dir/$param/$panel
		sbatch global_output.sh
		sleep 2
		
		##return to main folder
		cd ../../

	done
done



