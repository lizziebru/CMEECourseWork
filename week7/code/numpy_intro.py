#!/usr/bin/env python3

"""Introduction to numpy"""
__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import numpy as np

# example of making a 1D array
a = np.array(range(5))
a
print(type(a))
print(type(a[0]))

# can also specify the data type of the array:
# can make it a float:
a = np.array(range(5), float)
a
a.dtype # to check type
x = np.arange(5) # can make a 1D array this way
x
x = np.arange(5.) # directly specify float using decimal
x

# to see dimensions:
x.shape


# can convert to and from python lists:
b = np.array([i for i in range(10) if i % 2 == 1]) #odd numbers between 1 and 10
b

# convert back to list
c = b.tolist() #convert back to list
c

# need a 2D numpy array to make a matrix
mat = np.array([[0, 1], [2, 3]])
mat
mat.shape


# indexing and accessing arrays:
mat[1]

mat[:,1] # accessing whole second column

mat[0,0] # 1st row, 1st column element

mat[1,0] # 2nd row, 1st column element

mat[:,0] # whole first column

mat[0,1]

mat[0,-1] # also accepts negative values for going back to the start from the end of an array

mat[-1,0]

mat[0,-2]


# manipulating arrays:
mat[0, 0] = -1
mat

mat[:,0] = [12,12] #replace whole column
mat

np.append(mat, [[12,12]], axis = 0) #append row, note axis specification

np.append(mat, [[12],[12]], axis = 1) #append column

newRow = [[12,12]] #create new row

mat = np.append(mat, newRow, axis = 0) #append that existing row
mat

np.delete(mat, 2, 0) #Delete 3rd row

# concatenation:
mat = np.array([[0, 1], [2, 3]])
mat0 = np.array([[0, 10], [-1, 3]])
np.concatenate((mat, mat0), axis = 0)


# flattening of reshaping arrays:

mat.ravel() # flattens it from a matrix to a vector

mat.reshape((4,1)) # un-flattens it to dimensions (4,1)

mat.reshape((1,4)) # the same but with different dimensions

#mat.reshape((3,1)) # ditto
# gives an error bc the total no. of elements has to stay the same!


# pre-allocating arrays
np.ones((4,2)) # initialising an array with 4 rows and 2 columns and filled with just ones
np.zeros((4,2)) # can also do it with zeros
m = np.identity(4) # creating an identity matrix
m
m.fill(16) # fill the matrix with 16
m


# numpy matrices

# can perform some common matrix-vector operations on arrays:

mm = np.arange(16)
mm = mm.reshape(4,4) #Convert to matrix
mm

mm.transpose() # just a normal matrix transpose

mm + mm.transpose() # normal matrix arithmetic

mm - mm.transpose() # ditto

mm * mm.transpose() # Note that this is element-wise multiplication

mm // mm.transpose()

mm // (mm + 1).transpose()

mm * np.pi

mm.dot(mm) # No this is matric multiplication, or the dot product

mm = np.matrix(mm) # convert to scipy/numpy matrix class
mm

print(type(mm))

mm * mm # instead of mm.dot(mm) --> makes multiplication syntactically easier

#--> BUT: don't use the numpy matrix class cause it might be removed in future






