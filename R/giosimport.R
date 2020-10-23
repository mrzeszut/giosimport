#' giosimport: Pakiet pobierania i wczytywania danych o jakosci powietrza
#'
#'
#' Pakiet składa się z 5 funkcji, do pobierania metadanych i danych, wczytywania
#' danych do R oraz wstepnej wizualizacji pozwalajacej zapoznać się z danymi.
#' Pobierane są dane udostepniane za posrednictwem
#' \url{http://powietrze.gios.gov.pl/pjp/archives}
#'
#' @section UWAGA: Funkcje zawarte w pakiecie tworzą plikową bazę danych na
#'   dysku lokalnym. Cała baza danych możej zajmować prawie 700 MB. Istnieje
#'   możliwość pobierania tylko wybranych części plikowej bazy danych. W tym
#'   przypadku dane są pobierane dla każdego roku oddzielnie. Dostępne dane nie
#'   są aktualizowane, więc wystarczy pobrać dane tylko raz. Warto umieścić je w
#'   odpowiedniej lokalizacji.
#'
#' @docType package
#' @name giosimport
#' @import magrittr
#' @importFrom tidyr spread gather
#' @importFrom openxlsx read.xlsx getSheetNames
#' @importFrom dplyr mutate as.tbl rename select left_join if_else mutate_if
#' @importFrom purrr map map_df
#' @importFrom janitor excel_numeric_to_date
#' @importFrom stringr str_detect str_sub str_replace
#' @importFrom lubridate round_date
#' @importFrom leaflet leaflet addTiles addCircleMarkers colorFactor addLegend
NULL
