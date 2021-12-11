# HPC extra code


# Question 7 - take 1
neutral_time_series <- function(community,duration)  {
  spp_richness <- species_richness(community)
  count = 0 
  repeat{ # run neutral_steps on the community, repeating this until a certain number of times is reached
    community <- neutral_step(community) 
    spp_richness <- append(spp_richness, species_richness(community)) # like c() but faster
    count = count + 1
    if (count == duration){ # stop repeating once you've done this the correct number of times (i.e. up to 'duration')
      break
    }
  }
  return(c(spp_richness)) # return the vector of species' richness
}