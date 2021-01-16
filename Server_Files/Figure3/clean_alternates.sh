#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p output_alternates

panel="figure3_"
file1="figure3a_output"
file2="figure3b_output"
file3="figure3c_output"
file4="figure3d_output"
ext=".mat"

## run alternate parameters

for param in high low long flu smallpox measles
do
	mkdir output_alternate/"$param"
	for letter in a b c d e
	do
		cd $dir/$param/"${panel}${letter}"
	
		## clean
		pwd
		cp figure3A_output.mat ../../output_alternate/"$param"/"${file1}${letter}${ext}"
		cp figure3B_output.mat ../../output_alternate/"$param"/"${file2}${letter}${ext}"
		cp figure3C_output.mat ../../output_alternate/"$param"/"${file3}${letter}${ext}"
		cp figure3D_output.mat ../../output_alternate/"$param"/"${file4}${letter}${ext}"
	
		##return to main folder
		cd ../../

	done
done





























