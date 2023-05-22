
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

------------------------------------------------------------------------

# UWAGA - Pakiet nie jest doskonały.

------------------------------------------------------------------------

Dobrze działa dla okresu lat 2015-2020. Natomiast w przypadku pobierania
pełnej wersji wymaga pewnych modyfikacji pobranych plików. Po pobraniu
całej bazy danych (2000:2020) należy, wykonać kilka korekt:

-   2012 PM10 1g - nalezy dodać dodatkowy wiersz wskaźniki
-   2012 O3 1g - nalezy dodać dodatkowy wiersz wskaźniki
-   2012 NOx 1g - zlikwiduj pierwszy wiersz danych
-   2012 NOx 1g - zmień nazwę substancji z “jest” na “NOx” (wiersz wskaźniki)
-   2013 Nox 1g - brakuje wiersza wskaźniki
-   2014 NOx 1g - zmień w wierszy wskaźniki “Nox” na “NOx”

-   2009 PM10 24g - usunać powtarzającą się kolumne danych "DsOlesnicaPM"
-   2020_BaP(PM10)_24g usuń niepoprawny wiersz "rok 2021"" 6 wiersz danych
-   2005_C6H6_24g - dodać wiersz "wskaźnik C6H6" do pliku 
-   2012_PM2.5_24g - dodać wiersz "wskaźnik PM2.5" do pliku 
-   2012_C6H6_24g - poprawić wiersze naglowka
-   2015_DBahA_24g - zmienić nazwe w pliku z DBah(PM10) na DBahA(PM10)  

Znacznie prostszym i łatwiejszym jest wykonanie tych korekt. Niestety
plikowa baza danych gioś air nie jest jednorodna, co dostarcza wielu
problemów. Prawdopodobnie w przyszłości te problemy zostaną rozwiązane i
dopisane odpowiednie funkcjonalności pakietu.
