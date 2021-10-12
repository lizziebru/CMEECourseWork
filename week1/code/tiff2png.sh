#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: tiff2png.sh
# Desc: demonstrating how to convert tiff to png
# Arguments: none
# Date: Oct 2021

for f in *.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done