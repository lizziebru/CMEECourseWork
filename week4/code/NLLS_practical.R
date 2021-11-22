# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: Model Fitting using Non-linear Least-squares
# Desc: learning how to fit non-linear mathematical models to data using Non-Linear Least Squares (NLLS)
# Date: Nov 2021

install.packages("minpack.lm")
require(minpack.lm)
install.packages("nlstools")
require(nlstools)
require(ggplot2)
install.packages("ggpmisc")
require(ggpmisc)

# clear all variables and graphic devices and load necessary packages

rm(list = ls())
graphics.off()



# Generate data -----------------------------------------------------------

# need a sequence of substrate concentrations rom 1-50 in jumps of 5
S_data <- seq(1,50,5)
S_data

# generate a Michaelis-Menten reaction velocity response with V_max = 12.5 and K_M = 7.1:
V_data <- ((12.5*S_data)/(7.1 + S_data))
plot(S_data, V_data)

# can now add some random (normally-distributed) fluctuations to the data to emulate experimental/measurement error:
set.seed(1456) # to get the same random fluctuations in the "data" every time
V_data <- V_data + rnorm(10, 0, 1) # add 10 random fluctuations with standard deviation of 0.5 to emulate error
plot(S_data, V_data)




# Fitting the model using NLLS --------------------------------------------

MM_model <- nls(V_data ~ V_max * S_data / (K_M + S_data))
# get a warning bc nls requires starting values for the parameters (V_max and K_M) to start searching for optimal combinations of parameter values
# will address this later

# for now: examine how good the fit we obtained looks:
plot(S_data,V_data, xlab = "Substrate Concentration", ylab = "Reaction Rate")  # first plot the data 
lines(S_data,predict(MM_model),lty=1,col="blue",lwd=2) # now overlay the fitted model 
# --> BUT: this isn't the best way to do it bc predict() without any further arguments by default only generates predicted values for the actual x-values data used to fit the model 
# (i.e. if there are v few values in the original data, you don't get a smooth predicted curve)
# --> better approach: generate a sufficient number of x-axis values then calculate the predicted line

# to do this:

coef(MM_model) # check the coefficients

Substrate2Plot <- seq(min(S_data), max(S_data),len=200) # generate some new x-axis values just for plotting

Predict2Plot <- coef(MM_model)["V_max"] * Substrate2Plot / (coef(MM_model)["K_M"] + Substrate2Plot) # calculate the predicted values by plugging the fitted coefficients into the model equation 

plot(S_data,V_data, xlab = "Substrate Concentration", ylab = "Reaction Rate")  # first plot the data 
lines(Substrate2Plot, Predict2Plot, lty=1,col="blue",lwd=2) # now overlay the fitted model


# summary stats of the fit:

summary(MM_model)
# see notes for info on these stats





# Statistical inference using NLLS fits -----------------------------------

# goodness of fit
# - best way to assess goodness of fit is to compare it to another, alternative model's fit
# (cant use anova (compares the fitted model to a null model) bc it's not a linear model)

# - also good to examine whether the fitted coefficients are reliable i.e. are significant, based on their (low) standard errors, (high) t-values, and (low) p-values 

# can't use R^2 to assess quality of fit or between competing models


# confidence intervals
# --> useful to construct CIs around the estimated parameters in our fitted model
confint(MM_model)




# The starting values problem ---------------------------------------------

# try the NLLS fitting again, this time with starting values:
MM_model2 <- nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 12, K_M = 7))

# compare the coefficient estimates from our two diff model fits to the same dataset:
coef(MM_model)
coef(MM_model2)

# trying even more different starting values:
MM_model3 <- nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = .01, K_M = 20))

# compare coefficients to the ones from the previous models
coef(MM_model)
coef(MM_model2)
coef(MM_model3)

# plotting model1 and model3 together to compare fit:
plot(S_data, V_data) # first plot the data
lines(S_data, predict(MM_model), lty = 1, col = "blue", lwd = 2) # overlay the original model fit
lines(S_data, predict(MM_model3), lty = 1, col = "red", lwd = 2) # overlay the latest model fit

# trying again with even more different starting values:
nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 0, K_M = 0.1))
# error bc starting values provided are too far from the optimal solution (the starting value for V_max is in fact biologicall impossible)

# trying another pair of starting values:
nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = -0.1, K_M = 100))
# model fitting starting but eventually failed bc the starting values were too far from the optimal values

