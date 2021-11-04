# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: PP_Dists.R
# Desc: Practical work on body mass distributions
# Arguments: none
# Date: Oct 2021

install.packages("ggpubr", dependencies = T)
library(ggpubr)

# read in raw data
ecol_data <- read.csv("../data/EcolArchives-E089-51-D1.csv")


# figure 1: distribution of predator mass 

# TO DO: manually extend axes and make colours colour-blind friendly

pred_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#CC79A7", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-4, 6)
pred_insect

pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#56B4E9", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-5, 15)
pred_pisc


pred_plank <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "planktivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#009E73", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Planktivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-10, 15)
pred_plank


pred_pred <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious"))+
  geom_density(aes(log(Predator.mass)), fill = "#F0E442", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Predacious")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-10, 15)
pred_pred

pred_pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious/piscivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#0072B2", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Predacious/piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-3, 9)
pred_pred_pisc

pred_all <- ggarrange(pred_insect, pred_pisc, pred_plank, pred_pred, pred_pred_pisc, labels = c("A", "B", "C", "D", "E"))

annotate_figure(pred_all, top = "Distribution of predator mass by feeding interaction type")

pdf(sizeratio_all, "../results/Pred_Subplots.pdf")

# figure 2: distribution of prey mass

prey_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#CC79A7", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-10, 0)
prey_insect

prey_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#56B4E9", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-10, 10)
prey_pisc


prey_plank <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "planktivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#009E73", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Planktivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-25, 5)
prey_plank


prey_pred <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious"))+
  geom_density(aes(log(Prey.mass)), fill = "#F0E442", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Predacious")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-20, 10)
prey_pred

prey_pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious/piscivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#0072B2", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Predacious/piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-4, 6)
prey_pred_pisc

prey_all <- ggarrange(prey_insect, prey_pisc, prey_plank, prey_pred, prey_pred_pisc, labels = c("A", "B", "C", "D", "E"))

annotate_figure(prey_all, top = "Distribution of prey mass by feeding interaction type")

pdf(sizeratio_all, "../results/Prey_Subplots.pdf")

# figure 3: size ratio of prey mass over predator mass by feeding interaction type:

# to do: change colours & potentially axes limits (check w Eamonn)

sizeratio_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes(log(Prey.mass/Predator.mass)), fill = "red", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))
sizeratio_insect

sizeratio_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes(log(Prey.mass/Predator.mass)), fill = "blue", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))
sizeratio_pisc


sizeratio_plank <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "planktivorous"))+
  geom_density(aes(log(Prey.mass/Predator.mass)), fill = "green", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Planktivorous")+
  theme(plot.title = element_text(hjust = 0.5))
sizeratio_plank


sizeratio_pred <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious"))+
  geom_density(aes(log(Prey.mass/Predator.mass)), fill = "yellow", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Predacious")+
  theme(plot.title = element_text(hjust = 0.5))
sizeratio_pred

sizeratio_pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious/piscivorous"))+
  geom_density(aes(log(Prey.mass/Predator.mass)), fill = "pink", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Predacious/piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))
sizeratio_pred_pisc

sizeratio_all <- ggarrange(sizeratio_insect, sizeratio_pisc, sizeratio_plank, sizeratio_pred, sizeratio_pred_pisc, labels = c("A", "B", "C", "D", "E"))

annotate_figure(sizeratio_all, top = "Distribution of size ratio of prey mass over predator mass by feeding interaction type")

pdf(sizeratio_all, "../results/SizeRatio_Subplots.pdf")

# calculate the (log) mean & median predator mass, prey mass and predator-prey size ratios to a csv file:

# means:
i_pred_mean <- 
i_prey_mean <-
i_ratio_mean <- 
pisc_pred_mean <-
pisc_prey_mean <-
pisc_ratio_mean <-
plank_pred_mean <-
plank_prey_mean <-
plank_ratio_mean <- 



mean_medians <- data.frame(feeding_type = c(rep("insectivorous", length(3)), rep("piscivorous", length(3)), rep("planktivorous", length(3)), rep("predacious", length(3)), rep("predacious/piscivorous", length(3))),
                           species_type = c(rep("predator", "prey", "size ratio"), length(5)),
                           mean = c())




