# AtmChile
R package that allows compiling information on air quality parameters and meteorological parameters of Chile from the sites of the National Air Quality System (SINCA) dependent on the Ministry of the Environment and the Meteorological Directorate of Chile (DMC) dependent on the Directorate General of Aeronautic.

**Installation from GitHub:**

        library(devtools)
        install_github("franciscoxaxo/AtmChile")
        
 **Istallation from CRAN:**
 
        install.packages("AtmChile")
 
        
**Usage:**

        library(AtmChile)


## ChileAirQuality
Function that compiles in a data frame air quality data from the National Air Quality System ([SINCA](https://sinca.mma.gob.cl/ "SINCA")).

The function has available the following air quality parameters:

Parameter| Description                                      | Units
---------|--------------------------------------------------|----------
PM10     |Particulate material minor to 10 micron           | ug/m^{3}N
PM25     |Particulate material minor to 2,5 micron          | ug/m^{3}N
SO2      |Sulfur dioxide                                    | ug/m^{3}N
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

N° |Code      |Latitude    |Longitude    |Estation                  | Ad. division |
---|----------|------------|-------------|--------------------------|--------------|
1  | SA       |  -33.4508  |  -70.6604   | P. O'Higgins             | RM           |
2  | CE1      |   -33.4795 |  -70.7190   | Cerrillos 1              | RM           |
3  | CE       |  -33.4824  |  -70.7039   | Cerrillos                | RM           |
4  | CN       |   -33.4197 |  -70.7317   | Cerro Navia              | RM           |
5  | EB       |   -33.5336 |  -70.6659   | El Bosque                | RM           |
6  | IN       |   -33.4089 |  -70.6508   | Independecia             | RM           |
7  | LF       |   -33.5032 |  -70.5879   | La Florida               | RM           |
8  | LC       |   -33.3634 |  -70.5230   | Las Condes               | RM           |
9  | PU       |   -33.4244 |  -70.7498   | Pudahuel                 | RM           |
10 | PA       |   -33.5779 |  -70.5941   | Puente Alto              | RM           |
11 | QU       |    -33.336 |  -70.7235   | Quilicura                | RM           |
12 | QU1      |   -33.3525 |  -70.7479   | Quilicura 1              | RM           |
15 | AH       |   -20.2904 |  -70.1001   | Alto Hospicio            | I            |
16 | AR       |   -18.4768 |  -70.2879   | Arica                    | XV           |
17 | TE       |   -38.7486 |  -72.6207   | Las Encinas Temuco       | IX           |
18 | TEII     |   -38.7270 |  -72.5800   | Nielol Temuco            | IX           |
19 | TEIII    |   -38.7253 |  -72.5711   | Museo Ferroviario Temuco | IX           |
20 | PLCI     |   -38.7724 |  -72.5950   | Padre Las Casas I        | IX           |
21 | PLCII    |   -38.7647 |  -72.5987   | Padre Las Casas II       | IX           |
22 | LU       |   -40.2868 |  -73.0767   | La Union                 | XIV          |
23 | LR       |   -40.3212 |  -72.4718   | CESFAM Lago Ranco        | XIV          |
24 | MAI      |   -39.6656 |  -72.9537   | Mafil                    | XIV          |
25 | MAII     |   -39.5423 |  -72.9252   | Fundo La Ribera          | XIV          |
26 | MAIII    |   -39.7192 |  -73.1286   | Vivero Los Castanos      | XIV          |
27 | VA       |   -39.8313 |  -73.2285   | Valdivia I               | XIV          |
28 | VAII     |   -39.8054 |  -73.2587   | Valdivia II              | XIV          |
29 | OS       |   -40.5844 |  -73.1187   | Osorno                   | X            |
30 | OSII     |   -40.6837 |  -72.5963   | Entre Lagos              | X            |
31 | PMI      |   -41.3991 |  -72.8995   | Alerce                   | X            |
32 | PMII     |   -41.4795 |  -72.9687   | Mirasol                  | X            |
33 | PMIII    |   -41.5103 |  -73.0652   | Trapen Norte             | X            |
34 | PMIV     |   -41.5187 |  -73.0880   | Trapen Sur               | X            |
35 | PV       |   -41.3289 |  -72.9682   | Puerto Varas             | X            |
36 | COI      |   -45.5799 |  -72.0610   | Coyhaique I              | XI           |
37 | COII     |   -45.5790 |  -72.0499   | Coyhaique II             | XI           |
38 | PAR      |   -53.1582 |  -70.9214   | Punta Arenas             | XII          |






### Parameters

**Comunas:** data vector containing the names or codes of the monitoring stations. Available stations: "P. O'Higgins", "Cerrillos 1", "Cerrillos", "Cerro Navia", "El Bosque", "Independecia", "La Florida", "Las Condes", "Pudahuel", "Puente Alto "," Quilicura", "Quilicura 1", "Coyhaique I", "Coyhaique II".To see the table with the monitoring stations use:

        ChileAirQuality()

**Parametros:** data vector containing the names of the air quality parameters. Available parameters: "PM10", "PM25", "CO", "NOX", "NO2", "NO", "O3", "SO2", "temp" (temperature), "RH" (relative humidity), "ws" ( wind speed),   "wd" (wind direction).

**fechadeInicio:** text string containing the start date of the data request.

**fechadeTermino:** text string containing the end date of the data request.

**Curar:** logical value that activates data curation for particulate matter, nitrogen oxides, relative humidity and wind direction. Default value: TRUE.

**Site:** logical value that allows entering the code of the monitoring station in the variable "Comunas". Default value: FALSE.

### Examples:

#### Example 1:

        ChileAirQuality(Comunas = "Cerrillos", Parametros = c("PM10, PM25"), fechadeInicio = "01/01/2020,", fechadeTermino = "01/01/2021", Curar = TRUE, Site = FALSE)
        
#### Example 2:

        ChileAirQuality(Comunas = c("SA", "CE"), Parametros = c("NO2", "O3"), fechadeInicio = "01/01/2020,", fechadeTermino = "01/01/2021", Curar = FALSE, Site = TRUE)
        


## ChileClimateData

Function that compiles climate data from Climate direction of Chile ([DMC](http://www.meteochile.gob.cl/ "DMC")).

The function has available the following climate parameters: Temperature("Temperatura"), dew point("PuntoRocio"), wind direction("Viento"), humidity("Humedad"), Pressure at sea level("PresionQFF") and Pressure at monitoring station level("PresionQFE").

The following stations are available:


N.  | National Code     |                               Name     | Latitude   |Longitude  | Ad. division |
----|-------------------|----------------------------------------|------------|-----------|--------------|
1   |        180005     |              Chacalluta, Arica Ap.     | -18.35555  |-70.33889  | XV
2   |       200006      |         Diego Aracena Iquique Ap.      |-20.54917   |-70.16944  | I
3   |       220002      |                El Loa, Calama Ad.      |-22.49806   |-68.89805  | II
4   |       230001      |      Cerro Moreno Antofagasta Ap.      |-23.45361   |-70.44056  | II
5   |       270001      |       Mataveri Isla de Pascua Ap.      |-27.15889   |-109.42361 | V
6   |       270008      |  Desierto de Atacama, Caldera Ad.      |-27.25444   |-70.77944  | III
7   |       290004      |         La Florida, La Serena Ad.      |-29.91444   |-71.20333  | IV
8   |       320041      |     Viña del Mar Ad. (Torquemada)      |-32.94944   |-71.47444  | V
9   |       320051      |                  Los Libertadores      |-32.84555   |-70.11861  | V
10  |        330007     |                     Rodelillo, Ad.     | -33.06528  |-71.55917  | V
11  |        330019     |      Eulogio Sánchez, Tobalaba Ad.     | -33.45528  |-70.54222  | RM
12  |        330020     |            Quinta Normal, Santiago     | -33.44500  |-70.67778  | RM
13  |        330021     |                  Pudahuel Santiago     | -33.37833  |-70.79639  | RM
14  |        330030     |                 Santo Domingo, Ad.     | -33.65611  |-71.61000  | V
15  |        330031     |Juan Fernández, Estación Meteorológica. | -33.63583  |-78.83028  | V
16  |        330066     |       La Punta, Juan Fernández Ad.     |-33.66639   |-78.93194  | V
17  |        330077     |                        El Colorado     |-33.35000   |-70.28805  | RM
18  |        330111     |       Lo Prado Cerro San Francisco     |-33.45806   |-70.94889  | RM
19  |        330112     |                  San José Guayacán     |-33.61528   |-70.35583  | RM
20  |        330113     |                           El Paico     |-33.70639   |-71.00000  | RM
21  |        340031     |        General Freire, Curicó Ad.      |-34.96944   |-71.22028  | VII
22  |        360011     | General Bernardo O'Higgins, Chillán Ad.| -36.58583  |-72.03389  | XVI
23  |        360019     |        Carriel Sur, Concepción Ap.     |-36.78055   |-73.05083  | VIII
24  |        360042     |                  Termas de Chillán     |-36.90361   |-71.40667  | XVI
25  |        370033     |     María Dolores, Los Angeles Ad.     |-37.39694   |-72.42361  | VIII
26  |        380013     |               Maquehue, Temuco Ad.     |-38.76778   |-72.62694  | IX
27  |        380029     |                   La Araucanía Ad.     |-38.93444   |-72.66083  | IX
28  |        390006     |               Pichoy, Valdivia Ad.     |-39.65667   |-73.08472  | XIV
29  |        400009     |             Cañal Bajo, Osorno Ad.     |-40.61444   |-73.05083  | X
30  |        410005     |         El Tepual Puerto Montt Ap.     |-41.44750   |-73.08472  | X
31  |        420004     |                       Chaitén, Ad.     |-42.93028   |-72.71167  | X
32  |        420014     |                      Mocopulli Ad.     |-42.34667   |-73.71167  | X
33  |        430002     |                      Futaleufú Ad.     |-43.18889   |-71.86417  | X
34  |        430004     |                    Alto Palena Ad.     |-43.61167   |-71.81333  | X
35  |        430009     |                        Melinka Ad.     |-43.89778   |-73.74555  | X
36  |        450001     |                   Puerto Aysén Ad.     |-45.39944   |-72.67778  | XI
37  |        450004     |      Teniente Vidal, Coyhaique Ad.     |-45.59083   |-72.10167  | XI
38  |        450005     |                      Balmaceda Ad.     |-45.91833   |-71.67778  | XI
39  |        460001     |                    Chile Chico Ad.     |-46.58500   |-71.69472  | XI
40  |        470001     |                  Lord Cochrane Ad.     |-47.24389   |-72.57611  | XI
41  |        510005     |  Teniente Gallardo, Puerto Natales Ad. | -51.66722  |-72.52528  | XII
42  |        520006     |    Carlos Ibañez, Punta Arenas Ap.     |-53.00167   |-70.84722  | XII
43  |        530005     |     Fuentes Martínez, Porvenir Ad.     |-53.25361   |-70.32194  | XII
44  |        550001     |Guardiamarina Zañartu, Pto Williams Ad. |-54.93167   |-67.61000  | XII
45  |        950001     |C.M.A. Eduardo Frei Montalva, Antártica |-62.19194   |-58.98278  | XII
46  |        950002     |        Arturo Prat, Base Antártica     |-62.47861   |-59.66083  | XII
47  |        950003     | Bernardo O`Higgins, Base Antártica     |-63.32083   |-57.89805  | XII
 

### Parameters

**Estaciones:** data vector containing the  codes of the monitoring stations. To see the table with the monitoring stations use:

         ChileClimateData()

**Parametros:** data vector containing the names of the climate parameters. Available parameters: "Temperatura", "PuntoRocio", "Humedad","Viento", "PresionQFE", "PresionQFF".

**inicio:** text string containing the start year of the data request.

**fin:** text string containing the end year of the data request.

**Region:** logical parameter. If region is true it allows to enter the administrative region in which the station is located instead of the station code.

### Examples:

#### Example 1:

        ChileClimateData(Estaciones = c("180005", "200006"), Parametros = c("Temperatura", "Humedad", "Viento"), inicio = "2020", fin = "2021")
        
#### Example 2:
        ChileClimateData(Estaciones = "II", Parametros = "Temperatura", inicio = "2020", fin = "2021", Region = TRUE)
        
## User Interface

The ChileAirQuality function and the ChileClimateData has been implemented in a ShinyApp user interface with graphics functions for air quality analysis (OpenAir and Plotly packages):

[ChileAirQuality ShinyApp](https://chileairquality.shinyapps.io/chileairquality/ "ShinyApp")





