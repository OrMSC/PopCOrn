#Kaelem Mohabir 12-12-2023
#This script
#Script assumes you have census API key saved in .Renviron
#If not, use this line: census_api_key("KEY_GOES_HERE", install = TRUE)


#Tidyverse, Tidycensus packages
#install.packages(c("tidycensus", "tidyverse"))
library(tidycensus)
library(tidyverse)


#Pull acs5 data by TRACT for headers identified by RSG and write to csv 
vars <- read.csv("ACS_Tract_fields.csv")
acs5_22_vars <- get_acs(
  geography = "tract",
  state = "WA",
  variables = c(vars[,"UniqueID"]),
  output = "wide",
  year = 2022
)

#make new short names for tables
Names <- paste(rep(vars$ShortName,each=2),c("E","M"),sep="_")
names(Names) = paste(rep(vars$UniqueID,each=2),c("E","M"),sep="")
names(acs5_22_vars)[names(acs5_22_vars) %in%names(Names)] = Names[names(acs5_22_vars)[names(acs5_22_vars) %in%names(Names)]]

write.csv(acs5_22_vars,"ACS5_2022_TRACT.csv",row.names=F)
