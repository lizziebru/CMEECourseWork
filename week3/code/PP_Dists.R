# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: PP_Dists.R
# Desc: Practical work on body mass distributions
# Date: Oct 2021

library(ggplot2)
library(ggpubr)

# read in raw data
ecol_data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# some of the units for predator mass are mg not g: need to convert them all to g
ecol_data$Prey.mass[which(ecol_data$Prey.mass.unit=="mg")] <- ecol_data$Prey.mass[which(ecol_data$Prey.mass.unit=="mg")]/1000
ecol_data$Prey.mass.unit[which(ecol_data$Prey.mass.unit=="mg")] <- "g"


# figure 1: distribution of predator mass 

pred_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#CC79A7", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-4, 6) # need to adjust the axes to optimise view
pred_insect

pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#56B4E9", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(0, 14)
pred_pisc


pred_plank <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "planktivorous"))+
  geom_density(aes(log(Predator.mass)), fill = "#009E73", size = 1)+
  xlab("log(predator mass)")+
  ylab("Density")+
  ggtitle("Planktivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-10, 13)
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
  xlim(3, 9)
pred_pred_pisc

pred_all <- ggarrange(pred_insect, pred_pisc, pred_plank, pred_pred, pred_pred_pisc, labels = c("A", "B", "C", "D", "E"))

annotate_figure(pred_all, top = "Distribution of predator mass by feeding interaction type")

pdf("../results/Pred_Subplots.pdf")
print(pred_all)
dev.off()

# figure 2: distribution of prey mass

prey_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#CC79A7", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-14, -6)
prey_insect

prey_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes(log(Prey.mass)), fill = "#56B4E9", size = 1)+
  xlab("log(prey mass)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-6, 8)
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

pdf("../results/Prey_Subplots.pdf")
print(prey_all)
dev.off()

# figure 3: size ratio of prey mass over predator mass by feeding interaction type:

sizeratio_insect <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "insectivorous"))+
  geom_density(aes((log(Prey.mass)/log(Predator.mass))), fill = "#CC79A7", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Insectivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-50, 30)
sizeratio_insect

sizeratio_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "piscivorous"))+
  geom_density(aes((log(Prey.mass)/log(Predator.mass))), fill = "#56B4E9", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-1, 1)
sizeratio_pisc


sizeratio_plank <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "planktivorous"))+
  geom_density(aes((log(Prey.mass)/log(Predator.mass))), fill = "#009E73", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Planktivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-0.6, 0.5)
sizeratio_plank


sizeratio_pred <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious"))+
  geom_density(aes((log(Prey.mass)/log(Predator.mass))), fill = "#F0E442", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Predacious")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-1.5, 1)
sizeratio_pred

sizeratio_pred_pisc <- ggplot(data = subset(ecol_data, Type.of.feeding.interaction == "predacious/piscivorous"))+
  geom_density(aes((log(Prey.mass)/log(Predator.mass))), fill = "#0072B2", size = 1)+
  xlab("log(size ratio)")+
  ylab("Density")+
  ggtitle("Predacious/piscivorous")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlim(-0.8, 0)
sizeratio_pred_pisc

sizeratio_all <- ggarrange(sizeratio_insect, sizeratio_pisc, sizeratio_plank, sizeratio_pred, sizeratio_pred_pisc, labels = c("A", "B", "C", "D", "E"))

annotate_figure(sizeratio_all, top = "Distribution of size ratio of prey mass over predator mass by feeding interaction type")

pdf("../results/SizeRatio_Subplots.pdf")
print(sizeratio_all)
dev.off()


# calculate the (log) mean & median predator mass, prey mass and predator-prey size ratios to a csv file:

# make column with size ratio
ecol_data2 <- transform(ecol_data, sizeratio = Prey.mass / Predator.mass)

#subset the data for each feeding type:
insects <- subset(ecol_data2, Type.of.feeding.interaction == "insectivorous")
piscs <- subset(ecol_data2, Type.of.feeding.interaction == "piscivorous")
planks <- subset(ecol_data2, Type.of.feeding.interaction == "planktivorous")
preds <- subset(ecol_data2, Type.of.feeding.interaction == "predacious")
pred_piscs <- subset(ecol_data2, Type.of.feeding.interaction == "predacious/piscivorous")

mean_medians <- data.frame(feeding_type = c(rep("insectivorous", length(3)), rep("piscivorous", length(3)), rep("planktivorous", length(3)), rep("predacious", length(3)), rep("predacious/piscivorous", length(3))), #15
                           species_type = c("predator", "prey", "size ratio", "predator", "prey", "size ratio", "predator", "prey", "size ratio", "predator", "prey", "size ratio", "predator", "prey", "size ratio"), #15
                           mean = c(mean(insects$Predator.mass), mean(insects$Prey.mass), mean(insects$sizeratio), mean(piscs$Predator.mass), mean(piscs$Prey.mass), mean(piscs$sizeratio), mean(planks$Predator.mass), mean(planks$Prey.mass), mean(planks$sizeratio), mean(preds$Predator.mass), mean(preds$Prey.mass), mean(preds$sizeratio), mean(pred_piscs$Predator.mass), mean(pred_piscs$Prey.mass), mean(pred_piscs$sizeratio)), #15
                           median = c(median(insects$Predator.mass), median(insects$Prey.mass), median(insects$sizeratio), median(piscs$Predator.mass), median(piscs$Prey.mass), median(piscs$sizeratio), median(planks$Predator.mass), median(planks$Prey.mass), median(planks$sizeratio), median(preds$Predator.mass), median(preds$Prey.mass), median(preds$sizeratio), median(pred_piscs$Predator.mass), median(pred_piscs$Prey.mass), median(pred_piscs$sizeratio))) #15

write.csv(mean_medians, "../results/PP_Results.csv")

