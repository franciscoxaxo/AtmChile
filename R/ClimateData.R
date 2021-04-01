ClimateData <- function(inEstaciones, inParametros, inicio, fin){
  url1 <- "https://climatologia.meteochile.gob.cl/application/productos/gethistoricos/"

  estaciones <- c("180005", "200006")
  parametros <- c("Temperatura", "PuntoRocio", "Humedad", "TMinAM", "TMaxPM", "Viento", "PresionQFE", "PresionQFF", "Agua6Horas", "Agua24Horas")
  date <- inicio:fin

  lenInEstaciones <- length(inEstaciones)
  lenInParametros <- length(inParametros)
  lenEstaciones   <- length(estaciones)
  lenParametros   <- length(parametros)
  lendate         <- length(date)

  fechadeInicio  <-paste("01/01/", inicio, sep = "")
  fechadeTermino <-paste("31/12/", fin, sep = "")

  predata <- NULL
  aux2<- data.frame()


  for(i in 1:lenInEstaciones){
    for(j in 1:lenEstaciones){
      if(inEstaciones[i] == estaciones[j]){
        for(k in 1:lenInParametros){
          for(l in 1:lenParametros){
            if(inParametros[k] == parametros[l]){
              for(m in 1:lendate){
                 try(
                  {
                    url3 <- paste(url1, estaciones[j],"_",date[m],"_", parametros[l],"_", sep = "")
                    filename <- paste(estaciones[j],"_",date[m],"_", parametros[l], ".zip", sep = "")
                    csvname <- paste(estaciones[j],"_",date[m],"_", parametros[l], "_.csv", sep = "")
                    download.file(url3, destfile = filename, method = "curl")
                    unzip(zipfile = filename)
                    file.remove(filename)
                    csv  <- read.csv(csvname, sep =  ";", dec = ".")
                   if(length(aux2) == 0){
                     aux2 <- csv
                   }else{
                     aux2 <- rbind(aux2, csv)
                   }
                    try({
                      file.remove(csvname)
                    }, silent = T)


                  }, silent = T)
              }
              if(length(predata) == 0){
                predata <- aux2
              } else{
                print(aux2[3])
                predata <- cbind(predata, aux2[3])
              }

            }
          }
        }
      }
    }
  }
  return(predata)
}





