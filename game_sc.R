#######################################################################
#########   Get shot chart gamelogs from BASKETBALL-REFERENCE.COM 
#######################################################################

#######packages needed
require(rvest)

#########create function -- give me a box score link, I'll get shot chart data

game_sc<-function(
	#---season to get play-by-play logs for
		year
	#---dates to get play-by-play logs for
	  #date=NULL
	
	
##----for v2.0!

###----FYI... 2001-2010 at hoop is only one point
 ####----2011-... precise locatio is given.
	###############add column w.player name??
		##id=FALSE
	##############add column w. season?
		##year=FALSE
		)
{
  

#---root link!! data source!!
  link.root<-"https://www.basketball-reference.com"
  
######################################################################
#---subroutine: get listing of all NBA teams in season
  source("team_listing.R")
  team.listing(year)->team.list

  
  
#####################################################  
#---menu: what team to get shot chart data for?
  menu(
    #---choices: all teams from a given season
    team.list[,1],
    #---title
    title=paste0("Select shot chart data from a game from the ",year," season from which team?")
    )->team.row
#---save my team, abbreviation, and html link  
  my.team<-team.list[team.row,]

  
###########################################################################
#---subroutine:  get a listing of all games my team played in my season
  source("game_listing.R")
  game.listing(team=my.team)->game.list
  #---game.list is DF: col 1-7: game data, 8: menu.text, 9: boxscores html, 10: play-by-play html, 11: shot chart html
  

#####################################################  
#---menu: what games to get shot chart data for?
  menu(
    #---choices: game listing for given season
    game.list[,8],
    #---title
    title=paste0("What game from the ",year," ",team.list[team.row,1]," do you want shot chart data for?"))->game.row
  #---save game data & links
  my.game<-game.list[game.row,]

  
#########################################################
#----subroutine: extract play-by-play table
	source("sc_clean.R")
  output<-sc_clean(my.team,my.game)
	
###################################################
#----available to be called:
  #---my.team
  #---my.game
  
#-----OUTPUT!!!!
  output}

