#' @title ChileAirQuality
#' @description function that compiles air quality data from the National Air Quality System (S.I.N.C.A.)
#' @param Comunas data vector containing the names or codes of the monitoring
#'  stations. Available stations: "P. O'Higgins","Cerrillos 1","Cerrillos","Cerro Navia",
#'  "El Bosque","Independecia","La Florida","Las Condes","Pudahuel","Puente Alto","Quilicura",
#'  "Quilicura 1","Alto Hospicio","Arica","Las Encinas Temuco","Nielol Temuco",
#'  "Museo Ferroviario Temuco","Padre Las Casas I","Padre Las Casas II","La Union",
#'  "CESFAM Lago Ranco","Mafil","Fundo La Ribera","Vivero Los Castanos","Valdivia I",
#'  "Valdivia II","Osorno","Entre Lagos","Alerce","Mirasol","Trapen Norte","Trapen Sur",
#'  "Puerto Varas","Coyhaique I","Coyhaique II","Punta Arenas".
#'   To see the full list of stations use ChileAirQuality()
#' @param Parametros data vector containing the names of the air quality parameters.
#'  Available parameters: "PM10", "PM25", "CO","SO2", "NOX", "NO2", "NO", "O3",
#'  "temp" (temperature), "RH" (relative humidity), "ws" ( wind speed),
#'   "wd" (wind direction).
#' @param fechadeInicio text string containing the start date of the data request
#' @param fechadeTermino text string containing the end date of the data request
#' @param Curar logical value that activates data curation for particulate matter,
#'  nitrogen oxides, relative humidity and wind direction.
#' @param st logical value that includes validation reports from S.I.N.C.A. "NV": No validated, "PV": Pre-validated, "V": Validated.
#' @param Site logical value that allows entering the code of the monitoring
#' station in the variable "Comunas"
#' @return A data frame with air quality data.
#' @source <https://sinca.mma.gob.cl/>
#' @export
#' @import utils
#' @examples
#'
#' try({
#' stations <- ChileAirQuality()
#' }, silent =TRUE)
#'
#' try({
#' data <- ChileAirQuality(Comunas = "El Bosque",
#'  Parametros = c("PM10", "PM25"), fechadeInicio = "01/01/2020",
#'   fechadeTermino = "02/01/2020")
#' }, silent =TRUE)
#'
#' try({
#' head(ChileAirQuality(Comunas = c("EB", "SA"),
#' Parametros = "PM10", fechadeInicio = "01/01/2020",
#' fechadeTermino = "01/03/2020", Site = TRUE))
#' }, silent = TRUE)
#'



