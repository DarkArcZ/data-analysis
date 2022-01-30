##
## Author: Jerome Wong
## HW3: Linear Regression
## INDE 546: Inferential Data Analytics for Engineers
##

# Libraries
library(tidyverse)
library(xtable)
library(sjPlot)
library(dplyr)
library(car)
set.seed(42)

# Read the survey data
survey <- read.csv("UW Class Survey W22.csv", 
                   na.strings=c("", "NA"), 
                   header=TRUE)
survey <- survey[, 3:63]

# Check the data types of variables
str(survey)

# Variable names
VarName <- colnames(survey); VarName  # View the variable names

##Ex2
#Dependent Variable 
survey$timeUW <- survey[,22]

#Independent Variable
survey$public_transport_frequency <- survey[,16]
public_transport_frequency_five <- ifelse(survey$public_transport_frequency=="5 or more days a week", "yes", "no")
survey$milesUW <- survey[,21]
ggplot(survey, aes(x=milesUW))+
  geom_histogram(color="darkblue", fill="lightblue")
survey <- survey %>% mutate(milesUWlog=log(milesUW))
survey$milesUWlog <- lapply(survey$milesUWlog, function(x) ifelse(is.infinite(x), NA, x))
survey$milesUWlog <- unlist(survey$milesUWlog)
survey$vehicle <- survey[,24]
survey$license <- survey[,60]

lr1 <- lm(timeUW~public_transport_frequency_five+milesUWlog+vehicle+license, data=survey)
summary(lr1)
xtable(lr1)
tab_model(lr1)

#Ex3
par(mfrow=c(2,2))
plot(lr1)
vif(lr1)


