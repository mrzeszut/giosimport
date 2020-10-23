
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giosimport

Celem pakietu `giosimport` jest pobieranie i wczytywanie danych z
**Portal Jakości Powietrza GIOŚ**. Funkcje zawarte w pakiecie tworzą
plikową bazę danych na dysku lokalnym. Cała baza danych może zajmować
prawie 700 MB. Istnieje możliwość pobierania tylko wybranych części
plikowej bazy danych. W tym przypadku dane są pobierane dla każdego roku
oddzielnie. Dostępne dane historyczne nie są aktualizowane, więc
wystarczy je pobrać tylko raz. Warto umieścić je w odpowiedniej
lokalizacji, by nie powielać pobierania danych. W celu korzystania z
pkaietu `giosimport` zapozanj się z
[RPubs](https://rpubs.com/rzeszut/giosimport)

[Portal Jakości Powietrza GIOŚ](http://powietrze.gios.gov.pl/pjp/home)
udostępnia [Bank Danych
Pomiarowych](http://powietrze.gios.gov.pl/pjp/home) który zawiera wyniki
pomiarów stężeń zanieczyszczeń powietrza w Polsce, poczynając od 2010 r.

# Instalacja (szybka)

``` r
# Potrzebujesz devtools ?
if (!require(devtools)) {install.packages("devtools"); require(devtools)}

# Instalujesz i wczytujesz
install_github("mrzeszut/giosimport")
library(giosimport)
```

Teraz możesz zapoznaź się z samouczkiem w celu skorzystania z pakietu
`giosimport`

``` r
browseURL("https://rpubs.com/rzeszut/giosimport")
```

lub skorzystać z systemu pomocy

``` r
?"giosimport"
```

# Instalacja wraz z winietą (wolna)

``` r
# Potrzebujesz devtools ?
if (!require(devtools)) {install.packages("devtools"); require(devtools)}

# Instalujesz i wczytujesz
install_github("mrzeszut/giosimport", force = T, build_vignettes = T)
library(giosimport)
```

Ciesz się winietą w systemie pomocy.

``` r
# Podgląd winiety w przeglądarce
browseVignettes("giosimport")

# przejrzyj w oknie pomocy
vignette("giosimport")

# wyswietli tylko kod
edit(vignette("giosimport"))
```
