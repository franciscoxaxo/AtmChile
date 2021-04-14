#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(climateandquality)
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    inicio <- reactive(input$rango[1])
    fin <- reactive(input$rango[2])
    
    data_total <- reactive(
        ChileClimateData(
            Estaciones = c(input$region1, input$region2),
            Parametros = input$parametros,
            inicio = input$rango[1],
            fin = input$rango[2],
            Region = TRUE
                
        )
        )
    
    

    output$table <- DT::renderDataTable(
        DT::datatable({data_total()},
                      filter = "top",
                      selection = 'multiple',
                      style = 'bootstrap'
        )
    )
    #Boton de descarga
    output$descargar<-downloadHandler(
        filename = "data.csv",
        content = function(file){
            write.csv(data_total(), file)
        }
    )

})
