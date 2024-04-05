# inputCheck.R
# Alex Bettinardi
# 5-30-17
# 3-1-18 edited AB
# 10-03-18 updated by JXR for 2017 PopSim HH Data
# 09-26-19 JXR streamlined as 2c1_CP_InputCheck.r

# Script to check for consistencies across syn pop input tables

# read syn pop input tables
#meta <- read.csv("data/GP_metaData.csv",as.is=T)
BG <- read.csv("data/GP_BGData.csv", as.is=T)
rownames(BG) <- BG$BG
BLOCK <- read.csv("data/GP_BlockData.csv",as.is=T)
  #newCW <- cbind(MAZ=maz$MAZ,TAZ=floor(maz$MAZ/100),PUMA=900,REGION=1)
cw <- read.csv("data/geo_cross_walk.csv",as.is=T)
rownames(cw) <- cw$BLOCK

# first verify all zone numbers align
# BLOCK
if(length(BLOCK$BLOCK[!BLOCK$BLOCK %in% cw$BLOCK])>0) stop("BLOCK numbers don't match crosswalk")
if(length(cw$BLOCK[!cw$BLOCK %in% BLOCK$BLOCK])>0) stop("BLOCK numbers don't match crosswalk")
# BG
if(length(BG$BG[!BG$BG %in% unique(cw$BG)])>0) stop("BG numbers don't match crosswalk")
if(length(unique(cw$BG)[!unique(cw$BG) %in% BG$BG])>0) stop("BG numbers don't match crosswalk")
# meta
#if(length(meta$REGION[!meta$REGION %in% unique(cw$REGION)])>0) stop("Meta numbers don't match crosswalk")
#if(length(unique(cw$REGION)[!unique(cw$REGION) %in% meta$REGION])>0) stop("BLOCK numbers don't match crosswalk")

# do totals align
# check hh: BG -> BG
if((any(as.integer(rowSums(BG[,grep("INC",names(BG))]) - rowSums(BG[,paste0("HHS",1:7)]))))!=0) stop("Inc and Size Households don't match at a BG level")
if((any(as.integer(rowSums(BG[,grep("INC",names(BG))]) - rowSums(BG[,grep("HHAGE",names(BG))]))))!=0) stop("Inc and Age Households don't match at a BG level")
if((any(as.integer(rowSums(BG[,grep("INC",names(BG))]) - rowSums(BG[,grep("HHV",names(BG))]))))!=0) stop("Inc and Vehicles Households don't match at a BG level")
#if((any(as.integer(rowSums(BG[,grep("INC",names(BG))]) - rowSums(BG[,c(grep("MAGE",names(BG)),grep("FAGE",names(BG)))]))))!=0) stop("Inc and Gender by age Households don't match at a BG level")
if((any(as.integer(rowSums(BG[,grep("INC",names(BG))]) - rowSums(BG[,c("HHSF","HHSFA","HHDUP","HHMF4","HHMF9","HHMF19","HHMF49","HHMF50","HHMH","HHRV")]))))!=0) stop("Inc and Household type don't match at a BG level")

# check hh: BLOCK -> BLOCK
#if(any(summary(rowSums(BLOCK[,grep("_HH",names(BLOCK))]) - BLOCK$HH)!=0)) stop("Households by type don't match total households at a BLOCK level")

# check hh BLOCK -> BG
BLOCKHH.Bg <- tapply(BLOCK$HH_Occ, cw[as.character(BLOCK$BLOCK),"BG"],sum)
if(any(round(summary(BLOCKHH.Bg-rowSums(BG[names(BLOCKHH.Bg),grep("INC",names(BG))])))!=0)) stop("BG HH totals versus BLOCK HH totals don't align")

# check population
BLOCKPop.Bg <- tapply(BLOCK$GP, cw[as.character(BLOCK$BLOCK),"BG"],sum)
if(any(round(summary(BLOCKPop.Bg-rowSums(BG[names(BLOCKPop.Bg),c(grep("MAGE",names(BG)),grep("FAGE",names(BG)))])))!=0)) stop("BG Pop totals versus BLOCK Pop totals don't align")

#BG$Pop <- rowSums(sweep(BG[,grep("SIZE",names(BG))],2, c(1:3, 4.50), "*"))
#print("BG Pop (by size) compared to Meta Pop - should never be greater than 1")
#print(tapply(BG$Pop, cw[match(BG$BG, cw$BG),"REGION"],sum)/meta$POP)

# check population at meta level
#if(any(summary(rowSums(meta[,grep("AGE",names(meta))]) - meta$POP)!=0)) stop("Total Pop and Pop by Age don't match at a Meta level")

#Worker/occupation totals by REGION (PUMA)
#cat("BG workers (by number of workers) compared to Meta workers by occupation\nshould  be as close to 1 as possible\n")
#meta$WORKER <- rowSums(meta[,grep("OCC",names(meta))])
#BG$WORKER <- rowSums(sweep(BG[,grep("WORK",names(BG))],2,c(0:2,3.25),"*"))
#print (tapply(BG$WORKER, cw[match(BG$BG, cw$BG),"REGION"],sum)/meta$WORKER)

#meta[,grep("OCC",names(meta))]<- round(meta[,grep("OCC",names(meta))]/(sum(meta[,grep("OCC",names(meta))])/sum(sweep(taz[,grep("WORK",names(taz))],2,c(0:2,3.3),"*"))))
#write.csv(meta,"metaData.csv",row.names=F)
