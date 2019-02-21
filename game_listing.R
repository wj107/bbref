########################################################################################
#---------create data frame with all games for an NBA teams in a given season
########################################################################################

#####NOTE!  Can be combined with team_gamelog. 
#####a logical argument toggles between statistical data & gamelog identifiers


game.listing<-function(
  ###is this needed???
  #---what season to get games from?  internal call; so no warnings
  ##season=NULL,
  
  #---what team to get games from?  internal call; so no warnings    
  team=NULL
){
  #---our data source!
  link.root<-"https://www.basketball-reference.com/"
  
  #---tweak team[,3] to get team url to gamelog webpage
  team.url<-substr(team[,3],1,nchar(team[,3])-5)
  
  #---url to access all games for an NBA team from given season
  gamelog.link<-file.path(link.root,team.url,"gamelog")
  
  
  #---get table data for games for the given season
  gamelog.html<-read_html(gamelog.link)
  gamelog.html<-html_nodes(gamelog.html,"table")
  game.list<-html_table(gamelog.html)
  
  
  ###-----v2.0, choose from playoffs too:
  ###https://stackoverflow.com/questions/40616357/how-to-scrape-tables-inside-a-comment-tag-in-html-with-r

  
#########################
#---clean data frame
  
  #---list to dataframe
  game.list<-game.list[[1]]
  #---only columns 2-8
  game.list<-game.list[,2:8]
  #---make sure row names are 'nice'
  game.list[1,]<-c("G","Date","HA","Opp","WL","PF","PA")
  #---1st row should be header
  names(game.list)<-game.list[1,]
  #---what rows do not have data?   delete ones w/out data
  which(is.na(as.numeric(game.list[,1])))->del.rows
  game.list<-game.list[-del.rows,]
  #---scores are numeric!!
  game.list[,6:7]<-lapply(game.list[,6:7],as.numeric)
  #---delete rownames
  rownames(game.list)<-NULL
  
###############################################
#----HA and WL are factors...
  game.list[,3]<-factor(game.list[,3],labels=c("H","A"))
  game.list[,5]<-factor(game.list[,5],labels=c("L","W"))
  
################################################
#---get links to specific game data
  html_nodes(gamelog.html,"a")->game.links
  #---I only want boxscore data!!
  game.links[grep("boxscores",game.links)]->game.links
  #---extract boxscore links
  html_attr(game.links,"href")->boxscores
  #---use gsub to create links for play-by-play and shot charts
  gsub("boxscores","boxscores/pbp",boxscores)->play.by.play
  gsub("boxscores","boxscores/shot-chart",boxscores)->shot.chart
  
  
###############################################################
#----put it together: game list + links to bx, pbp, shots
  game.list<-data.frame(game.list,boxscores,play.by.play,shot.chart,stringsAsFactors = F)
  game.list}

