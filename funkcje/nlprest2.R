
# definicja funkcji

nlprest2 <- function(t,u) {
  library(httr)
  library(xml2)
  d <- data.frame(stringsAsFactors = FALSE)
  p <- list(lpmn="any2txt|wcrft2",text=t,user=u)
  s <- POST("http://ws.clarin-pl.eu/nlprest2/base/process", body = p, encode = "json", verbose())
  r <- content(s, "text")
  orth <- unlist(as_list(xml_find_all(read_xml(r),"//tok/orth")))
  base <- unlist(as_list(xml_find_all(read_xml(r),"//tok/lex/base")))
  ctag <- unlist(as_list(xml_find_all(read_xml(r),"//tok/lex/ctag"))) 
  d <- rbind(d, as.data.frame(list(base = base, ctag = ctag), stringsAsFactors = FALSE))
  t <- paste(d$base, collapse = " ")
  return(list(source = unlist(strsplit(t, " ")), table = d, string = gsub('[[:punct:] ]+',' ',t)))
}

# uruchomienie z przykładowym tekstem:

t <- nlprest2("Ponad 20 lat temu pracowałem w antykwariacie w Vancouver i musiałem cały czas siedzieć za biurkiem. Właściciele antykwariatów są zawsze bardzo specyficzni. Tamten bał się, że gdybym na chwilę wstał, to zaraz ktoś by ukradł wszystkie pieniądze. Więc siedziałem i czytałem. Zupełnym przypadkiem na moje biurko trafił „Zniewolony umysł”, w którym Miłosz opisuje całe mnóstwo polskich pisarzy. Miałem poczucie, że otworzył się przede mną prywatny kosmos autorów, o których nikt w Kanadzie nie słyszał.","fds9sdfl@0fds8.pl")

# rezultat: podzielony na wyrazy tekst źródłowy

t$source[1:10]
# [1] "ponad"       "20"          "lato"        "temu"        "pracować"    "być"         "w"           "antykwariat"
# [9] "w"           "Vancouver" 

# rezultat: data frame z formami podstawowymi i cechami gramatycznymi

t$table[1:5,]
#      base               ctag
#1    ponad                qub
#2       20  num:pl:nom:m1:rec
#3     lato     subst:pl:gen:n
#4     temu           prep:acc
#5 pracować praet:sg:m1:imperf

# rezultat: tekst źródłowy złożony z form podstawowych bez interpunkcji

t$string
#[1] "ponad 20 lato temu pracować być w antykwariat w Vancouver i musieć być cały czas siedzieć za biurko właściciel antykwariat być zawsze bardzo specyficzny tamten bać #się że gdyby być na chwila wstać to zaraz ktoś by ukraść wszystek pieniądz więc siedzieć być i czytać być zupełny przypadek na moja biurko trafić zniewolić umysł w który #Miłosz opisywać cały mnóstwo polski pisarz miał poczucie że otworzyć się przed ja prywatny kosmos autor o który nikt w Kanada kanada nie słyszeć "
