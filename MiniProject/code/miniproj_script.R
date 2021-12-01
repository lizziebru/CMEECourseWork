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
install.packages("viridis")
library(viridis)
install.packages("ggpubr")
library(ggpubr)
install.packages("nlstools")
library(nlstools)
install.packages("olsrr")
library(olsrr)

data <- read.csv("../data/LogisticGrowthData2.csv")
data[is.na(data) | data == "Inf" | data == "-Inf"] <- NA  # Replace NaN & Inf with NA otherwise models don't run


# TO DO:

# COMPARE WITH BIC TOO!! THEN ONLY USE MODELS WHICH ARE AGREED TO BE THE BEST BY BOTH AIC AND BIC (JUST MAKES IT EXTRA ROBUST)

# fix plotting in the big loop

# make plots needed for write-up

# diagnostics

# model averaging and working out parameter values? - probs not though



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



# FINAL BIG LOOP:

cubic_AICs <- data.frame(Subset = c(1:285),
                         AIC = rep(0, 285))

quadratic_AICs <- data.frame(Subset = c(1:285),
                             AIC = rep(0, 285))

logistic_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))

gompertz_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))

# make table of p-values of results of shapiro-wilk test for residuals' normality
# null hypothesis: residuals are normally distributed
# i.e. p<0.05 == residuals are NOT normally distributed
residuals_normality <- data.frame(Subset = c(1:285),
                                  p_lm_cub = rep(0, 285), # p-value for shapiro test on lm residuals for cubic
                                  p_lm_quad = rep(0,285),
                                  p_nls_log = rep(0,285),
                                  p_nls_gomp = rep(0,285)) # p-value for shapiro test on nlsLM residuals for gompertz fit



logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   


