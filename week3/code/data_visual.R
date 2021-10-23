# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: data_visual.R
# Desc: script demonstrating examples of how to visualize data
# Date: Oct 2021


# READING IN AND INSPECTING DATA ------------------------------------------

# read data into a data frame:

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the size of the data frame you loaded


# have a look at the data:
head(MyDF)
str(MyDF)
View(MyDF)

# can also do data inspection/exploration using dplyr
require(tidyverse)
dplyr::glimpse(MyDF)

# change the type of certain columns to factor so that we can use them as grouping variables:
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
MyDF$Location <- as.factor(MyDF$Location)
str(MyDF)




# SCATTER PLOTS -----------------------------------------------------------

plot(MyDF$Predator.mass, MyDF$Prey.mass)
# --> doesn't look v meaningful - bc body sizes across species tend to be log-normally distributed (lots of small and large ones)

# try using logs instead:
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass))

# using a base-10 log transform:
plot(log10(MyDF$Predator.mass),log10(MyDF$Prey.mass))

# can tweak lots of aspects of the graph:
plot(log10(MyDF$Predator.mass),log10(MyDF$Prey.mass),pch=20) # Change marker
plot(log10(MyDF$Predator.mass),log10(MyDF$Prey.mass),pch=20, xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") # Add labels



# HISTOGRAMS --------------------------------------------------------------

# plotting histograms can be insightful bc can then see the 'marginal' distributions of the 2 variables

# histogram of predator body masses:
hist(MyDF$Predator.mass)
#--> the data are heavily right-skewed

# now take a logarithm and see if can get a better idea of what the distribution of predator size looks like:
hist(log10(MyDF$Predator.mass), xlab = "log10(Predator Mass (g))", ylab = "Count") # include labels
hist(log10(MyDF$Predator.mass),xlab="log10(Predator Mass (g))",ylab="Count", 
     col = "lightblue", border = "pink") # Change bar and borders colors 



# SUBPLOTS ----------------------------------------------------------------

# can plot both predator and prey body masses in different subplots using par to compare them visually:

par(mfcol=c(2,1)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
hist(log10(MyDF$Predator.mass),
     xlab = "log10(Predator Mass (g))", ylab = "Count", col = "lightblue", border = "pink", 
     main = 'Predator') # Add title
par(mfg = c(2,1)) # Second sub-plot
hist(log10(MyDF$Prey.mass), xlab="log10(Prey Mass (g))",ylab="Count", col = "lightgreen", border = "pink", main = 'prey')




# OVERLAYING PLOTS --------------------------------------------------------

# can see if predator and prey masses are similar by overlaying them too

hist(log10(MyDF$Predator.mass), # Predator histogram
     xlab="log10(Body Mass (g))", ylab="Count", 
     col = rgb(1, 0, 0, 0.5), # Note 'rgb', fourth value is transparency
     main = "Predator-prey size Overlap") 
hist(log10(MyDF$Prey.mass), col = rgb(0, 0, 1, 0.5), add = T) # Plot prey
legend('topleft',c('Predators','Prey'),   # Add legend
       fill=c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5))) # Define legend colors




# BOXPLOTS ----------------------------------------------------------------

# = useful for getting a visual summary of the distribution of data

boxplot(log10(MyDF$Predator.mass), xlab = "Location", ylab = "log10(Predator Mass)", main = "Predator mass")

# to see how many locations the data are from:
boxplot(log(MyDF$Predator.mass) ~ MyDF$Location, # Why the tilde?
        xlab = "Location", ylab = "Predator Mass",
        main = "Predator mass by location")

# boxplot by feeding interaction type:
boxplot(log(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
        xlab = "Location", ylab = "Predator Mass",
        main = "Predator mass by feeding interaction type")




# COMBINING PLOT TYPES ----------------------------------------------------

# would be nice to see both the predator & prey distributions too 
# --> can just do this by adding boxplots of the marginal variables to the scatterplot

par(fig=c(0,0.8,0,0.8)) # specify figure size as proportion
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass), xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") # Add labels
par(fig=c(0,0.8,0.4,1), new=TRUE)
boxplot(log(MyDF$Predator.mass), horizontal=TRUE, axes=FALSE)
par(fig=c(0.55,1,0,0.8),new=TRUE)
boxplot(log(MyDF$Prey.mass), axes=FALSE)
mtext("Fancy Predator-prey scatterplot", side=3, outer=TRUE, line=-3)



# SAVING YOUR GRAPHICS ----------------------------------------------------

# can save directly as PDF (= good resolution)

