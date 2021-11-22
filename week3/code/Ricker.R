# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: Ricker.R
# Desc: contains the Ricker model
# Arguments: none
# Date: Oct 2021

# it's a difference model - looking at the diff timesteps


# basically filling the vector with values

# then return n

# and plot (prints index bc by default just prints the values of the vector (calls them index))



Ricker <- function(N0=1, r=1, K=10, generations=50)
{
  # Runs a simulation of the Ricker model
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations)
  {
    N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K)))
  }
  return (N)
}

plot(Ricker(generations=10), type="l")

