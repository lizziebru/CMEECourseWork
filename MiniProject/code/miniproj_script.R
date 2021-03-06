# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: miniproj_script.R
# Desc: this script contains the plots for the miniproject
# Date: Nov 2021

# install.packages('ggplot2')
library(ggplot2)
# install.packages('minpack.lm')
library(minpack.lm)
# install.packages('qpcR')
library(qpcR)
# install.packages("viridis")
library(viridis)
# install.packages("ggpubr")
library(ggpubr)
# install.packages("olsrr")
library(olsrr)
# install.packages("dplyr")
library(dplyr)

data <- read.csv("../data/LogisticGrowthData2.csv")
data[is.na(data) | data == "Inf" | data == "-Inf"] <- NA  # Replace NaN & Inf with NA otherwise models don't run


# Model fitting -----------------------------------------------------------

cubic_AICs <- data.frame(Subset = c(1:285),
                         AIC = rep(0, 285))

quadratic_AICs <- data.frame(Subset = c(1:285),
                             AIC = rep(0, 285))

logistic_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))

gompertz_AICs <- data.frame(Subset = c(1:285),
                            AIC = rep(0, 285))


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
    try(
      cubic_AICs[i, "AIC"] <- AIC(lm(d$log_PopBio ~ poly(d$Time, 3, raw = TRUE))
      ), silent = TRUE)
    
    # quadratic:
    try(
      quadratic_fit <- lm(d$log_PopBio ~ poly(d$Time, 2, raw = TRUE), silent = TRUE))
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
    try(
      gompertz_AICs[i, "AIC"] <- min(AIC_reps, na.rm = T), silent = TRUE) # take the lowest AIC for each subset and put it in the AIC column of gompertz_AICs
  
  }
}


# count how many of the subsets gompertz managed to fit models for:
length(which(gompertz_AICs2$AIC != Inf))


# Plotting  --------------------------------------------------------

# need: one plot that of one subset with all the curves on it:

# pick a subset: ID = 1
d1 <- data[which(data$ID == 1),]


# fit each model:

# quadratic:
d1q <- lm(d1$log_PopBio ~ poly(d1$Time, 2, raw = TRUE))

# cubic:
d1c <- lm(d1$log_PopBio ~ poly(d1$Time, 3, raw = TRUE))

# logistic:
N_0_start <- min(d$PopBio)
K_start <- 2*max(d$PopBio)
r_max_start <- 0.00000001
d1l <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), d1,
             list(r_max=r_max_start, N_0 = N_0_start, K = K_start))

# gompertz:
# need to sample through starting values to make it fit
repeat {
  success <- 0
  N_0_start <- rnorm(1, m = min(d1$log_PopBio), sd = abs(3*min(d1$log_PopBio)))
  K_start <- rnorm(1, m = 2*max(d1$log_PopBio), sd = abs(3*2*max(d1$log_PopBio)))
  r_max_start <- runif(1, min = 10^-10, max = 10^-2)
  t_lag_start <- rnorm(1, m = d1$Time[which.max(diff(diff(d1$log_PopBio)))], sd = abs(3*d1$Time[which.max(diff(diff(d1$log_PopBio)))])) 
  try(
    {d1g <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), d1,
                                  list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
    success <- 1}
    )
  if (success == 1) { # terminate the loop as soon as it successfully fits one model - because just need one for the sake of visualisation
    break
  }
}

# make plot using these models:

timepoints <- seq(0, max(d1$Time), 0.1)
pred_df <- data.frame(timepoints = timepoints,
                      log_vals = log(logistic_model(r_max=coef(d1l)[1], N_0 = coef(d1l)[2], K = coef(d1l)[3], t = timepoints)),
                      gom_vals = gompertz_model(t_lag = coef(d1g)[1], r_max=coef(d1g)[2], N_0 = coef(d1g)[3], K = coef(d1g)[4], t = timepoints))

