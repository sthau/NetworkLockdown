#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p global_output

panel="global_"
file1="global_output"
ext=".mat"

## run alternate parameters

for param in base high low long flu smallpox measles
do
	mkdir -p global_output/"$param"
	for letter in a b
	do
		cd $dir/$param/"${panel}${letter}"
	
		## clean
		pwd
		cp global_output.mat ../../global_output/"$param"/"${file1}${letter}${ext}"

		##return to main folder
		cd ../../

	done
done