library(foreign)
x<- read.dbf("BLOCK_PUMA_cw.dbf",as.is=T)
y <- x[,c("GEOID20","GEOID","PUMACE10")]
str(y)
y[] <- as.numeric(unlist(y))
str(y)
summary(y)
y[is.na(y$PUMACE10),3] <- 300
summary(y)
names(y) <- c("BLOCK","BG","PUMA")
write.csv(y,"geo_cross_walk.csv",row.names=F)
q()
