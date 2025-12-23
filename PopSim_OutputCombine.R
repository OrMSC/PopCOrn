# Alex Bettinardi
# 12-22-25

# extra processing script to merge all the Oregon and Washington General population (GP) and group quarters (gq) populations into one pair of output tables (hh and persons)

# bind output rows for households and persons while updating the household ID fields:
hh <- read.csv("ACS22_PUMS22/PopSim_OR_2022_PUMS/output/GP_synthetic_households.csv",as.is=T,numerals = "no.loss")
hh2 <- read.csv("ACS22_PUMS22_WA/PopSim_WA_2022_PUMS/output/GP_synthetic_households.csv",as.is=T,numerals = "no.loss")

per <- read.csv("ACS22_PUMS22/PopSim_OR_2022_PUMS/output/GP_synthetic_persons.csv",as.is=T,numerals = "no.loss")
per2 <- read.csv("ACS22_PUMS22_WA/PopSim_WA_2022_PUMS/output/GP_synthetic_persons.csv",as.is=T,numerals = "no.loss")

# update household id fields
hh2$household_id <- hh2$household_id + nrow(hh)
per2$household_id <- per2$household_id + nrow(hh)

# combine hh and per 1 and 2
hh <- rbind(hh,hh2)
per <- rbind(per,per2)

rm(hh2,per2)

gq <- rbind(read.csv("ACS22_PUMS22/GQ_Civ/output/GQ_synthetic_households.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22/GQ_Mil/output/GQ_synthetic_households.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22/GQ_Uni/output/GQ_synthetic_households.csv",as.is=T,numerals = "no.loss"),			
			read.csv("ACS22_PUMS22_WA/GQ_Civ/output/GQ_synthetic_households.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22_WA/GQ_Uni/output/GQ_synthetic_households.csv",as.is=T,numerals = "no.loss"))


# add required fields to the gq tables
gq$BG <- substring(gq$BLOCK,1,12)
gq$TRACT <- substring(gq$BLOCK,1,11)
gq$WGTP <- gq$GQWGTP
# update house id number
hhTot <- nrow(hh)
gq$household_id <- (1:nrow(gq))+hhTot

# add required field to hh table
hh$GQTYPE <- 0

# combine all household records	(gp and gq)	
hh <- rbind(hh,gq[,names(hh)])						
			
# add person gq

gq <- rbind(read.csv("ACS22_PUMS22/GQ_Civ/output/GQ_synthetic_persons.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22/GQ_Mil/output/GQ_synthetic_persons.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22/GQ_Uni/output/GQ_synthetic_persons.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22_WA/GQ_Civ/output/GQ_synthetic_persons.csv",as.is=T,numerals = "no.loss"),
			read.csv("ACS22_PUMS22_WA/GQ_Uni/output/GQ_synthetic_persons.csv",as.is=T,numerals = "no.loss"))
			
# add required fields to the gq tables
gq$BG <- substring(gq$BLOCK,1,12)
gq$TRACT <- substring(gq$BLOCK,1,11)
gq$wgtp <- gq$gqwgtp
# update house id number
gq$household_id <- (1:nrow(gq))+hhTot

# add required field to per table
per$GQFLAG <- 0

# combine all person records (gp and gq)	
per <- rbind(per,gq[,names(per)])	

# export the final tables
write.csv(hh,"CombinedOutput/synthetic_households.csv",row.names=F)
write.csv(per,"CombinedOutput/synthetic_persons.csv",row.names=F)