for (i in 1:285) {
  gompertz_success <- 1
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) { # if there are fewer  datapoints than 4 (average no. of parameters in models), terminate loop
    next
  }
  else {
    # cubic:
    try(
      cubic_fit <- lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE), silent = TRUE))
    #cub_shap <- ols_test_normality(cubic_fit) 
    #try(residuals_normality[i, "p_lm_cub"] <- tidy(cub_shap$shapiro)[2], silent = TRUE)
    try(
      cubic_AICs[i, "AIC"] <- AIC(lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE))
      ), silent = TRUE)
    
    # quadratic:
    try(
      quadratic_fit <- lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE), silent = TRUE))
    #quad_shap <- ols_test_normality(quadratic_fit) 
    #try(residuals_normality[i, "p_lm_quad"] <- tidy(quad_shap$shapiro)[2], silent = TRUE)
    try(
      quadratic_AICs[i, "AIC"] <- AIC(lm(d$log_PopBio ~ poly(d$Time, 2, raw = TRUE))
      ), silent = TRUE)
    
    # logistic:
    N_0_start <- min(d$PopBio)
    K_start <- 2*max(d$PopBio)
    r_max_start <- 0.00000001
    try(
      logistic_fit <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                            list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
      , silent = TRUE)
    #log_shap <- test.nlsResiduals(nlsResiduals(logistic_fit))
    #try(residuals_normality[i, "p_lm_log"] <- log_shap$p.value, silent = TRUE)
    try(
      logistic_AICs[i, "AIC"] <- AIC(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                                           list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
      ), silent = TRUE)
    
    # gompertz:
    AIC_reps <- as.numeric(replicate(100, {
      N_0_start <- rnorm(1, m = min(d$log_PopBio), sd = abs(3*min(d$log_PopBio))) # use normal - higher confidence in mean # abs(): bc sometimes the min or max of log_PopBio is -ve then rnorm can't generate anything
      K_start <- rnorm(1, m = 2*max(d$log_PopBio), sd = abs(3*2*max(d$log_PopBio))) # use normal - higher confidence in mean
      r_max_start <- runif(1, min = 10^-10, max = 10^-2) # use a uniform distribution (lower confiendece in mean) - NB: changing these bounds doesn't change the number of models which it manages to fit so just keep it as it is and don't worry too much about it
      # need to choose lower & upper bounds: usually good to set bound to be 5-10% of the parameter's (mean) starting value
      t_lag_start <- rnorm(1, m = d$Time[which.max(diff(diff(d$log_PopBio)))], sd = abs(3*d$Time[which.max(diff(diff(d$log_PopBio)))]))  # normal distribution with mean calculated using diff (the last timepoint of lag phase) and sd as 3 times that
      tryCatch(
        expr = {gompertz_fit <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d,
                              list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))}, 
        error = function(e) {
          gompertz_success <- 0
          })
      try(
        AIC(nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d,
                  list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
        ), silent = TRUE)
    }))
    #try(gomp_shap <- test.nlsResiduals(nlsResiduals(gompertz_fit)), silent = TRUE)
    #try(residuals_normality[i, "p_lm_gomp"] <- gomp_shap$p.value, silent = TRUE)
    try(
      gompertz_AICs[i, "AIC"] <- min(AIC_reps, na.rm = T), silent = TRUE) # take the lowest AIC for each subset and put it in the AIC column of gompertz_AICs
    
    # test for normality of residuals:
    
  }
}



    # # plotting:
    # 
    # pred_cubic <- predict(cubic_fit, data.frame(x = d$Time), intervals = 'confidence', level = 0.99)
    # 
    # pred_quadratic <- predict(quadratic_fit, data.frame(x = d$Time), intervals = 'confidence', level = 0.99)
    # 
    # pred_logistic <- predict(logistic_fit, data.frame(x = d$Time), intervals = 'confidence', level = 0.99)
    # 
    # 
    # # make one plot per subset, with all 4 models on each one
    # plot <- ggplot(d, aes(x = Time), y = log_PopBio)+
    #   geom_point(size = 3)+
    #   geom_line(aes(x = Time, y = pred_cubic), colour = 1)+
    #   geom_line(aes(x = Time, y = pred_quadratic), colour = 2)+
    #   geom_line(aes(x = Time, y = pred_logistic), colour= 3)
    # # need to make legends - generally make these plots nicer
    # 
    # if (gompertz_success = 1) {
    #   pred_gompertz <- predict(gompertz_fit, data.frame(x = d$Time), intervals = 'confidence', level = 0.99)
    #   plot <- plot +
    #     geom_line(aes(x = Time, y = pred_gompertz), colour = 4)
    # }
    # 
    # ggsave(plot, file = paste0("../results/plot_", i, ".png"))

#--> need to try to fix this error: if can't, then just manually make a plot for one of the subsets




# Diagnostic plots? -------------------------------------------------------

# DIAGNOSTICS

##-- should probably check diagnostics of the model NLLS fit
##-- bc it carries 3 assumptions:
#- no measurement error in the x-variable
#- data have constant normal variance: errors in y-axis homogeneously distributed over the x-axis range
#- the measurement/observation errors are normally distributed (gaussian)
##-- so should at least plot the residuals of a fitted NLLS model
#--> check they're normally distributed!

# use nlstools

d <- data[which(data$ID == 10),]    
cubic_fit <- lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE))
cub_shap <- ols_test_normality(cubic_fit) 
tidy(cub_shap$shapiro)[2]

# --> Shapiro-Wilk test: p > 0.05 
# --> therefore cannot reject null hypothesis that the errors are not normally distributed

quadratic_fit <- lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE))
ols_test_normality(quadratic_fit)

logistic_fit <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                      list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
log_shap <- test.nlsResiduals(nlsResiduals(logistic_fit))
log_shap$p.value

gompertz_fit <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
test.nlsResiduals(nlsResiduals(gompertz_fit))










# Individual plots --------------------------------------------------------



# INDIVIDUAL PLOTS:

# logistic

