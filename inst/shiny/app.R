library(shiny)
library(shinycssloaders)

e <- new.env()
source("complementaryFunctions.R",local=e)
attach(e)

ui <-fluidPage(
  ################################### HEAD #####################################

    HTML("<head>
                    <title>ChileAirQuality Proyect</title>
                    <link rel='shortcut icon' href='ico.png'>
                    <meta name='robots' content='ChileAirQuality Web App' />
                    <meta name='description' content='Aplicación web para facilitar el estudio de la calidad del aire en Chile' />
          </head>
                   "),

    ################################# CALIDAD DEL AIRE TAB######################

    tabsetPanel(tabPanel("Data Calidad del Aire",
                         {
                           titlePanel("Captura de Datos")
                           sidebarLayout(
                             sidebarPanel(
                               #Input start date
                               dateInput("Fecha_inicio",
                                         label ="Fecha de inicio",
                                         value = Sys.Date()-1,
                                         min = "1997-01-01",
                                         max= Sys.Date(),
                                         format= "dd/mm/yyyy"),
                               #Input end date
                               dateInput("Fecha_Termino",
                                         label ="Fecha de Termino",
                                         value = Sys.Date()-1,
                                         min = ("1997-01-01"),
                                         max= Sys.Date(),
                                         format= "dd/mm/yyyy"),
                               #Control option: Curate data
                               checkboxInput("validacion",
                                             label = "Curar datos",
                                             value = TRUE),
                               #Air quality climate factors buttons
                               splitLayout(checkboxGroupInput("F_Climaticos",
                                                              label ="F. Climaticos",
                                                              choices =c("temp", "HR", "wd","ws", "all"),
                                                              selected = c("temp", "HR", "wd","ws")
                               ),
                               #Air quality pollutants buttons
                               checkboxGroupInput("Contaminantes",
                                                  label ="Contaminantes",
                                                  choices =c( "PM10", "PM25", "NO","NO2",
                                                              "NOX","O3","CO", "SO2")
                               )
                               ),
                               #Air quality stations buttons
                               splitLayout(checkboxGroupInput("Comunas1",
                                                              label ="Estaciones",
                                                              choices =c("P. O'Higgins","Cerrillos 1",
                                                                         "Cerrillos", "Cerro Navia",
                                                                         "El Bosque","Independecia")
                               ),
                               checkboxGroupInput("Comunas2",
                                                  label ="",
                                                  choices = c("Las Condes","La Florida",
                                                             "Pudahuel","Puente Alto","Quilicura",
                                                             "Quilicura 1", "Coyhaique I",
                                                             "Coyhaique II", "all")
                               )
                               ),
                               #Action button
                               submitButton("Aplicar Cambios")

                             ),

                             mainPanel(
                               #Deploy air quality data table
                               withSpinner(DT::dataTableOutput("table")),
                               #Download air quality data
                               downloadButton("descargar", label ="Descargar"),
                               #Hide error
                               tags$style(type="text/css",
                                          ".shiny-output-error { visibility: hidden; }",
                                          ".shiny-output-error:before { visibility: hidden; }"
                               )
                             )
                           )
                         }
    ),
    ############################### DATA CLIMATE TAB ###########################
    tabPanel("Data Climatica",
             {
               sidebarLayout(
                 sidebarPanel(
                   #Years range for the data collection
                   sliderInput("rango",
                               "Rango:",
                               min = 1940,
                               max = lubridate::year(Sys.Date()),
                               value = c(2000,(lubridate::year(Sys.Date()) - 1))),

                   #Climate data parameters
                   checkboxGroupInput("parametros",
                                      label ="Parametros",
                                      choices =c("Temperatura", "PuntoRocio", "Humedad",
                                                 "Viento", "PresionQFE", "PresionQFF"),
                                      selected = c("Temperatura", "PuntoRocio", "Humedad",
                                                   "Viento", "PresionQFE", "PresionQFF")),
                   #Ad regions button
                   splitLayout(
                     checkboxGroupInput("region1",
                                        label ="Regiones",
                                        choices =c("I","II",
                                                   "III", "IV",
                                                   "V","VI", "VII", "VIII")
                     ),
                     checkboxGroupInput("region2",
                                        label ="",
                                        choices =c("IX","X",
                                                   "XI","XII","XIV",
                                                   "XV", "XVI",
                                                   "RM"))
                   ),
                   #Action button
                   submitButton("Aplicar Cambios")


                 ),

                 #Deploy climate data table
                 mainPanel(
                   withSpinner( DT::dataTableOutput("table1")),
                   #Download button
                   downloadButton("descargar1",label ="Descargar"),
                   #Hide error
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }")
                 )
               )
             }
    ),
    ############################## GRAFICAS TAB ################################
    tabPanel("Gráficas",
             {
               sidebarLayout(
                 sidebarPanel(
                   uiOutput("sData2"),
                   uiOutput("selectorGraficos"),##In development!!!
                   #Deploy graphic selection bar option
                   #Deploy complementary options
                   uiOutput("moreControls"),
                   #Action button
                   submitButton("Actualizar")
                 ),
                 mainPanel(
                   withSpinner(uiOutput("mainGraphics"))
                   ,
                   #Hide errors
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"
                   )

                 )
               )
             }
    ),
    ############################# RESUMEN TAB ##################################
    tabPanel("Resumen",
             {
               sidebarLayout(
                 sidebarPanel(
                   uiOutput("sData"),
                   #Select statistic summary option
                   selectInput("statsummary","Resumen Estadistico",
                               choices = c("--Seleccionar--","Promedio",
                                           "Mediana","Desviacion Estandar",
                                           "coeficiente de variacion")
                   ),

                   #Action bottom
                   submitButton("Aplicar Cambios")
                 ),
                 mainPanel(
                   # Stats table
                   withSpinner(DT::dataTableOutput("statstable")),
                   #Download stats table
                   downloadButton("descargarstats",
                                  label ="Descargar"
                   ),
                   #Hide errors
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"
                   )
                 )
               )


             }
    ),
    ############################ INFORMACION TAB ###############################
    tabPanel("Información",
             {
               #Table of variables
               verticalLayout(

                 tags$body(HTML("
                   <h1><strong>Calidad del aire</strong></h1>
                   <h2><strong>Variables de Calidad del aire</strong></h2>
                   <p>Esta aplicación tiene disponible los siguientes
                      parámetros para el análisis de la calidad del
                      aire disponibles del Sistema de Información
                      Nacional de Calidad del Aire. </p>
                   ")),
                 withSpinner(tableOutput("info_2")),
                 tags$body(HTML("
                  <a href = 'https://sinca.mma.gob.cl/'> sinca.mma.gob.cl</a>
                  <h2><strong>Estaciones de monitoreo</strong></h2>
                  <p>Los datos recopilados por esta aplicación son reportados
                     por el sistema de información nacional de calidad
                     del aire a partir de la red de estaciones de monitoreo
                     MACAM distribuidas en las comunas de la región metropolitana. </p>"
                 )),


                 withSpinner(plotly::plotlyOutput("sitemap",
                                          width = "500px",
                                          height = "500px"
                 )),
                 tags$body(HTML("
                  <br>
                  <br>
                  <h1><strong>Meteorología</strong></h1>
                  <h2><strong>Variables meteorológicas</strong></h2>
                  <p>Esta aplicación tiene disponible los siguientes
                      parámetros para el análisis meteorológicos
                      disponibles en la Dirección meteorológica de
                      Chile.</p>
                                ")),
                 withSpinner(tableOutput("info_3")),
                 tags$body(HTML("
                  <a href = 'http://www.meteochile.gob.cl/'> www.meteochile.gob.cl</a>
                  <br>
                  <br>
                  <br>
                  <br>"))

               )
             }
    )

    ))
#################################SERVER#########################################

server <- function(input, output) {


  ######################################CALIDAD DEL AIRE TAB####################

  #Reactive function for download air quality information from SINCA
  data_totalAQ <- reactive({
    ChileAirQuality(
      Comunas = c(input$Comunas1, input$Comunas2),
      Parametros = c(input$Contaminantes, input$F_Climaticos),
      fechadeInicio = format(input$Fecha_inicio, "%d/%m/%Y"),
      fechadeTermino = format(input$Fecha_Termino, "%d/%m/%Y"),
      Curar = input$validacion
    )
  })

  #Data Table for air quality information
  output$table <- DT::renderDataTable(
    DT::datatable({data_totalAQ()},
                  filter = "top",
                  selection = 'multiple',
                  style = 'bootstrap'
    )
  )

  #Download Botton for air quality data
  output$descargar<-downloadHandler(
    filename = "data.csv",
    content = function(file){
      write.csv(data_totalAQ(), file)
    }
  )



  ############################### DATA CLIMATE TAB #############################

  #reactive function for download climate data from DMC
  data_totalDC <- reactive(

    ChileClimateData(
      Estaciones = c(input$region1, input$region2),
      Parametros = input$parametros,
      inicio = input$rango[1],
      fin = input$rango[2],
      Region = TRUE
    ))

  #Deploy data table for climate data
  output$table1 <- DT::renderDataTable(
    DT::datatable({data_totalDC()},
                  filter = "top",
                  selection = 'multiple',
                  style = 'bootstrap'
    )
  )

  #Download Button for climate data
  output$descargar1<-downloadHandler(
    filename = "data.csv",
    content = function(file){
      write.csv(data_totalDC(), file)
    }
  )

  ############################## GRAFICAS TAB ##################################

  output$sData2 <- renderUI({
    selectInput("selectData2","Seleccionar dataset",
                choices = c("--Seleccionar--","Data Climatica", "Calidad del aire")
    )
  })
  output$selectorGraficos <- renderUI({

    if(input$selectData2 == "Calidad del aire"){
      selectInput("Select","Tipo de Grafico",
                  choices = c("--Seleccionar--","timeVariation","corPlot","timePlot",
                              "calendarPlot","polarPlot","scatterPlot","smoothTrend")
      )
    }
    else if(input$selectData2 == "Data Climatica"){
      selectInput("Select","Tipo de Grafico",
                  choices = c("--Seleccionar--","timeVariation","corPlot","timePlot",
                              "calendarPlot","smoothTrend")
      )
    }
  })

  #Deploy reactive controls option for air quality graphics
  output$moreControls <- renderUI({
    parClimatico <- comparFunction(input$parametros)
    if(input$selectData2 == "Calidad del aire"){
      ##Options for calendarPlot
      if(input$Select == "calendarPlot"){
        flowLayout(
          sliderInput("rango_calendar",
                      "Rango:",
                      step = 1,
                      min = lubridate::year(as.Date(input$Fecha_inicio, format = "%d/%m/%Y")),
                      max = lubridate::year(as.Date(input$Fecha_Termino, format = "%d/%m/%Y")),
                      value = c(lubridate::year(as.Date(input$Fecha_inicio, format = "%d/%m/%Y")),
                                lubridate::year(as.Date(input$Fecha_Termino, format = "%d/%m/%Y")))),
          radioButtons(inputId = "choices",
                       label = "Contaminantes",
                       choices = input$Contaminantes)
        )
      }
      else if(input$Select == "scatterPlot"){
        ##Options for scatterPlot
        flowLayout(
          splitLayout(radioButtons(inputId = "x",
                                   label = "Contaminantes",
                                   choices = input$Contaminantes),
                      radioButtons(inputId = "y",
                                   label = "Contaminantes",
                                   choices = input$Contaminantes)
          ),
          splitLayout(
            #Logaritm options in the X axis
            checkboxInput(inputId = "logx",label = "log(x)"),
            #Logaritm options in the Y axis
            checkboxInput(inputId ="logy",label = "log(y)"),
            #Trace lineal correlation
            checkboxInput(inputId ="lineal",label = "Lineal")
          )

        )

      }
      else if(input$Select == "smoothTrend"){
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   radioButtons(inputId = "choices",
                                label = "Contaminantes",
                                choices = input$Contaminantes)
        )
      }
      else if(input$Select == "timePlot"){
        #Deploy un-group for station option
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   selectInput("avgtime","Promedio de tiempo",
                               choices = c("hour","year","month","week",
                                           "day")),
                   checkboxGroupInput(inputId = "choices",
                                      label = "Contaminantes",
                                      choices = input$Contaminantes,
                                      selected = input$Contaminantes)

        )

      }
      else{
        #Deploy un-group for station option
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   checkboxGroupInput(inputId = "choices",
                                      label = "Contaminantes",
                                      choices = input$Contaminantes,
                                      selected = input$Contaminantes)

        )

      }
    }
    else if(input$selectData2 == "Data Climatica"){
      if(input$Select == "calendarPlot"){
        flowLayout(
          sliderInput("rango_calendar",
                      "Rango:",
                      step = 1,
                      min = input$rango[1],
                      max =input$rango[2],
                      value = c(input$rango[1],
                                input$rango[2])),
          radioButtons(inputId = "choices",
                       label = "Parametros",
                       choices = parClimatico)
        )
      }
      else if(input$Select == "smoothTrend"){
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   radioButtons(inputId = "choices",
                                label = "Parametros",
                                choices = parClimatico)
        )
      }
      else if(input$Select == "timePlot"){
        #Deploy un-group for station option
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   selectInput("avgtime","Promedio de tiempo",
                               choices = c("hour","year","month","week",
                                           "day")),
                   checkboxGroupInput(inputId = "choices",
                                      label = "Parametros",
                                      choices = parClimatico,
                                      selected = parClimatico)
        )

      }
      else{
        #Deploy un-group for station option
        flowLayout(checkboxInput("checkSites","Desagrupar por Ciudad"),
                   checkboxGroupInput(inputId = "choices",
                                      label = "Parametros",
                                      choices = parClimatico,
                                      selected = parClimatico)
        )
      }
    }
  })

  #Transform controls for meteorological parameters
  output$grafico<-renderPlot({
    try({

      if(input$selectData2 == "Calidad del aire"){
        if(input$checkSites){
          if(input$Select =="timeVariation")
          {
            #deploy timeVariation of air quality data un-group by site
            openair::timeVariation(data_totalAQ(),
                          pollutant = input$choices,
                          type = "site")
          }
          else if(input$Select=="corPlot"){
            #deploy corPlot of air quality data un-group by site
            openair::corPlot(data_totalAQ(),
                    pollutant = c(input$choices,input$F_Climaticos),
                    type = "site")
          }
          else if(input$Select=="timePlot"){
            #deploy timePlot of air quality data un-group by site
            openair::timePlot(data_totalAQ(),
                     pollutant = input$choices,
                     type = "site",
                     avg.time = input$avgtime)
          }
          else if(input$Select=="polarPlot"){
            #deploy polarPlot of air quality data un-group by site
            openair::polarPlot(data_totalAQ(),
                      pollutant = input$choices,
                      type = "site")
          }
          else if(input$Select=="calendarPlot"){
            #deploy timePlot of air quality data un-group by site
            openair::calendarPlot(data_totalAQ(),
                         pollutant = input$choices,
                         type = "site",
                         year = as.numeric(input$rango_calendar[1]):as.numeric(input$rango_calendar[2]))
          }
          else if(input$Select=="scatterPlot"){
            #deploy scatterPlot of air quality data
            openair::scatterPlot(data_totalAQ(),
                        x = input$x,
                        y= input$y,
                        x.log = input$logx,
                        y.log = input$logy,
                        linear = input$lineal)
          }
          else if(input$Select=="smoothTrend"){
            openair::smoothTrend(data_totalAQ(),
                        pollutant = input$choices,
                        type = "site")
          }
        }else{
          if(input$Select=="timeVariation"){
            #deploy timeVariation of air quality data
            openair::timeVariation(data_totalAQ(), pollutant = input$choices)
          }
          else if(input$Select=="corPlot"){
            #deploy corPlot of air quality data
            openair::corPlot(data_totalAQ(), pollutant = c(input$choices,input$F_Climaticos))
          }
          else if(input$Select=="timePlot"){
            #deploy timePlot of air quality data un-group by site
            openair::timePlot(data_totalAQ(), pollutant = input$choices,
                     avg.time = input$avgtime)
          }
          else if(input$Select=="polarPlot"){
            #deploy polarPlot of air quality data un-group by site
            openair::polarPlot(data_totalAQ(), pollutant = input$choices)
          }
          else if(input$Select=="calendarPlot"){
            #deploy calendarPlot of air quality data un-group by site
            openair::calendarPlot(data_totalAQ(), pollutant = input$choices, year = as.numeric(input$rango_calendar[1]):as.numeric(input$rango_calendar[2]))
          }
          else if(input$Select=="scatterPlot"){
            #deploy scatterPlot of air quality data un-group by site
            openair::scatterPlot(data_totalAQ(),
                        x = input$x,
                        y= input$y,
                        log.x = input$logx,
                        log.y = input$logy,
                        linear = input$lineal)
          }
          else if(input$Select=="smoothTrend"){
            openair::smoothTrend(data_totalAQ(), pollutant = input$choices)

          }
        }
      }
      else if (input$selectData2 == "Data Climatica"){
        if(input$checkSites){
          if(input$Select=="timeVariation"){
            #deploy timeVariation of air quality data un-group by site
            openair::timeVariation(data_totalDC(),
                          pollutant = input$choices, type = "Nombre")
          }
          else if(input$Select=="corPlot"){
            #deploy corPlot of air quality data un-group by site
            openair::corPlot(data_totalDC(),
                    pollutant = input$choices
                    ,type = "Nombre")
          }
          else if(input$Select=="timePlot"){
            #deploy timePlot of air quality data un-group by site
            openair::timePlot(data_totalDC(),
                     pollutant = input$choices
                     ,type = "Nombre",
                     avg.time = input$avgtime)
          }
          else if(input$Select=="calendarPlot"){
            #deploy timePlot of air quality data un-group by site
            openair::calendarPlot(data_totalDC(),
                         pollutant = input$choices
                         ,type = "Nombre", year = as.numeric(input$rango_calendar[1]):as.numeric(input$rango_calendar[2]))
          }
          else if(input$Select=="smoothTrend"){
            openair::smoothTrend(data_totalDC(),
                        pollutant = input$choices
                        ,type = "Nombre")
          }
        }else{
          if(input$Select=="timeVariation"){
            #deploy timeVariation of air quality data
            openair::timeVariation(data_totalDC(), pollutant = input$choices)
          }
          else if(input$Select=="corPlot"){
            #deploy corPlot of air quality data
            openair::corPlot(data_totalDC(), pollutant = input$choices)
          }
          else if(input$Select=="timePlot"){
            #deploy timePlot of air quality data un-group by site
            openair::timePlot(data_totalDC(), pollutant = input$choices, avg.time = input$avgtime)
          }
          else if(input$Select=="calendarPlot"){
            #deploy calendarPlot of air quality data un-group by site
            openair::calendarPlot(data_totalDC(), pollutant = input$choices, year = as.numeric(input$rango_calendar[1]):as.numeric(input$rango_calendar[2]))
          }
          else if(input$Select=="smoothTrend"){
            openair::smoothTrend(data_totalDC(), pollutant = input$choices)
          }

        }
      }
    }, silent = TRUE)
  })

  #Graphics options descriptions
  output$text<-renderUI({
    #Time Variation description
    suppressWarnings({
      if(input$Select=="timeVariation"){
        tags$body(
          tags$h2("timeVariation"),
          tags$p("La función timeVariation produce cuatro gráficos: variación del día
                de la semana, variación de la hora media del día y un gráfico combinado
                de hora del día - día de la semana y un gráfico mensual. También se muestra
                en los gráficos el intervalo de confianza del 95% en la media.")
        )
      }
      else if(input$Select=="corPlot"){
        #Corplot description
        tags$body(
          tags$h2("corPlot"),
          tags$p("El corPlot muestra la correlación codificada de tres
                       formas: por forma (elipses), color y valor numérico. Las
                       elipses se pueden considerar como representaciones
                       visuales de un diagrama de dispersión. Con una correlación
                       positiva perfecta se traza una línea a 45 grados de
                       pendiente positiva. Para una correlación cero, la forma
                       se convierte en un círculo.")
        )
      }
      else if(input$Select=="timePlot"){
        #timePlot description
        tags$body(
          tags$h2("timePlot"),
          tags$p("La función timePlot permite trazar rápidamente
                       series de tiempo de datos para varios contaminantes
                       o variables. Trazara series de tiempo de datos
                       de alta resolución por hora.")
        )
      }
      else if(input$Select=="polarPlot"){
        #polarPlot description
        tags$body(
          tags$h2("polarPlot"),
          tags$p("La función polarPlot traza una gráfica polar bivariada
               de concentraciones. Se muestra como las concentraciones varían
               según la velocidad y la dirección del viento.")
        )
      }
      else if(input$Select=="calendarPlot"){
        #Calendarplot
        tags$body(
          tags$h2("calendarPlot"),
          tags$p("La función calendarPlot proporciona una forma eficaz de
                       visualizar los datos de esta manera al mostrar las
                       concentraciones diarias en formato de calendario. La
                       concentración de una especie se muestra por su color.")
        )
      }
      else if(input$Select=="scatterPlot"){
        #scatterPlot description
        tags$body(
          tags$h2("scatterPlot"),
          tags$p("Los gráficos de dispersión son extremadamente útiles y una
                       técnica de análisis muy utilizada para considerar como las
                       variables se relacionan entre sí."
          )
        )
      }
      else if(input$Select=="smoothTrend"){
        #Corplot description
        tags$body(
          tags$h2("smoothTrend"),
          tags$p("La función smoothTrend proporciona una forma flexible de estimar
               la tendencia en la concentración de un contaminante u otra variable.
               Los valores medios mensuales se calculan a partir de una serie de
               tiempo horaria (o de mayor resolución) o diaria. ")
        )
      }

    })
  })

  output$mainGraphics<-renderUI({
    verticalLayout(
      #Deploy air quality  graphics
      withSpinner(plotOutput("grafico")),
      uiOutput("text")

    )
  })


  ###################################### RESUMEN TAB ###########################

  #  Select dataset
  output$sData <- renderUI({
    selectInput("selectData","Seleccionar dataset",
                choices = c("--Seleccionar--","Data Climatica", "Calidad del aire")
    )
  })

  #Calculate the statistical summary
  stats<-reactive(
    if(input$selectData == "Data Climatica"){
      if(input$statsummary == "Promedio"){
        datamean2(data_totalDC())
      }
      else if(input$statsummary == "Mediana"){
        datamedian2(data_totalDC())
      }
      else if(input$statsummary == "Desviacion Estandar"){
        datasd2(data_totalDC())
      }
      else if(input$statsummary == "coeficiente de variacion"){
        datacv2(data_totalDC())
      }
    }
    else if(input$selectData == "Calidad del aire"){
      if(input$statsummary == "Promedio"){
        datamean(data_totalAQ())
      }
      else if(input$statsummary == "Mediana"){
        datamedian(data_totalAQ())
      }
      else if(input$statsummary == "Desviacion Estandar"){
        datasd(data_totalAQ())
      }
      else if(input$statsummary == "coeficiente de variacion"){
        datacv(data_totalAQ())
      }
    }
  )

  #Build the statistical summary table
  output$statstable <- DT::renderDataTable(
    DT::datatable({stats()},
                  filter = "top",
                  selection = 'multiple',
                  style = 'bootstrap'
    )
  )

  #Download the statistical summary
  output$descargarstats<-downloadHandler(
    filename = "stats.csv",
    content = function(file){
      write.csv(stats(), file)
    }
  )


  #################################INFORMACION TAB##############################

  #Map plot of air quality stations

  output$sitemap<-plotly::renderPlotly({
    siteplot(ChileAirQuality())
  })



  #air quality variables descriptions
  output$info_2 <- renderTable({
    read.csv("varAQ.csv",
             encoding = "UTF-8")
  })

  #data climate variables descriptions
  output$info_3 <- renderTable({
    read.csv("varDC.csv",
             encoding = "UTF-8")
  })


}


#############################################RUN################################
shinyApp(ui = ui, server = server)
