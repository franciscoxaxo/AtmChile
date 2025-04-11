

CV<- function(x, dec = 3){
  cv = (sd(x, na.rm = TRUE)/mean(x, na.rm = TRUE))*100
  cv = round(cv, dec)
  if(!is.na(cv)){
    cv = paste(cv, "%")
  }
  return(cv)
}


meant<-function(x, dec = 3){
  meant = round(mean(x, na.rm = TRUE), dec)
  return(meant)
}

mediant<-function(x, dec = 3){
  mediant = round(median(x, na.rm = TRUE), dec)
  return(mediant)
}

sdt<-function(x, dec = 3){
  sd = round(sd(x, na.rm = TRUE), dec)
  return(sd)
}

datamean<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datamean <- data[, lapply(.SD, meant), by = .(site, longitude, latitude), .SDcols = inicio:len]
  datamean <- as.data.frame(datamean)
  return(datamean)
}


datasd<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datasd <- data[, lapply(.SD, sdt), by = .(site, longitude, latitude), .SDcols = inicio:len]
  datasd <- as.data.frame(datasd)
  return(datasd)
}

datamedian<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datamedian <- data[, lapply(.SD, mediant), by = .(site, longitude, latitude), .SDcols = inicio:len]
  datamedian <- as.data.frame(datamedian)
  return(datamedian)
}

datacv<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datacv <- data[, lapply(.SD, CV), by = .(site, longitude, latitude), .SDcols = inicio:len]
  datacv <- as.data.frame(datacv)
  return(datacv)
}


datamean2<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datamean <- data[, lapply(.SD, meant), by = .(Nombre, Latitud, Longitud), .SDcols = inicio:len]
  datamean <- as.data.frame(datamean)
  return(datamean)
}


datasd2<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datasd <- data[, lapply(.SD, sdt), by = .(Nombre, Latitud, Longitud), .SDcols = inicio:len]
  datasd <- as.data.frame(datasd)
  return(datasd)
}

datamedian2<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datamedian <- data[, lapply(.SD, mediant), by = .(Nombre, Latitud, Longitud), .SDcols = inicio:len]
  datamedian <- as.data.frame(datamedian)
  return(datamedian)
}

datacv2<- function(data, inicio = 5){
  len = length(data)
  data<- data.table::data.table(data)
  datacv <- data[, lapply(.SD, CV), by = .(Nombre, Latitud, Longitud), .SDcols = inicio:len]
  datacv <- as.data.frame(datacv)
  return(datacv)
}

comparFunction<- function(data){
  obs <- data
  comparar <- data.frame(
    par<- c("Temperatura", "PuntoRocio", "Humedad", "PresionQFE", "PresionQFF", "dd_Valor", "ff_Valor"),
    nom <- c("Ts_Valor", "Td_Valor", "HR_Valor",  "QFE_Valor", "QFF_Valor", "dd_Valor", "ff_Valor")
  )
  a <- NULL
  for(i in 1:length(obs)){
    aux <- obs[i]
    if(aux == "Viento"){
      a <- c(a, "dd_Valor", "ff_Valor")
    }else{
      for(j in 1:nrow(comparar)){
        aux1 <- comparar[j, 1]
        aux2 <- comparar[j, 2]
        if(aux == aux1){
          a <- c(a, aux2)
          }
      }
    }

  }
  print(a)
  return(a)
}

siteplot<-function(data, latitud = data$Longitud, longitud = data$Latitud, centro = c(-70.6, -33.4)){


  fig<-plotly::plot_ly(data,
               lat = latitud,
               lon = longitud,
               marker = list(color = "red"),
               hovertext = ~paste("Estacion:", data$Estacion,"<br />", "Site:", data$Ciudad),
               type = 'scattermapbox'
  )
  fig<- plotly::layout(
      p = fig,
      mapbox = list(
        style = 'open-street-map',
        zoom =9,
        center = list(lon = centro[1], lat = centro[2])
      )
    )
  return(fig)
}

