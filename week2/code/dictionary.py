#!/usr/bin/env python3

"""Making a dictionary derived from tuples"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Exercise: write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa

# make empty dictionary
taxa_dic = {}

# use .setdefault() to set order_names as the first element of the dictionary and append corresponding taxon names to them
for taxon, order_name in taxa:
        taxa_dic.setdefault(order_name, []).append(taxon)

print(taxa_dic)