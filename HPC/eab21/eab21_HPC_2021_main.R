# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Lizzie Bru"
preferred_name <- "Lizzie"
email <- "e.bru21@imperial.ac.uk"
username <- "eab21"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!


# load required packages:
require(ggplot2)
require(viridis)


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
  
  # sometimes oct_min only has 5 octaves rather than 6, so this messes up the plotting: to fix this:
  if (length(oct_min) == 5) {
    oct_min <- c(oct_min, 0)
  }
  
  if (length(oct_min) == 4) {
    oct_min <- c(oct_min, 0, 0)
  }
  
  if (length(oct_min) == 3) {
    oct_min <- c(oct_min, 0, 0, 0)
  }
  
  # work out mean octaves
  oct_max_mean <- oct_max/counter
  oct_min_mean <- oct_min/counter
  
  # Plots: bar charts of mean octaves for communities with either max or min initial diversity
  df <- data.frame(ranges = c(seq(1,6), seq(1,6)),
                   values = c(oct_max_mean, oct_min_mean),
                   type = c(rep("Octave_max", 6), rep("Octave_min", 6)))
  df$ranges <- factor(df$ranges, levels = unique(df$ranges))
  p <- ggplot(data = df, aes(x = ranges, y = values, fill = type)) + 
    geom_bar(stat = "identity", position = "dodge") +
    xlab("Number of individuals per species") + 
    ylab("Number of species") +
    ggtitle("Number of species for various \nspecies abundances for communities \nunder neutral simulation")+
    theme(axis.title = element_text(size = 10, face = "bold"),
          plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
          legend.position = "bottom",
          #plot.background = element_rect(fill = "transparent", color = 'white'),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())+ 
    scale_fill_manual(name = "Initial diversity", labels = c("Maximum", "Minimum"), values = c("#005AB5", "#DC3220")) # colour-blind-friendly colours
  plot(p)
  
  return ("The initial condition does not affect the final outcome because both populations tend towards the same octave number after the initial 'burn-in' period (set here as 200 generations).")
}


# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  start <- proc.time() # get a timer working on its own
  community <- init_community_min(size) # define starting community as that with minimum diversity and size given as an argument to the function
  richness <- species_richness(community) # assign species richness of this starting community to a variable
  
  # apply neutral generations with a speciation rate given by speciation_rate for a pre-defined amount of time wall_time
  
  # initial burn-in period:
  for (i in 1:burn_in_generations){ 
    community <- neutral_generation_speciation(community, speciation_rate)
    if (i %% interval_rich == 0) { # store the species richness at intervals of interval_rich
      richness <- c(richness, species_richness(community))
      } 
  }
  
  # entire simulation:
  counter <- 0
  oct <- list(octaves(species_abundance(community)))
  while (TRUE){
    counter <- counter + 1
    community <- neutral_generation_speciation(community, speciation_rate)
    if (counter %% interval_oct == 0) { # record the species abundances as octaves every interval_oct generations
      oct[[(counter/interval_oct) + 1]] <- octaves(species_abundance(community))
      }
    final_time_min <- as.double((proc.time() - start) / 60)[3]
    if (final_time_min >= wall_time) break
  }
  
  # save simulation results in a file with name given by the input output_file_name
  save(richness, oct, community, final_time_min, speciation_rate, size, wall_time,
       interval_rich, interval_oct, burn_in_generations, file = output_file_name)
}



# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20  - TO DO: FIGURE OUT PROPERLY WHAT'S GOING ON AND FIND WAYS TO RE-WRITE LOTS OF THIS ONCE HAVE RESULTS THAT CAN WORK WITH
process_cluster_results <- function()  {
  # create empty lists for ouput variables
  sum_abundance <- c()
  sum_size <- c()
  combined_results <- list()
  
  # set counter
  counter <- 0
  while (counter < 100){
    counter <- counter + 1
    fileName <- paste("results/eab21_result", counter, ".rda", sep = "")
    load(fileName) # read in the output files
    
    # Work out mean value across all the data for each abundance octave and for each simulation size
    for (i in 1:length(oct)){
      sum_abundance <- sum_vect(sum_abundance, oct[[i]])
    }
    oct_mean <- sum_abundance/length(oct)
    sum_abundance <- c()
    sum_size <- sum_vect(sum_size, oct_mean)
    if (j %% 25 == 0){
      combined_results <- c(combined_results, list(sum_size / 25))
      sum_abundance <- c()
      sum_size <- c()
    }
    # save results to a new .rda file
    save(combined_results, file = "combined_results.rda")
  }
}

