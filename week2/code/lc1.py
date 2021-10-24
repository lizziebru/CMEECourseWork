#!/usr/bin/env python3

"""Exercises on list comprehensions and loops"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively

latin_names = [x[0] for x in birds] # x here is referring to each row of tuples individually (same applies for all list comprehensions/loops in these practicals)
print(latin_names)

common_names = [x[1] for x in birds]
print(common_names)

mean_body_masses = [x[2] for x in birds]
print(mean_body_masses)

# (2) Now do the same using conventional loops

latin_names2 = []

for first_tuple in birds:
    latin_names2.append(first_tuple[0])
print(latin_names2)


common_names2 = []

for second_tuple in birds:
    common_names2.append(second_tuple[1])
print(common_names2)


mean_body_masses2 = []

for third_tuple in birds:
    mean_body_masses2.append(third_tuple[2])
print(mean_body_masses2)