#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


## run main parameters
for panel in figure3_a figure3_b figure3_c figure3_d figure3_e figure3_f figure3_g figure3_h figure3_i figure3_j
do	
	## copy in files
	for files in graph.mat jurisdiction_policy_new.m figure3_output.sh base/figure_4.m base/figure_5.m base/figure_6.m base/figure_7.m
	do
		cp $files $dir/base/$panel
	done
	
	## navigate and run
	cd $dir/base/$panel
	sbatch --array=4-7 figure3_output.sh
	sleep 2
	
	##return to main folder
	cd ../../

done

