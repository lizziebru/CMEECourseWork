# CMEE 2021 HPC excercises R code challenge G pro forma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

# please edit these data to show your information.
name <- "Lizzie Bru"
preferred_name <- "Lizzie"
email <- "e.bru21@imperial.ac.uk"
username <- "eab21"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

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
