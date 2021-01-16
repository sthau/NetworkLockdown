#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


for param in low long smallpox measles flu
do
	## run parameters
	for panel in figure3_a figure3_b figure3_c figure3_d figure3_e 
	do	
		## copy in files
		for files in graph.mat jurisdiction_policy_new.m figure3_output.sh $param/figure_4.m $param/figure_5.m $param/figure_6.m $param/figure_7.m
		do
			cp $files $dir/$param/$panel
		done
	
		## navigate and run
		cd $dir/$param/$panel
		sbatch --array=4-7 figure3_output.sh
		sleep 2
		
		##return to main folder
		cd ../../

	done
done