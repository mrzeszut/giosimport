#' Funkcja pobierania i wczytywania metadanych
#'
#' Funkcja pobiera trzy rodzaje metadanych i wczytuje je jako obiekt
#' \code{\link[tibble]{tibble}}. Wczytuje metadane stacji jakości,
#' Szczegółowe informacje o stanowiskach pomiarowych oraz podstawowe statystyki
#' opisowe danych pomiarowych, oddzielnie dla każdego zanieczyszczenia powietrza,
#' substancji i roku kalendarzowego. Ostatni obiekt jest listą złożoną z
#' obiektów \code{\link[tibble]{tibble}}, które mają różną ilość kolumn,
#' ponieważ dla każdej substancji liczone są inne staystyki opisowe.
#'
#' @param type charcter, definiuje jakie metadane zostaną wczytane. dostępne są
#'   trzy argumenty \code{type = "stacje"} - metadane stacji, \code{type =
#'   "stanowiska"} - charakterystyka stanowisk pomiarowych, \code{type = "statystyki"} -
#'   statystyki opisowe wyznaczone dla każdej substanji.
#' @param download logical, jeśli \code{TRUE} pobierz dane. Jeśli uruchamiasz
#'   funkcje po raz drugi, wybierz \code{FALSE} oraz wskaż ścieżkę dostępu do
#'   pliku.
#' @inheritParams gios_download
#' @return \code{\link[tibble]{tibble}}
#' @examples
#' # Pobranie pliku metadanych stacji jakości powietrza do katalogu projektu.
#' meatadane <- gios_metadane(type = "stacje",
#'                            download = T,
#'                            path = "",
#'                            mode = "wb")
#' @export

gios_metadane <- function(type = "stacje",
                          download = TRUE,
                          path = "",
                          mode = "wb") {
  a <- getwd()

  if (type == "stacje") {


    ifelse(path == "",
           name <- "stacje.xlsx",
           name <- paste0(path,"/","stacje.xlsx"))

    if (download == TRUE) {

      download.file(url = "https://powietrze.gios.gov.pl/pjp/archives/downloadFile/522", # weryfikować
                    destfile = name, mode = mode)
    }

    sheet = 1 ; wek1 = c(1,14:15) ; wek2 = c("lat", "lon")

    meta <- read.xlsx(xlsxFile = name,
                      sheet = sheet,
                      colNames = T) # weryfikować

    colnames(meta) <- c("nr", tolower(colnames(meta))[-c(wek1)], wek2)

    colnames(meta) <- iconv(colnames(meta),
                            from="UTF-8",
                            to="ASCII//TRANSLIT") # zmienia polskie znaki

    meta <- meta %>%
      mutate(lat = as.numeric(lat),
             lon = as.numeric(lon))

    meta <- meta %>%
      dplyr::mutate(data.uruchomienia = excel_numeric_to_date(date_num = data.uruchomienia,
                                                              tz = "UTC"),
                    data.zamkniecia   = excel_numeric_to_date(date_num = data.zamkniecia,
                                                              tz = "UTC")) %>%
      as_tibble()
  }

  if (type == "stanowiska") {

    ifelse(path == "",
           name <- "stacje.xlsx",
           name <- paste0(path,"/","stacje.xlsx"))

    if (download == TRUE) {

      download.file(url = "https://powietrze.gios.gov.pl/pjp/archives/downloadFile/522", # weryfikować
                    destfile = name, mode = mode)
    }

    sheet = 2 ; wek1 = 1; wek2 = NULL

    meta <- read.xlsx(xlsxFile = name,
                      sheet = sheet,
                      colNames = T) # weryfikować

    colnames(meta) <- c("nr", tolower(colnames(meta))[-c(wek1)], wek2)

    colnames(meta) <- iconv(colnames(meta),
                            from="UTF-8",
                            to="ASCII//TRANSLIT") # zmienia polskie znaki

    meta <- meta %>%
      dplyr::mutate(data.uruchomienia = excel_numeric_to_date(date_num = data.uruchomienia,
                                                              tz = "UTC"),
                    data.zamkniecia   = excel_numeric_to_date(date_num = data.zamkniecia,
                                                              tz = "UTC")) %>%
      as_tibble()

  }


  if (type == "statystyki") {

    ifelse(path == "",
           name <- "statystyki.xlsx",
           name <- paste0(path,"/","statystyki.xlsx"))

    if (download == TRUE) {

      download.file(url = "https://powietrze.gios.gov.pl/pjp/archives/downloadFile/523", # weryfikować
                    destfile = name, mode = mode)
    }

    nazwy_ark <- openxlsx::getSheetNames(name)

    meta <- purrr::map(.x = nazwy_ark[-1],
                       .f = openxlsx::read.xlsx,
                       xlsxFile =  name,
                       startRow = 2,
                       colNames = T) # weryfikować

    nazwy <- purrr::map(.x = nazwy_ark[-1],
                        .f = openxlsx::read.xlsx,
                        xlsxFile =  name,
                        rows = 1,
                        colNames = T) # weryfikować

    for (i in 1:length(meta)) {
      colnames(meta[[i]]) <- colnames(nazwy[[i]])
    }

    names(meta) <- nazwy_ark[-1]

  }
  setwd(a)
  return(meta)
}
