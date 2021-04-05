# climateandquality
R package that allows compiling information on air quality parameters and meteorological parameters of Chile from the sites of the National Air Quality System (SINCA) dependent on the Ministry of the Environment and the Meteorological Directorate of Chile (DMC) dependent on the Directorate General of Aeronautic.

Installation from GitHub:

        library(devtools)
        install_github("franciscoxaxo/climateandquality")

Usage:

        library(climateandquality)


## ChileAirQuality
Function that compiles in a data frame air quality data from the National Air Quality System ([SINCA](https://sinca.mma.gob.cl/ "SINCA")).

The function has available the following air quality parameters:

Parameter| Description                                      | Units
---------|--------------------------------------------------|----------
PM10     |Particulate material minor to 10 micron           | ug/m^3^N
PM25     |Particulate material minor to 2,5 micron          | ug/m^3^N 
NOX      |Nitrogen oxides                                   | ppb
NO       |Nitrogen monoxide                                 | ppb
NO2      |Nitrogen dioxide                                  | ppb
O3       |tropospheric ozone                                | ppb
CO       |Carbon monoxide                                   | ppb
temp     |Temperature                                       | °C
ws       |Wind speed                                        | m/s
wd       |Wind direction                                    | °
HR       |Relative humidity                                 | %


The following stations are available:

N° |Code     |Latitude    |Longitude    |Estation         |
---|---------|------------|-------------|-----------------|
1  |     SA  |  -33.4508  |-70.6604     |P. O'Higgins     |
2  |    CE1  |   -33.4795 |  -70.7190   |Cerrillos 1      |
3  |     CE  |  -33.4824  | -70.7039    |Cerrillos        |
4  |     CN  |   -33.4197 |  -70.7317   |Cerro Navia      |
5  |     EB  |   -33.5336 |  -70.6659   | El Bosque       |
6  |     IN  |   -33.4089 |  -70.6508   |Independecia     |
7  |     LF  |   -33.5032 |  -70.5879   |La Florida       |
8  |     LC  |   -33.3634 |  -70.5230   |Las Condes       |
9  |     PU  |   -33.4244 |  -70.7498   |  Pudahuel       |
10 |     PA  |   -33.5779 |  -70.5941   |Puente Alto      |
11 |     QU  |    -33.336 |  -70.7235   | Quilicura       |
12 |    QU1  |   -33.3525 |  -70.7479   |Quilicura 1      |
13 |    COI  |-45.5799    | -72.0610    |Coyhaique I      |
14 |   COII  |-45.5790    | -72.0499    |Coyhaique II     | 
15 |AH       |RI/117|-20.290467|-70.100192|Alto Hospicio|
16 |AR       |RXV/F01|-18.476839|-70.287911|Arica|
17 |TE       |RIX/901|-38.748699|-72.620788|Las Encinas Temuco|
18 |TEII     |RIX/905|-38.727003|-72.580002|Nielol Temuco|
19 |TEIII    |RIX/904|-38.725302|-72.571193| Museo Ferroviario Temuco|
20 |PLCI     |RIX/903|-38.772463|-72.595024|Padre Las Casas I|
21 |PLCII    |RIX/902|-38.764767|-72.598796|Padre Las Casas II|
22 |LU       |RXIV/E04|-40.286857|-73.07671|La Union|
23 |LR       |RXIV/E06|-40.321282|-72.471895|CESFAM Lago Ranco|
24 |MAI      |RXIV/E01|-39.665626|-72.953729|Mafil|
25 |MAII     |RXIV/E05|-39.542346|-72.925205|Fundo La Ribera|
26 |MAIII    |RXIV/E02|-39.719218|-73.128677|Vivero Los Castanos|
27 |VA       |RXIV/E03|-39.831316|-73.228513|Valdivia I|
28 |VAII     |RXIV/E08|-39.805429|-73.25873|Valdivia II|
29 |OS|RX/A01|-40.584479|-73.11872|Osorno|
30 |OSII|RX/A04|-40.683736|-72.596399|Entre Lagos|
31 |PMI|RX/A08|-41.39917|-72.899523|Alerce|
32 |PMII|RX/A07|-41.479507|-72.968756|Mirasol|
33 |PMIII|RX/A02|-41.510342|-73.065294|Trapen Norte|
34 |PMIV|RX/A03|-41.518765|-73.08804|Trapen Sur|
35 |PV|RX/A09|-41.328935|-72.968209|Puerto Varas|
36 |COI|RXI/B03|-45.57993636|-72.06108480|Coyhaique I|
37 |COII|RXI/B04|-45.57904645|-72.04996681| Coyhaique II|
38 |PAr|RXII/C05|-53.158295|-70.921497|Punta Arenas|






### Parameters

**Comunas:** data vector containing the names or codes of the monitoring stations. Available stations: "P. O'Higgins", "Cerrillos 1", "Cerrillos", "Cerro Navia", "El Bosque", "Independecia", "La Florida", "Las Condes", "Pudahuel", "Puente Alto "," Quilicura", "Quilicura 1", "Coyhaique I", "Coyhaique II".To see the table with the monitoring stations use:

        ChileAirQuality()

**Parametros:** data vector containing the names of the air quality parameters. Available parameters: "PM10", "PM25", "CO", "NOX", "NO2", "NO", "O3", "temp" (temperature), "RH" (relative humidity), "ws" ( wind speed),   "wd" (wind direction).

**fechadeInicio:** text string containing the start date of the data request.

**fechadeTermino:** text string containing the end date of the data request.

**Curar:** logical value that activates data curation for particulate matter, nitrogen oxides, relative humidity and wind direction. Default value: TRUE.

**Site:** logical value that allows entering the code of the monitoring station in the variable "Comunas". Default value: FALSE

### Examples:

#### Example 1:

        ChileAirQuality(Comunas = "Cerrillos", Parametros = c("PM10, PM25"), fechadeInicio = "01/01/2020,", fechadeTermino = "01/01/2021", Curar = TRUE, Site = FALSE)
        
#### Example 2:

        ChileAirQuality(Comunas = c("SA", "CE"), Parametros = c("NO2", "O3"), fechadeInicio = "01/01/2020,", fechadeTermino = "01/01/2021", Curar = FALSE, Site = TRUE)
        
### User Interface

The ChileAirQuality function has been implemented in a ShinyApp user interface with graphics functions for air quality analysis (OpenAir and Plotly packages):

[ChileAirQuality ShinyApp](https://chileairquality.shinyapps.io/chileairquality/ "ShinyApp")



## ChileClimateData

Function that compiles climate data from Climate direction of Chile ([DMC](http://www.meteochile.gob.cl/ "DMC")).

The function has available the following climate parameters: Temperature("Temperatura"), dew point("PuntoRocio"), wind direction("Viento"), humidity("Humedad"), Pressure at sea level("PresionQFF") and Pressure at monitoring station level("PresionQFE").

The following stations are available:


N.  | National Code     |                               Name     | Latitude   |Longitude
----|-------------------|----------------------------------------|------------|----------
1   |        180005     |              Chacalluta, Arica Ap.     | -18.35555  |-70.33889
2   |       200006      |         Diego Aracena Iquique Ap.      |-20.54917   |-70.16944
3   |       220002      |                El Loa, Calama Ad.      |-22.49806   |-68.89805
4   |       230001      |      Cerro Moreno Antofagasta Ap.      |-23.45361   |-70.44056
5   |       270001      |       Mataveri Isla de Pascua Ap.      |-27.15889   |-109.42361
6   |       270008      |  Desierto de Atacama, Caldera Ad.      |-27.25444   |-70.77944
7   |       290004      |         La Florida, La Serena Ad.      |-29.91444   |-71.20333
8   |       320041      |     Viña del Mar Ad. (Torquemada)      |-32.94944   |-71.47444
9   |       320051      |                  Los Libertadores      |-32.84555   |-70.11861
10  |        330007     |                     Rodelillo, Ad.     | -33.06528  |-71.55917
11  |        330019     |      Eulogio Sánchez, Tobalaba Ad.     | -33.45528  |-70.54222
12  |        330020     |            Quinta Normal, Santiago     | -33.44500  |-70.67778
13  |        330021     |                  Pudahuel Santiago     | -33.37833  |-70.79639
14  |        330030     |                 Santo Domingo, Ad.     | -33.65611  |-71.61000
15  |        330031     |Juan Fernández, Estación Meteorológica. | -33.63583  |-78.83028
16  |        330066     |       La Punta, Juan Fernández Ad.     |-33.66639   |-78.93194
17  |        330077     |                        El Colorado     |-33.35000   |-70.28805
18  |        330111     |       Lo Prado Cerro San Francisco     |-33.45806   |-70.94889
19  |        330112     |                  San José Guayacán     |-33.61528   |-70.35583
20  |        330113     |                           El Paico     |-33.70639   |-71.00000
21  |        340031     |        General Freire, Curicó Ad.      |-34.96944   |-71.22028
22  |        360011     | General Bernardo O'Higgins, Chillán Ad.| -36.58583  |-72.03389
23  |        360019     |        Carriel Sur, Concepción Ap.     |-36.78055   |-73.05083
24  |        360042     |                  Termas de Chillán     |-36.90361   |-71.40667
25  |        370033     |     María Dolores, Los Angeles Ad.     |-37.39694   |-72.42361
26  |        380013     |               Maquehue, Temuco Ad.     |-38.76778   |-72.62694
27  |        380029     |                   La Araucanía Ad.     |-38.93444   |-72.66083
28  |        390006     |               Pichoy, Valdivia Ad.     |-39.65667   |-73.08472
29  |        400009     |             Cañal Bajo, Osorno Ad.     |-40.61444   |-73.05083
30  |        410005     |         El Tepual Puerto Montt Ap.     |-41.44750   |-73.08472
31  |        420004     |                       Chaitén, Ad.     |-42.93028   |-72.71167
32  |        420014     |                      Mocopulli Ad.     |-42.34667   |-73.71167
33  |        430002     |                      Futaleufú Ad.     |-43.18889   |-71.86417
34  |        430004     |                    Alto Palena Ad.     |-43.61167   |-71.81333
35  |        430009     |                        Melinka Ad.     |-43.89778   |-73.74555
36  |        450001     |                   Puerto Aysén Ad.     |-45.39944   |-72.67778
37  |        450004     |      Teniente Vidal, Coyhaique Ad.     |-45.59083   |-72.10167
38  |        450005     |                      Balmaceda Ad.     |-45.91833   |-71.67778
39  |        460001     |                    Chile Chico Ad.     |-46.58500   |-71.69472
40  |        470001     |                  Lord Cochrane Ad.     |-47.24389   |-72.57611
41  |        510005     |  Teniente Gallardo, Puerto Natales Ad. | -51.66722  |-72.52528
42  |        520006     |    Carlos Ibañez, Punta Arenas Ap.     |-53.00167   |-70.84722
43  |        530005     |     Fuentes Martínez, Porvenir Ad.     |-53.25361   |-70.32194
44  |        550001     |Guardiamarina Zañartu, Pto Williams Ad. |-54.93167   |-67.61000
45  |        950001     |C.M.A. Eduardo Frei Montalva, Antártica |-62.19194   |-58.98278
46  |        950002     |        Arturo Prat, Base Antártica     |-62.47861   |-59.66083
47  |        950003     | Bernardo O`Higgins, Base Antártica     |-63.32083   |-57.89805


### Parameters

**Estaciones:** data vector containing the  codes of the monitoring stations. To see the table with the monitoring stations use:

         ChileClimateData()

**Parametros:** data vector containing the names of the climate parameters. Available parameters: "Temperatura", "PuntoRocio", "Humedad","Viento", "PresionQFE", "PresionQFF".

**inicio:** text string containing the start year of the data request.

**fin:** text string containing the end year of the data request.

### Examples:

#### Example 1:

        ChileClimateData(Estaciones = c("180005", "200006"), Parametros = c("Temperatura", "Humedad", "Viento"), inicio = "2020", fin = "2021")
