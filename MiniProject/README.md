## **The Computing Miniproject**

This repository contains materials required to run the computing miniproject, detailed in the Miniproject section of [**The Multilingual Quantitative Biologist**](https://mhasoba.github.io/TheMulQuaBio/intro.html).


### **Languages**

Python version 3.8.10

R version 3.6.3

bash version 5.0.17

LaTeX

### **Dependencies and special packages** 

Python:
- Pandas: to create and manipulate dataframes
- NumPy: to manipuate dataframes

R:
- ggplot2: to create plots
- minpack.lm: to fit linear models
- qpcR: to help with model fitting
- viridis: to make colour-blind-friendly plots
- ggpubr: to combine plots
- olsrr: to help with Ordinary Least Squares model fitting
- dplyr: to manipulate dataframes


LaTeX:
- inputenc: to translate various input encodings
- setspace: set space between lines
- lineno: add line numbers
- authblk: support footnotes
- natbib: to insert a non-numeric bibliography
- geometry: to customize page layout
- tabularx: to make panelled tables
- booktabs: enahnces the quality of tables
- graphicx: to insert figures


### **Usage**

From the command line, navigate to the 'Code' directory in this Miniproject directory. Use bash to execute the [**run_miniproject.sh**](code/run_miniproject.sh) script. This will run the Python script [**miniproj_script.py**](code/miniproj_script.py) for data wrangling, the R script [**miniproj_script.R**](code/miniproj_script.R) for model fitting, plotting, and analysis, count the number of words in the report, and compile the final report ([**miniprojwriteup.tex**](code/miniprojwriteup.tex) with [**miniprojwriteup.bib**](code/miniprojwriteup.bib)).

Scripts:

[**run_miniproject.sh**](code/run_miniproject.sh): This script is run from the bash terminal and compiles the entire project from start to finish.

[**miniproj_script.py**](code/miniproj_script.py): This script is run by the [**run_miniproject.sh**](code/run_miniproject.sh) script; it contains the data wrangling.

[**miniproj_script.R**](code/miniproj_script.R): This script is also run by the [**run_miniproject.sh**](code/run_miniproject.sh) script; it contains the model fitting, plotting, and analysis.

[**miniprojwriteup.tex**](code/miniprojwriteup.tex): This script is also run by the [**run_miniproject.sh**](code/run_miniproject.sh) script; it contains the write-up of the report.

[**miniprojwriteup.bib**](code/miniprojwriteup.bib): This script is also run by the [**run_miniproject.sh**](code/run_miniproject.sh) script; it contains the bilbiography for the write-up.


### **Author name and contact**

Lizzie Bru
eab21@ic.ac.uk