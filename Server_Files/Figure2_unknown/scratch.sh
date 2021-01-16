#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for param in base low long flu smallpox measles
do
	for panel in figure2_a figure2_b 
	do	
		mkdir -p $dir/$param/$panel
	done
done
