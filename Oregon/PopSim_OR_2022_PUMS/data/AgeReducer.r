#Kaelem Mohabir 7/26/23
#This script creates a new set of Gender by Age columns in the GP_BGData.csv to condense down to 24 total from 46
#Reads in original GP_BGData.csv and outputs new 

x <- read.csv("GP_BGData.csv")

#create new columns with age groupings to match original PopulationSim

x$MAGE5 <- rowSums(x[ , c("MAGE5","MAGE6","MAGE7","MAGE8")])

x$MAGE6 <- rowSums(x[ , c("MAGE9","MAGE10")])

x$MAGE7 <- rowSums(x[ , c("MAGE11","MAGE12")])

x$MAGE8 <- rowSums(x[ , c("MAGE13","MAGE14")])

x$MAGE9 <- rowSums(x[ , c("MAGE15","MAGE16","MAGE17")])

x$MAGE10 <- rowSums(x[ , c("MAGE18","MAGE19","MAGE20")])

x$MAGE11 <- rowSums(x[ , c("MAGE21","MAGE22")])

x$MAGE12 <- x$MAGE23

x$FAGE5 <- rowSums(x[ , c("FAGE5","FAGE6","FAGE7","FAGE8")])

x$FAGE6 <- rowSums(x[ , c("FAGE9","FAGE10")])

x$FAGE7 <- rowSums(x[ , c("FAGE11","FAGE12")])

x$FAGE8 <- rowSums(x[ , c("FAGE13","FAGE14")])

x$FAGE9 <- rowSums(x[ , c("FAGE15","FAGE16","FAGE17")])

x$FAGE10 <- rowSums(x[ , c("FAGE18","FAGE19","FAGE20")])

x$FAGE11 <- rowSums(x[ , c("FAGE21","FAGE22")])

x$FAGE12 <- x$FAGE23

#add new columns to GP_BGData.csv

x <- x[,!(names(x) %in% c(paste0("MAGE",13:23),paste0("FAGE",13:23)))]

x$AGE1 <- x$MAGE1+x$FAGE1

x$AGE2 <- x$MAGE2+x$FAGE2

x$AGE3 <- x$MAGE3+x$FAGE3

x$AGE4 <- x$MAGE4+x$FAGE4

x$AGE5 <- x$MAGE5+x$FAGE5

x$AGE6 <- x$MAGE6+x$FAGE6

x$AGE7 <- x$MAGE7+x$FAGE7

x$AGE8 <- x$MAGE8+x$FAGE8

x$AGE9 <- x$MAGE9+x$FAGE9

x$AGE10 <- x$MAGE10+x$FAGE10

x$AGE11 <- x$MAGE11+x$FAGE11

x$AGE12 <- x$MAGE12+x$FAGE12

#write to csv
write.csv(x, "GP_BGData.csv", row.names=FALSE)