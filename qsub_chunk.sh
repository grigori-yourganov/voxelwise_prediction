#!/bin/bash
#PBS -l select=1:ncpus=30:mem=300gb:interconnect=hdr
#PBS -l walltime=72:00:00
#PBS -j oe

matlab_input="process_chunk("$chunk")"
echo $matlab_input
output_log=$HOME"/source/predict_voxels/log_chunk"$chunk
module load matlab/2020a
cd $HOME/source/predict_voxels
matlab -nodisplay -nosplash -r ${matlab_input} -logfile ${output_log}
