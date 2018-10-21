# bulk download scans from szukajwarchiwach.pl
# id = signature
# download = FALSE (default) will download no files
# returns list of scan image URLS
# some troubles with ssl certificate

swa_get_scans <- function (id,download=FALSE) {
  
  library(httr)
  library(xml2)
  library(progress)
  
  # building base URL with id
  url <- paste0("https://szukajwarchiwach.pl/",id,"/#tabSkany")
  
  # how to avoid certificate errors with SSL
  httr::set_config(config(ssl_verifypeer = 0L))
  
  # parsing base URL
  u <- GET(url)
  u <- content(u, "text")
  u <- read_html(u, encoding = "UTF-8")
  u <- xml_find_all(u, "//div[@class='pagerBox']")
  u <- xml_find_all(u, '//a[position()>1]/text()')
  u <- as_list(u)
  u <- unlist(tail(u, n=1))
  
  # parsing u pages
  
  images <- character()
  
  for(i in 1:u){
    i <- paste0("https://szukajwarchiwach.pl/",id,"/str/1/",i,"/15#tabSkany")
    p <- GET(i)
    p <- content(p, "text")
    p <- read_html(p, encoding = "UTF-8")
    p <- xml_find_all(p, "//div[@class='searchListBg']")
    p <- xml_find_all(p, '//a[@class="fancy_scan_link"]/@href')
    p <- as_list(p)
    p <- unlist(p)
    images <- append(images, p, after=length(images))
  }
  
  # preparing propper urls for scan images
  
  images <- lapply(images, gsub, pattern="^/", replacement = "https://szukajwarchiwach.pl/")
  images <- lapply(images, gsub, pattern="medium", replacement = "img",fixed=TRUE)
  
  # if download
  
  if(download==TRUE){
    
    
    dir.create(gsub("/","-",id,fixed = TRUE))
    a <- 1
    pb <- progress_bar$new(total = length(images))
    
    for(i in images){
      # if you prefer using httr GET rather than download.file to overcome SSL errors (rather slow method)
      # GET(url=i, write_disk(paste0(gsub("/","-",id,fixed = TRUE),"/",a,".jpg")))
      # or if you want to use download.file with wget --no-check-certificate (faster)
      download.file(url=i, paste0(gsub("/","-",id,fixed = TRUE),"/",a,".jpg"), method="wget", quiet= TRUE, extra = "--no-check-certificate")
      a <- a + 1
      # progress bar
      pb$tick()
      Sys.sleep(sample(3:6,1))
    }
    
  }
  
  # at least return images urls
  return(unlist(images))
  
}