pdf("../results/Pred_Prey_Overlay.pdf", # Open blank pdf page using a relative path
    11.7, 8.3) # These numbers are page dimensions in inches
hist(log(MyDF$Predator.mass), # Plot predator histogram (note 'rgb')
     xlab="Body Mass (g)", ylab="Count", col = rgb(1, 0, 0, 0.5), main = "Predator-Prey Size Overlap") 
hist(log(MyDF$Prey.mass), # Plot prey weights
     col = rgb(0, 0, 1, 0.5), 
     add = T)  # Add to same plot = TRUE
legend('topleft',c('Predators','Prey'), # Add legend
       fill=c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5))) 
graphics.off(); #you can also use dev.off() 

# can also have other graphics formats like png() (= raster format)




# BEAUTIFUL GRAPHICS IN R -------------------------------------------------

# use ggplot2!

require(ggplot2)

# can make quick plots for exploratory analysis using qplot
#scatterplots:
qplot(Prey.mass, Predator.mass, data = MyDF)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF) # with logs
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction) #  colouring the points according to type of feeding interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction, asp = 1) # improve the aspect ratio
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = Type.of.feeding.interaction, asp = 1) # changing the shape


## aesthetic mapping

qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, colour = "red")
#--> chose red but ggplot used mapping to convert it to a partic shade of red
#--> need to set it manually to the real red:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = I("red"))
#do the same for point size:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, size = 3) #with ggplot size mapping
qplot(log(Prey.mass), log(Predator.mass),  data = MyDF, size = I(3)) #no mapping
# for shape:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = 3)
#--> gives an error bc ggplot doesn't have continuous mapping 
#--> instead:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape= I(3))

# setting transparency: use alpha:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction, alpha = I(.5))


# adding smoothers and regression lines:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"))
# need to specify if we want a linear regression:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth")) + geom_smooth(method = "lm")
# can add 'smoother' for each type of interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"), 
      colour = Type.of.feeding.interaction) + geom_smooth(method = "lm")
# to extend the lines to the full range:
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"),
      colour = Type.of.feeding.interaction) + geom_smooth(method = "lm",fullrange = TRUE)
# to see how the ratio between prey and predator mass changes according to the type of interaction:
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)
# bc there are so many points: can 'jitter' them to get a better idea of the spread:
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "jitter")


# boxplots:
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "boxplot")


# histograms and density plots:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram")
# colour the histogram according to interaction type:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction)
# can also define your own bin widths:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction, binwidth = 1)
# can plot the smoothed density of data to make it easier to read:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction)
# can make the densities transparent so that the overlaps are visible:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction, 
      alpha = I(0.5))
# ..or can use colour instead lf fill to draw only the edge of the curve:
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      colour = Type.of.feeding.interaction)


## multi-faceted plots:

#--> useful for displaying data belonging to different classes
qplot(log(Prey.mass/Predator.mass), facets = Type.of.feeding.interaction ~., data = MyDF, geom =  "density")
# swap the position of the ~ to get a by-column configuration
qplot(log(Prey.mass/Predator.mass), facets =  .~ Type.of.feeding.interaction, data = MyDF, geom =  "density")

# logarithmic axes:
#--> better way to plot data in the log scale is also to set the axes to be logarithmic:
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy")

# plot annotations:
#--> can add a title & labels
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
      main = "Relation between predator and prey mass", 
      xlab = "log(Prey mass) (g)", 
      ylab = "log(Predator mass) (g)")
# adding + theme_bw() makes it suitable for black and white printing:
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
      main = "Relation between predator and prey mass", 
      xlab = "Prey mass (g)", 
      ylab = "Predator mass (g)") + theme_bw()


## saving your plots:
pdf("../results/MyFirst-ggplot2-Figure.pdf")
print(qplot(Prey.mass, Predator.mass, data = MyDF,log="xy", # using print ensures that you can use the command in a script:
            main = "Relation between predator and prey mass", 
            xlab = "log(Prey mass) (g)", 
            ylab = "log(Predator mass) (g)") + theme_bw())
dev.off()


## the geom argument:

# load the data
MyDF <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))
# barplot
qplot(Predator.lifestage, data = MyDF, geom = "bar")
# boxplot
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "boxplot")
# violin plot
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "violin")
# density
qplot(log(Predator.mass), data = MyDF, geom = "density")
# histogram
qplot(log(Predator.mass), data = MyDF, geom = "histogram")
# scatterplot
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "point")
# smooth
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth")
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth", method = "lm") # linear


## advanced plotting: ggplot

