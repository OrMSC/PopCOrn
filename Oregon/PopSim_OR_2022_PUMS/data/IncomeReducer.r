#Kaelem Mohabir
#9-13-23

x <- read.csv("GP_BGData.csv")

#create new columns with income groupings to fit standardized PopulationSim

x$HHINC1 <- rowSums(x[ , c("HHINC1","HHINC2")])

x$HHINC2 <- rowSums(x[ , c("HHINC3","HHINC4")])

x$HHINC3 <- rowSums(x[ , c("HHINC5","HHINC6")])

x$HHINC4 <- rowSums(x[ , c("HHINC7","HHINC8","HHINC9")])

x$HHINC5 <- rowSums(x[ , c("HHINC10","HHINC11")])

x$HHINC6 <- x$HHINC12

x$HHINC7 <- rowSums(x[ , c("HHINC13","HHINC14")])

x$HHINC8 <- x$HHINC15

x$HHINC9 <- x$HHINC16

#add new columns to GP_BGData.csv

x <- x[,!(names(x) %in% paste0("HHINC",10:16))]

#write to csv
write.csv(x, "GP_BGData.csv", row.names=FALSE)