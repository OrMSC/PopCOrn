# Alex Bettinardi
# 12-22-25

# side script to pull the person and household records for the Metro region

# Load the combined household and person tables
hh <- read.csv("CombinedOutput/synthetic_households.csv",as.is=T,numerals = "no.loss")
per <- read.csv("CombinedOutput/synthetic_persons.csv",as.is=T, numerals = "no.loss")

# read in the block records and MAZ and TAZ numbers identified for the Metro model
cw <- read.csv("CombinedOutput/Metro_Block_MAZ_Xwalk.csv",as.is=T, numerals = "no.loss")
rownames(cw) <- cw$FIPS..GEOID20.

# subset hh and per to just blocks in the Metro cw
hh <- hh[hh$BLOCK %in% cw$FIPS..GEOID20.,]
per <- per[per$household_id %in% hh$household_id,]

# add MAZ and TAZ to the household table
hh$MAZ <- cw[as.character(hh$BLOCK),"MAZ.NO"]
hh$TAZ <- cw[as.character(hh$BLOCK),"TAZ.NO"]

# write out tables 
write.csv(hh,"CombinedOutput/synthetic_households_Metro.csv",row.names=F)
write.csv(per,"CombinedOutput/synthetic_persons_Metro.csv",row.names=F)


