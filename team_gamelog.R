##############################################################
#----Get team gamelogs as data frame for a given season
##############################################################

######create a function to get a team's bxdata for a whole season
team_gamelog<-function(
    ######REWRITE WITH SUBROUTINE!!!
		###########team to get data from
		  team="LAL",
		###########season(s) to get data from
			season=year,
		###########include opponents stats, too?
			opp=F
		)
	{
########check arguments
###is team valid?
	#if(!(team %in% teams$abbr)) stop("Argument 'team' must be a valid abbreviation for an NBA team")
###is season valid?
	#if(!(season %in% 2000:2018)) stop("Argument 'season' must be between 2000 and 2018")
###is opp logical
	if(!is.logical(opp)) stop("Argument 'opp' must be logical")

###do I need 'teams' anymore, at all??

####full team
##	team.full<-teams$full[match(team,teams$abbr)]

##################################################
####obtain & clean schedule for the given season
##################################################

####path for box scores
	link.root<-"https://www.basketball-reference.com/teams"

####initialize output
output<-NULL



###########################
###NEED TO DEFINE 'team' 
####VIA SUBROUTINE, first.
############################

##no looping!!
#####loop across seasons
##for (i in season){
	
  #############download gamelog data###############
	
	#####specific path for current season
		gamelog<-file.path(link.root,team,season,"gamelog")
	#####read page w.gamelog
		gamelog<-read_html(gamelog)
	#####find tables in webpage
		gamelog.table<-html_nodes(gamelog,"table")
	#####'import' as data frame
		gamelog<-as.data.frame(html_table(gamelog.table), row.names=NULL)
	
	############clean gamelog data##################
	
	####fix names, delete redundancy
		names(gamelog)<-gamelog[1,]
		gamelog<-gamelog[-1,]
		gamelog<-gamelog[,-c(1,25)]
	####remove label rows
		gamelog<-gamelog[!is.na(as.numeric(gamelog[,1])),]
	####coerce stats to numeric
		gamelog<-cbind(gamelog[,1:5],data.frame(lapply(gamelog[,6:39],as.numeric)))
	####fix names
		names(gamelog)<-gsub("\\.","p",names(gamelog))
		names(gamelog)<-gsub("X3","t",names(gamelog))
	#####separate opponent's stats
		opp.gamelog<-gamelog[,24:39]
		gamelog<-gamelog[,1:23]
	
	##############format gamelog##########################
		
	####create home/away column
		gamelog[,3][gamelog[,3]=="@"]<-"A"
		gamelog[,3][gamelog[,3]==""]<-"H"
	####fix some names
		names(gamelog)[c(3,5:7)]<-c("HA","WL","PTS","oPTS")
	####format factors
		###future: order factors!!
		for (i in c(3,5)) gamelog[,i]<-as.factor(gamelog[,i])

	###############if opp, prepare opponent's data##################
	if(opp) {
		###designate opponent's stats
			names(opp.gamelog)<-paste0("o",gsub("p1","",names(opp.gamelog)))
		###cbind with gamelog data
			gamelog<-cbind(gamelog,opp.gamelog)
		}
				
####rbind season data to output
	output<-rbind(output,gamelog)
	
	#no looping
	###finish 'season' loop
	#}


#####output!!!
	output
}

