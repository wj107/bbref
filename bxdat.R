########################################################
########################################################
################scrape box score data
################v0.1
################30 January 2018
########################################################
#######get some box score data -- need it for GLM/NN!!
########################################################

#######packages needed
require(rvest)


#######principle path!
p<-"https://www.basketball-reference.com/boxscores/"

######for starters...
games<-c("201410280LAL.html","201410290PHO.html","201410310LAL.html","201411010GSW.html","201411040LAL.html")

###initial output data frame
bxdat<-NULL
#####loop through games
for (i in games){
	#####read webpage with boxscores
		bx.page<-read_html(file.path(p,i))
	#####identify tables in webpage
		table.nodes<-html_nodes(bx.page,"table")
	####find basic stats for Lakers
		bx<-table.nodes[grep("lal_basic",table.nodes)]
	####convert html table to data frame
		bx<-as.data.frame(html_table(bx))
	####clean it up!!
		bx[1,]->names(bx)
		bx<-bx[-1,]
	####append team totals to bxdat
		bxdat[[i]]<-bx[nrow(bx),]
	}

