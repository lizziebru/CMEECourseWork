#!/usr/bin/env python3

"""Read an input file containing tree names and extract the oak names, saving these to a CSV"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import csv
import sys

# NOTE: I am taking the instruction of making this script able to 'handle cases where there is a typo etc' to mean: allow for leeway if the same as quercus except for lowercase or space before

#Define function
def is_an_oak(name):
    """ Returns true if the tree is an oak (i.e. its name begins with 'quercus')

    >>> is_an_oak('Quercus robur')
    True

    >>> is_an_oak('Pinus sylvestris')
    False

    allow for lowercase
    >>> is_an_oak('quercus robur')
    True

    allow for a space before the start
    >>> is_an_oak(' Quercus robur')
    True

    don't allow for other typos
    >>> is_an_oak('QQuercus robur')
    False
    >>> is_an_oak('Quercuss robur')
    False
    >>> is_an_oak('Quercyuss')
    False

    """
    return name.lower().strip().startswith('quercus ')

def main(argv):
    """Open the input data from TestOaksData.csv and write the outputs (= only the species which have oak names) to JustOaksData.csv"""

    f = open('../data/TestOaksData.csv','r') # this csv contains 5 oak species names laid out in 2 columns (genus & species)
    g = open('../data/JustOaksData.csv','w') # this csv is empty

    taxa = csv.reader(f)
    csvwrite = csv.writer(g)

    for row in taxa:
        print(row)
        print ("The genus is: ")
        print(row[0] + '\n')
        if is_an_oak(" ".join(row)): # if it's an oak, write to JustOaksData.csv
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])

    f.close()  # need to close the csvs after opening them
    g.close()
    return 0
    
if (__name__ == "__main__"):
    import doctest

    doctest.testmod() # to run with embedded tests
    status = main(sys.argv)
    sys.exit(status)
