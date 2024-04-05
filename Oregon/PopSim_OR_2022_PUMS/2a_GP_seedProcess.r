# Dejan Dudich 8/2/2017
# Alex Bettinardi 3/1/18 - edited
# Alex Bettinardi 1/11/19 - correct wkhp to remove blanks and process 
# Alex Bettinardi 1/14/19 on a new student flag field   
# Jin 1/14/2019 - edited to from 2017 to 2010 $$$ and
# Jin 4/18/19 - revised values to fit 2000 census
# Jin updated to standardize the GP HH/Per seed creation on 9/25/19
# Jin 2/21/2023 updated 2016-2020 ACS data ss20hor.csv, ss20por.csv, TYPE to TYPEHUGQ, Adjust to 2010$
# Kaelem Mohabir 2/22/24 edited household and person table names for new 2022 5 year PUMS data and updated HHINCADJ factors (edits to lines 17-42)

#script to append required fields to PUMS PUMA800, 901, 902 records

# set group quarters data directory
gpData <- "data"

# read in household table
hh <- read.csv(paste0(gpData,"/psam_h41PUMA2010.csv"),as.is=T)
rownames(hh) <- hh$SERIALNO

# read in person table
per <- read.csv(paste0(gpData,"/psam_p41PUMA2010.csv"),as.is=T)

#group quarters household weight is zero for general population
hh$GQWGTP<-0

# ACS2016_2020_PUMS_README.pdf""
# E. Note on Income and Earnings Inflation Factor (ADJINC)
# Divide ADJINC by 1,000,000 to obtain the inflation adjustment factor and multiply it to 
# the PUMS variable value to adjust it to 2020 dollars. Variables requiring ADJINC on the 
# Housing Unit file are FINCP and HINCP. Variables requiring ADJINC on the Person files are: 
# INTP, OIP, PAP, PERNP, PINCP, RETP, SEMP, SSIP, SSP, and WAGP. 
# ADJUSTING TO 2010 DOLLARS:
#adjust to 2020 dollars first 
#and then multiply the 2020-2010 deflation value for adjustment from 2020$ to 2010$
#The US CPI was 257.971 in 2020 and 218.056 in 2010, the deflation =218.056/257.971=0.5453
hh$HHINCADJ<- 999
hh$HHINCADJ[hh$ADJINC==1184371]<-hh$HINCP[hh$ADJINC==1184371]*1.013097*1.16905988#*0.8453  #2018to2022$
hh$HHINCADJ[hh$ADJINC==1159866]<-hh$HINCP[hh$ADJINC==1159866]*1.010145*1.14821714#*0.8453  #2019to2022$
hh$HHINCADJ[hh$ADJINC==1140108]<-hh$HINCP[hh$ADJINC==1140108]*1.006149*1.13314076#*0.8453  #2020to2022$
hh$HHINCADJ[hh$ADJINC==1113261]<-hh$HINCP[hh$ADJINC==1113261]*1.029928*1.08091182#*0.8453  #2021to2022$
hh$HHINCADJ[hh$ADJINC==1042311]<-hh$HINCP[hh$ADJINC==1042311]*1.042311*1.00000000#*0.8453  #2022to2022$
hh$HHINCADJ[is.na(hh$HHINCADJ)]<- 999    

# create htype filed 
#hh$HTYPE<-c("2"=1,"4"=2,"5"=2,"6"=2,"7"=2,"8"=2,"9"=2,"1"=3,"10"=3,"3"=4)[as.character(hh$BLD)]

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
hh <- hh[hh$WGTP>0,]
hh <- hh[hh$NP>0,]
#hh<-reshape::rename(hh, c(TYPEHUGQ= "TYPE"))  #In 2020 ACS census TYPEHUGQ is TYPE in Specified ABM
hh <- hh[hh$TYPEHUGQ==1,]

# define hh REGION 1 for 800, 2 for 901, and 3 for 902, other REGION = 4
#hh$REGION [hh$PUMA == 800]  <- 1  
#hh$REGION [hh$PUMA == 901]  <- 2
#hh$REGION [hh$PUMA == 902]  <- 3

#add household number
hh$hhnum <- 1:nrow(hh)

# update per table fields
# add household weight
per$wgtp <- hh[as.character(per$SERIALNO),"WGTP"]
# remove persons that don't have a household
per <- per[!is.na(per$wgtp),]

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

# remove person blanks
per$WKHP[is.na(per$WKHP)] <- -8
per$ESR[is.na(per$ESR)] <- -8
per$SCHG[is.na(per$SCHG)] <- -8
per$WKW[is.na(per$WKW)] <- -8
per$MIL[is.na(per$MIL)] <- -8
per$SCHL[is.na(per$SCHL)] <- -8

# reset SCHG 1=1; 2=2: 3=3:6; 4=7,8,9,10; 5=11,12,13,14; 6=15, 7=16
per$SCHG[per$SCHG %in% c(3:6)] <- 3
per$SCHG[per$SCHG %in% c(7:10)] <- 4
per$SCHG[per$SCHG %in% c(11:14)] <- 5
per$SCHG[per$SCHG == 15] <- 6
per$SCHG[per$SCHG == 16] <- 7

# convert SCHG to ABM specified definitions:
# https://github.com/RSGInc/SOABM/wiki/Running-the-Population-Synthesizer#person-file-format
#schg <- c(-8,1,2,rep(3,4),rep(4,4),rep(5,4),6,7)
#names(schg) <- c(-8, 1:16)
#pergq$SCHG <- schg[as.character(pergq$SCHG)]


# convert SCHL to ABM specified definitions 
# SCHL 1=1; 2=2:7; 3=8:9; 4=10:11; 5=12; 6=13; 7=14; 8=15; 9=16:17; 10:16 = 18:24
# https://github.com/RSGInc/SOABM/wiki/Running-the-Population-Synthesizer#person-file-format
SCHL <- c(-8,1,rep(2,6),rep(3,2),rep(4,2),5:8,rep(9,2),10:16)
names(SCHL) <- c(-8, 1:24)
per$SCHL <- SCHL[as.character(per$SCHL)]
rm(SCHL)

# develop a full time worker flag
per$FTWK <- ifelse(per$AGEP >=16 & per$ESR %in% c(1,2,4,5) & per$WKHP >= 35 & per$WKW %in% 1:4,1,0)

# add a drivers license criteria 

# Develop a student flag
per$UNIS <- ifelse(per$FTWK==0 & per$SCHG >=6 & per$AGEP >= 16 ,1, 0)
per$UNIS[per$FTWK==0 & per$SCHG >=1 & per$AGEP >= 19 ] <- 1

# remove blanks from the household table too
# clean up NA fields
hh$HINCP[is.na(hh$HINCP)] <- -8
hh$TEN[is.na(hh$TEN)] <- -8
hh$BLD[is.na(hh$BLD)] <- -8
hh$VEH[is.na(hh$VEH)] <- -8
hh$HHT[is.na(hh$HHT)] <- -8
hh$NPF[is.na(hh$NPF)] <- -8
hh$HUPAC[is.na(hh$HUPAC)] <- -8

# define per REGION 1 for 800, 2 for 901, and 3 for 902, others REGION=4
#per$REGION  <- 4  
#per$REGION [per$PUMA == 800]  <- 1  
#per$REGION [per$PUMA == 901]  <- 2
#per$REGION [per$PUMA == 902]  <- 3

# write out updated hh and per tables
write.csv(hh, paste0(gpData,"/GP_seed_households.csv"),row.names=F) 
write.csv(per, paste0(gpData,"/GP_seed_persons.csv"),row.names=F) 

