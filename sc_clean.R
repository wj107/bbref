#######################################################################################################
#### script to clean data frame of shot chart data from a gamelink in basketball-reference.com
#######################################################################################################

sc_clean<-function(
  #---R object w. info about given team.  internal call; so no warnings
  my.team=NULL,
  #---R object w. info about given game.  internal call; so no warnings
  my.game=NULL
  ){

#----team abbreviations	
  ##################
  #---maybe this can be used to find shot data more efficiently???
  #----at home??
  if(my.game[,3]=="H") {
    my.team[,2]->home.team; my.game[,4]->away.team} else {
      #--away??
      my.team[,2]->away.team; my.game[,4]->home.team
    }
  
  
#---root link!! data source!!
  link.root<-"https://www.basketball-reference.com"
#--need rvest,first!!
  require(rvest)

################################################################################  
#---get html table w/shot chart data from gamelink, convert to data frame
  #---create link to shot chart data for my.game
  gamelink<-file.path(link.root,my.game[,11])
  #--get html table w/shot chart data
  read_html(gamelink)->shot.chart.html
  
  ######################################
  #---so the data is in the "div" nodes
  #----hope this is an effective, replicable way to get it out!!!
  html_nodes(shot.chart.html,"div")->shot.chart.html
  #---find all div nodes with "shot-area" in the attributes.
  regexpr("shot-area",shot.chart.html)->possible.div.nodes
  #---find which div nodes have "shot-area" attribute closest to node
  which(possible.div.nodes==min(possible.div.nodes[possible.div.nodes>0]))->my.divs
  
  
  ###############################################################
  #---use subroutine to extract shot chart df from div nodes
  source("sc_extract.R")
  #---for team1
  t1<-sc_extract(shot.chart.html[my.divs[1]])
  #---for team2
  t2<-sc_extract(shot.chart.html[my.divs[2]])
  
  
  #---prepare data for output
  output<-list(
    t1,t2
  )
  #---name with team abbreviations
  names(output)<-c(home.team,away.team)
  #---OUTPUT!!!
  output}

