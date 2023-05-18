###-------------------------------------------------------------------------###
# [1] Tworzymy listę linków pobierania danych. --------------------------------
###-------------------------------------------------------------------------###
# Może wymagać aktualizacji.
library(devtools)
library(tidyverse)
use_git()

dir.create("data")

load("R/sysdata.rda")

zrodlo <- data.frame(link = c(paste0("http://powietrze.gios.gov.pl/pjp/archives/downloadFile/",
                                     c(223, 224, 225, 226, 202, 203, 227, 228, 229, 230,
                                       231, 232, 233, 234, 302, 236, 242, 262, 303))),
                     rok = as.character(2000:2018)) %>%
  mutate_all(as.character)


zrodlo <- rbind(zrodlo,
                data.frame(link = "http://powietrze.gios.gov.pl/pjp/archives/downloadFile/322",
                           rok = as.character(2019)))

zrodlo <- rbind(zrodlo,
                data.frame(link = "https://powietrze.gios.gov.pl/pjp/archives/downloadFile/424",
                           rok = as.character(2020)))

zrodlo <- rbind(zrodlo,
                data.frame(link = "https://powietrze.gios.gov.pl/pjp/archives/downloadFile/486",
                           rok = as.character(2021)))


save(zrodlo, file = "data/zrodlo.rda")
###-------------------------------------------------------------------------###
# [2] Przydatne polecenia i skróty klawiaturowe -------------------------------
###-------------------------------------------------------------------------###
# [2.1] Programy
###-------------------------------------------------------------------------###

# Sprawdźć czy masz te programy !

# Rtools
# browseURL("https://cran.r-project.org/bin/windows/Rtools/")
# Pandoc
# browseURL("https://pandoc.org/installing.html")
# MiKText
# browseURL("https://miktex.org/download")

###-------------------------------------------------------------------------###
# [2.2] Pakiety ---------------------------------------------------------------
###-------------------------------------------------------------------------###

# install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
# install.packages("devtools") devtools::install_github("r-lib/fs")
# devtools::install_github("r-lib/devtools")
# devtools::install_github("r-lib/usethis")

library(devtools)
library(usethis)
library(fs)
library(testthat)
library(roxygen2)
library(giosimport)

###-------------------------------------------------------------------------###
###---- TOOLS -> Project options -> build and tools -> ustawienie roxygen --###
###-------------------------------------------------------------------------###


###-------------------------------------------------------------------------###
# [2.3] Roxygen tworzenie dokumentacji pakietu --------------------------------
###-------------------------------------------------------------------------###

# CTRL+SHIFT+D, use_document
devtools::document()
devtools::install()

# dokumentowanie danych

# tworzenie pomocniczego zestawu danych, nie wykorzystywanego w projekcie
# utworzono je w trakcie testowania funkcji, by nie pobierać za każdym razem
# danych do stworzenia samouczka

usethis::use_data(
  meta,
  pliki_2010,
  pliki_all,
  stanowiska,
  statystyki,
  internal = T)

usethis::use_readme_rmd()


devtools::install()
# [2.4] Tworzenie winiet ------------------------------------------------------

# nowy komponent

# Tworzy szblon winiety w nowym pakiecie
usethis::use_vignette("giosimport")

# # przykłady
# browseVignettes("giosimport")
# vignette("dplyr")
# edit(vignette("dplyr"))
#
#
# # po utworzeniu winiety
# vignette("giosimport")
# edit(vignette("giosimport"))

# Testy


# [2] Testy funkcji -----------------------------------------------------------------------------------

#library(tidyverse)
library(dplyr)
library(janitor)
library(leaflet)
library(magrittr)
library(openxlsx)
library(purrr)
library(stringr)
library(tidyr)
library(roxygen2)

# [2.1] ------------------------------------------------------------------------------------

kat_dost <- "D:/Qnap/bazy_danych/gios_airbase/"
library(giosimport)
# [2.1] ------------------------------------------------------------------------------------

