#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p fig2_output

panel="figure2_"
file1="figure2a_output"
file2="figure2b_output"
file3="figure2d_output"
ext=".mat"

## run alternate parameters

for param in base high low long flu smallpox measles
do
	mkdir -p fig2_output/"$param"
	for letter in a b
	do
		cd $dir/$param/"${panel}${letter}"
	
		## clean
		pwd
		cp figure2A_output.mat ../../fig2_output/"$param"/"${file1}${letter}${ext}"
		cp figure2B_output.mat ../../fig2_output/"$param"/"${file2}${letter}${ext}"
		cp figure2D_output.mat ../../fig2_output/"$param"/"${file3}${letter}${ext}"
	
		##return to main folder
		cd ../../

	done
done