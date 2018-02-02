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
		team=NULL
		)
	{

#######principle path!
	link.root<-"https://www.basketball-reference.com/boxscores/"
#######check argument
	#if(link==NULL) stop("Argument 'link' requires a valid path")
	#if(team==NULL) stop("Argument 'team' requires a team abbreviation")

###initialize output
	bxdat<-NULL
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
####clean it up!!
	bx[1,]->names(bx)
	bx<-bx[-1,]
####define W/L by summing plus.minus
	bx[,ncol(bx)]->pm
##convert to numeric
	pm<-as.numeric(pm)
##remove NA's
	pm<-pm[!is.na(pm)]
##SUM: positive = 1, negative = 0
	bx[nrow(bx),ncol(bx)]<-0
	if(sum(pm)>0) bx[nrow(bx),ncol(bx)]<-1
####output team totals to bxdat
	bx[nrow(bx),]
	}

