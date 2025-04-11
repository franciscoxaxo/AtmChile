#' Title ChileClimateData
#' @description function that compiles climate data from Climate direction of Chile (D.M.C.)
#' @param Estaciones data vector containing the  codes of the monitoring
#'  stations. To see the table with the monitoring stations use ChileClimateData()
#' @param Parametros data vector containing the names of the climate parameters.
#'  Available parameters: "Temperatura", "PuntoRocio", "Humedad","Viento", "PresionQFE", "PresionQFF".
#'
#' @param inicio text string containing the start year of the data request.
#' @param fin text string containing the end year of the data request.
#' @param Region logical parameter. If region is true it allows to enter the administrative region in which the station is located instead of the station code.
#' @return A data frame with climate data of Chile.
#'
#' @source <http://www.meteochile.gob.cl/>
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
#' data <- ChileClimateData(Estaciones = "180005",
#'  Parametros = c("Temperatura", "Humedad"),
#'   inicio = "2020", fin = "2020")
#' }, silent = TRUE)
#'
#' try({
#' head(ChileClimateData(Estaciones = "II",
#'  Parametros = "Temperatura", inicio = "2020",
#'   fin = "2020", Region = TRUE))
#' }, silent = TRUE)

ChileClimateData <- function(Estaciones = "INFO", Parametros, inicio, fin, Region = FALSE){

  #Find csv file location with list of monitoring stations
  sysEstaciones   <- system.file("extdata", "Estaciones.csv", package = "AtmChile")
  #Data frame with monitoring stations
  tablaEstaciones <- read.csv(sysEstaciones, sep = "," , dec =".", encoding = "UTF-8")
  # input "INFO" to request information from monitoring station
  if(Estaciones[1] == "INFO"){
    #Return data frame of stations
    return(tablaEstaciones)
  }

  # error message if end year is greater than start year
  if(fin < inicio){
    stop("Verificar fechas de inicio y fin")
  }
  #url part 1: Protocol, subdomain, domain and directory
  url1 <- "https://climatologia.meteochile.gob.cl/application/datos/getDatosSaclim/"
  #list of parameters to compare:
  parametros_list <- c("Temperatura", "PuntoRocio", "Humedad",
                       "Viento", "PresionQFE", "PresionQFF")
  ##Temporarily out of use
  #temporal <- c("TMinima", "TMaxima", "Agua6Horas", "Agua24Horas")
  #parametros_list <- c(parametros_list, temporal)

  #date ranges
  intervalo <- inicio:fin
  #store input length of Stations:
  lenInEstaciones <- length(Estaciones)
  #store input length of parameters:
  lenInParametros <- length(Parametros)
  #store internal length of Stations:
  lenEstaciones   <- nrow(tablaEstaciones)
  #store internal length of Parameters:
  lenParametros   <- length(parametros_list)
  #store internal length of date range:
  lendate         <- length(intervalo)
  #input date format:
  start <- as.POSIXct(strptime(paste("01-01-", inicio, "00:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
  end <- as.POSIXct(strptime(paste("31-12-", fin, "23:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
  #Temporarily out of use
  #horas<-(as.numeric(end)/3600-as.numeric(start)/3600)
  date = NULL
  #generate date column
  date <- seq(start, end, by = "hour")
  #format date column
  date <- format(date, format = "%d-%m-%Y %H:%M:%S")

  df    <- NULL
  df2   <- NULL
  #generate empty global data frame
  data_total <- data.frame()
  ## Control mechanism: If "Region" is true,
  ##the input parameters will be verified with column 7
  ##of the matrix (administrative divisions), if false, it will be
  ##compared with column 1 (Station codes)
  if(Region == TRUE){
    r <- 7
  }else{
    r <- 1
  }
  # Loop input variable "Estacion"
  for(i in 1:lenInEstaciones){
    # Loop Station Matrix (station code or ad division)
    for(j in 1:lenEstaciones){
      if(Estaciones[i] == tablaEstaciones[j, r]){

        estacion_var <- tablaEstaciones[j, 1]  #Assign station code to variable
        Latitud     <-  tablaEstaciones[j, 5]  #Assign latitude to variable
        Longitud    <-  tablaEstaciones[j, 6] #Assign longitude to variable
        Nombre      <-  rep(tablaEstaciones[j, 4], length(date)) #Generate station name column
        Latitud     <-  rep(tablaEstaciones[j, 5], length(date)) #Generate latitude column
        Longitud    <-  rep(tablaEstaciones[j, 6], length(date)) #Generate longitude column
        data        <-  data.frame(date, Nombre, Latitud, Longitud) #Join data, station name, longitude and latitude in station df
        setDT(data) #Set station data frame as data table
        #Loop input variable "Parametros"
        for(k in 1:lenInParametros){
          #Loop internal variable "parametros_list"
          for(l in 1:lenParametros){
            #Compare input with the internal list
            if(Parametros[k] == parametros_list[l]){
              #iterate for each year
              for(m in 1:lendate){
                temp  <- tempfile()
                temp1 <- tempfile()
                #concatenate url for query
                url3 <- paste(url1, estacion_var,"_",intervalo[m], "_", parametros_list[l], "_", sep = "")
                print(url3)
                #concatenate required zip file name
                filename <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], ".zip", sep = "")
                #concatenate required csv file name
                csvname <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], "_.csv", sep = "")
                #clear CSV variable
                CSV <- NULL
                try({
                  #Download zip file
                  download.file(url3, temp, method = "curl")
                  #suppress warnings messages
                  suppressWarnings({
                    #unzip downloaded file and assing name for the csv file
                    try({
                      #read csv file
                      #CSV<- read.csv(unzip(temp, csvname), sep =  ";", dec = ".", encoding = "UTF-8")
                      CSV<- data.table::fread(unzip(temp, csvname), sep =  ";", dec = ".", encoding = "UTF-8")
                      if(parametros_list[l] == "Viento"){
                        names(CSV) <- unlist(strsplit(names(CSV), ","))[1:5]
                      }else{
                        names(CSV) <- unlist(strsplit(names(CSV), ","))[-1]
                      }

                    }, silent = T)
                  })
                }, silent = TRUE)
                #In the event of an error or absence of data
                if(is.null(CSV)| length(CSV) == 0){
                  #auxliar date variables
                  momento1 <- as.POSIXct(strptime(paste("01-01-", intervalo[m], "00:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
                  momento2 <- as.POSIXct(strptime(paste("31-12-", intervalo[m], "23:00:00", sep =""), format = "%d-%m-%Y %H:%M:%S"))
                  #Generate date column
                  momento <- seq(momento1, momento2, by = "hour")
                  #Generate cod column
                  CodigoNacional <-rep("", length(momento))
                  #Format data column
                  momento <- format(momento, format = "%d-%m-%Y %H:%M:%S")
                  #generate empty column
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
                #join data column to station dataframe
                df<- rbind(df, CSV)
                #If the files exist delete them
                suppressWarnings({
                  file.remove(csvname)
                })
                unlink(temp)
              }

              if(parametros_list[l] == "Viento"){
                #If the parameter is wind, keep only columns 2, 3, 4 and 5 (with data)
                df2 <- data.frame(df[2], df[3], df[4], df[5])
              }else{
                #If the parameter isn't wind, keep only columns 2 and 3(with data)
                df2 <- data.frame(df[2], df[3])
              }
              #set auxiliary dataframe (df2) as data table
              setDT(df2)
              #Generate match between the donwloaded data and the partial dataframe
              data <- data[df2, on = c("date" = "momento")]
              #Clean df and df2
              df   <- NULL
              df2  <- NULL
            }
          }
        }
        #Join dataframes into a global dataframe
        if(is.null(data_total)){
          data_total<-data
        }else{
          data_total<-rbind(data_total, data)
        }
      }
    }
  }

  #format date column
  data_total$date <- format(as.POSIXct(strptime(data_total$date, format = "%d-%m-%Y %H:%M:%S")), format = "%d/%m/%Y %H:%M")
  #clean data without date records
  data_total <- data_total[!(is.na(data_total$date)),]
  #clean data without names station records
  data_total <- data_total[!(is.na(data_total$Nombre)),]

  #transform columns into numeric variables
  for(i in 3:ncol(data_total)){
    data_total[[i]]  <-  as.numeric(data_total[[i]])
  }
  #transform data table into a dataframe
  data_total <- as.data.frame(data_total)
  #Return dataframe
  return(data_total)
}
