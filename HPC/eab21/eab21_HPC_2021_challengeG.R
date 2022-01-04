# CMEE 2021 HPC excercises R code challenge G pro forma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

# please edit these data to show your information.
name <- "Lizzie Bru"
preferred_name <- "Lizzie"
email <- "e.bru21@imperial.ac.uk"
username <- "eab21"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

f=function(s,t,d,l,r){e=s+l*cos(d);f=t+l*sin(d);lines(c(s,e),c(t,f));if(l>0.01){f(e,f,d,l*7/8,-r);f(e,f,d+r*pi/4,l*3/8,r)}};p=function(){plot(c(0,4),c(0,9));f(2,1,pi/2,1,1)}
