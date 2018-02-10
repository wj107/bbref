#######################################################################
#########   SCRAPE BASKETBALL-REFERENCE.COM for player gamelogs
#######################################################################

#######packages needed
require(rvest)

#########create function -- give me a box score link, I'll get team data
bbplayer<-function(
	##################player to get data for
		player="Russell Westbrook",
	##################season to get data for
		season=2017,
	###############add column w.player name??
		id=FALSE,
	##############add column w. season?
		year=FALSE
		)
	{

#######principle path!
	link.root<-"https://www.basketball-reference.com/players/"
###player name in basketball-reference.com
	player.first<-unlist(strsplit(player," "))[1]
	player.last<-trimws(sub(player.first,"",player))
####parts of the name
	player.first.2<-tolower(substr(player.first,1,2))
	player.last.5<-tolower(substr(player.last,1,5))
	first.letter<-tolower(substr(player,1,1))
	
#######check argument
	#if(link==NULL) stop("Argument 'link' requires a valid path")
	#if(team==NULL) stop("Argument 'team' requires a team abbreviation")
###initialize output
	#bxdat<-NULL

#####initialize dat
dat<-NULL

#####loop through seasons
for (i in season){
#####read webpage with game data
	game.page<-file.path(link.root,first.letter,paste0(player.last.5,player.first.2,"01"),"gamelog",i)
	game.page<-read_html(game.page)
#####identify tables in webpage
	table.nodes<-html_nodes(game.page,"table")
####find nodes for desired table
	game.table<-table.nodes[grep("Regular Season Table",table.nodes)]
####convert html table to data frame
	game.table<-as.data.frame(html_table(game.table))
####add year if year=T
	if(year) {YR<-rep(i,nrow(game.table))
		game.table<-cbind(YR,game.table)
		}

	dat<-rbind(dat,game.table)
	}
####clean up labels/DNPs
	###find labels/DNPs
		labs<-sapply(1:nrow(dat), function(x) all(is.na(as.numeric(dat[x,10:ncol(dat)]))) )
	####eliminate labels/DNPs
		dat<-dat[!labs,]

#####clean up data!!
	######change "@" to "H" or "A"
	HA<-6
	if(year) HA<-HA+1
		dat[dat[,HA]=="",HA]<-"H"
		dat[dat[,HA]=="@",HA]<-"A"
	######find W/L, margin
	wl<-8
	if(year) wl<-wl+1	
		substr(dat[,wl],1,1)->WL
		###do the margin, later!!!
		dat[,wl]<-WL

	#########numeric columns, factor columns
		numeric.columns<-c(1,2,11:30)
		factor.columns<-c(5,6,8,9)
		
		###adjust if year=T
			if(year) {numeric.columns<-numeric.columns+1
				 factor.columns<-c(1,factor.columns+1)}

		###later-- order factors??	
	####coerce numeric/factor columns
		for (i in numeric.columns) as.numeric(dat[,i])->dat[,i]
		for (i in factor.columns) as.factor(dat[,i])->dat[,i]

	#########names for data frame
		dat.names<-c("G","GP","Date","Age","Team","HA","Opp","WL","GS","MP","FG","FGA","FGp","tP","tPA","tPp","FT","FTA","FTp",
			"ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PTS","GmSC","PM")
		###if year=T, add "YR"
			if(year) dat.names<-c("YR",dat.names)

		names(dat)<-dat.names
	#####add IF column if id=T
		if(id) {
			WHO<-rep(player.last,nrow(dat))
			dat<-cbind(WHO,dat)
			}

	
dat}
