#!/usr/bin/env python3

"""Exercises on list comprehensions and loops"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
lots_of_rain = [x for x in rainfall if x[1] > 100] 
print(lots_of_rain)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

not_much_rain = [x[0] for x in rainfall if x[1] < 50]
print(not_much_rain)

# (3) Now do (1) and (2) using conventional loops

lots_of_rain2 = []

for x in rainfall:
    if x[1] > 100:
        lots_of_rain2.append(x)
print(lots_of_rain2)


not_much_rain2 = []

for x in rainfall:
    if x[1] < 50:
        not_much_rain2.append(x[0])
print(not_much_rain2)