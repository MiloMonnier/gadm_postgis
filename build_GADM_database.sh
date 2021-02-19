# Get the latest download link on https://gadm.org/download_world.html
wget -nc https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_gpkg.zip
unzip gadm36_gpkg.zip


host='localhost'
port='5432'
db='gadm'
user='milo'
psswd='postgres'

# Create a new database "gadm"
psql -U ${user} -d postgres -c "CREATE DATABASE ${db};"
psql -U ${user} -d ${db} -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Import the geopackage file into the database
PGIDS="dbname=${db} host=${host} port=${port} user=${user} password=${psswd}"
ogr2ogr -f PostgreSQL PG:"${PGIDS}" gadm36.gpkg

# Create a test database (here, Senegal and Guinea) and check it with QGIS for example
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadmtest;
	CREATE TABLE gadmtest AS
	SELECT * FROM gadm 
		WHERE gid_0 IN ('SEN','GIN');
"

# Create 5 different tables at 5 administrative levels of aggregation

# 0 - country scale
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_0;
	CREATE TABLE gadm_0 AS
	SELECT
		gid_0, name_0,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY 
		gid_0, name_0;
"

# 1st administrative level (regions, in most of cases)
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_1;
	CREATE TABLE gadm_1 AS
	SELECT
		gid_0, name_0,
	    gid_1, name_1, engtype_1,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY 
		gid_0, name_0,
		gid_1, name_1, engtype_1;
"

# 2nd administrative level
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_2;
	CREATE TABLE gadm_2 AS
	SELECT
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2;
"

# 3rd administrative level
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_3;
	CREATE TABLE gadm_3 AS
	SELECT
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3;
"

# 4th administrative level
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_4;
	CREATE TABLE gadm_4 AS
	SELECT
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3,
		gid_4, name_4, engtype_4,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3,
		gid_4, name_4, engtype_4;
"


# 5th administrative level
psql -U ${user} -d ${db} -c "
	DROP TABLE IF EXISTS gadm_5;
	CREATE TABLE gadm_5 AS
	SELECT
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3,
		gid_4, name_4, engtype_4,
		gid_5, name_5, engtype_5,
	    ST_Union(wkb_geometry) AS geom
	FROM gadm
	GROUP BY
		gid_0, name_0,
		gid_1, name_1, engtype_1,
		gid_2, name_2, engtype_2,
		gid_3, name_3, engtype_3,
		gid_4, name_4, engtype_4,
		gid_5, name_5, engtype_5;
"

# Don't create spatial index
# Don't check geometry validity