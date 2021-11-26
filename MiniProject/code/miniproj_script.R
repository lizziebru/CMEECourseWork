# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: miniproj_script.R
# Desc: this script contains the plots for the miniproject
# Date: Nov 2021

install.packages('ggplot2')
library(ggplot2)
install.packages('broom')
library(broom)
install.packages('minpack.lm')
library(minpack.lm)
install.packages('qpcR')
library(qpcR)

data <- read.csv("../data/LogisticGrowthData2.csv")
data[is.na(data) | data == "Inf" | data == "-Inf"] <- NA  # Replace NaN & Inf with NA otherwise models don't run


# Model fitting -----------------------------------------------------------

# NB: can't run a model on subsets that have fewer points than there are parameters!


# easy linear models:
# cubic polynomial
# quadratic

# harder non-linear models:
# need to think about starting parameters, boundaries for starting parameters etc

# could use multiple different comparison criteria to compare between diff models

# use least squares

# model selection is key



# choosing parameter starting values:

##-- choose appropriate ones by eyballing the dataset

## important bc innapropriate starting values can cause algorithm to find parameter combinations representing convergence to a local optimum soln

# choosing bounding parameter values:

##-- preventing them from exceeding soem min/max value during the NLLS fitting process
##-- means can find the soln with fewer iterations
##-- BUT: if you bound too much (too narrow range): algorithm can't search sufficient parameter space and will fail to converge on a good soln

## need to understand meaning of parameters in model


# just use starting values for mechanistic ones (not for the phenomenological linear ones) -- probs use linear models to do that


# TO DO: it's good to repeat things multiple times: so need to look into that and starting values too


### CUBIC POLYNOMIAL

cubic_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))

for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    try(
      cubic_AICs[i, "AIC"] <- AIC(lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE))
      ), silent = TRUE)
  }
}


### QUADRATIC

# poly(Time, 2)

quadratic_AICs <- data.frame(Subset = c(1:285),
                         AIC = rep(0, 285))

for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    try(
      quadratic_AICs[i, "AIC"] <- AIC(lm(d$log_PopBio ~ poly(d$Time, 2, raw = TRUE))
      ), silent = TRUE)
  }
}




### LOGISTIC

# define it as a function object
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# fit the model:

# 1. subset the data
d <- data[which(data$ID == '1'),]

# 2. if there are fewer datapoints than the number of parameters: terminate the loop
#if (nrow(d) < 4) {
#  next
#} 


# 3. choose starting parameters for the model
N_0_start <- min(d$PopBio) # lowest population size
K_start <- 2*max(d$PopBio) # highest population size --> models fit better when make this bigger
#r_max_start: use estimate from OLS fitting of a linear model where there's a slope - need to figure out how to do that
# OR: could differentiate and use the max divided by the (approximate) time-step (i.e. use the max observed gradient of the curve)
#r_max_start <- max(diff(data$log_PopBio), na.rm = T)/mean(diff(d$Time)) # not great
# so try to set a super low r instead - seems to work better with low r:
r_max_start <- 0.00000001

# 4. fit model: 
fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                      list(r_max=r_max_start, N_0 = N_0_start, K = K_start))


# 5. extract AIC 
AIC(fit_logistic)


# put it all into a loop:

logistic_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))
  
for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    N_0_start <- min(d$PopBio)
    K_start <- 2*max(d$PopBio)
    r_max_start <- 0.00000001
    try(
      logistic_AICs[i, "AIC"] <- AIC(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                                     list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
      ), silent = TRUE)
  }
}



### GOMPERTZ

# use the logged version of PopBio


## --> need to vary the starting parameters and add bounding values

#  need to rerun fitting attempts multiple times
##--> each time sampling each of the starting values randomly 
##--> increases likelihood of the NLLS optimization algorithm finding a soln and not getting stuck in a local optimum

# if have high confidence in mean value of parameter: use gaussian distribution

# if have low confidence in mean but higher confidence in range of values that the parameter can take: use uniform distribution

# (mean = starting value you inferred from the model and the data)

# need to determine range of values to restrict each parameter's samples to:
#--> in both cases: will typically be some subset of the model's parameter bounds
## normal distributon: choose a standard deviation parameter
## uniform distribution: choose lower and upper bound - usually good to set the bound to be some percent (5-10%) of starting value


# number of times to re-run: depends on how 'difficult' the model is and how much computational power you have






# Comparing models --------------------------------------------------------

# use weighted AIC - make sure to justify in write-up why weighted AIC is better than normal AIC

# use function akaike.weights

# or just as a basic start: compare AICs for each one (just pick the model with the best AIC)


# make big table:

models_all <- data.frame(subset = rep(1:285, 3),
                         model = c(rep('quadratic', 285), rep('cubic', 285), rep('logistic', 285)),
                         AIC = c(quadratic_AICs$AIC, cubic_AICs$AIC, logistic_AICs$AIC))


# work out best model for each by just comparing AIC values to begin with:

models_best <- data.frame(subset = c(1:285),
                          best_model = rep(0, 285),
                          AIC = rep(0,285))

for (i in 1:285) {
  d <- models_all[which(models_all$subset == i),] # subset out by ID
  d_m <- d[which.max(d$AIC),] # select the row with the highest AIC
  try(models_best[i, "AIC"] <- d_m$AIC, silent = TRUE) # fill column in models_best with the details of this best model
}
for (i in 1:285) {
  d <- models_all[which(models_all$subset == i),] # subset out by ID
  d_m <- d[which.max(d$AIC),] # select the row with the highest AIC
  try(models_best[i, "best_model"] <- as.character(d_m$model), silent = TRUE) # fill column in models_best with the details of this best model
}



# Plotting ----------------------------------------------------------------

ggplot(data, aes(x = Time, y = PopBio))+
  geom_point(aes(colour = ID))
# looks like a bit of a mess
# most of the data is clustered at time 0-1000 or so

# best to visualize each subset separately

ggplot(subset(data, data$ID=="1"), aes(x = Time, y = PopBio))+
  geom_point()

# looks like there are broadly 2 types of trends going on: some have an increase in PopBio at around 200h and others stay flat

# would be good to find a way to visualize them all in one go

## probably just plot the ones with the same units on the same graph






# for logistic model:

timepoints <- seq(0, max(d$Time), 0.1)

logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"], 
                                  K = coef(fit_logistic)["K"], 
                                  N_0 = coef(fit_logistic)["N_0"])
df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic equation"
names(df1) <- c("Time", "PopBio", "model")

ggplot(d, aes(x = Time, y = PopBio)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = PopBio, col = model), size = 1) +
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "PopBio")














# Testing for whether replicates are an issue -----------------------------

# replicates: run lm to compare diff replicates --> establish that they're not significantly different from each other

# therefore it doesn't matter which one you choose 

# but do need to choose one of them bc they'll be a bit different bc they're diff experiments (so diff popns, probably diff starting points etc)

# so can just choose replicate = 1 for all of them



lm_reps <- lm(log_PopBio ~ Time + as.character(Rep), data = data)
summary(lm_reps)

##--> fix this later if choose to include this









