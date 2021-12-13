# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Lizzie Bru"
preferred_name <- "Lizzie"
email <- "e.bru21@imperial.ac.uk"
username <- "eab21"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!


# load required packages:
require(ggplot2)


# Question 1
species_richness <- function(community){
  length(unique(community)) # unique lists all the unique values - length then returns the length of that to give the number of unique values
}

# Question 2
init_community_max <- function(size){
  seq(from = 1, to = size, by = 1) # generate a sequence from one to the the size of the community in increments of 1
}

# Question 3
init_community_min <- function(size){
  rep(1, size) # repeat 1 however many times the size of the community is
}

# Question 4
choose_two <- function(max_value){
  # choose a random number according to uniform distribution between 1 and max_value (inclusive of endpoints)
  r1 <- sample(1:max_value, 1)
  # choose a second random number between 1 and max_value but not equal to r1
  repeat {
    r2 <- sample(1:max_value, 1)
    if (r2 != r1) { # terminate the loop as soon as it successfully generates an r2 which is different from r1
      break
    }
  }
  # return numbers as a vector of length 2
  c(r1, r2)
}

# Question 5
neutral_step <- function(community){
  # call choose_two to sample two random positions in the vector
  random2 <- choose_two(length(community))
  # make an individual die:
  com1 <- community[-random2[1]]
  # make another reproduce
  append(com1, community[random2[2]])
}

# Question 6
neutral_generation <- function(community){
  # store the value of generation length (half the number of individuals in the community (randomly rounded up or down if not a whole number))
  if ((length(community) %% 2) == 0) {# if the number of individuals is even (i.e. when divided by 2 gives a remainder of zero)
    half <- length(community)/2
    }
  else {
    half1 <- length(community)/2
    half2 <- half1 + sample(c(-0.1, 0.1), 1) # to randomly alternate between rounding up and down: either add or subtract 0.1 which means it'll either round up or down, respectively
    half <- round(half2)
  }
  count = 0  # set the counter equal to zero: this will be used to break the repeat loop
  repeat{ # run neutral_steps on the community, repeating this a number of times equal to half the size of the community
    community <- neutral_step(community) 
    count = count + 1
    if (count == half + 1){ # stop repeating once you've done this the correct number of times
      break
    }
  }
  return(community) # return the final community
}


# Question 7
neutral_time_series <- function(community,duration)  {
  # make empty spp_richness vector 
  spp_richness <- c(species_richness(community)) 
  #run neutral_generation on the community for each generation (i.e. duration)
  for (i in 1:duration) {
    community <- neutral_generation(community)
    richness = species_richness(community)
    spp_richness <- c(spp_richness, richness)
  } 
  # return species richness of the final community
  return(spp_richness)
}


# Question 8
question_8 <- function() {
  community <- init_community_max(100)
  spp_richness <- neutral_time_series(community, 200)
  graphics.off() # clear any existing graphs
  plot_df <- data.frame(spp_richness = spp_richness,
                        Generation = seq(0,200))
  p <- ggplot(plot_df, aes(x = Generation, y = spp_richness))+ # plot graph within the R window
    geom_line()+
    theme_bw()+
    ylab('Species richness')+
    theme(aspect.ratio = 1, plot.title = element_text(hjust = 0.5))+
    ggtitle("Species richness across generations \nin a neutral simulation")
  plot(p)
  return("The system will always converge to monodominance (species richness equal to 1) if you wait long enough because there is no immigration; when an individual reproduces to fill gaps left by individuals dying, it creates more individuals of that species which then each in turn create more, causing a gradual take-over by that species")
}


# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  # call choose_two to sample two random positions in the vector
  random2 <- choose_two(length(community))
  # make an individual die:
  com1 <- community[-random2[1]]
  # assign variable with either one of 2 values with probabilities equal to speciation_rate of 1-speciation_rate
  x <- sample(c(0,1), 1, prob = c(speciation_rate, 1-speciation_rate))
  # if x = 0: replace it with a new species (with probability 'speciation_rate') or the offspring of another individual (with probability 1-'speciation_rate')
  if (x == 0){
    repeat {
    r1 <- sample(1:100000, 1) # sample a random value
    if (!(r1 %in% community)) { # break the loop as soon as you've sampled a value that isn't already in community
      break
    }
    }
    append(com1, r1) # append it to the community
  }
  else {
  append(com1, community[random2[2]]) # reproduction of another species
  }
}


# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  # store the value of generation length (half the number of individuals in the community (randomly rounded up or down if not a whole number))
  if ((length(community) %% 2) == 0) {# if the number of individuals is even (i.e. when divided by 2 gives a remainder of zero)
    half <- length(community)/2
  }
  else {
    half1 <- length(community)/2
    half2 <- half1 + sample(c(-0.1, 0.1), 1) # to randomly alternate between rounding up and down: either add or subtract 0.1 which means it'll either round up or down, respectively
    half <- round(half2)
  }
  count = 0  # set the counter equal to zero: this will be used to break the repeat loop
  repeat{ # run neutral_steps on the community, repeating this a number of times equal to half the size of the community
    community <- neutral_step_speciation(community, speciation_rate) 
    count = count + 1
    if (count == half + 1){ # stop repeating once you've done this the correct number of times
      break
    }
  }
  return(community) # return the final community
}


# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  # make empty spp_richness vector 
  spp_richness <- c(species_richness(community)) 
  #run neutral_generation on the community for each generation (i.e. duration)
  for (i in 1:duration) {
    community <- neutral_generation_speciation(community, speciation_rate)
    richness = species_richness(community)
    spp_richness <- c(spp_richness, richness)
  } 
  # return species richness of the final community
  return(spp_richness)
}

# Question 12
question_12 <- function()  {
  community_max <- init_community_max(100)
  community_min <- init_community_min(100)
  spp_richness_max <- neutral_time_series_speciation(community_max, 0.1, 200)
  spp_richness_min <- neutral_time_series_speciation(community_min, 0.1, 200)
  graphics.off() # clear any existing graphs
  plot_df <- data.frame(spp_richness = c(spp_richness_max, spp_richness_min),
                        minmax = c(rep('Maximum_initial_richness', length(spp_richness_max)), rep('Minimum_initial_richness', length(spp_richness_max))),
                        Generation = c(rep(seq(0, 200), length(2))))
  p <- ggplot(plot_df, aes(x = Generation, y = spp_richness, colour = minmax))+ # plot graph within the R window
    geom_line()+
    scale_fill_manual(values = c("#005AB5", "#DC3220"))+ # use colour-blind-friendly colours
    theme_bw()+
    ylab('Species richness')+
    labs(colour="")+
    theme(legend.position = "bottom", 
          aspect.ratio = 1, 
          plot.title = element_text(hjust = 0.5, size = 15, face = "bold"), 
          axis.title = element_text(size = 10, face = "bold"))+
    ggtitle("Species richness across generations \nin a neutral simulation")
  plot(p)
  return("Communities with low initial species richness increase in diversity over time as common species are replaced by new, unique species. 
  Communities with high initial species richness conversely lose species richness over time as speciation replaces existing unique species with new species. 
  Over many generations, community species richness in both communities with initially low and initially high diversity tends towards the same equilibrium.
         This is because both are eitehr gaining or losing species richness such that they become less extreme in being of either high or low diversity.
         This equilibrium depends on speciation rate; higher speciation rates are associated with higher equilibrium species richness.")
}

# Question 13
species_abundance <- function(community)  {
  community_info <- table(community) # make table with each unique species identity and its corresponding abundance
  sorted <- as.data.frame(sort(community_info, decreasing = TRUE)) # sort by decreasing abundance of each species
  # return just the column with the abundance - return it as a list so it's easy to read
  return(sorted[,2])
}

# Question 14
octaves <- function(abundance_vector) {
  # take log2 of the abundance vector
  # Add 1 to this to account for the fact that there are zeros
  # use floor to round down to an integer value
  # bin these resulting values
  tabulate(floor(log2(abundance_vector))+1)
}

# Question 15
sum_vect <- function(x, y) {
  diff <- length(x)-length(y) # work out the difference in length between the 2 vectors
  if (diff > 0) { # if y is shorter than x, fill up y with zeros
    y <- c(y, rep(0, abs(diff))) }
  if (diff < 0) { # if x is shorter, do this to x instead
    x <- c(x, rep(0, abs(diff))) }
  vector_sum <- x + y # now add the vectors now they're the same length (if diff == 0 will go straight to this)
  return(vector_sum) # return the sum
}

# Question 16
question_16 <- function()  {
  # clear any existing graphs
  graphics.off()
  
  #Set starting values for temporary variables
  rich_max <- init_community_max(100)
  rich_min <- init_community_min(100)
  speciation_rate = 0.1
  burn = 200
  generations = 2000
  counter = 0
  
  # run neutral model for a 'burn in' period of 200 generations
  for (i in 1:burn) {
    rich_max <- neutral_generation_speciation(rich_max, speciation_rate)
    rich_min <- neutral_generation_speciation(rich_min, speciation_rate)
  }
  
  # record species abundance octave vectors
  oct_max <- octaves(species_abundance(rich_max))
  oct_min <- octaves(species_abundance(rich_min))
  
  # continue simulation for a further 2000 generations
  for (x in 1:generations) {
    rich_max <- neutral_generation_speciation(rich_max, speciation_rate)
    rich_min <- neutral_generation_speciation(rich_min, speciation_rate)
    # store octave values every 20 generations
    if (x%%20 == 0) {
      counter = counter+1 #set a counter for each iteration
      oct_min <- sum_vect(oct_min, octaves(species_abundance(rich_min)))
      oct_max <- sum_vect(oct_max, octaves(species_abundance(rich_max)))
    }
  }
  # work out mean octaves
  oct_max_mean <- oct_max/counter
  oct_min_mean <- oct_min/counter
  
  # Plots: bar charts of mean octaves for communities with either max or min initial diversity
  par(mfrow=c(1,2))
  barplot(oct_max_mean,generations)
  barplot(oct_max_mean,generations)
  
  return ("The initial condition does not affect the final outcome because both populations tend towards the same octave number after the initial 'burn-in' period (set here as 200 generations).")
}


# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
    
}



# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  combined_results <- list() #create your list output here to return
  # save results to an .rda file
  
}

plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
    
    return(combined_results)
}

# Question 21
question_21 <- function()  {
    
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
    
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {
    
  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 29
fern <- function(start_position, direction, length)  {
  
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  graphics.off() # clear any existing graphs
  
  # define variables to be used to simulate a community's species richness over many generations
  time <- seq(0, 200)
  rich_max <- matrix(nrow = 30, ncol = 201, data = NA)
  rich_min <- matrix(nrow = 30, ncol = 201, data = NA)
  
  # simulate neutral steps with speciation
  for (i in seq(1, 30)){
    rich_max[i,] <- neutral_time_series_speciation(init_community_max(100), 0.1, 200)
    rich_min[i,] <- neutral_time_series_speciation(init_community_min(100), 0.1, 200)
  }
  
  # make functions to work out upper and lower CIs
  CI_upper <- function(x){
    qnorm(0.972, mean = mean(x), sd = sd(x))}
  CI_lower <- function(x){
    qnorm(0.028, mean = mean(x), sd = sd(x))}
  
  # apply these functions to work out upper and lower CIs for max and min
  CI_upper_max <- apply(rich_max, 2, CI_upper)
  CI_lower_max <- apply(rich_max, 2, CI_lower)
  
  CI_upper_min <- apply(rich_min, 2, CI_upper)
  CI_lower_min <- apply(rich_min, 2, CI_lower)
  
  # work out the mean number of species at each generation
  rich_max <- apply(rich_max, 2, mean)
  rich_min <- apply(rich_min, 2, mean)
  
  # make dataframe for plot
  df <- data.frame(time = rep(time, 2), 
                   species_no = c(rich_max, rich_min),
                   CI_upper = c(CI_upper_max, CI_upper_min), 
                   CI_lower = c(CI_lower_max, CI_lower_min),
                   minmax = c(rep("Maximum intial diversity", 201), rep("Minimum initial diversity", 201)))
  # plot
  p <- ggplot(data = df, aes(x = time, y = species_no, colour = minmax)) +
    geom_point()+
    geom_ribbon(aes(ymin = CI_lower, ymax = CI_upper), alpha = 0.2) +
    annotate("text", label = "X", x = 29, y = 25, size = 5, colour = "black", fontface = "bold") +
    ggtitle("Mean species richness with \n97.2% confidence interval") +
    xlab("Generation") +
    ylab("Mean number of species") + 
    theme_bw()+
    theme(aspect.ratio = 1) +
    theme(legend.position = "bottom") +
    labs(colour="")+
    theme(axis.title = element_text(size = 10, face = "bold"), 
          plot.title = element_text(size = 15, face = "bold"))
  plot(p)

  return("The point labelled 'X' on the graph is my estimate of where the system reaches dynamic equilibrium: at roughly 29 generations.")
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


