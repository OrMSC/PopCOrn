library(foreign)
x<- read.dbf("Blocks2PUMA_Join.dbf",as.is=T)
y <- x[,c("GEOID20","PUMA")]
y[] <- as.numeric(unlist(y))
names(y) <- c("BLOCK","PUMA")
y$BG <- substring(y$BLOCK,1,12)
y$TRACT <- substring(y$BLOCK,1,11)
y <- y[y$PUMA %in% c(11000,11101:11104),c("BLOCK","BG","TRACT","PUMA")]
PUMAS <- unique(y$PUMA)
y$REGION <- sapply(y$PUMA,function(z)(which(z==PUMAS)))
write.csv(y,"geo_cross_walk.csv",row.names=F)