for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) { # if there are fewer datapoints than the number of parameters: terminate the loop
    next
  }
  else {
    N_0_start <- min(d$PopBio)
    K_start <- 2*max(d$PopBio)
    r_max_start <- 0.00000001
    fit_logistic <- try(
    nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                                       list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
    , silent = TRUE)

    timepoints <- seq(0, max(d$Time), 0.1)

    logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"], 
                                  K = coef(fit_logistic)["K"], 
                                  N_0 = coef(fit_logistic)["N_0"])
    df1 <- data.frame(timepoints, logistic_points)
    df1$model <- "Logistic equation"
    names(df1) <- c("Time", "PopBio", "model")

    log_plot <- ggplot(d, aes(x = Time, y = PopBio)) +
      geom_point(size = 3) +
      geom_line(data = df1, aes(x = Time, y = PopBio, col = model), size = 1) +
      theme(aspect.ratio=1, legend.position = "bottom")+ # make the plot square 
      labs(x = "Time", y = "PopBio")

    ggsave(log_plot, file = paste0("../results/plot_", i, ".png"))
    
  }
}


# they're not a super nice size but can fix this later


# gompertz:

for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) { # if there are fewer datapoints than the number of parameters: terminate the loop
    next
  }
  else {
    N_0_start <- min(d$PopBio)
    K_start <- 2*max(d$PopBio)
    r_max_start <- 0.00000001
    fit_gompertz <- try(
      nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
            list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
      , silent = TRUE)
    
    timepoints <- seq(0, max(d$Time), 0.1)
    
    logistic_points <- logistic_model(t = timepoints, 
                                      r_max = coef(fit_logistic)["r_max"], 
                                      K = coef(fit_logistic)["K"], 
                                      N_0 = coef(fit_logistic)["N_0"])
    df1 <- data.frame(timepoints, logistic_points)
    df1$model <- "Logistic equation"
    names(df1) <- c("Time", "PopBio", "model")
    
    log_plot <- ggplot(d, aes(x = Time, y = PopBio)) +
      geom_point(size = 3) +
      geom_line(data = df1, aes(x = Time, y = PopBio, col = model), size = 1) +
      theme(aspect.ratio=1, legend.position = "bottom")+ # make the plot square 
      labs(x = "Time", y = "PopBio")
    
    ggsave(log_plot, file = paste0("../results/plot_", i, ".png"))
    
  }
}











# Previous loops for model fitting ----------------------------------------






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


# also: make list of models so that can use built-in model comparisons:

# make an empty list
cubic <- vector(mode = "list", length = 285)

# fill that list with the models
for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    try(
      cubic[i] <- lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE)
      ), silent = TRUE)
  }
}



### QUADRATIC


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


# also: make list of models

# make an empty list
quadratic <- vector(mode = "list", length = 285)

# fill that list with the models
for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    try(
      quadratic[i] <- lm(d$log_PopBio ~ poly(d$Time, 2, raw = TRUE)
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




# also: make list of models:

# make an empty list
logistic <- vector(mode = "list", length = 285)

# fill that list with the models
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
      logistic[i] <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d,
                           list(r_max=r_max_start, N_0 = N_0_start, K = K_start)
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

gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   

gompertz_AICs2 <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))

for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    AIC_reps <- as.numeric(replicate(100, {
      N_0_start <- rnorm(1, m = min(d$log_PopBio), sd = abs(3*min(d$log_PopBio))) # use normal - higher confidence in mean    # abs(): bc sometimes the min or max of log_PopBio is -ve then rnorm can't generate anything
      K_start <- rnorm(1, m = 2*max(d$log_PopBio), sd = abs(3*2*max(d$log_PopBio))) # use normal - higher confidence in mean
      r_max_start <- runif(1, min = 10^-10, max = 10^-2) # use a uniform distribution (lower confiendece in mean) - NB: changing these bounds doesn't change the number of models which it manages to fit so just keep it as it is and don't worry too much about it
      # need to choose lower & upper bounds: usually good to set bound to be 5-10% of the parameter's (mean) starting value
      t_lag_start <- rnorm(1, m = d$Time[which.max(diff(diff(d$log_PopBio)))], sd = abs(3*d$Time[which.max(diff(diff(d$log_PopBio)))]))  # normal distribution with mean calculated using diff (the last timepoint of lag phase) and sd as 3 times that
      try(
        AIC(nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d,
                  list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
        ), silent = TRUE)
    }))
    try(
      gompertz_AICs2[i, "AIC"] <- min(AIC_reps, na.rm = T), silent = TRUE) # take the lowest AIC for each subset and put it in the AIC column of gompertz_AICs
  }
}


