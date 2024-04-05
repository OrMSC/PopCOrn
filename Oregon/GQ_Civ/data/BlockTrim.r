#Kaelem Mohabir 
#10/11/23
#this script deletes records in seeds not used by GQ Civ

#read in Decennial Block
block <- read.csv("DecennialBlockData_GQ.csv")

#sort zero values and delete them for Non Civ
block <- block[block$GQ_Non_Oth !=0,]

#read in crosswalk
cw <- read.csv("geo_cross_walk.csv")

#give rownames to crosswalk of the block and feed in 
rownames(cw) <- cw$BLOCK

#match trimmed block to cw
cw <- cw[as.character(block$BLOCK),]

#write out trimmed csv
write.csv(block, "DecennialBlockData_GQ.csv", row.names=F)
write.csv(cw, "geo_cross_walk.csv", row.names=F)

#?write.csv
#row.names=F


