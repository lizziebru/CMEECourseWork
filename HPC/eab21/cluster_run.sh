#!/bin/bash
#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
R --vanilla < $HOME/eab21_HPC_2021_cluster.R
mv eab21_result* $HOME
echo "R has finished running"
# this is a comment at the end of the file