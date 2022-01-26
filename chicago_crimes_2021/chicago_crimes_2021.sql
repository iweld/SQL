-- Create the three tables we are going to import of csv data into.

CREATE TABLE CRIMES (
	CRIME_ID serial, 
	CRIME_DATE TIMESTAMP,
	STREET_NAME VARCHAR(100),
	CRIME_TYPE VARCHAR(150),
	CRIME_DESCRIPTION VARCHAR(250),
	LOCATION_DESCRIPTION VARCHAR(150),
	ARREST boolean, 
	DOMESTIC boolean, 
	COMMUNITY_ID int, 
	LATITUDE numeric, 
	LONGITUDE numeric, 
	PRIMARY KEY (CRIME_ID));


CREATE TABLE COMMUNITY (
	AREA_ID int, 
	COMMUNITY_NAME VARCHAR(250),
	POPULATION int, 
	AREA_SIZE numeric, 
	DENSITY numeric, 
	PRIMARY KEY (AREA_ID));


CREATE TABLE WEATHER (
	WEATHER_DATE TIMESTAMP,
	WEEKDAY VARCHAR(20),
	TEMP_HIGH int, 
	TEMP_LOW int, 
	PRECIPITATION numeric, 
	PRIMARY KEY (WEATHER_DATE));
	
-- Copy and insert data from csv files to tables.

COPY CRIMES (
	CRIME_DATE,
	STREET_NAME,
	CRIME_TYPE,
	CRIME_DESCRIPTION,
	LOCATION_DESCRIPTION,
	ARREST,
	DOMESTIC,
	COMMUNITY_ID,
	LATITUDE,
	LONGITUDE)
FROM '* path to * \csv\chicago_crimes_2021.csv'
DELIMITER ',' CSV HEADER;

COPY COMMUNITY (
	AREA_ID, 
	COMMUNITY_NAME,
	POPULATION, 
	AREA_SIZE, 
	DENSITY)
FROM '* path to * \csv\chicago_areas.csv'
DELIMITER ',' CSV HEADER;

COPY WEATHER (
	WEATHER_DATE,
	WEEKDAY,
	TEMP_HIGH, 
	TEMP_LOW, 
	PRECIPITATION)
FROM '* path to * \csv\chicago_temps_2021.csv'
DELIMITER ',' CSV HEADER;

-- How many total crimes were reported in 2021?

select count(crime_id) as "Total Crimes"
from crimes;

-- What is the count of Homicides, Battery and Assualts reported?

select crime_type, count(*)
from crimes
where crime_type in ('homicide', 'battery', 'assault')
group by crime_type
order by count(*) desc;

-- What are the top ten communities that had the most crimes reported?
-- We will also add the current population to see if area density is also a factor.

select co.community_name as Community, co.population, co.density, count(*) as "Reported Crimes"
from community as co
inner join crimes as cr
on cr.community_id = co.area_id
group by co.community_name, co.population, co.density
order by count(*) desc limit 10;

-- What are the top ten communities that had the least amount of crimes reported?
-- We will also add the current population to see if area density is also a factor.

select community_name as Community, co.population, co.density, count(*) as "Reported Crimes"
from community as co
inner join crimes as cr
on cr.community_id = co.area_id
group by community_name, co.population, co.density
order by count(*) limit 10;

-- What month had the most crimes reported?

select extract(MONTH from crime_date), count(*)
from crimes
group by extract(MONTH from crime_date)
order by count(*) desc;

-- What month had the most homicides?

select extract(MONTH from crime_date), count(*)
from crimes
where crime_type = 'homicide'
group by extract(MONTH from crime_date)
order by count(*) desc;

-- What weekday were most crimes committed?

select weekday, count(*)
from weather
inner join crimes
on date(crimes.crime_date) = date(weather.weather_date)
group by weekday
order by count(*) desc;