# trying with values really close to the optimal values:
MM_model4 <- nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 12.96, K_M = 10.61))

coef(MM_model)
coef(MM_model4)
#--> still not exactly the same! - shows how NLLS isn't an exact procedure
#--> BUT: the two solns aren't v different - so if the starting values are reasonable, NLLS is exact enough


## can instead also use a more robust NLLS algorithm: the Levenberg-Marqualdt algorithm
# --> less likely to get stuck

MM_model5 <- nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 2, K_M = 2))

coef(MM_model2)
coef(MM_model5)
# -- close enough!

# now trying using all those starting parameter combinations that failed previously
MM_model6 <- nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = .01, K_M = 20))
MM_model7 <- nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 0, K_M = 0.1))
MM_model8 <- nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = -0.1, K_M = 100))

coef(MM_model6)
coef(MM_model7)
coef(MM_model8)

# --> all these worked with nlsLM even though they had failed with nls!

# bu nlsLM also has limits:
# trying with more absurd starting values:
nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = -10, K_M = -100))
#--> failed here: starting values are too far from the best solution





# Bounding parameter values -----------------------------------------------

# can also bound the starting values (i.e. prevent them from exceeding some min and max value during the NLLS fitting process)

nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 0.1, K_M = 0.1))

# now the same with parameter bounds:
nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 0.1, K_M = 0.1), lower=c(0.4,0.4), upper=c(100,100))
# --> solution was found in two fewer iterations 

# if you bound the parameters too much, the algorithm can't search sufficient parameter space and will fail to converge on a good soln:
nlsLM(V_data ~ V_max * S_data / (K_M + S_data), start =  list(V_max = 0.5, K_M = 0.5), lower=c(0.4,0.4), upper=c(20,20))
#--> converged on a poor solution, and too fewer iterations than before --> bc it couldn't explore sufficient parameter combinations of V_max and K_M



# Diagnostics of an NLLS fit ----------------------------------------------

hist(residuals(MM_model6))
# --> looks ok, but not surprising bc we generated these data ourselves using normally-distributed errors

# further diagnostics: using the nlstools package

# e.g. can get confidence intervals:
confint2(MM_model6, level = 0.95)

# + loads of other cool diagnostics - see documentation for more





# Allometric scaling of traits --------------------------------------------

# body weight vs change in body length --> in general this relationship is allometric

# import data:
MyData <- read.csv("../data/GenomeSize.csv") 

head(MyData)

# subset the data and remove NAs
Data2Fit <- subset(MyData,Suborder == "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] # remove NAs

# plot the data
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight, xlab = "Body Length", ylab = "Body Weight")

# fit the model to the data using NLLS:
nrow(Data2Fit)
PowFit <- nlsLM(BodyWeight ~ a * TotalLength^b, data = Data2Fit, start = list(a = .1, b = .1))




# NLLS fitting using a model object ---------------------------------------

# another way to tell nlsLM which model to fit

# first create a function object for the power law model:
powMod <- function(x, a, b) {
  return(a * x^b)
}

# now fit the model to the data using NLLS by calling the model:
PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = .1, b = .1))

summary(PowFit)




# Visualizing the fit -----------------------------------------------------

# generate a vector of body lengths (x-axis variable) for plotting

Lengths <- seq(min(Data2Fit$TotalLength),max(Data2Fit$TotalLength),len=200)


# calculate the predicted line

coef(PowFit)["a"] # need to extract the coefficient from the model fit object using the coef() command
coef(PowFit)["b"]

Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["b"])


# plot the data and the fitted model line
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)





# Summary of the fit ------------------------------------------------------

summary(PowFit)

print(confint(PowFit))



# Examine the residuals --------------------------------------------------

hist(residuals(PowFit))
#--> look ok







# Exercises ---------------------------------------------------------------

# a) make the same plot as above in ggplot and display the estimated equation

allometric_ggplot <- ggplot()+
  geom_point(aes(x = Data2Fit$TotalLength, y = Data2Fit$BodyWeight))+
  geom_smooth(aes(x = Lengths, y = Predic2PlotPow))+
  xlab("Total Length")+
  ylab("Body Weight")
allometric_ggplot

# play with starting values to see if you can "break" the model fitting
# (i.e. until the NLLS fitting doesn't converge on a solution)

nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = .001, b = .001))
nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = 0, b = .001))
nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = 0, b = 0))
nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = .1, b = -0.1))
nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = 0, b = .001))














