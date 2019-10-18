# użycie: raport <- save2wm(c('http://wp.pl/','http://prezydent.pl/'))
# funkcja przyjmuje też listy lub kolumny z ramki danych
 
save2wm <- function(urls) {
   
  s <- NULL
  w <- 'https://web.archive.org/save/'
  l <- length(urls)
  i <- 1
   
  for(u in urls){
     
    cat(paste0('Przetwarzam adres ',i,'/',l,' (',round(i/l * 100),'%)\n'))
    cat(paste0(u,'\n'))
     
    tryCatch(
      expr = {
        r <- httr::GET(paste0(w,u))    
          if(r$status_code == 200) {
            # status odpowiedzi 200 oznacza, że strona została poprawnie zapisana w Wayback Machine
            # wpisywanie do ramki danych odpowiedzi serwera z adresem archiwalnej kopii strony
            s <- rbind(as.data.frame(list(original_url = u, saved_url = paste0('https://web.archive.org',r$headers$`content-location`)),stringsAsFactors = FALSE),s)
          } else {
           # wpisywanie do ramki danych statusu odpowiedzi serwera 
           s <- rbind(as.data.frame(list(original_url = u, saved_url = as.character(r$status_code)),stringsAsFactors = FALSE),s)
          }
         
        cat(paste0('Status odpowiedzi: ', r$status_code,'\n'))
         
      },
      error = function(e){
        message('Wystąpił błąd!')
        print(e)
        cat('-----------------------------------------\n')    
         
      },
      warning = function(w){
        message('Ostrzeżenie!')
        print(w)
        cat('-----------------------------------------\n')    
         
      },
      finally = {
        message('Odpowiedź serwera zapisana')
      }
    )    
    # zawieszenie działania skryptu, dzięki czemu można zmieścić się w limicie zapytań
 
    cat('Czekam 12 sekund ')
 
    for(e in 0:11) {
      cat('#')
      Sys.sleep(1)
    }
 
    cat('\n-----------------------------------------\n')    
       
    i <- i + 1
     
     
  }
   
  return(s)
}
