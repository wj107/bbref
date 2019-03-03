#######################################################################
#########   Get play-by-play gamelogs from BASKETBALL-REFERENCE.COM 
#######################################################################


#########for a given game, I'll get play-by-play data
game_pbp<-function(
	#---season to get play-by-play logs for, from 'year' argument to bbref
		year

		
##----for v2.0!!
	#---dates to get play-by-play logs for
	#  date=NULL
	###############add column w.player name??
		##id=FALSE
	##############add column w. season?
		##year=FALSE
		)
{
  
  
######################################################################
#---subroutine: get listing of all NBA teams in season
  source("team_listing.R")
  team.listing(year)->team.list
  #---note: team.list is DF with columns teams, abbr, team.links

#####################################################  
#---menu: what team to get play-by-play data for?
  menu(
    #---choices: all team names from given season
    team.list[,1],
    #---title
    title=paste0("Select play-by-play data from a game from the ",year," season from which team?")
    )->team.row
#---save my team, abbreviation, and html link  
  my.team<-team.list[team.row,]

  
###########################################################################
#---subroutine:  get a listing of all games my team played in my season
  source("game_listing.R")
  game.listing(team=my.team)->game.list
  #---game.list is DF: col 1-7: game data, 8: menu.text, 9: boxscores html, 10: play-by-play html, 11: shot chart html
  
#####################################################  
#---menu: what games to get play-by-play data for?
  menu(
    #---choices: game listing for given season
    game.list[,8],
    #---title
    title=paste0("What game from the ",year," ",team.list[team.row,1]," do you want play-by-play data for?"))->game.row
  #---save game data & links
  my.game<-game.list[game.row,]

#########################################################
#----subroutine: extract play-by-play table
	source("pbp_clean.R")
  #---function to extract/clean pbp data!!
  pbp_clean(my.team,my.game)->output
	
#-----OUTPUT!!!!
  output}

