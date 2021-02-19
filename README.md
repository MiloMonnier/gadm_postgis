## Description

The purpose of this project is to create a PostGIS local database containing all possible administrative divisions of all countries of the world. Then this database can be accessed through all your GIS softwares without internet connexion : QGIS ArcGIS, R, etc.


## Why a PostGIS database ?

When I produce a map of a country or a region, I prefer to put this latter into its geographical context. For example, rather than plotting France alone as an island, I prefer to plot also the border countries. Sometimes, especially for statistical maps at different scales, I even plot the region (or states) borders of the other countries, and I want all the geometries to match.

I you use R to produce maps like me, you can use the [rnaturalearth](https://github.com/ropensci/rnaturalearth) package to download your data and plot it in R. It's simple and can meet your needs. But if you make statistical maps and need spatial divisions with administrative codes to join your own data, most of time, rnaturalearth data won't do the job. 

In terms of administrative codes, the Global Administrative Areas ([GADM](https://gadm.org/index.html)) database, developped by Robert Hijmans from University of California, is the most complete database containing all world countries I ever found. The website allows to download each country separately (recommended), or the whole world data at once. The [GADMTools](https://github.com/Epiconcept-Paris/GADMTools) package, developped by Jean-Pierre Decorps from Epiconcept, allows to download GADM data directly in R, such as the raster package with [getData](https://www.rdocumentation.org/packages/raster/versions/3.4-5/topics/getData) function.

However, if you use the lazy method and re-download the data each time you source your script, you will need a good internet connexion. So you need to previously download and store the data in your directory before using it ... not very convenient. When I was working in Senegal, the internet connexion of my office was very slow, and we were often facing power cuts of several hours. Thus, I looked for a method to access easily all administrative data without internet connexion. 

To summarize, this method has several advantages :

+ You don't need to download separately each country administrative file.
+ You won't need any internet connexion to access your data.
+ You have most of administrative divisions codes.
+ All geometries match.


## Process

First, we download the world data from GADM in GeoPackage format. For each country, GADM data is divided in 6 levels. Example with France :

+ level 0 : Country external border
+ level 1 : Regions
+ level 2 : Departments
+ level 3 : Arrondissements
+ level 4 : Cantons
+ level 5 : Communes

If the country has less than 6 administrative levels, smaller mesh inherits geography of wider mesh. Example with United States :

+ level 0 : Country external border
+ level 1 : States
+ level 2 : Counties
+ level 3 : Counties
+ level 4 : Counties
+ level 5 : Counties

However, the data downloaded contains only 1 table with the smaller mesh, the level 5. In order to have different ready-to-use administrative geometries, we aggregate successively each level with `St_Union` PostGIS function.

In the end, we have a database of 6 tables which can be queried easily.


## Other possible data sources

Beyond GADM and naturalearth data mentionned here, other database can be explored to make statistical mapping.


### R-focused

+ The [rgeoboundaries](https://github.com/wmgeolab/rgeoboundaries) package 
+ The [giscoR](https://dieghernan.github.io/giscoR/) package, using [Eurostat](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/countries) data.

### Africa
+ Check the [Humanitarian Data Exchange](https://data.humdata.org/)
+ Check also the [GeoNode](https://geonode.wfp.org/layers/geonode%3Aadm1_gaul_2015) data.

