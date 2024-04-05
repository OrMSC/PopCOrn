# Alex Bettinardi
# 5-17-23

# Read in assembled Block Group data
BG <- read.csv("ACS5_2022_BLKGRP.csv",as.is=T)

# Get rid of Margin of Error (_M) fields and other optional fields
BG <- BG[,!names(BG) %in% c(names(BG)[grep("_M",names(BG))],"NAME")]
rownames(BG) <- BG$GEOID#substring(BG$GEOID,3,12)
names(BG) <- gsub("_E","",names(BG))

# Create New Set of Distribution Fields
# start with Household Size
#BG$HH <- rowSums(BG[,c("FHH_E","NFHH_E")])

bgDist <- cbind(BG$NFHHS1,BG[,c("FHHS2","FHHS3","FHHS4","FHHS5","FHHS6","FHHS7")]+BG[,c("NFHHS2","NFHHS3","NFHHS4","NFHHS5","NFHHS6","NFHHS7")])/BG$HHT
names(bgDist) <- paste0("HHS",1:7)

# start with Age Distribution
bgDist <- cbind(bgDist,BG[,c("HHAGE1","HHAGE2","HHAGE3","HHAGE4")]/BG$HHT)

# add Income Distribution
bgDist <- cbind(bgDist, BG[,paste0("HHINC",1:16)]/BG$HHT)

# add Vehicle Distribution
bgDist <- cbind(bgDist,(BG[,c("HHOV0","HHOV1","HHOV2","HHOV3","HHOV4","HHOV5")]+BG[,c("HHRV0","HHRV1","HHRV2","HHRV3","HHRV4","HHRV5")])/BG$HHT)
names(bgDist) <- gsub("HHOV","HHV",names(bgDist))

# add units in structure distribution 
bgDist <- cbind(bgDist,BG[,c("HHSF","HHSFA","HHDUP","HHMF4","HHMF9","HHMF19","HHMF49","HHMF50","HHMH","HHRV")]/BG$HHUT)

# add sex by age distribution 
bgDist <- cbind(bgDist, BG[,c("MAGE1","MAGE2","MAGE3","MAGE4","MAGE5","MAGE6","MAGE7","MAGE8","MAGE9","MAGE10","MAGE11","MAGE12","MAGE13","MAGE14","MAGE15","MAGE16","MAGE17","MAGE18","MAGE19"
,"MAGE20","MAGE21","MAGE22","MAGE23","FAGE1","FAGE2","FAGE3","FAGE4","FAGE5","FAGE6","FAGE7","FAGE8","FAGE9","FAGE10","FAGE11","FAGE12","FAGE13","FAGE14","FAGE15","FAGE16","FAGE17","FAGE18","FAGE19"
,"FAGE20","FAGE21","FAGE22","FAGE23")]/BG$SAT)

# add hh by children
bgDist <- cbind(bgDist,HHKID= BG[,c("HHKID2")]/BG$HHUT)

#SEX BY AGE BY INDEPENDENT LIVING DIFFICULTY at tract level - investigate


# should equal the number of distrbutions that have been appended together.
summary(rowSums(bgDist))


# saving these - basically shows that Block data doesn't align with Block group data
 
x <- read.csv("mazData.csv",as.is=T)
x$BG <- substring(x$GEOID,1,12)
Pop.BG  <- tapply(x$GP,x$BG,sum)
HH.BG  <- tapply(x$HH_Occ,x$BG,sum)


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

# create block group control to export 
BG <- bgDist

# zero out NA's
BG[is.na(BG)] <- 0

# income 
BG[,grep("HHINC",names(BG))] <- t(apply(cbind(HH.BG[rownames(BG)],BG[,grep("HHINC",names(BG))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# household size
BG[,paste0("HHS",1:7)] <- t(apply(cbind(HH.BG[rownames(BG)],BG[,paste0("HHS",1:7)]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# age
BG[,grep("HHAGE",names(BG))] <- t(apply(cbind(HH.BG[rownames(BG)],BG[,grep("HHAGE",names(BG))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# vehicles
BG[,grep("HHV",names(BG))] <- t(apply(cbind(HH.BG[rownames(BG)],BG[,grep("HHV",names(BG))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# units in structure
BG[,c("HHSF","HHSFA","HHDUP","HHMF4","HHMF9","HHMF19","HHMF49","HHMF50","HHMH","HHRV")] <- t(apply(cbind(HH.BG[rownames(BG)],BG[,c("HHSF","HHSFA","HHDUP","HHMF4","HHMF9","HHMF19","HHMF49","HHMF50","HHMH","HHRV")]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# sex by age
BG[,c(grep("MAGE",names(BG)),grep("FAGE",names(BG)))] <- t(apply(cbind(Pop.BG[rownames(BG)],BG[,c(grep("MAGE",names(BG)),grep("FAGE",names(BG)))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))

# kids
BG$HHKID <- round(BG$HHKID*HH.BG[rownames(BG)])

#taz[,grep("SIZE",names(taz))] <- t(apply(cbind(mazHH.Tz[rownames(taz)],taz[,grep("SIZE",names(taz))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))
#taz[,grep("WORK",names(taz))] <- t(apply(cbind(mazHH.Tz[rownames(taz)],taz[,grep("WORK",names(taz))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))
#taz[,grep("CHILD",names(taz))] <- t(apply(cbind(mazHH.Tz[rownames(taz)],taz[,grep("CHILD",names(taz))]),1,function(x) ReAllocate(x[1],x[2:length(x)])))


# write out revised TAZ data
write.csv(BG,"GP_BGData.csv")

BG <- read.csv("GP_BGData.csv",as.is = T)
names(BG)[1] <- "BG"
write.csv(BG,"GP_BGData.csv",row.names=F)


#summary(BG[names(Pop.BG),"POP_HH"] - Pop.BG)
#summary(BG[,"POP_E"] - tapply(x$POP,x$BG,sum)[rownames(BG)] )



