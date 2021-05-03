#!/bin/bash
for chunk in {1..8}; do
  jobname="chunk"$chunk"_GM"
  echo $jobname
  cd $HOME/source/predict_voxels
  qsub -N $jobname -v chunk=$chunk,gm=1 qsub_chunk.sh
done

for chunk in {1..8}; do
  jobname="chunk"$chunk"_WM"
  echo $jobname
  cd $HOME/source/predict_voxels
  qsub -N $jobname -v chunk=$chunk,gm=0 qsub_chunk.sh
done
