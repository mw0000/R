

# bulk host checking using nslookup {curl} 
# using list hosty[1:1356]
# dostepna, wczesniej wygenerowana lista hosty
# hosty[1:1356]
# funkcja nslookup z pakietu curl

# tworzenie pustej listy

wynik <- c()

# zaczyna sie petla

for(i in 1:1356) {

# sprawdzanie IP (jesli istnieje, jakas strona jest dostepna)
# error = FALSE - dzieki temu informacje o bledzie nie rozwala petli
# error = FALSE is mandatory here

s <-    nslookup(hosty[i], error = FALSE)

# instrukcja warunkowa:
# jesli s == NULL - nie ma ip/hostu
# w takim przypadku musimy ustawic blad - lista nie moze przyjac pustej wartosci
# s can't be null

if (length(s) == 0) {

	s <- 'error'

}

# dopisujemy ip do listy

wynik[i] <- s

}

# potem generowanie tabeli i export do csv

tabela <- data.frame(hosty[1:1356],wynik)

sciezka <- file.choose()

write.csv2(tabela,sciezka)

# just for test, just for learning





