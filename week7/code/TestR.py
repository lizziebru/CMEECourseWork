#!/usr/bin/env python3

"""This script illustrates running R from Python"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell=True).wait()

# telling the script to run the R script, redirect its output and save it into results, and also save the second file in the same way

# shell = True: tells subprocess, rather than just spawning a process from bash, to actually open up the terminal window and keep the shell there

# --> the 2 outputs do indeed appear in the results folder