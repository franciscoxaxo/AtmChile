#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(devtools)
#install_github("franciscoxaxo/climateandquality")
library(climateandquality)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("rango",
                        "Rango:",
                        min = 1940,
                        max = 2021,
                        value = c(2000,2020)),
            
        checkboxGroupInput("parametros",
                           label ="Parametros",
                           choices =c("Temperatura", "PuntoRocio", "Humedad",
                                      "Viento", "PresionQFE", "PresionQFF"), 
                           selected = c("Temperatura", "PuntoRocio", "Humedad",
                                        "Viento", "PresionQFE", "PresionQFF")),
        splitLayout(checkboxGroupInput("region1",
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
        submitButton("Aplicar Cambios")
        
        
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        dataTableOutput("table"),
        downloadButton("descargar",label ="Descargar"),
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        )
    )
)))


