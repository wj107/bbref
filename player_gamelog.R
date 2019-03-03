#######################################################################
#########   Get gamelogsa for player gamelogs in a given season
#######################################################################

#######packages needed
require(rvest)

#########give me a player name, I'll get game-by-game bx gamelogsa
player_gamelog<-function(
  #----internal call, no warnings.
  year,
  
	##################player to get gamelogsa for
		#player="Russell Westbrook",
	##################season to get gamelogsa for
		#season=2017,
	###############add column w.player name??
    id.player=FALSE,
	##############add column w. season?
		id.year=FALSE
		)
	{

######################################################################
  #---subroutine: get listing of all NBA teams in season
  source("team_listing.R")
  team.listing(year)->team.list
  #---note: team.list is DF with columns teams, abbr, team.links
  
  #####################################################  
  #---menu: what team does the player play for?
  menu(
    #---choices: all team names from given season
    team.list[,1],
    #---title
    title=paste0("Select a player from which team during the ",year," season?")
  )->team.row
  #---save my team, abbreviation, and html link  
  my.team<-team.list[team.row,]
  
  
  ###########################################################################
  #---subroutine:  get a listing of all games my team played in my season
  source("player_listing.R")
  player.listing(team=my.team)->player.list
  #---player.list is DF: col 1-6: player data, 7: menu.text, 8: player html, 9: player gamelog html
  

  #####################################################  
  #---menu: what player to get gamelogs for?
  menu(
    #---choices: game listing for given season
    player.list[,7],
    #---title
    title=paste0("What player from the ",year," ",team.list[team.row,1]," do you want gamelog data for?"))->player.row
  #---save game gamelogsa & links
  my.player<-player.list[player.row,]  
  
  
#######principle path!
	link.root<-"https://www.basketball-reference.com/"

#####read webpage with game gamelogsa
	gamelog.url<-file.path(link.root,my.player[,9],year)
	gamelog.html<-read_html(gamelog.url)
#####identify tables in webpage, select regular season gamelogsa
	gamelog.html<-html_nodes(gamelog.html,"table")
	gamelog.html<-gamelog.html[grep("Regular Season Table",gamelog.html)]
####convert html table to data frame
	gamelogs<-as.data.frame(html_table(gamelog.html,fill=T))


####clean up labels/DNPs
	###find labels/DNPs
		labs<-sapply(1:nrow(gamelogs), function(x) all(is.na(as.numeric(gamelogs[x,10:ncol(gamelogs)]))) )
	####eliminate labels/DNPs
		gamelogs<-gamelogs[!labs,]
		
#####clean up data!!
	######change "@" to "H" or "A"
		gamelogs[gamelogs[,6]=="",6]<-"H"
		gamelogs[gamelogs[,6]=="@",6]<-"A"
	######find W/L, margin
		substr(gamelogs[,8],1,1)->WL
		###do the margin, later!!!
		gamelogs[,8]<-WL

	#########numeric columns, factor columns
		numeric.columns<-c(1,2,11:30)
		factor.columns<-c(5,6,8,9)
		
		###later-- order factors??	
	####coerce numeric/factor columns
		for (i in numeric.columns) as.numeric(gamelogs[,i])->gamelogs[,i]
		for (i in factor.columns) as.factor(gamelogs[,i])->gamelogs[,i]

	#########names for data frame
		gamelogs.names<-c("G","GP","date","Age","Team","HA","Opp","WL","GS","MP","FG","FGA","FGp","tP","tPA","tPp","FT","FTA","FTp",
			"ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PTS","GmSC","PM")
	

		names(gamelogs)<-gamelogs.names
		#####add YR column if id.year=T
		if(id.year) {
		  YR<-rep(year,nrow(gamelogs))
		  gamelogs<-cbind(YR,gamelogs)
		}
		#####add WHO column if id.player=T
		if(id.player) {
		  WHO<-rep(my.player[,2],nrow(gamelogs))
		  gamelogs<-cbind(WHO,gamelogs)
		}
	
		#---WTF last column??
	  if(all(is.na(gamelogs[,ncol(gamelogs)]))) gamelogs<-gamelogs[,-ncol(gamelogs)]
		
gamelogs}
