/*Cleaning data LOG - 
	1)Deleting Null and Duplicate values in the Primary Key - ride_ID
	2)The station ID values had inconsistent formatting, which was corrected. 
	2)Remove headers resulting from compilation (12 Rows)
	3)DROPPING Columns - Start and End lattitude and Longitude - because Irrelavent
	5)DELETED data where start time was greater than the end time		
*/
-- Delete Queries 

ALTER TABLE bike_data
DROP COLUMN Start_lat, End_lat, Start_lng, End_lng;

DELETE 
FROM 
	bike_data
WHERE 
	ride_id is null 
AND ride_id = 'ride_id'; -- resulting from compilation

DELETE
FROM 
	bike_data
WHERE 
	Started_at > Ended_at; -- does not make sense

### Checking integrity of the data and exploring the data

--1 Types of Members 
SELECT DISTINCT 
	member_casual 
FROM 
	bike_data;
-- Two types of members - Ok

--2 Date Range
SELECT DISTINCT 
	Extract(YEAR_MONTH from started_at) 
FROM 
	bike_data;
-- Data range - 2021 (Jan to Dec) - Ok

--3 start station count
SELECT 
	count(DISTINCT start_station_id),
	TRIM(start_station_name)
FROM 
	bike_data
WHERE start_station_id <> '' AND start_station_name <> ''
ORDER by 
	start_station_name;

--4 End station count
SELECT 
	count(DISTINCT end_station_id),
	TRIM(end_station_name)
FROM 
	bike_data
WHERE end_station_id <> '' AND end_station_name <> ''
ORDER by 
	start_station_name;
-- 845 end stations

--5 Rideable types
SELECT distinct
	rideable_type
FROM 
	bike_data;
-- There are three types of bikes - ok

-- Create Queries 
-- To make queries faster I divided the dataset into two parts 1)member data 2)casual data
CREATE TABLE  member_data AS 
SELECT * from bike_data where member_casual like  '%member%';

CREATE TABLE  casual_data AS 
SELECT * from bike_data where member_casual like  '%casual%';
