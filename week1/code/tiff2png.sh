#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: tiff2png.sh
# Desc: demonstrating how to convert tiff to png
# Arguments: 1 -> tiff file
# Date: Oct 2021

echo "Converting tiff file $1 to png..."

# if there's no file provided, print an error message and exit
if [ "$1" == "" ]
then 
echo 'Error: no input file provided. Exiting...'
exit
fi

# if anything else (i.e. if there is a file provided), carry out the following commands:
for f in *.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done

exit