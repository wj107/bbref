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
  #---some requireds
  #---rvest package for digging into html
  require(rvest)
  #---root link!! data source!!
  link.root<-"https://www.basketball-reference.com"

  
  ####################################
  #---Identify desired data to extract
  
  #---menu: what data to extract??
  menu(
    #---menu choices
    c(paste0("Team gamelogs for the ",year," season"),
      paste0("Player gamelogs for the ", year," season"), 
      paste0("Play-by-play data for a selected game during the ",year," season"),
      paste0("Shot charts for a selected game during the ",year," season")),
    #---chart title
    title="What type of data would you like to extract?"
    #---menu output = dat.type identifier
    )->dat.type
  
  #---if no selection, end program
  if(dat.type==0) stop("No selection made, program ended.")
  
  #---if team gamelogs...
  if(dat.type==1) {
    #---load the team_gamelog subroutine
    source("team_gamelog.R")
    team_gamelog(year,F)->output
  }
  
  #---if player gamelogs...
  if(dat.type==2) {
    #---load the player_gamelog subroutine
    source("player_gamelog.R")
    player_gamelog(year,F,F)->output
  }
  
  #---if play-by-play data...
  if(dat.type==3) {
    #---load the play-by-play subroutine
    source("game_pbp.R")
    #---extract play-by-play data for a given team on a given date
    game_pbp(year)->output
  }
  
  #---if shot chart data...
  if(dat.type==4) {
    #---load the team_gamelog subroutine
    source("game_sc.R")
    game_sc(year)->output
  }
  
#---OUTPUT!!
output
}
