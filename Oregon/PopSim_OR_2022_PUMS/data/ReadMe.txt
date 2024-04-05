Kaelem Mohabir
11-30-2023

Data folder

GP_BGData.csv - This .csv is output by ACS_4_PopSim.R and contains the processed data from the ACS5 to be input into PopulationSim. It has the processed counts of the ACS variables of interest from ACSfields.csv for each of the 2970 block groups in Oregon.

GP_TractData.csv - This .csv is output by ACS_4_PopSimTracts.R and contains the processed data from the ACS5 to be input into PopulationSim. It has the processed counts of the ACS variables of interest from ACS_Tract_fields.csv for each of the 1001 tracts in Oregon.

geo_cross_walk.csv - This .csv translates Block, Block Group, and PUMA geographies that must nest exactly. The crosswalk exists within the block data with the exception of the PUMA reference.The PUMA field was added with a spatial join.

