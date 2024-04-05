#Kaelem Mohabir 4-27-2023
#This script
#Script assumes you have census API key saved in .Renviron
#If not, use this line: 
# census_api_key("KEY_GOES_HERE", install = TRUE)

#Tidyverse, Tidycensus packages
#install.packages(c("tidycensus", "tidyverse"))
library(tidycensus)
#library(tidyverse)


#Pull acs5 data by blockgroups for headers identified by Martin and write to csv 
vars <- read.csv("DecennialFields_GQ.csv")
rownames(vars) <- vars$UniqueID
decData <- get_decennial(
  geography = "block",
  state = "WA",
  variables = rownames(vars),
  output = "wide",
  year = 2020
)

#add short names for tables
names(decData)[names(decData) %in% rownames(vars)] = vars[names(decData)[names(decData) %in% rownames(vars)],"ShortName"]

write.csv(decData,"DecennialBlockData_GQ.csv",row.names=F)
