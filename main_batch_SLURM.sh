#!/bin/bash
###
###SBATCH directives follow
###
### -n requests total cores. 
### With 7 cores we can run 4 jobs at once on the soph queue nodes
#SBATCH -n 7
### -N requests a number of nodes. In this case, we are requesting 1 node
#SBATCH -N 1
### -p requests a queue
#SBATCH -p soph
# set the number of jobs in the array
#SBATCH --array=1-8
#
#  Some debugging info
#
# prints the hostname
echo -n "hostname:"
hostname
# prints the current date
echo -n "current date:"
date
#
# set up TMPDIR because /tmp is small on Hyperion
#
export TEMPROOT=/local/`whoami`
mkdir -p $TEMPROOT
export TMPDIR=$TEMPROOT/${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}
mkdir -p $TMPDIR
#
#  Load the module for MATLAB and set up the MATLABPATH and other stuff
#
module load matlab
export FLAB=/work/fridriks-lab
export MATLABPATH=${FLAB}/voxelwise_prediction/programs:${FLAB}/spm12:${FLAB}/NiiStat:$MATLABPATH
export TZ=America/New_York
#export EDITOR=cat
#stamp=`date +%Y%m%d%H%M%S`
printenv | grep PATH
#
#  Set up paths for INPUT, OUTPUT, and EXCELFILE
#
export INPUT=${FLAB}/voxelwise_prediction/test-input/i3mT1.mat
echo INPUT=${INPUT}
export OUTPUT=${FLAB}/voxelwise_prediction/test-output2
echo OUTPUT=${OUTPUT}
export EXCELFILE=${FLAB}/voxelwise_prediction/test-input/baseline_imputed.xlsx
echo EXCELFILE=${EXCELFILE}
#
#  Show the matlab command we are running, and run it
#
echo time matlab -nodisplay -r "process_chunk(${SLURM_ARRAY_TASK_ID}, '${INPUT}', '${OUTPUT}', '${EXCELFILE}' );quit" -logfile process_chunk_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log
time matlab -nodisplay -r "process_chunk(${SLURM_ARRAY_TASK_ID}, '${INPUT}', '${OUTPUT}', '${EXCELFILE}' );quit" -logfile process_chunk_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log
#
#  Change group ownership of the output and clean up $TMPDIR
#
chgrp -R fridriks-lab ${OUTPUT}
#chmod -R g+w ${OUTPUT}
rm -rf $TMPDIR
echo "done"