plot_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  # load combined_results from your rda file
  load("combined_results.rda")
  
  # plot the graphs
  
  # make names variable - but not sure exactly this is the right thing to call it/what it does
  names <- c()
  for (n in 1:12){
    if (n == 1){
      names <- c(names, "1")
    } else {
      names <- c(names, paste(2^(n-1),"~",2^n-1, sep = ""))
    }
  }
  
  # make dataframe for plotting:
  df <- data.frame(ranges = c(names[1:9], names[1:10], names[1:11], names[1:11]),
                   octaves = c(combined_results[[1]], combined_results[[2]], combined_results[[3]], combined_results[[4]]),
                   sizes = c(rep("Size = 500 Simulation", 9), rep("Size = 1000 Simulation", 10), rep("Size = 2500 Simulation", 11), rep("Size = 5000 Simulation", 11)))
  
  df$ranges <- factor(df$ranges, levels = unique(df$ranges))
  df$size <- factor(df$size, levels = unique(df$size))
  
  p <- ggplot(df, aes(x = ranges, y = octaves, fill = sizes)) +
    geom_bar(stat = "identity") +
    facet_grid(Sizes ~ ., scales = "free")+
    theme(legend.position = "bottom")+
    xlab("Intervals") +
    ylab("Number of species") +
    theme_bw()+
    ggtitle("Mean species abundance octave of neutral \nsimulation for different simulation sizes") +
    theme(axis.title = element_text(size = 11, face = "bold"),
          plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
  plot(p)
  
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  dim <- log(8)/log(3)
  return(list(round(dim, 3), "The dimension of a fractal is given in the equation D = log(N)/log(S), where D is the dimension, N is the number of miniature pieces in the final figure, and S is the scaling factor. 
              The main pattern of this fractal repeats eight times so N = 8. To make a single line this fractal is repeated three times, so S = 3. Therefore, D = log(8)/log(3)."))
}

# Question 22
question_22 <- function()  {
  dim <- log(20)/log(3)
  return(list(round(dim, 3), "The dimension of a fractal is given in the equation D = log(N)/log(S), where D is the dimension, N is the number of miniature pieces in the final figure, and S is the scaling factor. 
  The overall cube has six faces each with eight smaller squares on it. Hence the overall cube is made up of 20 smaller cubes, so N = 20. To make a single line this fractal is repeated three times, so S = 3. Therefore, D = log(20)/log(3)."))
  }

# Question 23
chaos_game <- function()  {
  # clear any existing graphs
  graphics.off()
  
  # store the point vectors A, B, and C
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  
  # initialise the point vector X
  X = c(0,0)
  
  # plot a very small point on the graph at X
  df <- data.frame(rbind(A, B, C))
  plot(df$X1, # make plot with A, B, and C on it
       df$X2,
       type = "p",
       xlim = c(0,4),
       ylim = c(0,4),
       xlab = "x",
       ylab = "y",
       main = "Chaos game")
  text(0, 0.3, labels = "A")
  text(2.8, 4, labels = "B")
  text(4, 0.8, labels = "C")
  lines(X[1], # add a very small point for X in blue
        X[2],
        type = "p",
        cex = 0.3,
        col = "blue",
        pch = 1)
  
  # choose one of the 3 points at random and move X halfway towards it
  ABC <- list(A, B, C)
  X <- (X + sample(ABC, 1)[[1]])/2
  lines(X[1], 
        X[2], 
        type = "p",
        cex = 0.3,
        col = "blue",
        pch = 1)
  
  # repeat the two previous steps 30,000 times (because only takes a couple of seconds)
  for (i in 1:30000){
    X <- (X + sample(ABC, 1)[[1]])/2
    lines(X[1], 
          X[2], 
          type = "p",
          cex = 0.3,
          col = "blue",
          pch = 1)
  }
  return("This creates a fractal bounded between A, B, and C with repeating triangles of the shape defined by the minimum convex polygon around A, B, and C.")
}


# Question 24
turtle <- function(start_position, direction, length)  {
  # draw a line of given start position, direction & length  
  # first define the endpoint
  endpoint <- c(start_position[1] + length*cos(direction),
                start_position[2] + length*sin(direction))
  # then draw a line between the start and endpoint
  lines(c(start_position[1], endpoint[1]), c(start_position[2], endpoint[2]), type = "l")

  # return the endpoint of the line as a vector
  return(endpoint)
}

# Question 25
elbow <- function(start_position, direction, length)  {
  # call turtle twice to draw a pair of lines that join together with a given angle between them
  endpoint <- turtle(start_position, direction, length) # first line
  turtle(endpoint, direction-pi/4, 0.95 * length) # second line
}

# Question 26
spiral <- function(start_position, direction, length)  {
  # call turtle to draw the first line
  endpoint <- turtle(start_position, direction, length)
  # call spiral to draw the second line
  if (length >= 0.001) 
    spiral(endpoint, direction-pi/4, 0.95*length)
  return("To make the spiral function work, the if statement is needed. If it is not there, an error message is thrown because it is trying to store too much into the stack. This is because it is trying to spiral too many times due to the starting length being too small, meaning the recursion depth is too deep and the stack usage exceeds the maximum limit. The if statement thus makes it only make the spiral if the starting length is sufficiently long such that the recursion depth would be shallow enough for the stack usage limit to not be exceeded.")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs
  graphics.off()
  # make a new plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 8), ylim=c(0, 8))
  # call spiral
  spiral(c(2,3), pi/2, 2)
  # return the same text answer from the spiral function
  return("To make the spiral function work, the if statement is needed. If it is not there, an error message is thrown because it is trying to store too much into the stack. This is because it is trying to spiral too many times due to the starting length being too small, meaning the recursion depth is too deep and the stack usage exceeds the maximum limit. The if statement thus makes it only make the spiral if the starting length is sufficiently long such that the recursion depth would be shallow enough for the stack usage limit to not be exceeded.")
}

# Question 28
tree <- function(start_position, direction, length)  {
  # call turtle to draw the first line
  endpoint <- turtle(start_position, direction, length)
  # call tree twice to draw the next lines
  if (length >= 0.01) { # make the minimum length larger than for spiral so that it plots it in less than 30 seconds
    tree(endpoint, direction-pi/4, 0.65*length)
    tree(endpoint, direction+pi/4, 0.65*length)
  }
}

draw_tree <- function()  {
  # clear any existing graphs
  graphics.off()
  # make a new plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 8), ylim=c(0, 8))
  # call tree
  tree(c(4,1), pi/2, 2)
}

# Question 29
fern <- function(start_position, direction, length)  {
  # call turtle to draw the first line
  endpoint <- turtle(start_position, direction, length)
  # call fern twice to draw the next lines
  if (length >= 0.01) { # make the minimum length larger than for spiral so that it plots it in less than 30 seconds
    fern(endpoint, direction+pi/4, 0.38*length)
    fern(endpoint, direction, 0.87*length)
  }
}

draw_fern <- function()  {
  # clear any existing graphs
  graphics.off()
  # make a new plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 9))
  # call fern
  fern(c(3,1), pi/2, 1)
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  # call turtle to draw the first line
  endpoint <- turtle(start_position, direction, length)
  # call fern twice to draw the next lines
  if (length >= 0.01) { # make the minimum length larger than for spiral so that it plots it in less than 30 seconds
    fern2(endpoint, direction, 0.87*length, -dir)
    fern2(endpoint, direction + dir*pi/4, 0.38*length, dir)
  }
}  
  
draw_fern2 <- function()  {
  # clear any existing graphs
  graphics.off()
  # make a new plot
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 9))
  # call fern
  fern2(c(2,1), pi/2, 1, 1)
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
    theme(legend.position = "bottom")+ 
    theme(axis.title = element_text(size = 10, face = "bold"),
          plot.title = element_text(hjust = 0.5, size = 15, face = "bold"))+
    scale_fill_manual(name = "Initial diversity", labels = c("Maximum", "Minimum"), values = c("#005AB5", "#DC3220")) # colour-blind-friendly colours
  plot(p)

  return("The point labelled 'X' on the graph is my estimate of where the system reaches dynamic equilibrium: at roughly 29 generations.")
}

# Challenge question B
Challenge_B <- function() {
  graphics.off() # clear any existing graphs
  
  # set starting values
  mean_richness <- c()
  mean_richness_values <- c()
  series <- c()
  time_series <- c()
  
  # set counter
  counter <- 0
  
  while (counter < 10){ # only do this for 10 different starting communities otherwise the graph gets too messy
    counter <- counter + 1
    community <- replicate(100, sample(2 ** (counter + 1), 1))
    for (i in 1:30){
      richness <- neutral_time_series_speciation(community, 0.1, 100)
      mean_richness <- sum_vect(mean_richness, richness)
    }
    mean_richness <- mean_richness / counter
    mean_richness_values <- c(mean_richness_values, mean_richness)
    time_series <- c(time_series, seq(1, length(mean_richness)))
    series <- c(series, rep(species_richness(community), length(mean_richness)))
  }
  
  df <- data.frame(time = time_series, 
                   spp_no = mean_richness_values, 
                   types = factor(series, levels = unique(series)))
  
  p <- ggplot(data = df, aes(x = time, y = spp_no, colour = types))+
    geom_line()+
    theme(aspect.ratio = 1)+
    theme(legend.position = "bottom")+
    ggtitle("Average time series for a range of different \nstarting communities under neutral simulation")+
    xlab("Generation")+
    ylab("Number of species")+
    theme_bw()+
    theme(legend.position = "bottom")+ 
    theme(axis.title = element_text(size = 10, face = "bold"),
          plot.title = element_text(hjust = 0.5, size = 15, face = "bold"))+
    labs(fill = "Initial diversity")+
    scale_colour_viridis(discrete = TRUE, name = "Initial diversity") # colour-blind-friendly palette
  
  plot(p)
}

# Challenge question C - also have a look at once have run simulations on HPC --> TO FINISH ONCE HAVE RUN STUFF ON HPC!!
Challenge_C <- function() {
  # clear any existing graphs
  graphics.off()
  
  # make empty variables to fill
  mean_spp_richness <- c()
  mean_spp_richness_all <- c() # for the final output
  
  # set counter
  counter <- 0
  
  # read in results and work out mean octaves for each species abundance octave
  while(counter < 100){
    counter <- counter + 1
    result <- paste("results/eab21_result", i, ".rda", sep = "") # read in and load results
    load(result)
    mean_spp_richness <- sum_vect(mean_oct, richness)
    if (counter %% 25 == 0){
      mean_spp_richness_all <- c(mean_spp_richness_all, list(mean_richness / 25))
      mean_richness <- c()
    }
  }
  
  # plot graph of mean species richness against simulation generation 
  
  # make dataframe:
  df <- data.frame(generation = c(gen1_time, gen2_time, gen3_time, gen4_time), # need to fill this with generation times
                   richness = c(combined_results[[1]], combined_results[[2]], combined_results[[3]], combined_results[[4]]),
                   simulation = c(rep("Size = 500 Simulation", 4001), rep("Size = 1000 Simulation", 8001), rep("Size = 2500 Simulation", 20001), rep("Size = 5000 Simulation", 40001)))
  
  p <- ggplot(df, aes(x = time, y = richness, colour = simulation)) + 
    geom_line() +
    facet_wrap(Sizes ~ ., scales = "free") + 
    theme(legend.position = "bottom") +
    theme_bw()+
    xlab("Generations") + 
    ylab("Mean Species Richness")
  plot(p)
  
  
  

}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs
  
  return("type your written answer here")
}

# Challenge question E - TO DO: TRY TO FIGURE OUT WHY IT'S NOT PLOTTING PROPERLY
Challenge_E <- function() {
  # clear any existing graphs
  graphics.off()
  
  #############################################################################################################
  
  # FIGURING OUT WHAT HAPPENS WHEN X CHANGES
  
  # start the chaos game from a completely different initial position X
  
  chaos_function <- function(x,y){ # define function where can vary the starting values of X
    # store the point vectors A, B, and C
    A = c(0,0)
    B = c(3,4)
    C = c(4,1)
    
    # initialise the point vector X
    X = c(x,y)
    
    # plot a very small point on the graph at X
    df <- data.frame(rbind(A, B, C))
    plot(df$X1, # make plot with A, B, and C on it
         df$X2,
         type = "p",
         xlim = c(0,4),
         ylim = c(0,4),
         xlab = "x",
         ylab = "y",
         main = "Chaos game")
    text(0, 0.3, labels = "A")
    text(2.8, 4, labels = "B")
    text(4, 0.8, labels = "C")
    lines(X[1], # add a very small point for X in blue
          X[2],
          type = "p",
          cex = 0.3,
          col = "blue",
          pch = 1)
    
    # choose one of the 3 points at random and move X halfway towards it - and repeat 2000 times
    ABC <- list(A, B, C)
    for (i in 1:2000){
      X <- (X + sample(ABC, 1)[[1]])/2
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "blue",
            pch = 1)
    }
  }
  
  # try with a few different starting values of X:
  chaos_function(x = 4, y = 3)
  chaos_function(x = 2, y = 0)
  chaos_function(x = 1, y = 3)
  
  
  # try this plotting the first n steps in a different colour to better visualise what's going on
  # store the point vectors A, B, and C
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  
  # initialise the point vector X - set randomly to (4,3)
  X = c(4,3)
  
  # plot a very small point on the graph at X
  df <- data.frame(rbind(A, B, C))
  plot(df$X1, # make plot with A, B, and C on it
       df$X2,
       type = "p",
       xlim = c(0,4),
       ylim = c(0,4),
       xlab = "x",
       ylab = "y",
       main = "Chaos game")
  text(0, 0.3, labels = "A")
  text(2.8, 4, labels = "B")
  text(4, 0.8, labels = "C")
  lines(X[1], # add a very small point for X in blue
        X[2],
        type = "p",
        cex = 0.3,
        col = "blue",
        pch = 1)
  
  # choose one of the 3 points at random and move X halfway towards it - and repeat 2000 times
  ABC <- list(A, B, C)
  for (i in 1:2000){
    X <- (X + sample(ABC, 1)[[1]])/2
    if (i < 50) {
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "red",
            pch = 1)
    }
    else {
    lines(X[1], 
          X[2], 
          type = "p",
          cex = 0.3,
          col = "blue",
          pch = 1)
    }
  }
  
  # return description of what happens when change the starting values of X:
  return("Despite different starting values of X, each time the plot creates the same fractal bounded between A, B, and C with repeating triangles of the shape defined by the minimum convex polygon around A, B, and C. The further away from A, B, or C the starting value of X is, the less dense the fractal is (i.e. it takes more iterations to form it) and the more random points there are scattered aronnd the fractal. The plot with the different-coloured points for the first few iterations shows that the first few points are outside of the final fractal shape; this is before the algorithm converges on that final fractal.")
  
  
  #########################################################################################################################
  
  # to put the following two plots in one multi-panel graph
  par(mfrow = c(1, 2)) 
  
  #########################################################################################################################
  
  # EQUILATERAL TRIANGLE
  
  # now trying using an equilateral triangle as the starting points to produce a classic Sierpinksi Gasket
  # store the point vectors A, B, and C
  A <- c(0,0)
  B <- c(2,sqrt(12))
  C <- c(4,0)
  
  # initialise the point vector X - now know that it doesn't matter too much what this is since it would end up converging on the same fractal anyway
  X = c(0,0)
  
  # plot a very small point on the graph at X
  df <- data.frame(rbind(A, B, C))
  plot(df$X1, # make plot with A, B, and C on it
       df$X2,
       type = "p",
       xlim = c(0,4),
       ylim = c(0,4),
       xlab = "x",
       ylab = "y",
       main = "Chaos game - classic Sierpinksi Gasket")
  text(0, 0.3, labels = "A")
  text(2, 3.6, labels = "B")
  text(4, 0.3, labels = "C")
  lines(X[1], # add a very small point for X in blue
        X[2],
        type = "p",
        cex = 0.3,
        col = "blue",
        pch = 1)
  
  # choose one of the 3 points at random and move X halfway towards it - and repeat 2000 times
  ABC <- list(A, B, C)
  for (i in 1:2000){
    X <- (X + sample(ABC, 1)[[1]])/2
    if (i < 50) {
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "red",
            pch = 1)
    }
    else {
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "blue",
            pch = 1)
    }
  }
  
  #########################################################################################################################
  
  # SQUARE
  
  # now trying using a square as the starting points
  # store the point vectors A, B, and C
  A <- c(0,0)
  B <- c(0,4)
  C <- c(4,4)
  D <- c(4,0)
  
  # initialise the point vector X - now know that it doesn't matter too much what this is since it would end up converging on the same fractal anyway
  X = c(0,0)
  
  # plot a very small point on the graph at X
  df <- data.frame(rbind(A, B, C))
  plot(df$X1, # make plot with A, B, and C on it
       df$X2,
       type = "p",
       xlim = c(0,4),
       ylim = c(0,4),
       xlab = "x",
       ylab = "y",
       main = "Chaos game - square")
  text(0, 0.3, labels = "A")
  text(0, 4.2, labels = "B")
  text(4, 4.2, labels = "C")
  text(4, 0.3, labels = "D")
  lines(X[1], # add a very small point for X in blue
        X[2],
        type = "p",
        cex = 0.3,
        col = "blue",
        pch = 1)
  
  # choose one of the 3 points at random and move X halfway towards it - and repeat 2000 times
  ABC <- list(A, B, C)
  for (i in 1:2000){
    X <- (X + sample(ABC, 1)[[1]])/2
    if (i < 50) {
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "red",
            pch = 1)
    }
    else {
      lines(X[1], 
            X[2], 
            type = "p",
            cex = 0.3,
            col = "blue",
            pch = 1)
    }
  }
  
  #par(mfrow = c(1, 2)) -  maybe should be here instead?
  
}
  


# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs
  graphics.off()
  
  
  return("The shorter the length of the line, the less time it takes to make the fractal. This is because it takes less time to reach the minimum threshold length needed to make the next lines following the first one.")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


