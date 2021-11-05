# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: PP_Regress.R
# Desc: Practical work on visualizing regression analyses
# Date: Nov 2021

require(ggpubr)
require(plyr)
require(broom)
require(base)

# read in raw data
ecol_data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# some of the units for predator mass are mg not g: need to convert them all to g
ecol_data$Prey.mass[which(ecol_data$Prey.mass.unit=="mg")] <- ecol_data$Prey.mass[which(ecol_data$Prey.mass.unit=="mg")]/1000
ecol_data$Prey.mass.unit[which(ecol_data$Prey.mass.unit=="mg")] <- "g"

# figure

ecol_data_reg <- ggplot(ecol_data, aes(x = Prey.mass, y = Predator.mass, colour = Predator.lifestage))+
  geom_point(shape = 3)+
  geom_smooth(method = "lm", na.rm = T, fullrange = T, size = 0.5)+
  scale_x_log10("Prey Mass in grams", labels = scales::scientific)+
  scale_y_log10("Predator mass in grams", labels = scales::scientific)+
  labs(x = "Prey Mass in grams", y = "Predator mass in grams")+
  facet_grid(rows = vars(Type.of.feeding.interaction))+
  theme_bw()+
  theme(legend.position="bottom", legend.title = element_text(face="bold"), strip.text.y = element_text(size = 7), text = element_text(size = 9), panel.grid.minor.y = element_blank(), plot.margin = margin(r = 3.7, l = 3.7, unit = "cm"))+
  guides(colour = guide_legend(nrow = 1))
ecol_data_reg

# export as pdf
pdf("../results/PP_Regress_figure.pdf")
print(ecol_data_reg)
dev.off()


# csv with results:

# apply lm() to the data subsetted according to type of feeding interaction and predator lifestage:

lm_data <- dlply(ecol_data, .(Type.of.feeding.interaction, Predator.lifestage), function(x){lm(Predator.mass ~ Prey.mass, data = x)})

# extract the required stats from the lm:

lm_stats <- ldply(lm_data, function(x){
  slope <- tidy(x)[2,2]
  intercept <- tidy(x)[1,2]
  r_squared <- summary(x)$adj.r.squared
  p_value <- tidy(x)[2,5]
  data.frame(slope, intercept, r_squared, p_value)
})

colnames(lm_stats)[3] <- "slope"
colnames(lm_stats)[4] <- "intercept"

# have to do the f stat separately cause mucks up when do it in the above function
lm_stats_f <- ldply(lm_data, function(x){
  f_stat <- summary(x)$fstatistic[1]
  data.frame(f_stat)
})

colnames(lm_stats_f)[3] <- "f_stat"


# add the fstat column to the final dataframe:
lm_results <- merge(lm_stats, lm_stats_f, all.x = T) # has omitted the f-stat for piscivorous postlarva juvenile: so need to merge the 2 dataframes by specific row so that it fills gaps with NAs where necessary
lm_results
  
# export as csv
write.csv(lm_results, "../results/PP_Regress_Results.csv")