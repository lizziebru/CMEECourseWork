#!/usr/bin/env python3

"""Script demonstrating how to separate a tuple of tuples into separate lines"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

from typing import Pattern

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# 

for x in birds:
    print('Latin name: ', x[0])
    print('Common name: ', x[1])
    print('Mass: ', x[2])