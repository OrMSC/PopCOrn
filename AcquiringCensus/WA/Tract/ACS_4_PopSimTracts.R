# Alex Bettinardi
# 5-17-23

# Kaelem Mohabir
# 9-12-23
# Reworking to incorporate RSG Tract tables

# Read in assembled TRACT data
TRACT <- read.csv("ACS5_2022_TRACT.csv",as.is=T)

# Get rid of Margin of Error (_M) fields and other optional fields
TRACT <- TRACT[,!names(TRACT) %in% c(names(TRACT)[grep("_M",names(TRACT))],"NAME")]
rownames(TRACT) <- TRACT$GEOID#substring(BG$GEOID,3,12)
names(TRACT) <- gsub("_E","",names(TRACT))

# Create New Set of Distribution Fields
#BG$HH <- rowSums(BG[,c("FHH_E","NFHH_E")])

# Create New Set of Num of Workers and Person Occupation Distribution Fields
# TRACT$ <- rowSums(TRACT[,c("FHH_E","NFHH_E")])

# start with Num Workers
tractDist <- TRACT[,c("W0","W1","W2","W3")]/TRACT$POPW

# occupation
tractDist <- cbind(tractDist,TRACT[,c("OCCP_1","OCCP_2","OCCP_3","OCCP_4","OCCP_5","OCCP_6")])

tractDist[is.na(tractDist)] <- 0

summary(rowSums(tractDist))

x <- read.csv("mazData.csv",as.is=T)
x$TRACT <- substring(x$GEOID,1,11)
Pop.TRACT  <- tapply(x$GP,x$TRACT,sum)
HH.TRACT  <- tapply(x$HH_Occ,x$TRACT,sum)

# build controls
# create a function to re-tabulate taz households by category given new total households 
ReAllocate <- function(ctrl, Dist){
                  NewDist <- round(Dist*ctrl/sum(Dist))
                  if(sum(Dist)==0) NewDist=Dist  
                    if((ctrl-sum(NewDist))!=0) {
                       ind <- grep(max(NewDist),NewDist)[1]
                       NewDist[ind] <- NewDist[ind]+ ctrl-sum(NewDist)
                    }
                    NewDist
                    }

# create tract control to export 
TRACT <- tractDist

# zero out NA's
TRACT[is.na(TRACT)] <- 0


# workers
TRACT[,grep("W",names(TRACT))] <- t(apply(cbind(HH.TRACT[rownames(TRACT)],TRACT[,grep("W",names(TRACT))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# occupation
#TRACT[,grep("OCCP_",names(TRACT))] <- t(apply(cbind(HH.TRACT[rownames(TRACT)],TRACT[,grep("OCCP_",names(TRACT))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

write.csv(TRACT,"GP_TractData.csv")

######################################################################################################################################################
#tractDist <- cbind(TRACT, TRACT[,c("W0","W1","W2","W3")]/TRACT$POPW)

#tractDist <- cbind(tractDist, TRACT[,c("OCCP_1","OCCP_2","OCCP_3","OCCP_4", "OCCP_5", "OCCP_6")]/TRACT$OCCP)

#tractDist[is.na(tractDist)] <- 0

# should equal the number of distributions that have been appended together.
#summary(rowSums(tractDist[, 2:ncol(tractDist)]))

# write out TRACT Occupation/Emp Distribution
#write.csv(tractDist,"GP_TractData.csv")


