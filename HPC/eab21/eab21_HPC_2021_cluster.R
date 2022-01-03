# CMEE 2021 HPC excercises R code HPC run code pro forma

print("running cluster.R script")

rm(list=ls()) # good practice 

graphics.off() # clear any existing graphs

source("eab21_HPC_2021_main.R") # source main code file

# define variables needed
speciation_rate <- 0.0024267 # my personal speciation rate
community_size <- c(500, 1000, 2500, 5000)

# read in the job number from the cluster
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX")) # comment this out and set iter myself for testing locally

# setting iter myself for testing locally:
#iter <- 1

# select the correct value for community in each parallel simulation based on the value of iter
if (iter >= 1 && iter <= 25) size <- community_size[1]
if (iter > 25 && iter <= 50) size <- community_size[2]
if (iter > 50 && iter <= 75) size <- community_size[3]
if (iter > 75 && iter <= 100) size <- community_size[4]


# set seed
set.seed(iter)

# create a filename to store results
cluster_run(speciation_rate = speciation_rate, 
            size = size, 
            wall_time = 690, 
            interval_rich = 1,
            interval_oct = size / 10, 
            burn_in_generations = 8 * size, 
            output_file_name = paste("eab21_result", iter, ".rda", sep = ""))