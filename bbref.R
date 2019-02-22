####################################################################
#----------wrapper for bbref data extraction
####################################################################

bbref<-function(
  #----what season to focus on?
  year=format(Sys.time(),"%Y")
){
  ##################
  #---check arugment
  
  #---year is an integer
  year<-as.integer(year)
  #---if not...
  if(is.na(year)) stop("Argument 'year' must be a year between 1950 and the current year")
  #---or if not in proper range...
  if((year>as.numeric(format(Sys.time(),"%Y"))) | (year<1950)) stop("Argument 'year' must be a year between 1950 and the current year")
  
  ####################################
  #---Identify desired data to extract
  
  #---menu: team gamelogs, or game play-by-play??
  menu(c("Team gamelogs for the season", "Play-by-play data for a selected game"),title="What type of data would you like to extract?")->dat.type
  
  #---if gamelogs...
  if(dat.type==1) {
    #---load the team_gamelog subroutine
    source("team_gamelog.R")
    #---extract gamelog data for the given year
    #------NEED MENU FOR TEAM!!
    #------OPTION FOR OPPONENT'S DATA!!!
    team_gamelog("LAL",year,F)->output
  }
  
  #---if play-by-play data...
  if(dat.type==2) {
    #---load the play-by-play subroutine
    source("game_pbp.R")
    #---extract play-by-play data for a given team on a given date
    game_pbp(year)->output
  }
  
  
#---OUTPUT!!
output
}