#lines 4-8 formerly CrossWalkFix.R script and 12 -22 formerly RegionAdd.R script. Consolidated into one script to align PUMAs and add REGIONS

#lines 4-8 read in geocrosswalk and align PUMAs to BGs
x <- read.csv("geo_cross_walk.csv",as.is=T)

y <- tapply(x$PUMA, x$BG, function(z) {Out=table(z);names(Out)[order(Out,decreasing=T)][1]})

x$PUMA <- y[as.character(x$BG)]


#lines 12-22 add REGION to geocrosswalk unique to each PUMA 
rg <-1:31
names(rg) <- sort(unique(x$PUMA))
x$REGION <- rg[as.character(x$PUMA)]

write.csv(x,"geo_cross_walk.csv",row.names=F)