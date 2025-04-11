[![](https://www.r-pkg.org/badges/version/AtmChile?color=green)](https://cran.r-project.org/package=AtmChile)
![](https://github.com/franciscoxaxo/AtmChile/actions/workflows/r.yml/badge.svg)
![](https://cranlogs.r-pkg.org/badges/grand-total/AtmChile)

# AtmChile
R package that allows compiling information on air quality parameters and meteorological parameters of Chile from the sites of the National Air Quality System (SINCA) dependent on the Ministry of the Environment and the Meteorological Directorate of Chile (DMC) dependent on the Directorate General of Aeronautic.

Project developed by the Department of Chemistry, Faculty of Sciences of the University of Chile. FONDECYT Project 1200674.

**Installation from GitHub:**

        library(devtools)
        install_github("franciscoxaxo/AtmChile")
        

**Installation from CRAN:**

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

Code      |Latitude    |Longitude    |Estation                  | Ad. division |
----------|------------|-------------|--------------------------|--------------|
SA        |-33.450819  | -70.6604476  | Parque O'Higgins | RM
CEII      | -33.479515 | -70.719064 | Cerrillos 1 | RM
CEI       |-33.482411  | -70.703947 | Cerrillos | RM
CN        |-33.419725  | -70.73179 | Cerro Navia | RM
EB        | -33.533626 | -70.665906 | El Bosque | RM
IN        | -33.40892 | -70.650886 | Independencia | RM
LF        |  -33.503288 | -70.587916 | La Florida | RM
LC        |-33.363453 | -70.523024 | Las Condes | RM
PU        | -33.424439 | -70.749876 | Pudahuel | RM
PA        | -33.577948 | -70.594184 | Puente Alto | RM
QU        | -33.33632 | -70.723583 | Quilicura | RM
QUI       | -33.352539 | -70.747952 | Quilicura 1 | RM
TAL       | -33.674 | -70.953 | Talagante | RM
AH        | -20.290467 | -70.100192 | Alto Hospicio | I
AR        |  -18.476839 | -70.287911 | Arica | XV
TE        | -38.748699 | -72.620788 | Las Encinas Temuco | IX
TEII      |  -38.727003 | -72.580002 | Nielol Temuco | IX
TEIII     | -38.725302 | -72.571193 | Museo Ferroviario Temuco | IX
PLCI      | -38.772463 | -72.595024 | Padre Las Casas I | IX
PLCII     |  -38.764767 | -72.598796 | Padre Las Casas II | IX
LU        |-40.286857 | -73.07671 | La Union | XIV
LR        |  -40.321282 | -72.471895 | CESFAM Lago Ranco | XIV
MAI       |  -39.665626 | -72.953729 | Mafil | XIV
MAII      |  -39.542346 | -72.925205 | Fundo La Ribera | XIV
MAIII     | -39.719218 | -73.128677 | Vivero Los Castanos | XIV
VA        |  -39.831316 | -73.228513 | Valdivia I | XIV
VAII      |  -39.805429 | -73.25873 | Valdivia II | XIV
OS        | -40.584479 | -73.11872 | Osorno | X
OSII      |  -40.683736 | -72.596399 | Entre Lagos | X
PMI       | -41.39917 | -72.899523 | Alerce | X
PMII      |  -41.479507 | -72.968756 | Mirasol | X
PMIII     | -41.510342 | -73.065294 | Trapen Norte | X
PMIV      | -41.518765 | -73.08804 | Trapen Sur | X
PV        | -41.328935 | -72.968209 | Puerto Varas | X
VI        |  -45.404 | -66.687 | Vialidad | XI
COI       |  -45.57993636 | -72.0610848 | Coyhaique I | XI
COII      |  -45.57904645 | -72.04996681 | Coyhaique II | XI
PAR       | -53.158295 | -70.921497 | Punta Arenas | XII
TOCI      |  -22.06 | -70.187 | Tres Marias | II
TOCII     |  -22.086 | -70.188 | Super Site | II
TOCIII    |  -22.09 | -70.199 | Gobernacion | II
TOCIV     |  -22.108 | -70.209 | Bomberos | II
ANTI      | -23.614 | -70.383 | Antofagasta | II
ANTII     |  -23.674 | -70.407 | Playa Blanca | II
ANTIII    |  -23.612 | -70.381 | Rendic | II
ANTIV     | -23.833 | -70.309 | Sur | II
CALI      |  -22.342 | -68.651 | Chiu Chiu | II
CALII     |  -22.46 | -68.938 | Club Deportivo 23 de Marzo | II
CALIII    |  -22.442 | -68.933 | Colegio Pedro Vergara Keller | II
CALIV     |  -22.462 | -68.928 | Estacion Centro | II
CALV      |  -22.454 | -68.91 | Hospital el Cobre | II
CALVI     |  -22.343 | -68.649 | Nueva ChiuChiu | II
CALVII    |  -22.464 | -68.921 | Oasis | II
CALVIII   | -22.461 | -68.948 | Servicio Medico Legal | II
CALIX     |  -22.321 | -68.937 | Aukahuasi | II
CALX      |  -22.315 | -68.93 | San Jose | II
CALXI     |  -22.475 | -68.928 | Villa Caspana | II
MELI      |  -22.454 | -68.91 | Hospital | II
MELII     |  -22.345 | -69.661 | Iglesia | II
MEJI      |  -23.102 | -70.445 | Jardin Infantil Integra | II
MEJII     | -23.105 | -70.442 | Juan Jose Latorre | II
MEJIII    |  -23.1 | -70.45 | Compania de Bomberos | II
MEJIV     |  -23.098 | -70.463 | Ferrocarriles | II
SGO       |  -22.89 | -69.319 | Sierra Gorda | II
TALI      |  -25.007 | -70.463 | Paposo | II
TALII     |  -24.983 | -70.461 | Punto de Maximo Impacto | II
TOCI      |  -22.086 | -70.189 | Escuela E-10 | II
TOCII     |-22.094 | -70.197 | Centro | II
TOCIII    |  -22.089 | -70.195 | Escuela E-12 | II
TOCIV     |  -22.094 | -70.197 | Escuela Gabriela Mistral | II
TOCV      |-22.107 | -70.214 | Sur | II
COPI      |  -27.37 | -70.323 | Copiapo Sivica | III
COPII     |  -27.36 | -70.33 | Copiapo | III
COPIII    | -27.37 | -70.304 | Los Volcanes | III
COPIV     | -27.411 | -70.269 | Paipote | III
COPV      | -27.393 | -70.299 | San Fernando | III
DALI      |  -26.423 | -69.507 | CAP | III
DALII     |  -26.433 | -69.481 | Dona Ines | III
FREI      |  -28.504 | -71.127 | SM6 | III
FREII     | -28.498 | -71.096 | SM7 | III
FREIII    |  -28.508 | -71.081 | SM8 | III
HUAI      |  -28.47 | -71.22 | Huasco Sivica | III
HUAII     |  -28.468 | -71.227 | 21 de Mayo | III
HUAIII     |  -28.466 | -71.222 | EME F | III
HUAIV     |  -28.47 | -71.219 | EME M | III
HUAV      |  -28.465 | -71.257 | EME ME | III
HUAVI     |  -28.467 | -71.231 | Huasco II | III
HUAVII    |  -28.501 | -71.254 | SM1 | III
HUAVIII   |  -28.462 | -71.181 | SM2 | III
HUAIX     |  -28.472 | -71.178 | SM3 | III
HUAX      |  -28.481 | -71.167 | SM4 | III
HUAXI     | -28.484 | -71.146 | SM5 | III
TAMI      | -27.475509 | -70.265893 | Tierra Amarilla | III
TAMII     |  -27.658 | -70.235 | Pabellon | III
ANDI      |-30.228 | -71.086 | Andacollo | IV
ANDII     |  -30.252 | -71.082 | Chepiquilla | IV
ANDIII    | -30.233 | -71.094 | El Sauce | IV
ANDIV     |  -30.228 | -71.086 | Hospital | IV
ANDV      | -30.236 | -71.084 | Urmeneta - Plaza Centenario | IV
COQI      | -29.971 | -71.336 | Coquimbo | IV
COQII     | -29.92 | -71.256 | La Serena | IV
LVI       | -31.928 | -71.137 | Caimanes | IV
LVII      | -31.819 | -70.581 | Chacay | IV
LVIII     | -31.974 | -71.01 | El Mauro | IV
LVIV      | -83.85 | -89.132 | Punta Chungo | IV
SLMI      | -31.889 | -70.629 | Cuncumen | IV
SLMII     | -31.881 | -70.955 | Camisas | IV
SLMIII     | -31.805 | -74.279 | Coiron | IV
SLMIV 1   | -31.781 | -70.533 | Hotel Mina | IV
SLMV      | -31.895 | -70.836 | Quelen Alto | IV
CALEI     | -32.847 | -71.225 | "La Cruz   Colbun" | V
CALEII     | -32.782 | -71.19 | La Calera | V
CALEIII   | -32.749 | -72.246 | Rural 1 | V
CATEI     | -32.779 | -70.959 | Catemu | V
CATEII    | -32.824 | -71.006 | Romeral | V
CATEIII   | -32.777 | -70.938 | Santa Margarita | V
CCNI      | -32.926243 | -71.512461 | Concon MMA | V
CCNII  | -32.921 | -71.44 | Colmo | V
CCNIII | -32.925 | -71.515 | Concon | V
CCNIV | -32.935 | -71.525 | Junta de Vecinos | V
CCNV |-32.916 | -71.481 | Las Gaviotas | V
CCNVI | -32.933 | -71.528 | Concon Sur | V
LCZ | -32.813 | -71.227 | "La Cruz   Melon" | V
LAN  |-32.846 | -70.586 | Los Andes | V
LCA |-32.798 | -70.898 | Lo Campo | V
PCHI | -32.719 | -71.407 | Puchuncavi | V
PCHII  | -32.736 | -71.451 | Campiche | V
PCHIII  | -32.748 | -71.474 | La Greda | V
PCHIV | -32.764 | -71.455 | Los Maitenes | V
PCHV  | -31.841 | -71.456 | Ventanas | V
PCHVI  | -32.751 | -71.48 | Terminal Concentrados | V
QLLI  | -32.886 | -71.247 | Cuerpo de Bomberos | V
QLLII | -32.891794 | -71.208638 | La Palma | V
QLLIII  | -32.937 | -71.274 | San Pedro | V
QLLIV  | -32.913 | -71.372 | Manzanar | V
QLPI | -33.047 | -71.435 | Quilpue | V
QLPII | -33.039 | -71.429 | ARMAT | V
QNTI | -32.788 | -71.532 | Centro Quintero | V
QNTII | -32.795 | -71.496 | Loncura | V
QNTIII  | -32.772516 | -71.535303 | Quintero | V
QNTIV  | -32.801 | -71.483 | Sur | V
QNTV  | -32.808 | -71.436 | Valle Alegre | V
VPO  | -33.05 | -71.614 | Valparaiso | V
VNA  | -33.02 | -71.55 | Vina del Mar | V
CDE  | -34.032 | -76.66 | Codegua | VI
MCHI  | -34.245 | -76.556 | Cauquenes | VI
MCHII| -34.262 | -76.463 | Cipreses | VI
MCHIII  | -34.204 | -76.53 | Coya PoblaciOn | VI
MCHIV | -34.084 | -76.382 | Sewell | VI
MSTI  | -33.954 | -76.639 | Casas de Peuco | VI
MSTII | -33.981 | -76.704 | San Francisco de Mostazal | VI
RGAI  | -34.162 | -76.714 | Rancagua I | VI
RGAII  | -34.144 | -76.737 | Rancagua II | VI
RNG | -34.395 | -76.853 | Rengo | VI
RQNI  | -34.214 | -76.751 | MVC | VI
RQNII | -34.328 | -76.793 | Totihue | VI
SFDO  | -34.58 | -76.99 | San Fernando | VI
CQN | -35.965 | -72.317 | Cauquenes Sivica | VII
CRCI  | -34.975 | -77.234 | Curicó | VII
CRCII  | -34.972 | -77.23 | El Boldo | VII
LIN  | -35.837 | -77.593 | Linares | VII
TALI  | -35.435 | -77.678 | La Florida | VII
TALII  | -35.436 | -77.619 | U.C. Maule | VII
TALIII | -35.407 | -77.633 | Universidad de Talca | VII
TNOI | -34.868 | -77.164 | "Teno   CEMENTOS BIO BIO" | VII
TNOII  | -34.862 | -77.131 | "Teno   ENLASA" | VII
CBR | -37.024 | -72.266 | Colicheu | VIII
CHYI | -36.923 | -73.036 | Punteras | VIII
CHYII | -36.913 | -73.036 | "Meteorológica   Chiguayante" | VIII
CHLI | -36.595 | -72.089 | "INIA   Chillán" | VIII
CHLII | -36.616 | -72.093 | Puren | VIII
CONC  | -36.785 | -73.052 | Kingston College | VIII
CNELI  | -37.021 | -73.15 | Cerro Merquín | VIII
CNELII  | -36.999 | -73.104 | Calabozo | VIII
CNELIII  | -37.009 | -73.15 | Coronel Norte | VIII
CNELIV  | -37.032 | -73.139 | Coronel Sur | VIII
CNELV  | -36.954 | -73.151 | "Escuadron   ENEL" | VIII
CNELVI  | -36.934 | -73.153 | "Escuadron  ENESA" | VIII
CNELVII | -36.984 | -73.153 | "Lagunillas  ENEL" | VIII
CNELVIII | -37.1 | -73.152 | Lota rural | VIII
CNELIX  | -37.074 | -73.145 | Lota urbana | VIII
CNH | -37.485 | -73.332 | Balneario Curanilahue | VIII
HPNI | -36.803 | -73.12 | Bocatoma | VIII
HPNII  | -36.791 | -73.119 | ENAP Price | VIII
HPNIII  | -36.781 | -73.116 | JUNJI | VIII
HQI  | -36.977 | -72.932 | Hualqui | VIII
LAJ | -37.268 | -72.711 | Laja | VIII
LAI | -37.471 | -72.361 | 21 de mayo | VIII
LAII  | -37.463 | -72.325 | Los Ángeles Oriente | VIII
LAIII  | -37.464 | -72.362 | CESFAM   Los Ángeles | VIII
NACI  | -37.502 | -72.676 | Club de Empleados | VIII
NACII  | -37.504 | -72.66 | Entre Ríos | VIII
NACIII  | -37.509 | -72.656 | Lautaro | VIII
QLLI | -36.684 | -72.465 | Cayumanqui | VIII
QLLII  | -36.742 | -72.475 | Quillón | VIII
RQL  | -36.652 | -72.455 | Nueva Aldea | VIII
SCA  | -36.527 | -72.07 | San Carlos | VIII
SPP  | -36.867 | -73.141 | MASISA Mapal | VIII
THNI  | -36.724 | -73.124 | Consultorio - San Vicente | VIII
THNII  | -36.717 | -79.111 | Libertad | VIII
THNIII  | -36.722 | -73.123 | San Vicente  Bomberos | VIII
THNIV  | -36.77 | -73.114 | Indura | VIII
THNV  | -36.737 | -73.104 | Inpesca | VIII
THNVI | -36.736 | -73.119 | Nueva Libertad | VIII
TME| -36.602 | -72.959 | Liceo Polivalente | VIII






### Parameters

**Comunas:** data vector containing the names or codes of the monitoring stations. Available stations: "P. O'Higgins", "Cerrillos 1", "Cerrillos", "Cerro Navia", "El Bosque", "Independecia", "La Florida", "Las Condes", "Pudahuel", "Puente Alto "," Quilicura", "Quilicura 1", "Coyhaique I", "Coyhaique II".To see the table with the monitoring stations use:

        ChileAirQuality()

**Parametros:** data vector containing the names of the air quality parameters. Available parameters: "PM10", "PM25", "CO", "NOX", "NO2", "NO", "O3", "SO2", "temp" (temperature), "RH" (relative humidity), "ws" ( wind speed),   "wd" (wind direction).

**fechadeInicio:** text string containing the start date of the data request.

**fechadeTermino:** text string containing the end date of the data request.

**Curar:** logical value that activates data curation for particulate matter, nitrogen oxides, relative humidity and wind direction. Default value: TRUE.

**Site:** logical value that allows entering the code of the monitoring station in the variable "Comunas". Default value: FALSE.

**st:** logical value that includes validation reports from S.I.N.C.A. "NV": No validated, "PV": Pre-validated and "V": Validated. Default value: FALSE.

### Examples:

#### Example 1:

        ChileAirQuality(Comunas = "Cerrillos", Parametros = c("PM10", "PM25"), fechadeInicio = "01/01/2020", fechadeTermino = "01/01/2021", Curar = TRUE, Site = FALSE)
        
#### Example 2:

        ChileAirQuality(Comunas = c("SA", "CE"), Parametros = c("NO2", "O3"), fechadeInicio = "01/01/2020", fechadeTermino = "01/01/2021", Curar = FALSE, Site = TRUE)
        
#### Example 3:

        ChileAirQuality(Comunas = c("SA", "CE"), Parametros = c("NO2", "O3"), fechadeInicio = "01/01/2020", fechadeTermino = "01/01/2021", Curar = FALSE, Site = TRUE, st = TRUE)

#### Example 4:

        ChileAirQuality(Comunas = "all", Parametros = "all", fechadeInicio = "01/01/2020", fechadeTermino = "01/01/2021", Curar = FALSE, Site = TRUE, st = TRUE)


## ChileClimateData

Function that compiles climate data from Climate direction of Chile ([DMC](https://www.meteochile.gob.cl/ "DMC")).

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
        

## ChileAirQualityApp

ChileAirQualityApp is a dashboard that allows you to use the data download functions of this package enhanced with analysis, visualization and descriptive statistics tools.

        ChileAirQualityApp()

This dashboard is also hosted online on shinyapps.io:

[ChileAirQualityApp](https://chileairquality.shinyapps.io/chileairquality/ "ChileAirQualityApp")
