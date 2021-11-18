#!/usr/bin/env python3

"""This script illustrates subprocessing in Python"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import subprocess

#--> using subprocess: can run non-Python commands & scripts, obtain their outputs, and crawl through & manipulate directories


# try running some commands in the UNIX bash:
p = subprocess.Popen(["echo", "I'm talkin' to you, bash!"], # command line arguments passed as a list of strings to avoid needing to escape quotes
                     stdout=subprocess.PIPE, # output from the process spawned by the command
                     stderr=subprocess.PIPE) # error code from which you capture whether the process ran successfully or not
#--> creates an object p, from which you can extract the output and other info of the command you ran: the method PIPE creates a new "pipe" to the output of the "child" process

stdout, stderr = p.communicate()


# check what's in stderr and stdout

stderr
# --> nothing here bc the echo command doesn't return any code
# the b indicates that the output is unencoded

stdout

# encode and print it:
print(stdout.decode())

# can also use universal_newlines = True to make the outputs be returned as encoded text with line endings converted to '\n'
p = subprocess.Popen(["echo", "I'm talkin' to you, bash!"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines = True)
stdout, stderr = p.communicate()
stdout # don't need to decode it this time


# trying something else:
p = subprocess.Popen(["ls", "-l"], stdout=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode()) # lists all files in a long listing format


# can also call python itself from bash:
p = subprocess.Popen(["python3", "../../week2/code/boilerplate.py"], # need to give it the relative path to boilerplate
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE) # A bit silly!
stdout, stderr = p.communicate()
print(stdout.decode())
#--> telling python to run bash to open python and run boilerplate


# can also compile a latex document like this:
subprocess.os.system("pdflatex ../../week1/code/FirstExample")
# can also do it this way:
p = subprocess.Popen(["pdflatex", "../../week1/code/FirstExample.tex"], # need to give it the relative path to boilerplate
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE) # A bit silly!
stdout, stderr = p.communicate()
print(stdout.decode())


## Handling directory and file paths:

# e.g. to assign paths:
subprocess.os.path.join('directory', 'subdirectory', 'file')

# can catch the output of subprocess so that you can then use the output within your python script
MyPath = subprocess.os.path.join('directory', 'subdirectory', 'file')
MyPath


## Running R

# you can run R from Python easily

# have to make an R script first so that python has something to run

# --> see TestR.R and TestR.py scripts for more on this



# NB: need to explicitly tell subprocess to tell you if there are errors - it won't do it automatically!


