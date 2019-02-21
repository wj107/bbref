#######################################################################
#########   Get shot chart gamelogs from BASKETBALL-REFERENCE.COM 
#######################################################################

#######packages needed
require(rvest)

#########create function -- give me a box score link, I'll get team data
shot_chart<-function(
	#---season to get play-by-play logs for
		season=format(Sys.Date(),"%Y"),
	#---dates to get play-by-play logs for
	  date=NULL
	
	
##----for v2.0!!!
	###############add column w.player name??
		##id=FALSE
	##############add column w. season?
		##year=FALSE
		)
{
  
#######################################
#------check arguments
  
###if(!is.null(date)) {subroutine to extract games by date, first.}  

#---test season is 2001 or later
  if(is.na(as.numeric(season)) | as.numeric(season)<2001) stop("Season must be a year, in YYYY format, from 2001 or later.")

#---root link!! data source!!
  link.root<-"https://www.basketball-reference.com"
  
######################################################################
#---subroutine: get listing of all NBA teams in season
  source("team_listing.R")
  team.listing(season)->team.list

#####################################################  
#---menu: what team to get play-by-play data for?
  menu(team.list[,1],title="What team do you want play-by-play data for?")->team.row
#---save my team, abbreviation, and html link  
  my.team<-team.list[team.row,]

  
###########################################################################
#---subroutine:  get a listing of all games my team played in my season
  source("game_listing.R")
  game.listing(team=my.team)->game.list
  
#####################################################  
#---menu: what games to get play-by-play data for?
  #---first print game data
  print(game.list[,2:7])
  #---then create the menu
  menu(game.list[,2],title="What game do you want play-by-play data for?")->game.row
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

