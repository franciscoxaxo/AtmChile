#' Title ClimateData
#' @description function that compiles climate data from Climate direction of Chile (DMC)
#' @param Estaciones data vector containing the  codes of the monitoring
#'  stations. To see the table with the monitoring stations use ClimateData()
#' @param Parametros data vector containing the names of the climate parameters.
#'  Available parameters: "Temperatura", "PuntoRocio", "Humedad","Viento", "PresionQFE", "PresionQFF".
#'
#' @param inicio text string containing the start year of the data request.
#' @param fin text string containing the end year of the data request.
#'
#' @export
#' @import data.table
#' @import utils
#'
#' @examples
#' ClimateData()
#'
#' data <- ClimateData(Estaciones = "180005", Parametros = c("Temperatura", "Humedad"), inicio = "2020", fin = "2021")
#'
#'
ChileClimateData <- function(Estaciones = "INFO", Parametros, inicio, fin){

  tablaEstaciones <- read.csv("Estaciones.csv", sep = "," , dec =".", encoding = "UTF-8")
  View(tablaEstaciones)

  if(Estaciones[1] == "INFO"){
    return(tablaEstaciones)
  }
  if(fin < inicio){
    print("Verificar fechas de inicio y fin")
    stop()
  }

  url1 <- "https://climatologia.meteochile.gob.cl/application/productos/gethistoricos/"

  parametros_list <- c("Temperatura", "PuntoRocio", "Humedad",
                       "Viento", "PresionQFE", "PresionQFF")
  #temporal <- c("TMinima", "TMaxima", "Agua6Horas", "Agua24Horas")
  #parametros_list <- c(parametros_list, temporal)

  intervalo <- inicio:fin

  lenInEstaciones <- length(Estaciones)
  lenInParametros <- length(Parametros)
  lenEstaciones   <- nrow(tablaEstaciones)
  lenParametros   <- length(parametros_list)
  lendate         <- length(intervalo)

  start <- as.POSIXct(strptime(paste("01-01-", inicio, "00:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
  end <- as.POSIXct(strptime(paste("31-12-", fin, "23:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
  horas<-(as.numeric(end)/3600-as.numeric(start)/3600)
  date = NULL

  date <- seq(start, end, by = "hour")
  date <- format(date, format = "%d-%m-%Y %H:%M:%S")

  df    <- NULL
  df2   <- NULL
  data_total <- data.frame()

  for(i in 1:lenInEstaciones){
    for(j in 1:lenEstaciones){
      if(Estaciones[i] == tablaEstaciones[j, 1]){
        estacion_var <- tablaEstaciones[j, 1]
        Latitud      <- tablaEstaciones[j, 5]
        Logitud      <- tablaEstaciones[j, 6]

        Nombre <- rep(tablaEstaciones[j, 4], length(date))
        data <- data.frame(date, Nombre)
        setDT(data)

        for(k in 1:lenInParametros){
          for(l in 1:lenParametros){
            if(Parametros[k] == parametros_list[l]){

                for(m in 1:lendate){

                    url3 <- paste(url1, estacion_var,"_",intervalo[m], "_", parametros_list[l], "_", sep = "")
                    filename <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], ".zip", sep = "")
                    csvname <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], "_.csv", sep = "")
                    download.file(url3, destfile = filename, method = "curl")

                      unzip(zipfile = filename)
                      file.remove(filename)

                      df <- rbind(df, read.csv(csvname, sep =  ";", dec = ".", encoding = "UTF-8"))

                      file.remove(csvname)

                }

                df2 <- data.frame(df[2], df[3])
                setDT(df2)
                data <- data[df2, on = c("date" = "momento")]
                df   <- NULL
                df2  <- NULL
            }

          }


        }
        if(is.null(data_total)){
          data_total<-data
        }else{
          data_total<-rbind(data_total, data)
        }

      }

    }
  }
  return(data_total)
}





