#!/bin/bash
#SBATCH -n 16 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 5000  # Runtime in minutes
#SBATCH -p shared # Partition to submit to
#SBATCH --mem-per-cpu 5500 # Memory per node
#SBATCH --open-mode=append # Append when writing files
#SBATCH -o panel_%a_%A.out # Standard out goes to this file
#SBATCH -e panel_%a_%A.err # Standard err goes to this file
#SBATCH --mail-user=samuelthau@college.harvard.edu 
#SBATCH --mail-type=ALL
module load matlab/R2019a-fasrc01
matlab -nodisplay-nosplash < figure_"${SLURM_ARRAY_TASK_ID}".m