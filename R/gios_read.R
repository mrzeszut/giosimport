#' Wczytywanie danych pomiarowych
#'
#' Funkcja wczytuje dane pomiarowe z pobranej plikowej bazy danych. W plikowej
#' bazie danych dostępne są dwa różne zestawy danych. tj. dane średnie 1-h i
#' 24-h. Jednorazowo pobierany jest pełny zestaw danych pomiarowych dla całej
#' polski za dany rok kalendarzowy.
#'
#' @param nazwa - a character skalar, nazwa pliku który chcemy wczytać.
#' @param czas_mu a charcter skalar, można stosować tylko \code{czas_mu = "1g"}
#'   dla średnich 1-h lub \code{czas_mu = "24g"}
#' @inheritParams gios_download
#' @return \code{\link[tibble]{tibble}}
#' @examples
#' #' ## Pobranie plikowej bazy danych na dysk z <powietrze.gios.gov.pl>
#' pliki <- gios_download(url = zrodlo[1,1],
#'                        rok = zrodlo[1,2],
#'                        path = "",
#'                        mode = "wb")
#'
#' # Wczytanie danych o stężeniach średniodobowych PM10
#' pm10 <- gios_read(nazwa = pliki[5],
#'                   czas_mu = "24h",
#'                   path =  "")
#' @export
gios_read <- function(nazwa,
                      czas_mu = "24g",
                      path = "") {
  lok <- getwd()

  ifelse(path == "",
         dir <- paste0(substr(nazwa, 1, 4), "/"),
         dir <- paste0(path,"/",substr(nazwa, 1, 4), "/"))

  setwd(dir = dir)

  # Rózne formaty plików xlsx ustawienia parametrów wczytywania

  if (str_sub(nazwa, 1,4) %in% c(2016, 2017, 2018, 2019, 2020)) {
    startRow = 2 ; end_row = 4
  } else if (str_sub(nazwa, 1,4) %in% c(2000:2015)) {
    startRow = 1 ; end_row = 2
  }

  # Wczytywanie danych

  dane <- openxlsx::read.xlsx(nazwa,           # Wczytujemy dane z exele
                              startRow = startRow,
                              colNames = T)
  colnames(dane)[1] <- "date"                  # modyfikacja nazwy pierwszej kolumny
  sub =  dane[1,2]                             # nazwa substancji

  dane <- map_df(.x = dane[-c(1:end_row),],    # usunięcie nagłówka oraz
                 .f = str_replace,             # zamiena separatora z ',' na '.'
                 pattern = ",",                # w kazdej kolumnie
                 replacement = ".")

  # konwersja daty z formatu liczbowego exela

  if (czas_mu == "1g") {

    dane <- dane %>%
      mutate(date = as.numeric(date),
             date = excel_numeric_to_date(date, include_time = T,
                                          date_system = "modern",
                                          tz = "UTC") - 3600,
             date = round_date(date, "hour")) # zaokrąglanie daty (daty w excel)

  } else if (czas_mu == "24g") {

    dane$date <- as.Date(as.numeric(dane$date),
                         origin = "1899-12-30",
                         tz = "UTC")
  }

  # ostatni szlift

  dane <- dane %>%
    mutate_if(is.character,             # Zamiena typ danych na double
              as.double)  %>%
    gather(key = "kod",                 # Wąski układ danych (łączenia df)
           value = "obs", -date) %>%
    mutate(sub = sub,
           obs = round(obs, 6)) %>%     # Nazwa substancji
    .[,c("kod", "sub", "date", "obs")]

  setwd(lok)                            # powrót do katalogu projektu

  return(dane)

}

