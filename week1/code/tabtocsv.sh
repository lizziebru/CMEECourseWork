#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas and save the output as a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2021

# need it to give feedback to the user and exit if the right inputs aren't provided

echo "Creating a comma delimited version of $1..."

# if there's no file provided, print an error message and exit
if [ "$1" == "" ]
then 
echo 'Error: no input file provided. Exiting...'
exit
fi

# then for anything else (i.e. if there is a file provided), substitute the tabs in the files with commas
cat $1 | tr -s "\t" "," >> ../results/$1.csv #output to the results directory
echo "Done!"

exit