########################################################################################
#---------create data frame with all NBA teams & abbreviations for a given season
########################################################################################

team.listing<-function(
  #---what season to get data from?  internal call; so no warnings
  season=NULL
){
  #---all NBA teams from given season
  season.link<-paste0("https://www.basketball-reference.com/leagues/NBA_",season,".html")
  
  #---get html links to all NBA teams for the given season
  team.html<-read_html(season.link)
  team.html<-html_nodes(team.html,"table")
  
  #---you shouldn't have more than 2 tables...
  if(length(team.html)>2) team.html<-team.html[1:2]
  
  team.html<-html_nodes(team.html,"a")
  
  
  
  #---clean up data from team.html
  teams<-html_text(team.html)
  team.links<-html_attr(team.html,"href")
  
  abbr<-strsplit(team.links,"/")
  #---take the elements of length 3... oughta be abbreviations for the teams!!
  abbr<-sapply(abbr,function(x) x[which(nchar(x)==3)])
  
  #---output: all the team info together in data frame!!!
  data.frame(teams, abbr,team.links,stringsAsFactors = F)
}