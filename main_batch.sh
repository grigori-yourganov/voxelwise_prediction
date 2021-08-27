#!/bin/bash
for chunk in {1..8}; do
  jobname="chunk"$chunk"_i3m"
  echo $jobname
  cd $HOME/source/predict_voxels
  qsub -N $jobname -v chunk=$chunk qsub_chunk.sh
done
