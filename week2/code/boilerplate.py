#!/usr/bin/env python3

"""Boilerplate for Python programs""" # doc strings - interprets it as being documentation for the code - so if you type help for this function this is what you get
# --> makes it easy for you to document what your program is

__appname__ = '[application name here]'
__author__ = 'Your Name (your@email.address)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys # module to interface our program with the operating system (comes with the python operating system)
# this one has lots of powerful commands that allow you to use python in different platforms

## constants ##
# --> double hashes are useful to section things out nicely
# no constants here bc it's a boilerplate

## functions ##
def main(argv):
    """ Main entry point of the program """
    print('This is a boilerplate') # NOTE: indented using two tabs or 4 spaces
    return 0 #= just being explicit that this was a successful run (0 = code for successful run)
# this is all this program does: prints 'This is a boilerplate'

if __name__ == "__main__": # if this script is being run directly: capture the status, store it, then exit after passing it through the above function, then exit
    """Makes sure the "main" function is called from command line"""  
    print(__name__)
    status = main(sys.argv)
    sys.exit(status) # well-defined way of exiting: means it'll include the output of this function too