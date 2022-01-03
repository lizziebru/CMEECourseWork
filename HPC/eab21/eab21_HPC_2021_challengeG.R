# CMEE 2021 HPC excercises R code challenge G pro forma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

# please edit these data to show your information.
name <- "Lizzie Bru"
preferred_name <- "Lizzie"
email <- "e.bru21@imperial.ac.uk"
username <- "eab21"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

t=function(s,d,l){e=c(s[1]+l*cos(d),s[2]+l*sin(d));lines(c(s[1],e[1]),c(s[2],e[2]),type="l");return(e)};f=function(s,d,l,r){e=t(s,d,l);if(l>=0.01){f(e,d,0.87*l,-r);f(e,d+r*pi/4, 0.38*l,r)}};p=function(){plot.new();f(c(2,1),pi/2,1,1)}


# what it used to be:

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
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 9), axes = F)
  # call fern
  fern2(c(2,1), pi/2, 1, 1)
}
