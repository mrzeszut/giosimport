#' Korekta starych nazw stacji jakosci powietrza
#'
#' Funkcja identyfikuje stare kody stacji jakosci powietrza w wczytanych danych
#' - \code{\link{gios_read}}. Nastepnie zamienia je na nowe kody stacji.
#' wymaga pozyskania również metadanych - \code{\link{gios_metadane}}.
#' @param data data.frame wczytany za pomoca funkcji \code{\link{gios_read}} z
#'   nieuporzadkowanymi oznaczeniami kodow stacji.
#' @param meta data.frame pozyskany za pomoca funkcji \code{\link{gios_metadane}} zawiera
#'   informacje o starych i aktulanych kodach stacji.
#' @return zwraca obiekt `data` z zmodyfikowaną zmienna `kod``
#' @examples
#' ## Pobranie plikowej bazy danych na dysk z <powietrze.gios.gov.pl>
#' pliki <- gios_download(url = zrodlo[1,1],
#'                        rok = zrodlo[1,2],
#'                        path = "",
#'                        mode = "wb")
#'
#' # Wczytanie danych o stężeniach średniodobowych PM10
#' pm10 <- gios_read(nazwa = pliki[5],
#'                   czas_mu = "24h",
#'                   path =  "")
#'
#' # pozyskanie metadanych
#' metadane  <- gios_metadane(type = "meta",
#'                            download = T,
#'                            path = "",
#'                            mode = "wb")
#'
#' # kerekta zmienej kod
#' pm10_new <- gios_kody(data = pm10, meta = metadane)
#'
#' # porownanie starych i nowych kodow stacji
#' data.frame(new  = flatten_chr(unique(pm10_new[1])),
#'            old  = flatten_chr(unique(pm10[1])),
#'            test = (unique(pm10[1]) == unique(pm10_new[1])))
#' @export

gios_kody <- function(data, meta){

  a <- getwd()

  meta <- meta %>%
    rename(kod = stary.kod.stacji) %>%
    select(kod.stacji, kod)

  data <- left_join(data,
                    meta,
                    by = "kod")  %>%
    mutate(kod.stacji = if_else(is.na(kod.stacji),  kod,  kod.stacji)) %>%
    mutate(kod = kod.stacji) %>%
    select(-kod.stacji)

  setwd(a)

  return(data)
}
