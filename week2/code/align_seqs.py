#!/usr/bin/env python3

"""This script aligns two DNA sequences such that they are as similar as possible"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

# Two example sequences to match
#seq2 = "ATCGCCGGATTACGGG"
#seq1 = "CAATTCGGAT"

# import input data

import csv

with open("../data/align_seqs_data.csv") as dna_data:
    csvreader = csv.reader(dna_data)
    header = next(csvreader)
    print(header)
    rows = [r for r in csvreader]
    print(rows)

## assign seq1 and seq2 to the two example sequences to match

# make empty list
empty_list = []

# open the csv file and loop through the rows, appending them to a list
with open("../data/align_seqs_data.csv") as dna_data:
    dna_data_csvreader = csv.reader(dna_data)
    for row in dna_data_csvreader:
        empty_list.append(row)

# assign seq2 and seq1 to each line of the list
seq2 = str(empty_list[0])
seq1 = str(empty_list[1])

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

## Save the best alignemt and its corresponding score in a single text file to results directory:

# import module
import os

# make empty code file and write data to it (the 'w' allows this)
# use a with loop for this (do this whenever you're interacting with files in this way!) so that it automatically closes the file if it encounters any errors along the way

with open("../results/dna_align_output.txt", "w") as dna_output:
    # write outputs to it
    dna_output.write("Best alignment:" + "\n" + my_best_align +"\n" + str(s1) + "\n" + "Score: " + str(my_best_score))

