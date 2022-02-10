##
## Author: Jerome Wong
## HW4: Logistic Regression
## INDE 546: Inferential Data Analytics for Engineers
##

# Libraries
library(tidyverse)
library(xtable)
library(dplyr)
library(glm2)
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

##Ex1
#Dependent Variable 
survey$education <- survey[,2]
survey$UG <- ifelse(survey$education=="Undergraduate student", 1, 0)
survey$UG <- survey$education=="1"
survey$UG

# barplot of Dependent Variable
par(mar=c(5.1,4.1,4.1,2.1))

barplot(table(survey$UG),
        main="Not Undergraduates vs Undergraduates",
        xlab = "Education Level",
        ylab= "Count",
        names.arg = c("Not Undergraduate", "Undergraduate")
        )

#Independent Variable
survey$age <- survey[,56]
survey$age25 <- ifelse(survey$age>25, 1, 0)
survey$credits <- survey[,3]
survey$class_missed <- survey[,5]

UG_l <- glm(UG~age25+credits+class_missed, data=survey, family=binomial())
summary(UG_l)
xtable(UG_l)

#Ex2
predict(UG_l)
ggplot(UG_l,aes(x=age25+credits+class_missed, y=UG)) +
  geom_point(alpha=.5) + 
  stat_smooth(method="glm", se=FALSE, method.args=list(family=binomial))
chisq = 421.87-241.66
pchisq(chisq, df=3, lower.tail=FALSE)

#Ex3
UG25 <- ifelse(survey$age>25 & survey$UG==1,1,0)
UG_l_2 <- glm(UG~age25+credits+class_missed+UG25, data=survey, family=binomial()) 
summary(UG_l_2)
