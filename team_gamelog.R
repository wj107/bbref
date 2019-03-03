##############################################################
#----Get team gamelogs as data frame for a given season
##############################################################

######create a function to get a team's bxdata for a whole season
team_gamelog<-function(
    #---what season to get data from?   year from bbref.  internal call; so no warnings
    year,
		
    
    ####_v2.0!!!
    ###########include opponents stats, too?
			opp=F
		)
	{

  
######################################################################
  #---subroutine: get listing of all NBA teams in season
  source("team_listing.R")
  team.listing(year)->team.list
  #---note: team.list is DF with columns teams, abbr, team.links
  
#####################################################  
#---menu: what team to get gamelog data for?
  menu(
    #---choices: all team names from given season
    team.list[,1],
    #---title
    title=paste0("Select gamelog data from the ",year," season for which team?")
  )->team.row
  #---save my team, abbreviation, and html link  
  my.team<-team.list[team.row,]
  
  
##################################################
####obtain & clean schedule for the given season
##################################################

####path for box scores
	link.root<-"https://www.basketball-reference.com"


  #---tweak my.team[3] to get team url to gamelog webpage
  team.url<-substr(my.team[3],1,nchar(my.team[3])-5)
	
  #############download gamelog data###############
	
	#####specific path for current season
		gamelog<-file.path(link.root,team.url,"gamelog")
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
		
		
		##--v2.0
	###############if opp, prepare opponent's data##################
	if(opp) {
		###designate opponent's stats
			names(opp.gamelog)<-paste0("o",gsub("p1","",names(opp.gamelog)))
		###cbind with gamelog data
			gamelog<-cbind(gamelog,opp.gamelog)
		}
			
#####output!!!
	gamelog
}

