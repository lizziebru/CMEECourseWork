#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: CountLines.sh
# Desc: count the number of lines in a file
# Arguments: 1 -> file containing lines
# Date: Oct 2021

# need it to give feedback to the user and exit if the right inputs aren't provided

echo "Counting the number of lines in $1..."

# if there's no file provided, print an error message and exit
if [ "$1" == "" ]
then 
echo 'Error: no input file provided. Exiting...'
exit
fi

# if anything else (i.e. if there is a file provided), carry out the following commands:
NumLines=`wc -l < $1` # the > changes the way that $1 is put through the command: when it's present, the contents of $1 are taken and put through the command, whereas without it the command just addresses $1 directly (means that the filename comes out in the output)
echo "The file $1 has $NumLines lines"
exit