###################################################################
###################################################################
#############pull a list of box scores from an entire season
###################################################################
###################################################################

###Package for scraping tables
	require(rvest)
###Load variable of team abbreviations and names (later.... seasons, too!!!)
	load("teams.R")


######create a function to get a team's bxdata for a whole season
bx.season<-function(
		###########team to get data from
			team="LAL",
		###########season to get data from
			season=2010
		)
	{
########check arguments
###is team valid?
	#if(!(team %in% teams$abbr)) stop("Argument 'team' must be a valid abbreviation for an NBA team")
###is season valid?
	#if(!(season %in% 2000:2018)) stop("Argument 'season' must be between 2000 and 2018")

####full team
	team.full<-teams$full[match(team,teams$abbr)]

##################################################
####obtain & clean schedule for the given season
##################################################

####path for box scores
	link.root<-"https://www.basketball-reference.com/"

#####specific path for desired season
	link.season<-file.path(link.root,"teams",team,paste0(season,"_games.html"))
	
#####read page w.schedule
	season.schedule<-read_html(link.season)

#####find tables in webpage
	season.schedule<-html_nodes(season.schedule,"table")
#####find --regular season-- games in webpage
	reg.season<-season.schedule[grep("\"games\"",season.schedule)]
	###someday!!
	###playoffs<-season.schedule[grep("\"games_playoffs\"",season.schedule)]

#####'import' as data frame
	reg.season<-as.data.frame(html_table(reg.season))
####erase label rows
	reg.season<-reg.season[!is.na(as.numeric(reg.season[,1])),]
#####extract and format dates
	reg.season[,2]->reg.season.dates
	reg.season.dates<-strptime(reg.season.dates,"%a, %b %d, %Y")
	reg.season.dates<-format(reg.season.dates,format="%Y%m%d")
#####redefine 'opponent' column as 'home team'
	###replace opp in games w/out "@" as full home team name
	which(reg.season[,6]=="")->H
	team.full->reg.season[H,7]
	###replace all full teams with abbreviations
	home.team<-teams$abbr[match(reg.season[,7],teams$full)]

######combine:  dates + teams for box score links
	bx.pages<-paste0(reg.season.dates,"0",home.team,".html")
	
#####get rid of NAs... IF there's NAs
	if(length(grep("NA.html",bx.pages))>0) 
		bx.pages<-bx.pages[-grep("NA.html",bx.pages)]

######get data for all the pages!!
	####initialize
	###make sure script to get data is loaded
		source("bxdat.R")
		output<-vector("list")
	###loop through bx.pages, get data
		for (i in 1:length(bx.pages)) bxdat(bx.pages[i],team)->output[[i]]

######clean up data into data frame
	names(output[[1]])->stats
	length(stats)->N
	output<-matrix(unlist(output),ncol=N,byrow=T)
	output<-data.frame(output)
	names(output)<-stats

#####output!!!
	output

}

