#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: demonstrating how to concatenate the contents of two files
# Arguments: none
# Date: Oct 2021

cat $1 > $3 # redirects the output from 'cat $1' to file $3 (overwrites it if $3 already exists)
cat $2 >> $3 # appends the output from 'cat $2' to file $3
echo "Merged File is"
cat $3