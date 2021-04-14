#' @title ChileAirQuality
#' @description function that compiles air quality data from the National Air Quality System (SINCA)
#' @param Comunas data vector containing the names or codes of the monitoring
#'  stations. Available stations: "P. O'Higgins", "Cerrillos 1",
#'   "Cerrillos", "Cerro Navia", "El Bosque", "Independecia", "La Florida",
#'    "Las Condes", "Pudahuel", "Puente Alto "," Quilicura "," Quilicura 1 ",
#'    " Coyhaique I "," Coyhaique II ". To see the full list of stations use ChileAirQuality()
#' @param Parametros data vector containing the names of the air quality parameters.
#'  Available parameters: "PM10", "PM25", "CO", "NOX", "NO2", "NO", "O3",
#'  "temp" (temperature), "RH" (relative humidity), "ws" ( wind speed),
#'   "wd" (wind direction).
#' @param fechadeInicio text string containing the start date of the data request
#' @param fechadeTermino text string containing the end date of the data request
#' @param Curar logical value that activates data curation for particulate matter,
#'  nitrogen oxides, relative humidity and wind direction.
#' @param Site logical value that allows entering the code of the monitoring
#' station in the variable "Comunas"
#' @export
#' @import utils
#' @examples
#'
#' stationList <- ChileAirQuality()
#'
#' data <- ChileAirQuality(Comunas = "El Bosque", Parametros = c("PM10", "PM25"), fechadeInicio = "01/01/2020", fechadeTermino = "02/01/2020")
#'


