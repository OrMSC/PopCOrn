#Kaelem Mohabir 4-27-2023
#This script pulls all fields for Decennial 2020
#Script assumes you have census API key saved in .Renviron
#If not, use this line: census_api_key("KEY_GOES_HERE", install = TRUE)


#Tidyverse, Tidycensus packages
#install.packages(c("tidycensus", "tidyverse"))
library(tidycensus)
library(tidyverse)

#load all variables in Decennial 2020 pl table and write to csv ***this is all the available data for 2020 census at time of writing
decennial_2020_vars <- load_variables(2020, "pl")
write.csv(decennial_2020_vars,"All_Decennial_20_Variables.csv",row.names=F)