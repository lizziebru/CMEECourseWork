#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: compiles LaTeX with Bibtex
# Arguments: 1 -> .tex file
# Date: Oct 2021

# need to make sure it works on files both with and without .tex extension

# check if extension is "tex"
# if not, print something to terminal
notex=$(basename -- "$1")
extension="${notex##*.}"
filename="${notex%.*}"

# compile LaTeX wth Bibtex
pdflatex $notex.tex
bibtex $notex
pdflatex $notex.tex
pdflatex $notex.tex
evince $notex.pdf &

## Cleanup - could be nice to check if they're there first before deleting them (cause doesn't throw an error if you try to delete things that aren't there)
[ -e *.aux ] && rm *.aux
[ -e *.aux ] && rm *.log
[ -e *.aux ] && rm *.bbl
[ -e *.aux ] && rm *.blg


# how to run this: type into terminal:
    # bash CompileLaTeX.sh FirstExample
    ##--> don't include the .tex ending for the file name
    ##--> if you're doing it for a .tex file in a different directory, just use the relative path to CompileLateX.sh