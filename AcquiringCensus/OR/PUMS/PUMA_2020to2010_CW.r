#Kaelem Mohabir
#2-14-24
#This script reallocates 2010 PUMAs to 2020 PUMAs based on population 
#It uses 2020 census blocks that have been joined to 2010 and 2020 PUMAs
library(foreign)

blocks <- read.dbf("PUMA2010to2020.dbf", as.is=TRUE)

cw <- tapply(blocks$POP,list(blocks$PUMACE20,blocks$PUMACE10),sum)

temp <- apply(cw,1,function(x)x[!is.na(x)]/sum(x,na.rm=TRUE))

temp <- unlist(lapply(temp,function(x)round(x*100)[round(x*100)>0]))

do.call(rbind,strsplit(names(temp),"\\."))

out <- cbind(do.call(rbind,strsplit(names(temp),"\\.")),temp)

colnames(out)=c("PUMA20","PUMA10","Percentage")

write.csv(out,"PUMA2020to2010.csv",row.names=FALSE)