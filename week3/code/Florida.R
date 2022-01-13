# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: Florida.R
# Desc: Script that helps answer the question: Is Florida getting warmer?
# Date: Oct 2021

# need to calculate the correlation coefficients between temperature and time
# need to do a permutation analysis bc can't use standard p-value since temp variables at successive time-points aren't independent

# load dataset:

rm(list=ls())

load("../data/KeyWestAnnualMeanTemperature.RData")

ls()

class(ats)

head(ats)

plot(ats)

# compute the correlation coefficient between years & temp and store it
install.packages('ggpubr') # feedback said there was an error and ggpubr wasn't installed before so have added this in
library(ggpubr)
ats_cor <- cor(ats$Year, ats$Temp, method = c("pearson")) # use pearson: bc it should be pearson/spearman bc they correlate normally distributed data and pearson is most appropriate for measurements taken from an interval scale vs spearman is better for measurements taken from ordinal scales
ats_cor

# randomly reshuffle the temperatures then recalculate the correlation coefficient to generate the null distribution of correlation coefficients

# loop step-by-step:
#1) reshuffle the temperatures
temp_reshuffle <- sample(ats$Temp, replace = F) # reshuffles ats$Temp without replacement
#2) calculate the correlation coeff
cor(ats$Year, temp_reshuffle, method = c("pearson"))

# loop: replicate all this 10,000 times and make a dataframe out of it:
cor_null <- data.frame(matrix(unlist(replicate(10000, {
  temp_reshuffle <- sample(ats$Temp, replace = F)
  cor(ats$Year, temp_reshuffle, method = c("pearson"))
}))))


# then test for the likelihood of the actual correlation coeff being drawn from this null distribution
#--> i.e. calculate what fraction of the random correlation coeffs were greater than the observed one
approx_p_value <- (sum(cor_null$matrix.unlist.replicate.10000... > ats_cor))/10000
approx_p_value
#--> = 0: means that the correlation between temp and year is significantly different from that expected by chance, suggesting that there is a significant positive correlation between them

# make plot of temp/year:
require(ggplot2)
temp_year <- ggplot(ats, aes(x = Year, y = Temp))+
  geom_point()+
  #ggtitle("Annual temperature in Key West, Florida, \nfrom 1901 to 2000")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlab("Year")+
  ylab("Temperature /C")+
  geom_smooth(method = lm) # default is with confidence intervals
temp_year <- temp_year  

# make plot of null distribution of correlation coefficients and test value:
temp_null <- ggplot()+
  geom_density(data = cor_null, aes(cor_null$matrix.unlist.replicate.10000...), fill = "lightgrey", size = 1)+
  geom_vline(xintercept = 0.5331784, colour = "blue", linetype = "dashed", size = 1)+
  xlab("Correlation coefficient")+
  ylab("Density")+
  #ggtitle("Test correlation coefficient relative to the \nnull dstribution of correlation coefficients")+
  theme(plot.title = element_text(hjust = 0.5))
temp_null  

# save both as PDFs
pdf("../results/Florida_scatter_plot.pdf")
print(temp_year)
graphics.off()
pdf("../results/Florida_temp_null_distr.pdf")
print(temp_null)
graphics.off()