ChileClimateData <- function(Estaciones = "INFO", Parametros, inicio, fin, Region = FALSE){

  tablaEstaciones <- data.frame(
    "Codigo Nacional" = c("180005","200006","220002","230001","270001","270008","290004","320041",
                          "320051","330007","330019","330020","330021","330030","330031","330066",
                          "330077","330111","330112","330113","340031","360011","360019","360042",
                          "370033","380013","380029","390006","400009","410005","420004","420014",
                          "430002","430004","430009","450001","450004","450005","460001","470001",
                          "510005","520006","530005","550001","950001","950002","950003"),
    "Codigo OMM"      = c("85406","85418","85432","85442","85469","85467","85488","85556","85539",
                          "85560","85580","85577","85574","85586","85585","85584","85594","85571",
                          "85593","85569","85629","85672","85682","85671","85703","85743","85744",
                          "85766","85782","85799","85830","85824","85832","85836","85837","85862",
                          "85864","85874","85886","85892","85920","85934","85940","85968","89056",
                          "89057","89059"),
    "Codigo OACI"     = c("SCAR","SCDA","SCCF","SCFA","SCIP","SCAT","SCSE","SCVM","","SCRD","SCTB",
                          "SCQN","SCEL","SCSN","","SCIR","","","","","SCIC","SCCH","SCIE","","SCGE",
                          "SCTC","SCQP","SCVD","SCJO","SCTE","SCTN","SCPQ","SCFT","SCAP","SCMK","SCAS",
                          "SCCY","SCBA","SCCC","SCHR","SCNT","SCCI","SCFM","SCGZ","SCRM","SCBP","SCBO"),
    "Nombre"          = c("Chacalluta Arica Ap.","Diego Aracena Iquique Ap.","El Loa Calama Ad.",
                          "Cerro Moreno Antofagasta Ap.","Mataveri Isla de Pascua Ap.",
                          "Desierto de Atacama Caldera Ad.","La Florida La Serena Ad.",
                          "Vina del Mar Ad. (Torquemada)","Los Libertadores","Rodelillo Ad.",
                          "Eulogio Sanchez Tobalaba Ad.","Quinta Normal Santiago","Pudahuel Santiago",
                          "Santo Domingo Ad.","Juan Fernandez Estacion Meteorologica.",
                          "La Punta Juan Fernandez Ad.","El Colorado","Lo Prado Cerro San Francisco",
                          "San Jose Guayacan","El Paico","General Freire Curico Ad.",
                          "General Bernardo O'Higgins Chillan Ad.","Carriel Sur Concepcion Ap.",
                          "Termas de Chillan","Maria Dolores Los Angeles Ad.","Maquehue Temuco Ad.",
                          "La Araucania Ad.","Pichoy Valdivia Ad.","Canal Bajo Osorno Ad.",
                          "El Tepual Puerto Montt Ap.","Chaiten Ad.","Mocopulli Ad.","Futaleufu Ad.",
                          "Alto Palena Ad.","Melinka Ad.","Puerto Aysen Ad.","Teniente Vidal Coyhaique Ad.",
                          "Balmaceda Ad.","Chile Chico Ad.","Lord Cochrane Ad.",
                          "Teniente Gallardo Puerto Natales Ad.","Carlos Ibanez Punta Arenas Ap.",
                          "Fuentes Martinez Porvenir Ad.","Guardiamarina Zanartu Pto Williams Ad.",
                          "C.M.A. Eduardo Frei Montalva Antartica","Base Antartica Arturo Prat",
                          "Base Antartica Bernardo O`Higgins"),
    "Latitud"         = c("-18.35555","-20.54917","-22.49806","-23.45361","-27.15889","-27.25444",
                          "-29.91444","-32.94944","-32.84555","-33.06528","-33.45528","-33.44500",
                          "-33.37833","-33.65611","-33.63583","-33.66639","-33.35000","-33.45806",
                          "-33.61528","-33.70639","-34.96944","-36.58583","-36.78055","-36.90361",
                          "-37.39694","-38.76778","-38.93444","-39.65667","-40.61444","-41.44750",
                          "-42.93028","-42.34667","-43.18889","-43.61167","-43.89778","-45.39944",
                          "-45.59083","-45.91833","-46.58500","-47.24389","-51.66722","-53.00167",
                          "-53.25361","-54.93167","-62.19194","-62.47861","-63.32083"),
    "Longitud"        = c("-70.33889","-70.16944","-68.89805","-70.44056","-109.42361","-70.77944",
                          "-71.20333","-71.47444","-70.11861","-71.55917","-70.54222","-70.67778",
                          "-70.79639","-71.61000","-78.83028","-78.93194","-70.28805","-70.94889",
                          "-70.35583","-71.00000","-71.22028","-72.03389","-73.05083","-71.40667",
                          "-72.42361","-72.62694","-72.66083","-73.08472","-73.05083","-73.08472",
                          "-72.71167","-73.71167","-71.86417","-71.81333","-73.74555","-72.67778",
                          "-72.10167","-71.67778","-71.69472","-72.57611","-72.52528","-70.84722",
                          "-70.32194","-67.61000","-58.98278","-59.66083","-57.89805"),
    "Region"          = c("XV","I","II","II","V","III","VI","V","V","V","RM","RM","RM","V","V","V",
                          "RM","RM","RM","RM","VII","XVI","VII","XVI","VIII","IX","IX","XIV","X","X",
                          "X","X","X","X","XI","XI","XI","XI","XI","XI","XII","XII","XII","XII","XII",
                          "XII","XII")

  )

  if(Estaciones[1] == "INFO"){
    return(tablaEstaciones)
  }
  if(fin < inicio){
    print()
    stop("Verificar fechas de inicio y fin")
  }

  url1 <- "https://climatologia.meteochile.gob.cl/application/datos/getDatosSaclim/"

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
        data.table::setDT(data)

        for(k in 1:lenInParametros){
          for(l in 1:lenParametros){
            if(Parametros[k] == parametros_list[l]){

              for(m in 1:lendate){

                url3 <- paste(url1, estacion_var,"_",intervalo[m], "_", parametros_list[l], "_", sep = "")
                print(url3)
                filename <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], ".zip", sep = "")
                csvname <- paste(estacion_var,"_",intervalo[m],"_", parametros_list[l], "_.csv", sep = "")
                CSV <- NULL
                try({
                  download.file(url3, destfile = filename, method = "curl")
                  suppressWarnings({
                    unzip(zipfile = filename)
                    try({
                      #CSV <- read.csv(csvname, sep =  ";", dec = ".", encoding = "UTF-8")
                      CSV <- data.table::fread(csvname, sep =  ";", dec = ".", encoding = "UTF-8")
                      if(parametros_list[l] == "Viento"){
                        names(CSV) <- unlist(strsplit(names(CSV), ","))[1:5]

                      }else{
                        names(CSV) <- unlist(strsplit(names(CSV), ","))[-1]
                      }
                      CSV<-as.data.frame(CSV)



                    }, silent = T)
                  })

                }, silent = TRUE)
                print(head(CSV))
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
              data.table::setDT(df2)
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
  data_total <- data_total[!(is.na(data_total$Nombre)),]

  data_total <- as.data.frame(data_total)
  for(i in 3:ncol(data_total)){
    data_total[[i]]  <-  as.numeric(data_total[[i]]) #transformar columnas en variables numericas
  }
  return(data_total)
}

ChileAirQuality <- function(Comunas = "INFO", Parametros, fechadeInicio, fechadeTermino, Site = FALSE, Curar = TRUE){


  estationMatrix <- data.frame(
    "Ciudad"   = c("SA","CE1","CE","CN","EB","IN","LF","LC","PU","PA","QU","QU1","AH","AR","TE","TEII",
                   "TEIII","PLCI","PLCII","LU","LR","MAI","MAII","MAIII","VA","VAII","OS","OSII","PMI",
                   "PMII","PMIII","PMIV","PV","COI","COII","PAR"),
    "cod"      = c("RM/D14","RM/D16","RM/D31","RM/D18","RM/D17","RM/D11","RM/D12","RM/D13","RM/D15",
                   "RM/D27","RM/D30","RM/D19","RI/117","RXV/F01","RIX/901","RIX/905","RIX/904","RIX/903",
                   "RIX/902","RXIV/E04","RXIV/E06","RXIV/E01","RXIV/E05","RXIV/E02","RXIV/E03","RXIV/E08",
                   "RX/A01","RX/A04","RX/A08","RX/A07","RX/A02","RX/A03","RX/A09","RXI/B03","RXI/B04","RXII/C05"),

    "Longitud"  = c("-33.450819","-33.479515","-33.482411","-33.419725","-33.533626","-33.40892","-33.503288",
                    "-33.363453","-33.424439","-33.577948","-33.33632","-33.352539","-20.290467","-18.476839",
                    "-38.748699","-38.727003","-38.725302","-38.772463","-38.764767","-40.286857","-40.321282",
                    "-39.665626","-39.542346","-39.719218","-39.831316","-39.805429","-40.584479","-40.683736",
                    "-41.39917","-41.479507","-41.510342","-41.18765","-41.328935","-45.57993636","-45.57904645",
                    "-53.158295"),

    "Latitud" = c("-70.6604476","-70.719064","-70.703947","-70.73179","-70.665906","-70.650886","-70.587916",
                  "-70.523024","-70.749876","-70.594184","-70.723583","-70.747952","-70.100192","-70.287911",
                  "-72.620788","-72.580002","-72.571193","-72.595024","-72.598796","-73.07671","-72.471895",
                  "-72.953729","-72.925205","-73.128677","-73.228513","-73.25873","-73.11872","-72.596399",
                  "-72.899523","-72.968756","-73.065294","-73.08804","-72.968209","-72.0610848","-72.04996681",
                  "-70.921497"),

    "Estacion" = c("P. O'Higgins","Cerrillos 1","Cerrillos","Cerro Navia","El Bosque","Independecia","La Florida",
                   "Las Condes","Pudahuel","Puente Alto","Quilicura","Quilicura 1","Alto Hospicio","Arica",
                   "Las Encinas Temuco","Nielol Temuco","Museo Ferroviario Temuco","Padre Las Casas I",
                   "Padre Las Casas II","La Union","CESFAM Lago Ranco","Mafil","Fundo La Ribera",
                   "Vivero Los Castanos","Valdivia I","Valdivia II","Osorno","Entre Lagos","Alerce","Mirasol",
                   "Trapen Norte","Trapen Sur","Puerto Varas","Coyhaique I","Coyhaique II","Punta Arenas"),

    "Region"   = c("RM","RM","RM","RM","RM","RM","RM","RM","RM","RM","RM","RM","I","XV","IX","IX","IX","IX",
                   "IX","XIV","XIV","XIV","XIV","XIV","XIV","XIV","X","X","X","X","X","X","X","XI","XI","XII")


  )

  if(any(tolower(Parametros) =="all")){Parametros = c("PM10", "PM25", "CO","SO2", 
                                                 "NOX", "NO2", "NO", "O3", "temp",
                                                 "RH" , "ws", "wd")}
  
  if (any(tolower(Comunas) == "all")) {
    Comunas <- estationMatrix[[1]]  # Extrae la primera columna como vector
    Site <- TRUE
  }
  
  
  if(any(Comunas == "info")){ #"INFO" para solicitar informacion de estaciones de monitoreo
    return((estationMatrix)) #Retorna matriz de estaciones
  }else{
    
    # Convertir fechas de inicio y término a formato POSIXct
    Fecha_inicio <- as.POSIXct(strptime(paste(fechadeInicio,"1:00"), format = "%d/%m/%Y %H:%M"))
    #End date format
    Fecha_termino<- as.POSIXct(strptime(paste(fechadeTermino,"23:00"), format = "%d/%m/%Y %H:%M"))
    
    
    # Generar código de fecha para URL
    id_fecha <- gsub(" ","",paste("from=", as.character(format(Fecha_inicio, "%y%m%d")), 
                                  "&to=", as.character(format(Fecha_termino, "%y%m%d"))))    
    # Calcular las horas entre las fechas
    horas <- as.numeric(difftime(Fecha_termino, Fecha_inicio, units = "hours"))
    
    # Parte inicial y final de la URL
    urlSinca  <- "https://sinca.mma.gob.cl/cgi-bin/APUB-MMA/apub.tsindico2.cgi?outtype=xcl&macro=./"
    urlSinca2 <- "&path=/usr/airviro/data/CONAMA/&lang=esp&rsrc=&macropath="
    
    # Data frame vacío
    date = NULL
    date <- seq(Fecha_inicio, Fecha_termino, by = "hour")
    date <- format(date, format = "%d/%m/%Y %H:%M")
    data <- data.frame(date) # Parche que evita un ERROR
    data_total <- data.frame() # Data frame vacío

    for (i in 1:length(Comunas)) {
      try({
        inEstation <- Comunas[i] # Asignar Comunas a variable

        for(j in 1:nrow(estationMatrix)){
          mSite      <-  estationMatrix[j, 1] #Asignar site a variable
          mCod       <-  estationMatrix[j, 2] #Asignar code a variable
          mLon       <-  estationMatrix[j, 3] #Asignar latitud a variable
          mLat       <-  estationMatrix[j, 4] #Asignar longitud a variable
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

                  if(tolower(inParametro) == "pm10" )
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

                  } else if(tolower(inParametro) == "pm25" )
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
                  } else if(tolower(inParametro) == "o3")
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
                  } else if(tolower(inParametro) == "co")
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
                  } else if(tolower(inParametro) == "no")
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
                  }else if(tolower(inParametro) == "no2")
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
                  }else if(tolower(inParametro) == "nox")
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
                  }else if(tolower(inParametro) == "so2")
                  {
                    codParametro <- "/Cal/0001//0001.horario.horario.ic&"
                    url <- gsub(" ", "",paste(urlSinca, mCod, codParametro, id_fecha, urlSinca2))
                    try(
                      {
                        SO2_Bruto <- read.csv(url, dec =",", sep= ";", na.strings= "")
                        SO2_col1 <- SO2_Bruto$Registros.validados
                        SO2_col2 <- SO2_Bruto$Registros.preliminares
                        SO2_col3 <- SO2_Bruto$Registros.no.validados
                        SO2 <- gsub("NA","",gsub(" ", "",paste(SO2_col1, SO2_col2, SO2_col3)))
                        if(length(SO2) == 0){SO2 <- rep("",horas + 1)}
                        data <- data.frame(data, SO2)
                        print(paste(inParametro, inEstation))
                      }
                      , silent = TRUE)
                  }else if(tolower(inParametro) == "temp" )
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
                  } else if(tolower(inParametro) == "hr")
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
                  } else if(tolower(inParametro) == "wd")
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
                  } else if(tolower(inParametro) == "ws")
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