# count how many of the subsets it managed to fit models for:
length(which(gompertz_AICs2$AIC != Inf))


# also: make list with all the models:

# make an empty list
gompertz <- vector(mode = "list", length = 285)

# fill it with the models:
for (i in 1:285) {
  d <- data[which(data$ID == i),]
  if (nrow(d) < 4) {
    next
  }
  else {
    best_model <- replicate(100, {
      N_0_start <- rnorm(1, m = min(d$log_PopBio), sd = 3*min(d$log_PopBio)) # use normal - higher confidence in mean
      K_start <- rnorm(1, m = 2*max(d$log_PopBio), sd = 3*2*max(d$log_PopBio)) # use normal - higher confidence in mean
      r_max_start <- runif(1, min = 10^-10, max = 10^-2) # use a uniform distribution (lower confiendece in mean)
      t_lag_start <- rnorm(1, m = d$Time[which.max(diff(diff(d$log_PopBio)))], sd = 3*d$Time[which.max(diff(diff(d$log_PopBio)))])  # normal distribution with mean calculated using diff (the last timepoint of lag phase) and sd as 3 times that
      all_models <- try(
        nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d,
                  list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
        , silent = TRUE)
    })
    # loop through every thing in best_model 
    AICs <- for (i in 100) {
      try(AIC(best_model[i]), silent = TRUE)
    }
    everything <- data.frame(model = c(best_model),
                             AIC = c(AICs)) # make df with model in one column and AIC in other
    low_AIC <- everything[which.min(everything$AIC),] # select the row with the lowest AIC
    try(
      gompertz[i] <- low_AIC$model, silent = TRUE) # take the lowest AIC for each subset and put it in the AIC column of gompertz_AICs
  }
}

# --> problems with this loop... - need to fix







# Comparing models --------------------------------------------------------

# make big table:

models_all <- data.frame(subset = rep(1:285, 4),
                         model = c(rep('quadratic', 285), rep('cubic', 285), rep('logistic', 285), rep('gompertz', 285)),
                         AIC = c(quadratic_AICs$AIC, cubic_AICs$AIC, logistic_AICs$AIC, gompertz_AICs$AIC))

# save to results:
write.csv(models_all, file = "../results/models_all.csv")

# work out best model for each by just comparing AIC values to begin with:

models_best <- data.frame(subset = c(1:285),
                          best_model = rep(0, 285),
                          AIC = rep(0,285))


for (i in 1:285) {
  # subset out by ID:
  d <- models_all[which(models_all$subset == i),] 
  
  # rank AICs in order of lowest to highest:
  a <- order(d$AIC)
  ordered <- d$AIC[a]
  
  # if the diff between smallest and middle is < 2, terminate:
  if (isTRUE((ordered[2] - ordered[1]) < 2)) { 
    next
  }
  
  # otherwise, select the row with the lowest AIC
  else { 
    
    d_m <- d[which(d$AIC == ordered[1]),]
  
    # fill column in models_best with the details of this best model
    try(models_best[i, "AIC"] <- d_m$AIC, silent = TRUE) 
    try(models_best[i, "best_model"] <- as.character(d_m$model), silent = TRUE)
  }
  
}

# make zeros in model column NAs:
models_best$best_model[models_best$best_model==0] <- NA


# save to results:
write.csv(models_best, file = "../results/models_best.csv")



# where models have similar levels of support: use model averaging to make robust parameter estimates & predictions?





# HYPOTHESIS TESTING ------------------------------------------------------


# make final dataframe used for analysis:

# add columns with potential predictors:

data$Species <- as.character(data$Species)

