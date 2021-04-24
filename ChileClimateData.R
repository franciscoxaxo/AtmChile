#' Title ChileClimateData
#' @description function that compiles climate data from Climate direction of Chile (DMC)
#' @param Estaciones data vector containing the  codes of the monitoring
#'  stations. To see the table with the monitoring stations use ChileClimateData()
#' @param Parametros data vector containing the names of the climate parameters.
#'  Available parameters: "Temperatura", "PuntoRocio", "Humedad","Viento", "PresionQFE", "PresionQFF".
#'
#' @param inicio text string containing the start year of the data request.
#' @param fin text string containing the end year of the data request.
#' @param Region logical parameter. If region is true it allows to enter the administrative region in which the station is located instead of the station code.
#'
#' @export
#' @import data.table
#' @import utils
#'
#'
#' @examples
#'
#' try({ChileClimateData()}, silent = TRUE)
#'
#' try({
#' head(ChileClimateData(Estaciones = "180005",
#'  Parametros = c("Temperatura", "Humedad"),
#'   inicio = "2020", fin = "2021"))
#' }, silent = TRUE)
#'
#' try({
#' ChileClimateData(Estaciones = "II",
#'  Parametros = "Temperatura", inicio = "2020",
#'   fin = "2021", Region = TRUE)
#' }, silent = TRUE)

ChileClimateData <- function(Estaciones = "INFO", Parametros, inicio, fin, Region = FALSE){


  sysEstaciones   <- system.file("extdata", "Estaciones.csv", package = "climateandquality")
  tablaEstaciones <- read.csv(sysEstaciones, sep = "," , dec =".", encoding = "UTF-8")

  if(Estaciones[1] == "INFO"){
    return(tablaEstaciones)
  }
  if(fin < inicio){
    print()
    stop("Verificar fechas de inicio y fin")
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
  #horas<-(as.numeric(end)/3600-as.numeric(start)/3600)
  date = NULL

  date <- seq(start, end, by = "hour")
  date <- format(date, format = "%d-%m-%Y %H:%M:%S")

  df    <- NULL
  df2   <- NULL
  data_total <- data.frame()

  if(Region == TRUE){
    r <- 7
  }else{
    r <- 1
  }

  for(i in 1:lenInEstaciones){
    for(j in 1:lenEstaciones){
      if(Estaciones[i] == tablaEstaciones[j, r]){

        estacion_var <- tablaEstaciones[j, 1]
        Latitud     <-  tablaEstaciones[j, 5]
        Longitud    <-  tablaEstaciones[j, 6]
        Nombre      <-  rep(tablaEstaciones[j, 4], length(date))
        Latitud     <-  rep(tablaEstaciones[j, 5], length(date))
        Longitud    <-  rep(tablaEstaciones[j, 6], length(date))
        data        <-  data.frame(date, Nombre, Latitud, Longitud)
        setDT(data)

        for(k in 1:lenInParametros){
          for(l in 1:lenParametros){
            if(Parametros[k] == parametros_list[l]){

              for(m in 1:lendate){

                url3 <- paste(url1, estacion_var,"_",intervalo[m], "_", parametros_list[l], "_", sep = "")
                print(url3)
                filename <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], ".zip", sep = "")
                csvname <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], "_.csv", sep = "")
                CSV <- NULL
                download.file(url3, destfile = filename, method = "curl")
                suppressWarnings({
                  unzip(zipfile = filename)
                  try({
                    CSV <- read.csv(csvname, sep =  ";", dec = ".", encoding = "UTF-8")
                  }, silent = T)
                })

                if(is.null(CSV)| length(CSV) == 0){
                  momento1 <- as.POSIXct(strptime(paste("01-01-", intervalo[m], "00:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
                  momento2 <- as.POSIXct(strptime(paste("31-12-", intervalo[m], "23:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
                  momento <- seq(momento1, momento2, by = "hour")
                  CodigoNacional <-rep("", length(momento))
                  momento <- format(momento, format = "%d-%m-%Y %H:%M:%S")

                  if(parametros_list[l] == "Temperatura"){
                    Ts_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, Ts_Valor)
                  }else if(parametros_list[l] == "PuntoRocio"){
                    Td_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, Td_Valor)
                  }else if(parametros_list[l] == "Humedad"){
                    HR_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, HR_Valor)
                  }else if(parametros_list[l] == "Viento"){
                    dd_Valor<- rep("", length(momento))
                    ff_Valor<- rep("", length(momento))
                    VRB_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, dd_Valor,ff_Valor, VRB_Valor)
                  }else if(parametros_list[l] == "PresionQFE"){
                    QFE_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, QFE_Valor)
                  }else if(parametros_list[l] == "PresionQFF"){
                    QFF_Valor<- rep("", length(momento))
                    CSV <- data.frame(CodigoNacional, momento, QFF_Valor)
                  }
                }
                df<- rbind(df, CSV)
                suppressWarnings({
                  file.remove(filename)
                  file.remove(csvname)
                })
              }
              if(parametros_list[l] == "Viento"){
                df2 <- data.frame(df[2], df[3], df[4], df[5])
              }else{
                df2 <- data.frame(df[2], df[3])
              }
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


  data_total$date <- format(as.POSIXct(strptime(data_total$date, format = "%d-%m-%Y %H:%M:%S")), format = "%d/%m/%Y %H:%M")

  data_total <- data_total[!(is.na(data_total$date)),]

  data_total <- as.data.frame(data_total)

  return(data_total)
}