ChileAirQuality <- function(Comunas = "INFO", Parametros, fechadeInicio, fechadeTermino, Site = FALSE, Curar = TRUE, st = FALSE){
  #Find csv file location with list of monitoring stations
  sysEstaciones   <- system.file("extdata", "SINCA.CSV", package = "AtmChile")
  #Data frame with monitoring stations
  estationMatrix <- read.csv(sysEstaciones, sep = ",", dec =".", encoding = "UTF-8")
  if(any(tolower(Comunas) == "info")){
    #Return data frame of stations
    
    return((estationMatrix))
  }else{
    
    if(any(tolower(Parametros) =="all")){Parametros <- c("PM10", "PM25", "CO","SO2", 
                                                         "NOX", "NO2", "NO", "O3", "temp",
                                                         "RH" , "ws", "wd")}
    
    
    
    if (any(tolower(Comunas) == "all")) {
      Comunas <- estationMatrix[[1]]  # Extrae la primera columna como vector
      Site <- TRUE
    }
    
    
    # input "INFO" to request information from monitoring stations
    
    #Start date format
    Fecha_inicio <- as.POSIXct(strptime(paste(fechadeInicio,"1:00"), format = "%d/%m/%Y %H:%M"))
    #End date format
    Fecha_termino<- as.POSIXct(strptime(paste(fechadeTermino,"23:00"), format = "%d/%m/%Y %H:%M"))
    
    #date range code for url
    id_fecha <- gsub(" ","",paste("from=", as.character(format(Fecha_inicio, "%y%m%d")), 
                                  "&to=", as.character(format(Fecha_termino, "%y%m%d"))))
    #time interval in hours
    horas <- (as.numeric(Fecha_termino)/3600-as.numeric(Fecha_inicio)/3600)
    
    #url part 1: Protocol, subdomain, domain and directory
    urlSinca  <- "https://sinca.mma.gob.cl/cgi-bin/APUB-MMA/apub.tsindico2.cgi?outtype=xcl&macro=./"
    #url part 2: query generals parameters
    urlSinca2 <- "&path=/usr/airviro/data/CONAMA/&lang=esp&rsrc=&macropath="
    
    # Cleaning variable date
    date = NULL
    #Date column
    date <- seq(Fecha_inicio, Fecha_termino, by = "hour")
    #Date column format
    date <- format(date, format = "%d/%m/%Y %H:%M")
    #Patch that avoids an ERROR
    data <- data.frame(date)
    #Empty data frame
    data_total <- data.frame()
    
    ##Selector
    #loop input variable "Comunas"
    for (i in 1:length(Comunas)) {
      try({
        ## Assign inputs in "Comunas"to variable
        inEstation <- Comunas[i]
        
        for(j in 1:nrow(estationMatrix)){
          mSite      <-  estationMatrix[j, 1] #Assign site to variable
          mCod       <-  estationMatrix[j, 2] #Assign code to variable
          mLon       <-  estationMatrix[j, 3] #Assign latitude to variable
          mLat       <-  estationMatrix[j, 4] #Assign longitude to variable
          mEstation  <-  estationMatrix[j, 5] #Assign station to variable
          #Verify "Site" control parameter
          if(Site){
            #Compare "Comunas" with the Sites column
            aux      <-  mSite
          }else{
            #Compare "Comunas" with the Full Names column
            aux      <-  mEstation
          }
          ##If the comparison is fulfilled, do:
          if(inEstation == aux){
            try({
              #Generate site column
              site <- rep(mSite, horas + 1)
              #Generate longitude and latitude column
              longitude <- rep(mLat, horas + 1)
              latitude <- rep(mLon, horas + 1)
              # Join the columns dates, longitude and latitude
              data <- data.frame(date, site, longitude, latitude)
              {
                #Loop input variable "Parametros"
                for(p in 1:length(Parametros))
                {
                  #Assign "Parametros" to variable
                  inParametro <-  Parametros[p]
                  # If input parameter is PM10, do:
                  if(tolower(inParametro) == "pm10")
                  {
                    #sub query for the parameter PM10
                    codParametro <- "/Cal/PM10//PM10.horario.horario.ic&"
                    #Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        PM10_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        PM10 <- apply(PM10_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                      function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.PM10 <- apply(PM10_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                          function(row) {
                                            if (!is.na(row[1])) "V" 
                                            else if (!is.na(row[2])) "PV" 
                                            else if (!is.na(row[3])) "NV" 
                                            else ""
                                          })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(PM10) == 0 && st) s.PM10 <- rep("", horas + 1)
                          data <- data.frame(data, s.PM10)
                        }
                        
                        
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(PM10) == 0){PM10 <- rep("", horas + 1)}
                        
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, PM10)
                        # Print success message
                        print(paste(inParametro, inEstation))
                      }
                      ,silent = T)
                    
                  }
                  # If input parameter is PM25, do:
                  else if(tolower(inParametro) == "pm25")
                  {
                    #sub query for the parameter
                    codParametro <- "/Cal/PM25//PM25.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca,
                                              mCod, codParametro, id_fecha,
                                              urlSinca2))
                    try(
                      {
                        #Download csv file
                        PM25_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        PM25 <- apply(PM25_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                      function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.PM25 <- apply(PM25_Bruto[, c("Registros.validados",
                                                         "Registros.preliminares",
                                                         "Registros.no.validados")], 1, 
                                          function(row) {
                                            if (!is.na(row[1])) "V" 
                                            else if (!is.na(row[2])) "PV" 
                                            else if (!is.na(row[3])) "NV" 
                                            else ""
                                          })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(PM25) == 0 && st) s.PM25 <- rep("", horas + 1)
                          data <- data.frame(data, s.PM25)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(PM25) == 0){PM25 <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data,PM25)
                        # Print success message
                        print(paste(inParametro, inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is Ozone, do:
                  else if(tolower(inParametro) == "o3")
                  {
                    #sub query for the parameter
                    codParametro <- "/Cal/0008//0008.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        O3_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        O3 <- apply(O3_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                    function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.O3 <- apply(O3_Bruto[, c("Registros.validados",
                                                     "Registros.preliminares",
                                                     "Registros.no.validados")], 1, 
                                        function(row) {
                                          if (!is.na(row[1])) "V" 
                                          else if (!is.na(row[2])) "PV" 
                                          else if (!is.na(row[3])) "NV" 
                                          else ""
                                        })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(O3) == 0 && st) s.O3 <- rep("", horas + 1)
                          data <- data.frame(data, s.O3)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(O3) == 0){O3 <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, O3)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is carbon monoxide, do:
                  else if( tolower(inParametro) == "co")
                  {
                    # sub query for the parameter
                    codParametro <- "/Cal/0004//0004.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        CO_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        CO <- apply(CO_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                    function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.CO <- apply(CO_Bruto[, c("Registros.validados",
                                                     "Registros.preliminares",
                                                     "Registros.no.validados")], 1, 
                                        function(row) {
                                          if (!is.na(row[1])) "V" 
                                          else if (!is.na(row[2])) "PV" 
                                          else if (!is.na(row[3])) "NV" 
                                          else ""
                                        })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(CO) == 0 && st) s.CO <- rep("", horas + 1)
                          data <- data.frame(data, s.CO)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(CO) == 0){CO <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, CO)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is nitrogen monoxide, do:
                  else if(tolower(inParametro) == "no")
                  {
                    # sub query for the parameter
                    codParametro <- "/Cal/0002//0002.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        NO_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        NO <- apply(NO_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                    function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.NO <- apply(NO_Bruto[, c("Registros.validados",
                                                     "Registros.preliminares",
                                                     "Registros.no.validados")], 1, 
                                        function(row) {
                                          if (!is.na(row[1])) "V" 
                                          else if (!is.na(row[2])) "PV" 
                                          else if (!is.na(row[3])) "NV" 
                                          else ""
                                        })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(NO) == 0 && st) s.NO <- rep("", horas + 1)
                          data <- data.frame(data, s.NO)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(NO) == 0){NO <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, NO)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      ,silent = T)
                  }
                  # If input parameter is nitrogen dioxide, do:
                  else if(tolower(inParametro) == "no2")
                  {
                    # sub query for the parameter
                    codParametro <- "/Cal/0003//0003.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        NO2_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        NO2 <- apply(NO2_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                     function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.NO2 <- apply(NO2_Bruto[, c("Registros.validados",
                                                       "Registros.preliminares",
                                                       "Registros.no.validados")], 1, 
                                         function(row) {
                                           if (!is.na(row[1])) "V" 
                                           else if (!is.na(row[2])) "PV" 
                                           else if (!is.na(row[3])) "NV" 
                                           else ""
                                         })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(NO2) == 0 && st) s.NO2 <- rep("", horas + 1)
                          data <- data.frame(data, s.NO2)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(NO2) == 0){NO2 <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, NO2)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is nitrogen oxide, do:
                  else if(tolower(inParametro) == "nox")
                  {
                    # sub query for the parameter
                    codParametro <- "/Cal/0NOX//0NOX.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        NOX_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        NOX <- apply(NOX_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                     function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.NOX <- apply(NOX_Bruto[, c("Registros.validados",
                                                       "Registros.preliminares",
                                                       "Registros.no.validados")], 1, 
                                         function(row) {
                                           if (!is.na(row[1])) "V" 
                                           else if (!is.na(row[2])) "PV" 
                                           else if (!is.na(row[3])) "NV" 
                                           else ""
                                         })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(NOX) == 0 && st) s.NOX <- rep("", horas + 1)
                          data <- data.frame(data, s.NOX)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(NOX) == 0){NOX <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, NOX)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is sulfur dioxide, do:
                  else if(tolower(inParametro) == "so2")
                  {
                    # sub query for the parameter
                    codParametro <- "/Cal/0001//0001.horario.horario.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download csv file
                        SO2_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        # Join columns of files
                        SO2 <- apply(SO2_Bruto[, c("Registros.validados", "Registros.preliminares", "Registros.no.validados")], 1, 
                                     function(row) gsub("NA", "", paste0(row, collapse = "")))
                        
                        if (st) {
                          s.SO2 <- apply(SO2_Bruto[, c("Registros.validados",
                                                       "Registros.preliminares",
                                                       "Registros.no.validados")], 1, 
                                         function(row) {
                                           if (!is.na(row[1])) "V" 
                                           else if (!is.na(row[2])) "PV" 
                                           else if (!is.na(row[3])) "NV" 
                                           else ""
                                         })
                          
                          # Asegurar que las longitudes coincidan
                          if (length(SO2) == 0 && st) s.SO2 <- rep("", horas + 1)
                          data <- data.frame(data, s.SO2)
                        }
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(SO2) == 0){SO2 <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, SO2)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  # If input parameter is temperature, do:
                  else if(tolower(inParametro) == "temp")
                  {
                    # sub query for the parameter
                    codParametro <-     "/Met/TEMP//horario_000.ic&"
                    codParametro_alt <- "/Met/TEMP//horario_002.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "", paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download CSV file
                        temp_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        if(length(temp_bruto)<2){
                          url <- gsub(" ", "",paste(urlSinca, mCod, codParametro_alt, id_fecha, urlSinca2))
                          temp_bruto <-read.csv(url,dec =",", sep= ";",na.strings= "")
                        }
                        
                        # Join columns of files
                        temp_col1 <- temp_bruto$X
                        temp <- gsub("NA","",gsub(" ", "",temp_col1))
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(temp) == 0){temp <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data, temp)
                        # Print success message
                        print(paste(inParametro, inEstation))
                      }
                      , silent = TRUE)
                  }
                  #If input parameter is RH, do:
                  else if(tolower(inParametro) %in% c("hr", "rh"))
                  {
                    # sub query for the parameter
                    codParametro <- "/Met/RHUM//horario_000.ic&"
                    codParametro_alt <-"/Met/RHUM//horario_002.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca,
                                              mCod, codParametro, id_fecha,
                                              urlSinca2))
                    try(
                      {
                        #Download CSV file
                        HR_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        if(length(HR_bruto)<2){
                          url <- gsub(" ", "",paste(urlSinca, mCod, codParametro_alt, id_fecha, urlSinca2))
                          HR_bruto <-read.csv(url,dec =",", sep= ";",na.strings= "")
                        }
                        
                        # Join columns of files
                        HR_col1 <- HR_bruto$X
                        HR <- gsub("NA","",gsub(" ", "",HR_col1))
                        
                        
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(HR) == 0){HR <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data,HR)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  #If input parameter is wind direction, do:
                  else if(tolower(inParametro) == "wd")
                  {
                    # sub query for the parameter
                    codParametro <-     "/Met/WDIR//horario_000_spec.ic&"
                    codParametro_alt <- "/Met/WDIR//horario_010_spec.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download CSV file
                        wd_bruto <-read.csv(url,dec =",", sep= ";",na.strings= "")
                        if(length(wd_bruto)<2){
                          url <- gsub(" ", "",paste(urlSinca, mCod, codParametro_alt, id_fecha, urlSinca2))
                          wd_bruto <-read.csv(url,dec =",", sep= ";",na.strings= "")
                        }
                        # Join columns of files
                        wd_col1 <- wd_bruto$X
                        wd <- gsub("NA","",gsub(" ", "",wd_col1))
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(wd) == 0 ){wd  <-  rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data,wd)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  #If input parameter is wind speed, do:
                  else if(tolower(inParametro) == "ws")
                  {
                    # sub query for the parameter
                    codParametro <-     "/Met/WSPD//horario_000.ic&"
                    codParametro_alt <- "/Met/WSPD//horario_010.ic&"
                    # Concatenate URL
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        #Download CSV file
                        ws_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        if(length(ws_bruto)<2){
                          url <- gsub(" ", "",paste(urlSinca, mCod, codParametro_alt, id_fecha, urlSinca2))
                          ws_bruto <-read.csv(url,dec =",", sep= ";",na.strings= "")
                        }
                        # Join columns of files
                        ws_col1 <- ws_bruto$X
                        ws <- gsub("NA","",gsub(" ", "",ws_col1))
                        # Control mechanism: if the file is not found, it generates an empty column
                        if(length(ws) == 0){ws <- rep("",horas + 1)}
                        # Incorporate the column into the station data frame
                        data <- data.frame(data,ws)
                        # Print success message
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  }
                  #If the input parameter is not one of the list, do:
                  else
                  {
                    # Print failure message
                    print(paste("Parametro",inParametro,"no soportado en la libreria")) #Generar mensaje de fracaso
                  }
                }
                
                try(
                  {
                    # Join the df of each station to the global dataframe
                    data_total <- rbind(data_total, data)
                    
                  }
                  , silent = T)
              }
              
            }
            , silent = T)
          }
        }
        
        
      }, silent = T)
    }
    #Control mechanism: If "Curar" is true, do:
    if(Curar){
      #Variable that stores the number of rows in the dataframe
      len = nrow(data_total)
      ## First data curation tool: nitrogen oxides
      ## As long as the nitrogen oxides are not empty columns, do:
      if((length(data_total$NO)  != 0) &
         (length(data_total$NO2) != 0) &
         (length(data_total$NOX) != 0)){
        try({
          for (i in 1:len)
          {
            try(
              {
                #If the sum of NO and NO2 is greater than NOX Eliminate the data of NO, NO2 and NOX considering an error of 0.1%
                if((as.numeric(data_total$NO[i]) + as.numeric(data_total$NO2[i])) > as.numeric(data_total$NOX[i]) * 1.001){
                  data_total$NO[i] = ""
                  data_total$NO2[i] = ""
                  data_total$NOX[i] = ""
                }
              }
              , silent = T)
          }
        }, silent = T)
      }
      #Second data curation tool: particulate matter
      if((length(data_total$PM25)  != 0) &
         (length(data_total$PM10)  != 0)){
        try({
          for (i in 1:len)
          {
            try(
              {
                # If PM25 is greater than PM10, delete PM10 and PM25, considering an error of 0.1%
                if(as.numeric(data_total$PM25[i]) > as.numeric(data_total$PM10[i])*1.001){
                  data_total$PM10[i] = ""
                  data_total$PM25[i] = ""
                }
              }
              ,silent = T)
          }
        }, silent = T)
      }
      
      try({
        #Third control mechanism: wind direction
        for (i in 1:len)
        {
          try({
            #If the wind direction is less than 0 or greater than 360, delete the data
            if(as.numeric(data_total$wd[i]) > 360||as.numeric(data_total$wd[i]) < 0){
              data_total$wd[i] = ""
            }
          }, silent = T)
        }
        
      }, silent = T)
      
      try({
        i =NULL
        #Fourth control mechanism: Relative humidity
        for (i in 1:len)
        {
          try(
            {
              ##If the relative humidity is greater than 100% delete the data
              if(as.numeric(data_total$HR[i]) > 100||as.numeric(data_total$HR[i]) <0){
                data_total$HR[i] = ""
              }
              
            }, silent = T)
        }
        
      }, silent = T)
    }
    #transform columns into numeric variables
    if(!st){
      for(i in 3:ncol(data_total)){
        data_total[[i]] <- as.numeric(data_total[[i]])
      }
    }else{
      for(i in 3:ncol(data_total)){
        val <- TRUE
        j <- 1
        while(val){
          if(data_total[j, i] == ""| is.na(data_total[j, i])){
            j <- j + 1
            if(j > nrow(data_total)){
              val <- FALSE
            }
          }
          if(data_total[j, i] != "NV" & data_total[j, i] != "PV" & data_total[j, i] != "V"){
            data_total[[i]] <- as.numeric(data_total[[i]])
            val <- FALSE
          }else{
            val <- FALSE
          }
        }
      }
    }
    #print final success message
    print("Datos Capturados!")
    #return df global
    return(data_total)
  }
}
