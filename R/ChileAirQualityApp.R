#' Title ChileAirQualityApp
#' @description This tool is a dashboard that allows you to use the data download
#'  functions of this package enhanced with analysis, visualization and
#'  descriptive statistics tools.
#' @return A shiny dashboard to work with the package
#' @export
#' @seealso <https://chileairquality.shinyapps.io/chileairquality/>
#' @examples \dontrun{ChileAirQualityApp()}
#' @import shiny
#' @import shiny
#' @import shinycssloaders
# @importFrom plotly plot_ly
# @importFrom data.table setDT data.table
# @importFrom DT dataTableOutput datatable renderDataTable
# @importFrom lubridate year
# @importFrom openair timeVariation corPlot timePlot polarPlot calendarPlot scatterPlot smoothTrend
ChileAirQualityApp <- function() {
  if(FALSE){
    DT::datatable(data.frame(a = 1, b = 2))          # Example of DT
    DT::renderDataTable(data.table::data.table())    # Example of DT
    lubridate::year(Sys.Date())                     # Example of lubridate
    openair::timeVariation(data.frame())            # Example of openair
    openair::corPlot(data.frame())                   # Example of openair
    openair::timePlot(data.frame())                 # Example of openair
    openair::polarPlot(data.frame())                # Example of openair
    openair::calendarPlot(data.frame())             # Example of openair
    openair::scatterPlot(data.frame())              # Example of openair
    openair::smoothTrend(data.frame())              # Example of openair
    plotly::plot_ly(x = 1:10, y = 1:10) 
  }

  
  
  Directory <- system.file("shiny", package = "AtmChile")
  if (Directory == "") {
    stop("Try reinstalling the package 'AtmChile'.", call. = FALSE)
  }
  shiny::runApp(Directory, display.mode = "normal")
}