models_plot <- ggplot(d1, aes(Time, log_PopBio)) + geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, degree = 2, raw = TRUE), se = FALSE, aes(colour = "#CC79A7")) + #add aes colours to tell them apart
  geom_smooth(method = "lm", formula = y ~ poly(x, degree = 3, raw = TRUE), se = FALSE, aes(colour = "#D55E00")) +
  geom_smooth(method = "loess", data = pred_df, formula = y ~ x, aes(timepoints, log_vals, colour = "#0072B2")) +
  geom_smooth(method = "loess", data = pred_df, formula = y ~ x, aes(timepoints, gom_vals, colour = "#F0E442"))+
  scale_color_manual(name = NULL, values = c("#CC79A7", "#D55E00", "#0072B2", "#F0E442"), labels = c("Quadratic", "Cubic", "Logistic", "Gompertz"))+
  guides(col = guide_legend("Model"))+
  ylab("Log(population density)")+
  theme_bw()+
  ylim(0, 8)

ggsave(models_plot, filename = "../results/fig1.png", height = 4, width = 4)


# Selecting the best model --------------------------------------------------------

# make big table:

models_all <- data.frame(subset = rep(1:285, 4),
                         model = c(rep('Quadratic', 285), rep('Cubic', 285), rep('Logistic', 285), rep('Gompertz', 285)),
                         AIC = c(quadratic_AICs$AIC, cubic_AICs$AIC, logistic_AICs$AIC, gompertz_AICs$AIC))


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
  
  # if the difference between smallest and next smallest is < 2, terminate:
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

# make the zeros in the model column into NAs:
models_best$best_model[models_best$best_model==0] <- NA


# Analysis ------------------------------------------------------

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

# make temperature a factor for analysis:
models_everything$Temperature <- as.factor(models_everything$Temperature)



# Q1: hich models more commonly fit best


# work out number & proportion of each model fitted: (for everywhere where one model was better than others)

length(which(models_everything$Model != 'NA'))
#--> a best model was selected for 232 of the subsets

# cubic:
cubic_no <- length(which(models_everything$Model == 'Cubic'))
cubic_prop <- cubic_no / 231

# quadratic:
quadratic_no <- length(which(models_everything$Model == 'Quadratic'))
quadratic_prop <- quadratic_no / 231

# logistic:
logistic_no <- length(which(models_everything$Model == 'Logistic'))
logistic_prop <- logistic_no / 231

# gompertz:
gompertz_no <- length(which(models_everything$Model == 'Gompertz'))
gompertz_prop <- gompertz_no / 231

# make final dataframe with these results rounded to 3sf
proportions <- data.frame(Model = c("Quadratic", "Cubic", "Logistic", "Gompertz"),
                          Count = c(signif(quadratic_no, 3), signif(cubic_no, 3), signif(logistic_no, 3), signif(gompertz_no, 3)),
                          Proportion = c(signif(quadratic_prop, 3), signif(cubic_prop, 3), signif(logistic_prop, 3), signif(gompertz_prop, 3)))



# Q2: test for the effects of predictors on which model is best:

# intrinsic chi-squared test:

genus_test <- chisq.test(table(models_everything$Model, models_everything$Genus))
genus_test

medium_test <- chisq.test(table(models_everything$Model, models_everything$Medium))
medium_test

temp_test <- chisq.test(table(models_everything$Model, models_everything$Temperature))
temp_test

#--> all significant

# get more detail about how exactly they predict the best model:

#subset by model and visually inspect:

cub <- models_everything[which(models_everything$Model == "Cubic"), ]
log <- models_everything[which(models_everything$Model == "Logistic"), ]
gomp <- models_everything[which(models_everything$Model == "Gompertz"), ]

# also make tables to better see what's going on:
cub_gen <- as.data.frame(table(cub$Genus))
cub_gen <- cub_gen[which(cub_gen$Freq != 0), ]  # remove rows where count is zero
cub_gen <- na.omit(cub_gen) # also remove any rows filled with NAs (sometimes does this)
cub_gen <- cub_gen[order(- cub_gen$Freq),] # order by descending frequency

