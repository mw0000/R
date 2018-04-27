
# simple searching for files (mimetypes) in Wayback Machine within Polish gov sites
# using Wayback CDX Server API  

getDocs <- function(mimetype){
  
  library(jsonlite)
  library(dplyr)
  
  domains <- c("mswia","ms","mkidn","mg","mz","ml","msz","mf")
  #data <- as.data.frame(NULL,col.names = c("urlkey","timestamp","original","mimetype","statuscode","digest","length"))
  
  for(type in mimetype) {
    
    for(d in domains) {
    u <- paste0("http://web.archive.org/cdx/search/cdx?url=",d,".gov.pl&from=1996&to=2001&matchType=domain&filter=mimetype:",type,"&output=json&showPagedIndex=true")  
    j <- as.data.frame(fromJSON(u), stringsAsFactors = FALSE)  
    j <- j %>% mutate(wayback_url = paste0("https://web.archive.org/web/",j$V2,"/",j$V3))
    data <- rbind(data,j[-1,])
    cat(paste("Done with",type,"for",d,"\n"))
    Sys.sleep(4)
    }
  
  }
  
  data <- as.data.frame(data, stringsAsFactors = FALSE)
  names(data) <- c("urlkey","timestamp","original","mimetype","statuscode","digest","length","wayback_url")
  return(data)
  
}
