#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: CountLines.sh
# Desc: demonstrating how values can be assigned using explicit declaration
# Arguments: none
# Date: Oct 2021

NumLines=`wc -l < $1` # the > changes the way that $1 is put through the command: when it's present, the contents of $1 are taken and put through the command, whereas without it the command just addresses $1 directly (means that the filename comes out in the output)
echo "The file $1 has $NumLines lines"
echo
