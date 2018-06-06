
spelcra <- read.delim("~/Pobrane/spelcra.txt", encoding="UTF-8", header=FALSE, comment.char="#", stringsAsFactors=FALSE)

getLemma <- function(t,u) {
  library(httr)
  library(xml2)
  p <- list(lpmn="any2txt|wcrft2",text=t,user=u)
  s <- POST("http://ws.clarin-pl.eu/nlprest2/base/process", body = p, encode = "json", verbose())
  r <- content(s, "text")
  r <- gsub('[[:punct:] ]+','',unlist(as_list(xml_find_all(read_xml(r),"//base"))))
  return(r[r != ""])
}

spelcra2 <- spelcra$V1

a <- 1
b <- list()
for(s in spelcra2){
  b[[a]] <- getLemma(s, "832@dsds.pl")
  a <- a + 1
}

tabelka <- data.frame(cbind(zrodlo=spelcra$V1[1:5],lemma=b))

# dostep do wartosci

tabelka$lemma[[1]]

tabelka$lemma[[1]][1:5]
