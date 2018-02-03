#######################################################
########################################################
################scrape box score data
################v0.12
################1 February 2018
########################################################
#######get some box score data -- need it for GLM/NN!!
########################################################
###now written as a function

#######packages needed
require(rvest)

#########create function -- give me a box score link, I'll get team data
bxdat<-function(
	##################bx score link
		link=NULL,
	##################team to get data from
		team=NULL,
	####should I give the season with the data??
		#####v0.2, you know??
		year=FALSE	
		)
	{

#######principle path!
	link.root<-"https://www.basketball-reference.com/boxscores/"
#######check argument
	#if(link==NULL) stop("Argument 'link' requires a valid path")
	#if(team==NULL) stop("Argument 'team' requires a team abbreviation")
	if(!is.logical(year)) stop("Argument: `year' must be logical")

###initialize output
	#bxdat<-NULL
#####read webpage with boxscores
	bx.page<-read_html(file.path(link.root,link))
#####identify tables in webpage
	table.nodes<-html_nodes(bx.page,"table")
#####identify name of table to get data for
	table.to.get<-paste0(tolower(team),"_basic")
####find nodes for desired table
	bx<-table.nodes[grep(table.to.get,table.nodes)]
####convert html table to data frame
	bx<-as.data.frame(html_table(bx))
####clean up names and non-numeric rows
	bx[1,]->names(bx)
	bx<-bx[-c(1,7),]
####clean up DNPs
	###find DNPs (etc)
		dnp<-sapply(1:nrow(bx), function(x) all(is.na(as.numeric(bx[x,]))) )
	####eliminate dnp's
		bx<-bx[!dnp,]
	####find dim's
		M<-nrow(bx)
		N<-ncol(bx)
####sum +/- for team total
	bx[M,N]<-sum(as.numeric(bx[,N][-M]))

#####output team totals, replace +/- w. "WL"
	###total team data
		team.total<-as.numeric(bx[M,-1])
	##set +/- to 0 or 1, rename
		if(team.total[N-1]>0) team.total[N-1]<-1
			else team.total[N-1]<-0
		names(bx)[N]<-"WL"
		names(bx)[-1]->names(team.total)
		team.total
	}
