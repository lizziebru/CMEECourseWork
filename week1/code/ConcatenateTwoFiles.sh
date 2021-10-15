#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: demonstrating how to concatenate the contents of two files
# Arguments: 2 -> 2 files to concatenate together
# Date: Oct 2021

# need it to give feedback to the user and exit if the right inputs aren't provided

echo "Concatenating the contents of $1 and $2..."

# if there are not two files provided, print an error message and exit
if [[ $# != 2 ]]
then 
echo 'Error: incorrect number of files provided (needs two). Exiting...'
exit
fi

# then for anything else (i.e. if there are two files provided), concatenate their two contents
cat $1 > mergedfile.sh # redirects the output from 'cat $1' to new file called 'mergedfile.sh' (overwrites it if already exists)
cat $2 >> mergedfile.sh # appends the output from 'cat $2' to file 'mergedfile.sh'
echo "Merged File is"
cat mergedfile.sh >> ../results/$3 #output to the results directory

exit