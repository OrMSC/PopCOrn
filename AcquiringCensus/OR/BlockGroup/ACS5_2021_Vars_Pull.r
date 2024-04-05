#Kaelem Mohabir 4-27-2023
#This script pulls all fields for 2021 ACS 5
#Script assumes you have census API key saved in .Renviron
#If not, use this line: census_api_key("KEY_GOES_HERE", install = TRUE)


#Tidyverse, Tidycensus packages
#install.packages(c("tidycensus", "tidyverse"))
library(tidycensus)
library(tidyverse)

#load all variables in 2021 acs5 and write to csv
acs5_2021_vars <- load_variables(2021, "acs5")
write.csv(acs5_2021_vars,"All_ACS5_21_Variables.csv",row.names=F)