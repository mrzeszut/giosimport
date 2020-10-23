#' Mapa lokalizacji stacji jakości powietrza
#'
#' Funkcja tworzy interaktywną mapę lokalizacji stacji oraz przedstawia rodzaj
#' stacji ze wzgledu na źródło odziaływania. Wyświetla kod stacji, co pozwala w
#' łatwy sposób identyfikować intersujące nas dane pomiarowe.
#'
#' @param data - \code{\link[tibble]{tibble}}, obiektem wejsciowym jest
#'   obiekt generowany przez funkcję \code{\link{gios_read}}.
#' @return \code{\link[leaflet]{leaflet}}
#' @examples
#' # Pobranie pliku metadanych stacji jakości powietrza do katalogu projektu.
#' meta <- gios_metadane(type = "meta",
#'                       download = T,
#'                       path = "",
#'                       metod = "wb")
#' # wyświetlenie metadanych
#' gios_vis(data = meta %>% filter(status == "aktywny"))
#' @export

gios_vis <- function(data = meta) {

    a <- getwd()

    pal <- colorFactor(palette = c("blue", "red", "darkgreen"),
                       domain = c("tło", "komunikacyjna", "przemysłowa"))

    ## Deklarowanie zawartości popupu
    desc <- paste(paste(
      data$kod.stacji,
      paste("Miejscowość:", data$miejscowosc),
      paste("Data uruchomienia:", data$data.uruchomienia),
      paste("Data zamknięcia:", data$data.zamkniecia),
      paste("Typ stacji:", data$typ.stacji),
      paste("Typ obszaru:", data$typ.obszaru),
      sep = "<br/>"
    ))

    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = data %>% filter(lat != -999 & lon != -999),
                       lng = ~lon,
                       lat = ~lat,
                       popup = desc,
                       fillOpacity = 2,
                       radius = 5,
                       label = ~as.character(kod.stacji),
                       color = ~pal(typ.stacji)) %>%
      addLegend(position = "bottomright",
                colors = c("darkgreen", "red", "blue"),
                labels = c("tło", "przemysłowa", "komunikacyjna"),
                opacity = 1)

    setwd(a)
}