meta  <- gios_metadane(type = "stacje",  download = T, path = kat_dost, mode = "wb")

stand <- gios_metadane(type = "stanowiska", download = T, path = kat_dost, mode = "wb")

stats <- gios_metadane(type = "statystyki", download = T, path = kat_dost, mode = "wb")

# konwertujemy nazwy kolumn
#colnames(df) <- iconv(colnames(df), from="UTF-8", to="ASCII//TRANSLIT")

# [2.1] ------------------------------------------------------------------------------------
meta  <- gios_metadane(type = "meta",  download = F, path = kat_dost, mode = "wb")


pliki <- gios_download(url = zrodlo[21,1], rok = zrodlo[21,2], path = kat_dost, mode = "wb")

NO2_24h <- gios_read(nazwa = "2021_NO2_24g.xlsx", czas_mu = "24g", path = kat_dost)
NO2_1h  <- gios_read(nazwa = "2021_NO2_1g.xlsx",  czas_mu = "1g",  path = kat_dost)

NO2_24h
NO2_1h

gios_vis(data = meta %>% filter(is.na(data.zamkniecia)))

# [2.1] ------------------------------------------------------------------------------------

help(package = dplyr)

# [2.1] ------------------------------------------------------------------------------------

unique(NO2$kod)
NO2 <- gios_kody(data = NO2, meta = meta)
unique(NO2$kod)

gios_kody()



# 3 EXAMPLE --------------------------------------------------------------------------------
#[3.1 gios_metadane] -----------------------------------------------------------------------
meatadane <- gios_metadane(type = "meta",
                           download = T,
                           path = "",
                           metod = "wb")

#[3.2 gios_vis] ----------------------------------------------------------------------------
# Pobranie pliku metadanych stacji jakości powietrza do katalogu projektu.
meta <- gios_metadane(type = "meta",
                      download = T,
                      path = "",
                      metod = "wb")
# wyświetlenie metadanych
gios_vis(data = meta %>% filter(status == "aktywny"))

#[3.3 gios_downlaod] -----------------------------------------------------------------------
gios_downland(url = zrodlo[1,1],
              rok = "2000",
              path = "")

#[3.4 gios_read] ---------------------------------------------------------------------------

#[3.5 gios_kody] ---------------------------------------------------------------------------

# pobranie danych na dysk
pliki <- gios_downland(url = zrodlo[1,1],
                       rok = zrodlo[1,2],
                       path = "",
                       mode = "wb")
# wczytanie danych
pm10 <- gios_read(nazwa = pliki[5],
                  czas_mu = "1h",
                  path =  "")
# pozyskanie metadanych
metadane  <- gios_metadane(type = "meta",
                           download = T,
                           path = "",
                           mode = "wb")
# kerekta zmienej kod
pm10_new <- gios_kody(data = pm10, meta = metadane)

# porownanie starych i nowych kodow stacji
data.frame(new  = flatten_chr(unique(pm10_new[1])),
           old  = flatten_chr(unique(pm10[1])),
           test = (unique(pm10[1]) == unique(pm10_new[1])))

#[3.X gios_kody] ---------------------------------------------------------------------------
setwd("C:/Qsync/R/R_package/giosimport/")
devtools::document()
devtools::load_all()
devtools::install()
library(giosimport)
devtools::check()

browseVignettes()
help(package = giosimport)
vignette("giosimport")
edit(vignette("dplyr"))


use_readme_rmd()


pliki_all <- map2(.x = as.list(zrodlo[,1]),
                  .y = as.list(zrodlo[,2]),
                  .f = gios_download,
                  path = kat_dost,
                  mode = "wb")

PM10 %>%
  filter(kod %in% (unique(PM10$kod) %>% .[str_detect(., "MpKrak")])) -> PM10



save(meta,
     statystyki,
     stanowiska,
     identyfikacja,
     pliki_all,
     pliki_2020, file = "R/sysdata.rda")

library(devtools)
document()
check()
install()
