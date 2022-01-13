#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: csvtospace.sh
# Desc: takes a comma separated values file and converts it to space separated values file
# Arguments: 1 -> comma separated values file
# Date: Oct 2021

# needs to not change the input file - shoudl save it as a differently named file
# should be able to handle wrong/missing inputs like for the others

echo "Converting comma separated values file $1 to space separated values file..."

# if there's no file provided, print an error message and exit
if [ "$1" == "" ]
then 
echo 'Error: no input file provided. Exiting...'
exit
fi

# if anything else (i.e. if there is a file provided), replace commas with spaces
sed -e 's/,/ /g' $1 >> ../results/`basename -s .csv $1`.txt #output to the results directory

exit
