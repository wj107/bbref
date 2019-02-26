#######################################################################
#########   Get play-by-play gamelogs from BASKETBALL-REFERENCE.COM 
#######################################################################


#########for a given game, I'll get play-by-play data
game_pbp<-function(
	#---season to get play-by-play logs for, from 'year' argument to bbref
		year=year
	#---dates to get play-by-play logs for
	#  date=NULL
	
	
##----for v2.0!!!
	###############add column w.player name??
		##id=FALSE
	##############add column w. season?
		##year=FALSE
		)
{
  
#######################################
#------check arguments...
#------not needed, internal call
  
###if(!is.null(date)) {subroutine to extract games by date, first.}  


  #---test season is 2001 or later
  if(is.na(as.numeric(season)) | as.numeric(season)<2001) stop("Season must be a year, in YYYY format, from 2001 or later.")
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
	source("pbp_clean.R")
  output<-pbp_clean(my.team,my.game)
	
###################################################
#----available to be called:
  #---my.team
  #---my.game
  
#-----OUTPUT!!!!
  output}

