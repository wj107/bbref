

#########################################################
#-----figure out how to re-write as a subroutine
#########################################################






##################################
#-----create quarter identifier
#---find ENDS of each quarter
grep("End of", dat[,2])->qtr.end
#---create vector with lengths of each quarter
qtr.len<-c(qtr.end[1],diff(qtr.end))
#---create and rbind quarter identifiers
Qtr<-rep(1:length(qtr.len),qtr.len)
dat<-cbind(dat,Qtr)

##############################
#-----obtain scores
#---convert "+2" etc into numbers
dat[,3]<-as.numeric(dat[,3])
dat[,5]<-as.numeric(dat[,5])
#---replace NA's with zero.
dat[is.na(dat[,3]),3]<-0
dat[is.na(dat[,5]),5]<-0
#---initialize blank score columns
s1<-rep(0,nrow(dat))
s2<-rep(0,nrow(dat))
#---fill score columns
for (i in 2:nrow(dat)){
  s1[i]<-s1[i-1]+dat[i,3]
  s2[i]<-s2[i-1]+dat[i,5]
}

##############################################################
#---remove original score columns, add & rename new ones
dat<-dat[,-c(3,4,5)]
dat<-cbind(dat,s1,s2)
names(dat)[5]<-away.team
names(dat)[6]<-home.team

#############################################
#---delete rows w/out times
dat<-dat[-grep("[A-Z]",dat[,1]),]
#---create column for plays and teams
Play<-vector("character",nrow(dat))
Team<-vector("character",nrow(dat))

#---identify begin/end plays
which(dat$at!="" & dat$ht!="")->beg.end
Play[beg.end]<-dat$at[beg.end]
Team[beg.end]<-"..."
#---erase beg/end plays from team plays
dat$at[beg.end]<-""
dat$ht[beg.end]<-""
#---populate plays from away team
which(dat$at!="")->at.index
Play[at.index]<-dat$at[at.index]
Team[at.index]<-away.team
#---populate plays from home team
which(dat$ht!="")->ht.index
Play[ht.index]<-dat$ht[ht.index]
Team[ht.index]<-home.team


#---split times into minutes/seconds
time<-matrix(0,nrow(dat),2)
for (i in 1:nrow(dat)) as.numeric(unlist(strsplit(as.character(dat[i,1]),split=":",fixed=TRUE)))->time[i,]
#---convert min/secs into seconds
MM<-matrix(c(60,1),2,1)
Sec<-time%*%MM
Sec<-720-Sec
#---convert seconds from opening tip
as.numeric(dat$Qtr)-1->Qs
time<-cbind(Qs,Sec)
MM<-matrix(c(720,1),2,1)
time%*%MM->SecS