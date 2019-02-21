################################################################
#------subroutine to extract shot chart data as a data frame
################################################################

sc_extract<-function(
  #---div node for xml with shot chart; internal call -- no warning needed
  div.node
){
  
  #---div nodes for each shot attempt
  raw1<-html_nodes(div.node,"div")
  #---extract data from html attrs
  raw1<-sapply(raw1,html_attrs)
  #---how many data observations?
  ncol(raw1)->N
  
################################################################
#----raw1: contains 3 rows: coor's, shooter info, player code
  raw1[1,]->coor
  raw1[2,]->who
  raw1[3,]->code
  
  
  ####MAN!  Tighten this up.
  #---split coor's into top and left (y and x)
  top<-sapply(1:N,function(x) as.numeric(unlist(strsplit(coor[x],"[^0-9]+"))[2]))
  left<-sapply(1:N,function(x) as.numeric(unlist(strsplit(coor[x],"[^0-9]+"))[3]))
  
  #---split who into qtr,time, who
  time<-sapply(1:N,function(x) unlist(strsplit(who[x],"<br>"))[1])
  who<-sapply(1:N,function(x) unlist(strsplit(who[x],"<br>"))[2])
  qtr<-sapply(1:N,function(x) unlist(strsplit(time[x],", "))[1])
  time<-sapply(1:N,function(x) unlist(strsplit(time[x],", "))[2])
  time<-sapply(1:N,function(x) unlist(strsplit(time[x]," remaining"))[1])
  
  dist<-sapply(1:N,function(x) unlist(strsplit(who[x]," from "))[2])
  dist<-sapply(1:N,function(x) as.numeric(unlist(strsplit(dist[x]," "))[1]))
  
  who<-sapply(1:N,function(x) unlist(strsplit(who[x]," from "))[1])
  
  #---assemble it all into a data frame
  output<-data.frame(top, left,qtr,time,who,dist,stringsAsFactors = F)
  
  output}