ChileAirQuality <- function(Comunas = "INFO", Parametros, fechadeInicio, fechadeTermino, Site = FALSE, Curar = TRUE){

  sysEstaciones   <- system.file("extdata", "SINCA.CSV", package = "climateandquality")
  estationMatrix <- read.csv(sysEstaciones, sep = ",", dec =".", encoding = "UTF-8") #Matriz base de estaciones de monitoreo


  if(Comunas[1] == "INFO"){ #"INFO" para solicitar informacion de estaciones de monitoreo
    return((estationMatrix)) #Retorna matriz de estaciones
  }else{

    fi <- paste(fechadeInicio,"1:00") #incluir hora en fecha de inicio
    ft <- paste(fechadeTermino,"23:00") # incluir hora en fecha de termino
    Fecha_inicio <- as.POSIXct(strptime(fi, format = "%d/%m/%Y %H:%M")) #Asignar formato de fecha de termino
    Fecha_termino<- as.POSIXct(strptime(ft, format = "%d/%m/%Y %H:%M")) #Asignar formato de fecha de termino

    #Fechas para arana#
    Fecha_inicio_para_arana <- as.character(Fecha_inicio, format("%y%m%d")) #formato fecha inicio para el enrutador
    Fecha_termino_para_arana <-  as.character(Fecha_termino, format("%y%m%d")) #formato fecha termino para el enrutador
    id_fecha <- gsub(" ","",paste("from=", Fecha_inicio_para_arana, "&to=", Fecha_termino_para_arana)) #codigo de intervalo de fechas para enrutador
    horas <- (as.numeric(Fecha_termino)/3600-as.numeric(Fecha_inicio)/3600) #horas entre fechas


    urlSinca  <- "https://sinca.mma.gob.cl/cgi-bin/APUB-MMA/apub.tsindico2.cgi?outtype=xcl&macro=./" #parte inicial url de extraccion
    urlSinca2 <- "&path=/usr/airviro/data/CONAMA/&lang=esp&rsrc=&macropath=" #parte final de ur de extraccion

    #Data frame vacio#
    date = NULL
    date <- seq(Fecha_inicio, Fecha_termino, by = "hour")
    date <- format(date, format = "%d/%m/%Y %H:%M")
    data <- data.frame(date)#Parche que evita un ERROR
    data_total <- data.frame() #Data frame Vacio


    for (i in 1:length(Comunas)) {
      try({
        inEstation <- Comunas[i] # Asignar Comunas a variable

        for(j in 1:nrow(estationMatrix)){
          mSite      <-  estationMatrix[j, 1] #Asignar site a variable
          mCod       <-  estationMatrix[j, 2] #Asignar code a variable
          mLat       <-  estationMatrix[j, 3] #Asignar latitud a variable
          mLon       <-  estationMatrix[j, 4] #Asignar longitud a variable
          mEstation  <-  estationMatrix[j, 5] #Asignar estacion a variable
          if(Site){                 # Si Site es verdadero
            aux      <-  mSite      #aux, la variable de comparacion
          }else{                    #Se comparara con Site
            aux      <-  mEstation  #Si es falso se comparara con El nombre de la estacion
          }
          if(inEstation == aux){
            try({

              site <- rep(mSite, horas + 1) #Generar columna site
              longitude <- rep(mLat, horas + 1) #Generar columna longitud
              latitude <- rep(mLon, horas + 1) # Generar columna latitud
              data <- data.frame(date, site, longitude, latitude) #Unir columnas
              {
                for(p in 1:length(Parametros))
                {
                  inParametro <-  Parametros[p] #Asignar contaminante a variable

                  if(inParametro == "PM10" |inParametro == "pm10" |
                     inParametro == "pM10" |inParametro == "Pm10")
                  {
                    codParametro <- "/Cal/PM10//PM10.horario.horario.ic&" #Codigo especifico para PM10
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2)) #Generar URL
                    try(
                      {
                        PM10_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "") #Descargar csv
                        PM10_col1  <- PM10_Bruto$Registros.validados
                        PM10_col2  <- PM10_Bruto$Registros.preliminares
                        PM10_col3  <- PM10_Bruto$Registros.no.validados
                        PM10 <- gsub("NA","",gsub(" ", "",paste(PM10_col1,PM10_col2,PM10_col3))) #unir columnas del csv
                        if(length(PM10) == 0){PM10 <- rep("", horas + 1)}# Generar columna vacia en caso de que no exista informacion
                        data <- data.frame(data,PM10) #Incorporar al df de la comuna
                        print(paste(inParametro,inEstation)) #Imprimir mnsje de exito
                      }
                      ,silent = T)

                  } else if(inParametro == "PM25" |inParametro == "pm25" |
                            inParametro == "pM25" |inParametro == "Pm25")
                  {
                    codParametro <- "/Cal/PM25//PM25.horario.horario.ic&" #Codigo especifico PM25
                    url <- gsub(" ", "",paste(urlSinca,
                                              mCod, codParametro, id_fecha,
                                              urlSinca2)) #Generar URL
                    try(
                      {
                        PM25_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        PM25_col1 <- PM25_Bruto$Registros.validados
                        PM25_col2 <- PM25_Bruto$Registros.preliminares
                        PM25_col3 <- PM25_Bruto$Registros.no.validados
                        PM25 <- gsub("NA","",gsub(" ", "",paste(PM25_col1,PM25_col2,PM25_col3)))
                        if(length(PM25) == 0){PM25 <- rep("",horas + 1)}
                        data <- data.frame(data,PM25) #Crear columna
                        print(paste(inParametro, inEstation)) #Mensaje de exito
                      }
                      , silent = TRUE)
                  } else if(inParametro == "O3")
                  {
                    codParametro <- "/Cal/0008//0008.horario.horario.ic&" #Codigo url Ozono
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2)) #Generarurl
                    try(
                      {
                        O3_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        O3_col1 <- O3_Bruto$Registros.validados
                        O3_col2 <- O3_Bruto$Registros.preliminares
                        O3_col3 <- O3_Bruto$Registros.no.validados
                        O3 <- gsub("NA","",gsub(" ", "",paste(O3_col1, O3_col2, O3_col3)))
                        if(length(O3) == 0){O3 <- rep("",horas + 1)}
                        data <- data.frame(data, O3)
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "CO"| inParametro == "co"|
                            inParametro == "Co"| inParametro == "cO")
                  {
                    codParametro <- "/Cal/0004//0004.horario.horario.ic&" #Codigo CO
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2)) #Generar url
                    try(
                      {
                        CO_Bruto <- read.csv(url, dec =",", sep= ";",na.strings = "")
                        CO_col1 <- CO_Bruto$Registros.validados
                        CO_col2 <- CO_Bruto$Registros.preliminares
                        CO_col3 <- CO_Bruto$Registros.no.validados
                        CO <- gsub("NA","",gsub(" ", "",paste(CO_col1,CO_col2,CO_col3)))
                        if(length(O3) == 0){O3 <- rep("",horas + 1)}
                        data <- data.frame(data,CO)
                        print(paste(inParametro, inEstation)) #mensaje de exito
                      }
                      , silent = TRUE)
                  } else if(inParametro == "NO"| inParametro == "no"|
                            inParametro == "No"| inParametro == "nO")
                  {
                    codParametro <- "/Cal/0002//0002.horario.horario.ic&" #codigo monoxido de carbono
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro,
                                              id_fecha, urlSinca2)) #generar url
                    try(
                      {
                        NO_Bruto <- read.csv(url, dec = ",", sep = ";",na.strings = "")
                        NO_col1 <- NO_Bruto$Registros.validados
                        NO_col2 <- NO_Bruto$Registros.preliminares
                        NO_col3 <- NO_Bruto$Registros.no.validados
                        NO <- gsub("NA", "", gsub(" ", "", paste(NO_col1, NO_col2, NO_col3)))
                        if(length(NO) == 0){NO <- rep("", horas + 1)}
                        data <- data.frame(data, NO)
                        print(paste(inParametro, inEstation)) #mensaje de exito
                      }
                      ,silent = T)
                  } else if(inParametro == "NO2"| inParametro == "no2"|
                            inParametro == "No2"| inParametro == "nO2")
                  {
                    codParametro <- "/Cal/0003//0003.horario.horario.ic&" #codigo dioxido de nitrogeno
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        NO2_Bruto <- read.csv(url, dec =",", sep= ";", na.strings= "")
                        NO2_col1 <- NO2_Bruto$Registros.validados
                        NO2_col2 <- NO2_Bruto$Registros.preliminares
                        NO2_col3 <- NO2_Bruto$Registros.no.validados
                        NO2 <- gsub("NA","",gsub(" ", "",paste(NO2_col1,NO2_col2,NO2_col3)))
                        if(length(NO2) == 0){NO2 <- rep("",horas + 1)}
                        data <- data.frame(data, NO2)
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "NOX"|inParametro == "NOx"|
                            inParametro == "nOX"|inParametro == "NoX"|
                            inParametro == "Nox"|inParametro == "nOx"|
                            inParametro == "nox"|inParametro == "noX")
                  {
                    codParametro <- "/Cal/0NOX//0NOX.horario.horario.ic&"
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        NOX_Bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        NOX_col1 <- NOX_Bruto$Registros.validados
                        NOX_col2 <- NOX_Bruto$Registros.preliminares
                        NOX_col3 <- NOX_Bruto$Registros.no.validados
                        NOX <- gsub("NA", "", gsub(" ", "", paste(NOX_col1, NOX_col2, NOX_col3)))
                        if(length(NOX) == 0){NOX <- rep("", horas + 1)}
                        data <- data.frame(data, NOX)
                        print(paste(inParametro, inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "tEMP" |inParametro == "TeMP"|inParametro == "TEmP" |inParametro == "TEMp"
                            |inParametro == "TEmp"|inParametro == "TeMp"|inParametro == "TemP"|inParametro == "tEMp"
                            |inParametro == "tEmP"|inParametro == "teMP"|inParametro == "temp"|inParametro == "TEMP"
                            |inParametro == "temP"|inParametro == "teMp"|inParametro == "tEmp"|inParametro == "Temp")
                  {
                    codParametro <- "/Met/TEMP//horario_000.ic&"
                    url <- gsub(" ", "", paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        temp_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        temp_col1 <- temp_bruto$X
                        temp <- gsub("NA","",gsub(" ", "",temp_col1))
                        if(length(temp) == 0){temp <- rep("",horas + 1)}
                        data <- data.frame(data, temp)
                        print(paste(inParametro, inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "HR"| inParametro == "hr"|
                            inParametro == "hR"| inParametro == "Hr")
                  {
                    codParametro <- "/Met/RHUM//horario_000.ic&"
                    url <- gsub(" ", "",paste(urlSinca,
                                              mCod, codParametro, id_fecha,
                                              urlSinca2))
                    try(
                      {
                        HR_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        HR_col1 <- HR_bruto$X
                        HR <- gsub("NA","",gsub(" ", "",HR_col1))
                        if(length(HR) == 0){HR <- rep("",horas + 1)}
                        data <- data.frame(data,HR)
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "wd"| inParametro == "WD"|
                            inParametro == "Wd"| inParametro == "wD")
                  {
                    codParametro <- "/Met/WDIR//horario_000_spec.ic&"
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        wd_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        wd_col1 <- wd_bruto$X
                        wd <- gsub("NA","",gsub(" ", "",wd_col1))
                        if(length(wd) == 0 ){wd  <-  rep("",horas + 1)}
                        data <- data.frame(data,wd)
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  } else if(inParametro == "ws"| inParametro == "WS"|
                            inParametro == "Ws"| inParametro == "wS")
                  {
                    codParametro <- "/Met/WSPD//horario_000.ic&"
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        ws_bruto <- read.csv(url,dec =",", sep= ";",na.strings= "")
                        ws_col1 <- ws_bruto$X
                        ws <- gsub("NA","",gsub(" ", "",ws_col1))
                        if(length(ws) == 0){ws <- rep("",horas + 1)}
                        data <- data.frame(data,ws)
                        print(paste(inParametro,inEstation))
                      }
                      , silent = TRUE)
                  } else
                  {
                    print(paste("Contaminante",inParametro,"no soportado en el Software")) #Generar mensaje de fracaso
                  }
                }

                try(
                  {
                    data_total <- rbind(data_total, data)
                    #Unir el df de cada comuna al df total
                  }
                  , silent = T)
              }

            }
            , silent = T)
          }
        }


      }, silent = T)
    }

    if(Curar){
      len = nrow(data_total) #Variable que almacena el numero de filas del dataframe

      try({
        for (i in 1:len)
        {
          try(
            {
              if((as.numeric(data_total$NO[i]) + as.numeric(data_total$NO2[i])) > as.numeric(data_total$NOX[i]) * 1.001){
                data_total$NO[i] = "" #Si la suma de NO y NO2 es mayor a NOX
                data_total$NO2[i] = "" #Eliminar el dato de NO, NO2 y NOX
                data_total$NOX[i] = "" #Conciderando error del 0.1%

              }
            }
            , silent = T)
        }
      }, silent = T)

      try({
        for (i in 1:len)
        {
          try(
            {
              if(as.numeric(data_total$PM25[i]) > as.numeric(data_total$PM10[i])*1.001){
                data_total$PM10[i] = "" #Si PM25 es mayor a PM10 borrar PM10
                data_total$PM25[i] = "" #Y PM25 conciderando error del 0.1%
              }
            }
            ,silent = T)
        }
      }, silent = T)

      try({
        for (i in 1:len)
        {
          try({
            if(as.numeric(data_total$wd[i]) > 360||as.numeric(data_total$wd[i]) < 0){
              data_total$wd[i] = "" #Si la tireccion del viento es menor a 0 o mayor a 360 eliminar el dato
            }
          }, silent = T)
        }

      }, silent = T)

      try({
        i =NULL
        for (i in 1:len)
        {
          try(
            {
              if(as.numeric(data_total$HR[i]) > 100||as.numeric(data_total$HR[i]) <0){
                data_total$HR[i] = "" #Si la humedad relativa es mayor al 100% borrar el dato
              }

            }, silent = T)
        }

      }, silent = T)
    }

    for(i in 3:ncol(data_total)){
      data_total[[i]]  <-  as.numeric(data_total[[i]]) #transformar columnas en variables numericas
    }
    print("Datos Capturados!")
    return(data_total) #retornar df total
  }
}
