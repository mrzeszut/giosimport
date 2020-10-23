#' Pobieranie plikowej bazy danych jakosci powietrza
#'
#' Funkcja pobiera pliki archiwum z poratalu
#' \url{http://powietrze.gios.gov.pl/pjp/archives}. Rozpakowywuje do wskazanej
#' lokalizacji. Zwraca listę plików, które są dostępne w plikowej bazie danych.
#' Lista plików może posłużyć jak obiekt wejściowy dla funkcji wczytywania
#' danych \code{gios_read}
#' @param url charactet, adres pliku archiwum, dostępny jest w obiekcie
#'   `zrodlo`.
#' @param rok character, zawiera informacje o roku z którego chcemy pozyskać
#'   dane np. \code{rok = "2000"}.
#' @param path character, scieżka dostępu do przestrzeni w której chcemy
#'   utowrzyć plikową baze danych, path = "" oznacza, że dane zostaną zapisane w
#'   folderze roboczym.
#' @param ... patrz argumenty funkcji \code{\link[utils]{download.file}}, w
#'   systemie windows ustawić \code{mode = "wb"}
#' @return `list` z nazwami plików, które zostały pobrane do lokalizacji `path`.
#' @examples
#' # Pobranie danych za rok 2000 do folderu projektu.
#' gios_downland(url = zrodlo[1,1],
#'               rok = "2000",
#'               path = "",
#'               mode = "wb")
#' @export

gios_download <- function(url, rok = "2000", path = "", ...) {

    a <- getwd()

    if (!is.character(url) | !is.character(rok)) {
        stopifnot("Wartości argumentów: `url` i `rok` muszą być typu character") }

    if (length(url) != 1 | length(rok) != 1) {
        stopifnot("Argumenty: `url` i `rok` przyjmują tylko pojedyńcze wartości") }

    # nazwa pobranego archiwum i nazwa katalogu danego archiwum
    zip      <- ifelse(path == "", paste0(path, rok, ".zip"), paste0(path, "/", rok, ".zip"))
    katalog  <- ifelse(path == "", paste0(path, rok),         paste0(path, "/", rok))
    katalog2 <- ifelse(path == "", paste0(path, "inne"),      paste0(path, "/", "inne"))

    # Pobieranie pliku zip
    download.file(url, zip, quiet = T, ...)

    # Rozpakowanie pobranych danych do foldru o nazwie rok np. 2018 usuniecie pliku archiwum
    unzip(zipfile = zip, exdir = katalog)
    file.remove(zip)

    # Korekty nazw plikó
    # Zmiana nazw plików PM25 na PM2.5 ---------------------------------------#

    pliki <- dir(katalog)
    name_old <- pliki[stringr::str_detect(pliki, "PM25|PM2_5")]

    if (length(name_old) >= 1) {

        name_new <- stringr::str_replace(name_old,
                                         pattern = "PM25|PM2_5",
                                         replacement = "PM2.5")

        file.rename(from = paste0(katalog, "/", name_old),
                    to   = paste0(katalog, "/", name_new))

        pliki <- dir(katalog)
    }

    # inne depozycja i jony do folderu inne ----------------------------------#
    regular <- "Jony|_Ca|_K|_Mg|_Na|_NH4|_NO3|_SO42|Cl_|EC|OC|epozycj|Prekursory"

    jony <- pliki[str_detect(pliki, regular)]

    if (length(jony) >= 1) {

        dir.create(katalog2, showWarnings = F)

        file.copy(from = paste0(katalog,  "/", jony),
                  to   = paste0(katalog2, "/", jony))

        file.remove(paste0(katalog, "/", jony))

        pliki <- dir(katalog)
    }

    setwd(a)

    return(pliki)
}
