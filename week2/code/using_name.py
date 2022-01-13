#!/usr/bin/env python3

"""Script to demonstrate the use of __name__ == '__main__'  in Python"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

if __name__ == '__main__': # directs the python interpreter to set the special __name__ variable to have a value "__main__" so that the file is usable as a script as well as an importable module
    print('This program is being run by itself')
else:
    print('I am being imported from another module')

print("This module's name is: " + __name__)