#--> qplot only allows you to use a single dataset & single set of aesthetics 
#--> need to use the command ggplot to make full use of ggplot2 --> allows you to use layering (i.e. adding additional elements to the plot)

# to start: need to specify the data and the aesthetics:
p <- ggplot(MyDF, 
            aes(x = log(Predator.mass),y = log(Prey.mass),colour = Type.of.feeding.interaction))
p

# can add other elements & plot layers:
p + geom_point()

# can use the + sign to concatenate diff commands:
p <- ggplot(MyDF, aes(x = log(Predator.mass), y = log(Prey.mass), colour = Type.of.feeding.interaction ))
q <- p + 
  geom_point(size=I(2), shape=I(10)) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1) # make the plot square
q

# to remove the legend:
q + theme(legend.position = "none") + theme(aspect.ratio=1)

# can do the same as before but using ggplot instead of qplot:
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), fill = Type.of.feeding.interaction )) + geom_density()
p
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), fill = Type.of.feeding.interaction)) + geom_density(alpha=0.5)
p

# can also make a multi-faceted plot:
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), fill = Type.of.feeding.interaction )) +  geom_density() + facet_wrap( .~ Type.of.feeding.interaction)
p

# can free up the axes to allow data-specific axis limits by using the scales = "free" argument
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), fill = Type.of.feeding.interaction )) +  geom_density() + facet_wrap( .~ Type.of.feeding.interaction, scales = "free")
p

# can plot size-ratio distributions by location:
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass))) +  geom_density() + facet_wrap( .~ Location, scales = "free")
p

# a different example:
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +  geom_point() + facet_wrap( .~ Location, scales = "free")
p

# can also combine categories:
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +  geom_point() + facet_wrap( .~ Location + Type.of.feeding.interaction, scales = "free")
p

# can also change the order of the combination:
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +  geom_point() + facet_wrap( .~ Type.of.feeding.interaction + Location, scales = "free")
p


## some useful ggplot examples:

# plotting a matrix
require(reshape2)
GenerateMatrix <- function(N){
  M <- matrix(runif(N * N), N, N)
  return(M)
}
M <- GenerateMatrix(10)
Melt <- melt(M)
p <- ggplot(Melt, aes(Var1, Var2, fill = value)) + geom_tile() + theme(aspect.ratio = 1)
p

# add a black line dividing cells:
p + geom_tile(colour = "black") + theme(aspect.ratio = 1)

# remove the legend:
p + theme(legend.position = "none") + theme(aspect.ratio = 1)

# remove all the rest:
p + theme(legend.position = "none", 
          panel.background = element_blank(),
          axis.ticks = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank())

# explore some colours:
p + scale_fill_continuous(low = "yellow", high = "darkgreen")
p + scale_fill_gradient2()
p + scale_fill_gradientn(colours = grey.colors(10))
p + scale_fill_gradientn(colours = rainbow(10))
p + scale_fill_gradientn(colours = c("red", "white", "blue"))


## plotting 2 dataframes together

# example: draw the results of a simulation of Girko's circular law (that the eigenvalues of a matrix size N x N are approximately contained in a circle in the complex plane with radius sqrt(N))
# first build a function object that will calculate the ellipse (the predicted bounds of the eigenvalues)
build_ellipse <- function(hradius, vradius){ # function that returns an ellipse
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)  
  return(data.frame(x = x, y = y))
}

N <- 250 # Assign size of the matrix

M <- matrix(rnorm(N * N), N, N) # Build the matrix

eigvals <- eigen(M)$values # Find the eigenvalues

eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # Build a dataframe

my_radius <- sqrt(N) # The radius of the circle is sqrt(N)

ellDF <- build_ellipse(my_radius, my_radius) # Dataframe to plot the ellipse

names(ellDF) <- c("Real", "Imaginary") # rename the columns

# now plot
# plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <- p +
  geom_point(shape = I(3)) +
  theme(legend.position = "none")

# now add the vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))

# finally, add the ellipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))
p

# (see Girko.R for a script with only this)


## annotating plots: see MyBars.R

## mathematical display: see plotLin.R

## ggthemes

#--> provides you with additional geoms, scales, and themes for ggplot

install.packages("ggthemes")

library(ggthemes)

p <- ggplot(MyDF, aes(x = log(Predator.mass), y = log(Prey.mass),
                      colour = Type.of.feeding.interaction )) +
  geom_point(size=I(2), shape=I(10)) + theme_bw()

p + geom_rangeframe() + # now fine tune the geom to Tufte's range frame
  theme_tufte() # and theme to Tufte's minimal ink theme    