data$Medium <- as.character(data$Medium)

models_everything <- data.frame(subset = c(models_best$subset),
                                Model = c(models_best$best_model),
                                AIC = c(models_best$AIC),
                                Temperature = c(rep(0, 285)),
                                species = c(rep(NA, 285)),
                                Genus = c(rep(NA, 285)),
                                Medium = c(rep(NA, 285)),
                                stringsAsFactors = FALSE)

# fill the temp, species, and medium column
for (i in 1:285) {
  # subset by ID
  d <- data[which(data$ID == i),]
  # populate models_everything with temp, medium & species for each ID
  models_everything[i, "Temperature"] <- d$Temp[1]
  models_everything[i, "species"] <- d$Species[1]
  models_everything[i, "Medium"] <- d$Medium[1]
}

# fill the genus column: will test for effect of that instead of species:
models_everything$Genus[models_everything$species=="Acinetobacter.clacoaceticus..RDA.R."] <- "Acinetobacter"
models_everything$Genus[models_everything$species=="Acinetobacter.clacoaceticus.1"] <- "Acinetobacter"
models_everything$Genus[models_everything$species=="Acinetobacter.clacoaceticus.2"] <- "Acinetobacter"

models_everything$Genus[models_everything$species=="Aerobic Mesophilic."] <- "Aerobic"
models_everything$Genus[models_everything$species=="Aerobic Psychotropic."] <- "Aerobic"

