#!/bin/bash
# Author: Lizzie Bru eab21@ic.ac.uk
# Script: Run Miniproject
# Desc: Script to run Miniproject from code for data wrangling, modelling, and analysis to final LaTeX report compilation
# Date: December 2021

# Data Wrangling
echo "Wrangling data ..."
python3 miniproj_script.py
echo "Data wrangling complete"

# Model fitting and analysis
echo "Fitting models, plotting data, and analysing results..."
Rscript miniproj_script.R
echo "Modelling, plotting, and analysis complete"

# count words in report
texcount -1 -sum=1,2 miniprojwriteup.tex > words.sum

rm *.pdf
# LaTeX report
echo "Compiling LaTeX"
pdflatex miniprojwriteup.tex
bibtex miniprojwriteup.aux
pdflatex miniprojwriteup.tex
pdflatex miniprojwriteup.tex
echo "Compiled LaTeX report"