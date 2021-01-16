#!/bin/bash
#SBATCH -n 20 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 300  # Runtime in minutes
#SBATCH -p serial_requeue # Partition to submit to
#SBATCH --mem-per-cpu 4000 # Memory per node
#SBATCH --open-mode=append # Append when writing files
#SBATCH -o global.out # Standard out goes to this file
#SBATCH -e global.err # Standard err goes to this file
module load matlab/R2019a-fasrc01
matlab -nodisplay-nosplash < figure_global.m
