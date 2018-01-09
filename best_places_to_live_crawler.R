# scrape(url=NULL, # a vector of URLs, each as a character string. Either the url, object, or the file parameter must be provided.
#        object=NULL,
#        file=NULL,
#        chunkSize=50,
#        maxSleep=5,
#        userAgent=unlist(options("HTTPUserAgent")),
#        follow=FALSE,
#        headers=TRUE,
#        parse=TRUE,
#        isXML=FALSE,
#        .encoding=integer(),
#        verbose=FALSE)

library(rvest)
url<- "https://realestate.usnews.com/places/rankings/best-places-to-live"
page<-read_html(url)

overall_score<-html_nodes(page,css=".text-tightest:nth-child(1) .text-coal") %>% html_text()
overall_score<-as.numeric(gsub(" Overall Score","",overall_score))

life_quality<-html_nodes(page, css=".text-tightest:nth-child(2) .text-coal") %>% html_text()
life_quality<-as.numeric(gsub("[\r\n QualityofLife]", "", life_quality))

value<-html_nodes(page, css=".border-left-for-medium-up+ .text-tightest .text-coal") %>% html_text()
value<-as.numeric(gsub("[\r\n Value]", "", value))

heading<-html_nodes(page, css=".heading-large a") %>% html_text()
city<-sapply(heading,function(x){strsplit(x,split=", ")[[1]][1]})
state<-sapply(heading,function(x){strsplit(x,split=", ")[[1]][2]})


real_estate<-data.frame(city,state,overall_score,life_quality,value, row.names = NULL)
real_estate