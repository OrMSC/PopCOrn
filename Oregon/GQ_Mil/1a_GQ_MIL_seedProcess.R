# Dejan Dudich 8/2/2017
# Alex Bettinardi 3/1/18 - edited
# Alex, Jin, Dejan 3/30/2018 - edited to work with group quarters
# Jin 4/18/19 revised PUMA for 800, 901, 902 and SCHG to fit 2000 census 
# Jin 9/24/19 standardized file names, subfolders and r-scripts
# Jin 2/21/2023 updated 2016-2020 ACS data ss20hor.csv, ss20por.csv, TYPE to TYPEHUGQ

#script to append required fields to PUMS records

# set group quarters data directory
gqData <- "data"

# read in household table
hh <- read.csv(paste0(gqData,"/psam_h41PUMA2010.csv"),as.is=T)
rownames(hh) <- hh$SERIALNO

# read in person table
per <- read.csv(paste0(gqData,"/psam_p41PUMA2010.csv"),as.is=T)

#Filtering to just group quarter households, non vacant non insitutional
hh<-reshape::rename(hh, c(TYPEHUGQ= "TYPE"))  #In 2020 ACS census TYPEHUGQ is TYPE in Specified ABM
hh<-hh[hh$NP==1 & hh$TYPE==3, ] 

#Subset person table to persons in GQ houesholds
per<-per[per$SERIALNO %in% hh$SERIALNO,]

#Move person weight to household table
rownames(per)<- per$SERIALNO
hh$GQWGTP<- per[as.character(hh$SERIALNO),"PWGTP"]


#Group Quarters do not have income
hh$HHINCADJ<- 999

# create htype filed
hh$HTYPE<-999

# create number of children field
hh$hhchild <- c("4"=1,"1"=2,"2"=2,"3"=2)[as.character(hh$HUPAC)]
hh$hhchild[is.na(hh$hhchild)]<- 999

# tabulate number of workers by household
wrks.Hh <- table(per$SERIALNO[per$ESR %in% c(1,2,4,5)])

# create worker field
hh$NWESR <- 0
# population worker field
hh[names(wrks.Hh),"NWESR"] <- wrks.Hh

# filter out zero weight households
hh <- hh[hh$GQWGTP>0,]
hh <- hh[hh$NP>0,]

# remove person blanks
per$WKHP[is.na(per$WKHP)] <- -8
per$ESR[is.na(per$ESR)] <- -8
per$SCHG[is.na(per$SCHG)] <- -8
per$WKW[is.na(per$WKW)] <- -8
per$MIL[is.na(per$MIL)] <- -8
per$SCHL[is.na(per$SCHL)] <- -8

# reset SCHG 1=1; 2=2; 3=3,4,5,6; 4=7,8,9,10; 5=11,12,13,14; 6=15, 7=16
per$SCHG[per$SCHG %in% c(3:6)] <- 3
per$SCHG[per$SCHG %in% c(7:10)] <- 4
per$SCHG[per$SCHG %in% c(11:14)] <- 5
per$SCHG[per$SCHG == 15] <- 6   #SCHG 15 for undergraduate
per$SCHG[per$SCHG == 16] <- 7   #SCHG 16 for graduate/professional

# convert SCHL to ABM specified definitions 
# SCHL 1=1; 2=2:7; 3=8:9; 4=10:11; 5=12; 6=13; 7=14; 8=15; 9=16:17; 10:16 = 18:24
# https://github.com/RSGInc/SOABM/wiki/Running-the-Population-Synthesizer#person-file-format
SCHL <- c(-8,1,rep(2,6),rep(3,2),rep(4,2),5:8,rep(9,2),10:16)
names(SCHL) <- c(-8, 1:24)
per$SCHL <- SCHL[as.character(per$SCHL)]
rm(SCHL)

#Add in GQ HH type
hh$GQTYPE<-4
hh$MIL<- per[as.character(hh$SERIALNO),"MIL"]
hh$SCHG<- per[as.character(hh$SERIALNO),"SCHG"]
hh$GQTYPE[hh$MIL==1]<- 2
hh$GQTYPE[hh$SCHG %in% 6:7] <- 1  

#Add in GQ Per type
per$GQTYPE<-4
per$GQTYPE[per$MIL==1]<- 2
per$GQTYPE[per$SCHG %in% 6:7] <- 1

#subset seed to MIL GQ
hh<-hh[hh$GQTYPE==2, ] 

#Subset person table to persons in GQ houesholds
per<-per[per$SERIALNO %in% hh$SERIALNO,]


#add household number
hh$hhnum <- 1:nrow(hh)

#add GQ flag field
hh$GQFLAG <- 1

# update per table fields
# add GQ household weight
per$gqwgtp <- hh[as.character(per$SERIALNO),"GQWGTP"]
per$GQFLAG <- hh[as.character(per$SERIALNO),"GQFLAG"]

#  add an employeed field
per$employed <- ifelse(per$ESR %in% c(1,2,4,5),1,0)

# add a clean soc field
per$soc <- as.numeric(substring(per$SOCP,1,2))
per$soc[is.na(per$soc)] <- as.numeric(substring(per$SOCP[is.na(per$soc)],1,2))
per$soc[!per$ESR %in% c(1,2,4,5)] <- 0

# create occupation field
per$OCCP <- 999  # --Not in labor force
per$OCCP[per$soc %in% c(11,13,15,17,19,27,39)] <- 1  #--Management, Business, Science, and Arts
per$OCCP[per$soc %in% c(21,23,25,29,31)] <- 2  #--White Collar Service Occupations
per$OCCP[per$soc %in% c(33,35,37)] <- 3  #--Blue Collar Service Occupations
per$OCCP[per$soc %in% c(41,43)] <- 4  #--Sales and Office Support
per$OCCP[per$soc %in% c(45,47,49)] <- 5  #--Natural Resources, Construction, and Maintenance
per$OCCP[per$soc %in% c(51,53,55)] <- 6  #--Production, Transportation, and Material Moving

#add household number to persons file
per$hhnum <- hh[as.character(per$SERIALNO),"hhnum"]

# write out updated hh and per tables
# reduce to only PUMS data from PUMA 900
write.csv(hh, paste0(gqData,"/GQ_seed_households.csv"),row.names=F) 
write.csv(per,paste0(gqData,"/GQ_seed_persons.csv"),row.names=F) 

