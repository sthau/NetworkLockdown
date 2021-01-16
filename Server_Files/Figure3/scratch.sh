#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


for panel in figure3_a figure3_b figure3_c figure3_d figure3_e figure3_f figure3_g figure3_h figure3_i figure3_j
do	
	mkdir -p $dir/base/$panel
done


for alt in low long flu smallpox measles
do

	for panel in figure3_a figure3_b figure3_c figure3_d figure3_e 
	do	
		mkdir -p $dir/$alt/$panel
	done
done
