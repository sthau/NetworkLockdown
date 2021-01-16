#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for param in base low long smallpox measles flu high
do
	## run parameters
	for panel in figure2_a figure2_b 
	do	
		## copy in files
		for files in graph.mat kx_policy_v3.m figure2_output.sh
		do
			cp $files $dir/$param/$panel
		done
	
		## navigate and run
		cd $dir/$param/$panel
		sbatch --array=1-3 figure2_output.sh
		sleep 2
		
		##return to main folder
		cd ../../

	done
done



