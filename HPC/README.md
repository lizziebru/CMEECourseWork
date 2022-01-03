## **High Performance Computing**

This repository contains materials required to run the High Performance Computing coursework.

### **Languages**

R version 3.6.3

bash version 5.0.17

### **Dependencies and special packages** 

R:
- ggplot2: to create plots
- viridis: to make colour-blind-friendly plots

### **Usage**

All scripts and files are in the 'eab21' directory in this HPC directory.
Scripts:

[**cluster_run.sh**](eab21/cluster_run.sh): This script is run from the bash terminal in the HPC cluster and calls [**eab21_HPC_2021_cluster.R**](eab21/eab21_HPC_2021_cluster.R) to run the simulations on the HPC.

[**eab21_HPC_2021_challengeG.R**](eab21/eab21_HPC_2021_challengeG.R): This script contains the answer to challenge question G.

[**eab21_HPC_2021_cluster.R**](eab21/eab21_HPC_2021_cluster.R): This script sources the [**eab21_HPC_2021_main.R**](eab21/eab21_HPC_2021_main.R) script and calls the cluster_run function to run simulations.

[**eab21_HPC_2021_main.R**](eab21/eab21_HPC_2021_main.R): This script contains all of the functions made during this coursework apart from challenge G.

### **Author name and contact**

Lizzie Bru
eab21@ic.ac.uk