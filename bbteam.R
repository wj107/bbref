##########################################################################################
#######Scrape basketball-reference.com for team gamelogs for a given season(s) 
##########################################################################################

#-----------------------------
#---requirements
#-----------------------------

	###Package for scraping tables
		require(rvest)

#-----------------------------
#---function call
#-----------------------------

	bbteam<-function(
		#####team to get data from
			team="LAL",
		#####season(s) to get data from
			season=2010,
		###include opponents stats, too?
			opp=F,
		###include ID on data with team/season
			id=T
		)
	{

#-----------------------------
#---check arguments
#-----------------------------

	##[[[ENSEGUIDO!!]]  check arguments!!
	###is team valid?
	###is season valid?

	###is opp, id logical
		if(!is.logical(opp)) stop("Argument 'opp' must be logical")
		if(!is.logical(id)) stop("Argument 'id' must be logical")

#-----------------------------------------------------
#-----obtain & clean schedule for the given season
#-----------------------------------------------------

	#-------initialize-------
	####path for box scores
		link.root<-"https://www.basketball-reference.com/teams"
	####initialize output
		output<-NULL

#-----------loop across seasons--------------------------
for (i in season){
	
	#-----download gamelog data------

	#####specific path for current season
		gamelog<-file.path(link.root,team,i,"gamelog")
	#####read page w.gamelog
		gamelog<-read_html(gamelog)
	#####find tables in webpage
		gamelog.table<-html_nodes(gamelog,"table")
	#####'import' as data frame
		gamelog<-as.data.frame(html_table(gamelog.table), row.names=NULL)
	
	#------clean gamelog data------
	
	####fix names, delete redundancy, NA's
		names(gamelog)<-gamelog[1,]
		gamelog<-gamelog[-1,]
		gamelog<-gamelog[,-c(1,25)]
	####remove label rows
		gamelog<-gamelog[!is.na(as.numeric(gamelog[,1])),]
	####coerce stats to numeric
		gamelog<-cbind(gamelog[,1:5],data.frame(lapply(gamelog[,6:39],as.numeric)))
	####fix names
		names(gamelog)<-gsub("\\.","p",names(gamelog))
		names(gamelog)<-gsub("X3","t",names(gamelog))
	
	#-----format gamelog--------

	####create home/away column
		gamelog[,3][gamelog[,3]=="@"]<-"A"
		gamelog[,3][gamelog[,3]==""]<-"H"
	####fix some names
		names(gamelog)[c(3,5:7)]<-c("HA","WL","PTS","oPTS")
	####format factors
		###future: order factors!!
		for (i in c(3,5)) gamelog[,i]<-as.factor(gamelog[,i])

	#------if opp, designate opponent's data-----
	if(opp) names(gamelog)[24:39]<-paste0("o",gsub("p1","",names(gamelog)[24:39]))
		###else cut out opponent's data
			else gamelog<-gamelog[,1:23]
				
	#----rbind season data to output, finish 'season' loop
	output<-rbind(output,gamelog)
	}

#----output and we're done!
output
}

