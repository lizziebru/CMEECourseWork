#!/bin/bash
#PBS -l walltime=00:08:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
cd $HOME/eab21
echo "R is about to run"
R --vanilla $HOME/eab21/eab21_HPC_2021_cluster.R
mv $HOME/eab21/results/eab21_result* $HOME
echo "R has finished running"
# this is a comment at the end of the file