models_everything$Genus[models_everything$species=="Arthrobacter aurescens"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter citreus"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter globiformis"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter simplex"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter sp. 62"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter sp. 77"] <- "Arthrobacter"
models_everything$Genus[models_everything$species=="Arthrobacter sp. 88"] <- "Arthrobacter"

models_everything$Genus[models_everything$species=="Bacillus.pumilus"] <- "Bacillus"
models_everything$Genus[models_everything$species=="Bacillus.pumilus..RDA.R."] <- "Bacillus"

models_everything$Genus[models_everything$species=="Chryseobacterium.balustinum"] <- "Chryseobacterium"

models_everything$Genus[models_everything$species=="Clavibacter.michiganensis"] <- "Clavibacter"
models_everything$Genus[models_everything$species=="Clavibacter.michiganensis..RDA.R."] <- "Clavibacter"

models_everything$Genus[models_everything$species=="Dickeya.zeae"] <- "Dickeya"
models_everything$Genus[models_everything$species=="Dickeya.zeae..RDA.R."] <- "Dickeya"

models_everything$Genus[models_everything$species=="Enterobacter.sp."] <- "Enterobacter"

models_everything$Genus[models_everything$species=="Escherichia coli"] <- "Escherichia"

models_everything$Genus[models_everything$species=="Klebsiella.pneumonia"] <- "Klebsiella"
models_everything$Genus[models_everything$species=="Klebsiella.pneumonia..RDA.R."] <- "Klebsiella"

models_everything$Genus[models_everything$species=="Lactobacillus plantarum"] <- "Lactobacillus"
models_everything$Genus[models_everything$species=="Lactobacillus sakei"] <- "Lactobacillus"
models_everything$Genus[models_everything$species=="Lactobaciulus plantarum"] <- "Lactobacillus"

models_everything$Genus[models_everything$species=="Oscillatoria agardhii Strain 97"] <- "Oscillatoria"
models_everything$Genus[models_everything$species=="Oscillatoria agardhii StrainCYA 128"] <- "Oscillatoria"

models_everything$Genus[models_everything$species=="Pantoea.agglomerans..RDA.R."] <- "Pantoea"
models_everything$Genus[models_everything$species=="Pantoea.agglomerans.1"] <- "Pantoea"
models_everything$Genus[models_everything$species=="Pantoea.agglomerans.2"] <- "Pantoea"

models_everything$Genus[models_everything$species=="Pectobacterium.carotovorum.subsp..Carotovorum.Pcc2"] <- "Pectobacterium"

models_everything$Genus[models_everything$species=="Pseudomonas sp."] <- "Pseudomonas"
models_everything$Genus[models_everything$species=="Pseudomonas spp."] <- "Pseudomonas"
models_everything$Genus[models_everything$species=="Pseudomonas.fluorescens.1"] <- "Pseudomonas"
models_everything$Genus[models_everything$species=="Pseudomonas.fluorescens.2"] <- "Pseudomonas"

models_everything$Genus[models_everything$species=="Salmonella Typhimurium"] <- "Salmonella"

models_everything$Genus[models_everything$species=="Serratia marcescens"] <- "Serratia"

models_everything$Genus[models_everything$species=="Spoilage"] <- "Spoilage" #--> this is a combination of bacteria which causes food spoilage

models_everything$Genus[models_everything$species=="Staphylococcus spp."] <- "Staphylococcus" 

models_everything$Genus[models_everything$species=="Stenotrophomonas.maltophilia.1"] <- "Stenotrophomonas"
models_everything$Genus[models_everything$species=="Stenotrophomonas.maltophilia.2"] <- "Stenotrophomonas"
models_everything$Genus[models_everything$species=="Stenotrophomonas.maltophilia..RDA.R."] <- "Stenotrophomonas"

models_everything$Genus[models_everything$species=="Tetraselmis tetrahele"] <- "Tetraselmis"

models_everything$Genus[models_everything$species=="Weissella viridescens"] <- "Weissella"

# make temp factor for analysis:
models_everything$Temperature <- as.factor(models_everything$Temperature)

# save as csv:
write.csv(models_everything, file = "../results/models_everything.csv")


# read back in for future use:
models_everything <- read.csv("../results/models_everything.csv")



# general questions about which models more commonly fit best

# i.e. mechanistic vs phenomenological

# work out number & proportion of each model fitted: (for everywhere where one model was better than others)

length(which(models_everything$Model != 'NA'))
#--> a best model was selected for 231 of the subsets

# cubic:
cubic_no <- length(which(models_everything$Model == 'cubic'))
cubic_prop <- cubic_no / 231
cubic_prop #--> 0.1341991

# quadratic:
quadratic_no <- length(which(models_everything$Model == 'quadratic'))
#--> 0

# logistic:
logistic_no <- length(which(models_everything$Model == 'logistic'))
logistic_prop <- logistic_no / 231
logistic_prop #--> 0.3722944

# gompertz:
gompertz_no <- length(which(models_everything$Model == 'gompertz'))
gompertz_prop <- gompertz_no / 231
gompertz_prop #--> 0.4935065

# --> problem: can't really test for whether we have most gompertz in a statistically significant way bc would need a null hypothesis/distribution

# --> BUT.. there's some variation in which model fits best
## maybe quote some stat for this? (e.g. which percentage of the subsets is represented by this model)


# so need to control for potential confounding factors in the variables delineating the subsets which could be biasing our result
## e.g. if we find logistic is the most common - is it the most common just bc most of the subsets are of a certain temp which is fitted better by a certain model


# potential predictors of which model fits best:
# species
# temp
# medium

#--> these could especially affect whether logistic or gompertz fit best:
# bc they might affect the time lag which the gompertz model accounts for:
# see big model fitting notes section - right at the end (Population growth rates >> Using NLLS)








# test for the effects of predictors on which model it ends up being:



# species and medium: intrinsic chisquared test:

genus_test <- chisq.test(table(models_everything$Model, models_everything$Genus))
genus_test

medium_test <- chisq.test(table(models_everything$Model, models_everything$Medium))
medium_test

temp_test <- chisq.test(table(models_everything$Model, models_everything$Temperature))
temp_test

#--> all significant

# visualizing it: bar plot:

genus_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = Genus)+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom')+
  xlab('Model')+
  ylab('Count')
  


medium_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = Medium)+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom')+
  ylab('Count')

temp_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = Temperature)+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom', legend.title = "Temperature (C)")+
  ylab('Count')

fig2 <- ggarrange(species_plot, medium_plot, temp_plot, labels = c("A", "B", "C"))



