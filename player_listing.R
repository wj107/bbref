########################################################################
#---------create a listing of players on a given team
########################################################################


player.listing<-function(
  #---what team to get player list from?   year from bbref.  internal call; so no warnings
  team
){
  #---link root
  link.root<-"https://www.basketball-reference.com"
  #---url to access all players for an NBA team from given season
  player.list.link<-file.path(link.root,team[,3])
  

  #---get table data for players for the given season
  player.list.html<-read_html(player.list.link)
  player.list.html<-html_nodes(player.list.html,"table")
  player.list<-html_table(player.list.html)

#########################
#---clean data frame
  
  #---list to dataframe
  player.list<-player.list[[1]]
  #---only columns 1-5,8
  player.list<-player.list[,c(1:5,8)]
  #---make sure column names are 'nice'
  names(player.list)[1]<-"Num"
  
  #---create menu.text
  menu.text<-sapply(1:nrow(player.list), 
                    function(x) paste0(player.list[x,2]," (",player.list[x,4]," ",player.list[x,3],")",collapse="")
  )
  
################################################
  #---get links to specific game data
  html_nodes(player.list.html,"a")->player.links
  #---I only want player links!!
  player.links[grep("players",player.links)]->player.links
  #---extract player links
  html_attr(player.links,"href")->players
  #---use gsub to create links for player gamelogs
  gsub(".html","/gamelog",players)->players.gamelog
  
  
  ###############################################################
  #----put it together: game list + links to bx, pbp, shots
  player.list<-data.frame(player.list,menu.text,players,players.gamelog,stringsAsFactors = F)
  player.list}
  