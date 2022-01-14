#!/usr/bin/env python3

"""Script to demonstrate the use of __name__ == '__main__'  in Python"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')

print("This module's name is: " + __name__)
