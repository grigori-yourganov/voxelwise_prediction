#!/bin/bash
#SBATCH -n 1
#SBATCH -N 5
#SBATCH --mem=100gb

matlab_input="process_chunk("$chunk")"
echo $matlab_input
output_log=$HOME"/source/predict_voxels/log_chunk"$chunk
#module load matlab/2020a
cd $HOME/source/predict_voxels
matlab -nodisplay -nosplash -r ${matlab_input} -logfile ${output_log}
