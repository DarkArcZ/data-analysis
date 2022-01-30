##
## Author: Jerome Wong
## HW2: Statistics and Visualization
## INDE 546: Inferential Data Analytics for Engineers
##

# Libraries
library(tidyverse)
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

#Ex1.1
#create variable Age to plot Histogram
survey$Age=survey[,56]  
ggplot(survey, aes(x=Age))+
  geom_histogram(color="darkblue", fill="lightblue")

#Ex1.2
#Create variable Gender to plot Barchart
survey$Gender= survey[,55]
ggplot(survey, aes(x=Gender,fill=Gender))+
  geom_bar(color="black")+scale_fill_brewer(palette="Dark2")
summary(survey$Age)

#Ex1.3
#Creating variable Housing and Distance to plot Boxplot
survey$Housing = survey[,48]
survey$Distance = survey[,21]
ggplot(survey, aes(x=Distance, y=Housing, fill=Housing))+
         geom_boxplot(color="black")


#Ex1.4
#Scatterplot of Distance against Gender
ggplot(survey, aes(x=Gender, y=Distance))+
  geom_jitter(width=.5, size=1)

#Ex3
male <- survey[survey$Gender=="Man",]
male_distance <- male[, 21]
summary(male_distance)
female <- survey[survey$Gender=="Woman",]
female_distance <- female[,21] 
summary(female_distance)
t.test(male_distance, female_distance, paired=FALSE)