cub_med <- as.data.frame(table(cub$Medium))
cub_med <- cub_med[which(cub_med$Freq != 0), ]  # remove rows where count is zero
cub_med <- na.omit(cub_med) # also remove any rows filled with NAs (sometimes does this)
cub_med <- cub_med[order(- cub_med$Freq),] # order by descending frequency

cub_temp <- as.data.frame(table(cub$Temperature))
cub_temp <- cub_temp[which(cub_temp$Freq != 0), ]  # remove rows where count is zero
cub_temp <- na.omit(cub_temp) # also remove any rows filled with NAs (sometimes does this)
cub_temp <- cub_temp[order(- cub_temp$Freq),] # order by descending frequency


log_gen <- as.data.frame(table(log$Genus))
log_gen <- log_gen[which(log_gen$Freq != 0), ]  # remove rows where count is zero
log_gen <- na.omit(log_gen) # also remove any rows filled with NAs (sometimes does this)
log_gen <- log_gen[order(- log_gen$Freq),] # order by descending frequency

log_med <- as.data.frame(table(log$Medium))
log_med <- log_med[which(log_med$Freq != 0), ]  # remove rows where count is zero
log_med <- na.omit(log_med) # also remove any rows filled with NAs (sometimes does this)
log_med <- log_med[order(- log_med$Freq),] # order by descending frequency

log_temp <- as.data.frame(table(log$Temperature))
log_temp <- log_temp[which(log_temp$Freq != 0), ]  # remove rows where count is zero
log_temp <- na.omit(log_temp) # also remove any rows filled with NAs (sometimes does this)
log_temp <- log_temp[order(- log_temp$Freq),] # order by descending frequency


gomp_gen <- as.data.frame(table(gomp$Genus))
gomp_gen <- gomp_gen[which(gomp_gen$Freq != 0), ]  # remove rows where count is zero
gomp_gen <- na.omit(gomp_gen) # also remove any rows filled with NAs (sometimes does this)
gomp_gen <- gomp_gen[order(- gomp_gen$Freq),] # order by descending frequency

gomp_med <- as.data.frame(table(gomp$Medium))
gomp_med <- gomp_med[which(gomp_med$Freq != 0), ]  # remove rows where count is zero
gomp_med <- na.omit(gomp_med) # also remove any rows filled with NAs (sometimes does this)
gomp_med <- gomp_med[order(- gomp_med$Freq),] # order by descending frequency

gomp_temp <- as.data.frame(table(gomp$Temperature))
gomp_temp <- gomp_temp[which(gomp_temp$Freq != 0), ]  # remove rows where count is zero
gomp_temp <- na.omit(gomp_temp) # also remove any rows filled with NAs (sometimes does this)
gomp_temp <- gomp_temp[order(- gomp_temp$Freq),] # order by descending frequency


# examining biases in the data:
# how many of each genus:
genera <- table(models_everything$Genus)
# work out what percentage of the populations are Aerobic, Arthrobacter, and Pseudomonas::
aerobic <- 100*length(which(models_everything$Genus == 'Aerobic'))/length(models_everything$Genus)
arthrobacter <- 100*length(which(models_everything$Genus == 'Arthrobacter'))/length(models_everything$Genus)
pseudomonas <- 100*length(which(models_everything$Genus == 'Pseudomonas'))/length(models_everything$Genus)



# visualizing this: bar plot:

genus_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = Genus)+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom')+
  xlab('Model')+
  ylab('Count')+
  coord_flip()
  
medium_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = Medium)+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom')+
  ylab('Count')+
  coord_flip()

temp_plot <- ggplot(data = subset(models_everything, !is.na(Model)))+
  aes(x = Model, fill = as.factor(Temperature))+
  geom_bar()+
  scale_fill_viridis(discrete = TRUE)+
  theme_minimal()+
  theme(legend.position = 'bottom')+
  labs(fill = "Temperature (C)")+
  ylab('Count')+
  coord_flip

fig2 <- ggarrange(genus_plot, temp_plot, medium_plot, labels = c("A", "B", "C"), nrow = 3)

ggsave(fig2, filename = "../results/fig2.png", height = 10, width = 10)


