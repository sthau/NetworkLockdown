#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p output_base

panel="figure3_"
file1="figure3a_output"
file2="figure3b_output"
file3="figure3c_output"
file4="figure3d_output"
ext=".mat"

## run main parameters
for letter in a b c d e f g h i j
do
	cd $dir/base/"${panel}${letter}"

	## clean
	pwd
	cp figure3A_output.mat ../../output_base/"${file1}${letter}${ext}"
	cp figure3B_output.mat ../../output_base/"${file2}${letter}${ext}"
	cp figure3C_output.mat ../../output_base/"${file3}${letter}${ext}"
	cp figure3D_output.mat ../../output_base/"${file4}${letter}${ext}"

	##return to main folder
	cd ../../

done

