# Previous loops for comparing models -------------------------------------



# PREVIOUS LOOPS: not needed

for (i in 1:285) {
  d <- models_all[which(models_all$subset == i),] # subset out by ID
  
  # rank the AICs in order of lowest to highest
  d_m <- d[which.min(d$AIC),] # select the row with the lowest AIC
  try(models_best[i, "AIC"] <- d_m$AIC, silent = TRUE) # fill column in models_best with the details of this best model
}
for (i in 1:285) {
  d <- models_all[which(models_all$subset == i),] # subset out by ID
  d_m <- d[which.min(d$AIC),] # select the row with the lowest AIC
  try(models_best[i, "best_model"] <- as.character(d_m$model), silent = TRUE) # fill column in models_best with the details of this best model
}


# 1. subset out by ID
d <- models_all[which(models_all$subset == 1),] 

# 2. rank AICs in order of lowest to highest
a <- order(d$AIC)
ordered <- d$AIC[a]

# 3. if the diff between smallest and middle is < 2, terminate
if ((ordered[2] - ordered[1]) < 2) { 
  next
}

# 4. otherwise, select the row with the lowest AIC
d_m <- d[which(d$AIC == ordered[1]),]


# fill column in models_best with the details of this best model
try(models_best[i, "AIC"] <- d_m$AIC, silent = TRUE) 
try(models_best[i, "best_model"] <- as.character(d_m$model), silent = TRUE)








# DON'T NEED THIS FOR NOW:

# --> don't need to do this by hand! - R has built-in functions:

# need to loop the following through each ID:

# put the all the models together in a list (starting with quadratic then cubic then logistic)
models_list <- c(quadratic[1], cubic[1], logistic[1])
model_names <- c('quadratic', 'cubic', 'logistic')

# run aictab() to do the comparison
aictab(cand.set = models_list, modnames = model_names)


#--> BUT: then again: maybe don't need this bc the main important thing it brings to the table is a way to calculate AIC weights
#--> but bc the models aren't nested AIC weights aren't that helpful - so might just stick to manually using standard AIC comparison?












# purpose of this: to work out parameter values







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

# OR: can also visualise logistic using log-transformed data:
ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = log(N), col = model), size = 1) +
  theme(aspect.ratio=1)+ 
  labs(x = "Time", y = "log(Cell number)")
#--> potential divergences of model from data might be visible here where they weren't before.. - bc of the way logs work



# plotting multiple models for comparison:

timepoints <- seq(0, 24, 0.1)

logistic_points <- log(logistic_model(t = timepoints, 
                                      r_max = coef(fit_logistic)["r_max"], 
                                      K = coef(fit_logistic)["K"], 
                                      N_0 = coef(fit_logistic)["N_0"]))

gompertz_points <- gompertz_model(t = timepoints, 
                                  r_max = coef(fit_gompertz)["r_max"], 
                                  K = coef(fit_gompertz)["K"], 
                                  N_0 = coef(fit_gompertz)["N_0"], 
                                  t_lag = coef(fit_gompertz)["t_lag"])

df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic model"
names(df1) <- c("Time", "LogN", "model")

df2 <- data.frame(timepoints, gompertz_points)
df2$model <- "Gompertz model"
names(df2) <- c("Time", "LogN", "model")

model_frame <- rbind(df1, df2)

ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = model_frame, aes(x = Time, y = LogN, col = model), size = 1) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "log(Abundance)")





# Testing for whether replicates are an issue -----------------------------

# replicates: run lm to compare diff replicates --> establish that they're not significantly different from each other

# therefore it doesn't matter which one you choose 

# but do need to choose one of them bc they'll be a bit different bc they're diff experiments (so diff popns, probably diff starting points etc)

# so can just choose replicate = 1 for all of them



lm_reps <- lm(PopBio ~ Time + as.character(Rep), data = data) # need to make it as a character so that 
summary(lm_reps)

##--> Rep is not a significant predictor of relationship between PopBio and Time therefore don't need to worry about it 









