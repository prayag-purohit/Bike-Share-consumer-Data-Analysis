--1 Count the number of rides by each type of members
SELECT 
	count(ride_id) as number_of_rides, 
    member_casual
FROM 
	bike_data
GROUP BY 
	member_casual;

#2 Average duration of rides by member type 
SELECT 
	member_casual, 
	SEC_TO_TIME(ABS((AVG(TIMESTAMPDIFF(SECOND,ended_at,started_at))))) as duration
FROM 
	bike_data
GROUP BY 
	member_casual;
/*Members ride for shorter durations of time (13 mins), Casual riders ride for 32 minutes. 
This could be because members are commuters*/

--3 Do casual members start and stop at the same place? -Data where startstation and endstation are same
SELECT 
	member_casual,
	count(*)
FROM
(
SELECT DISTINCT 
	ride_id, 
	start_station_id, 
	start_station_name, 
	end_station_id, 
	end_station_name, 
	member_casual
FROM 
	bike_data
WHERE 
	start_station_id = end_station_id
AND 
	start_station_name = end_station_name
    ) CTE
GROUP BY member_casual;
/*Members usually end up at a different place from the start station. However only a fraction of people end up at the same station 
664624 - member, 857754 - casual*/

--4 Duration and Usage by weekdays and member type 
SELECT 
    WEEKDAY(started_at) AS day,
    COUNT(*) AS noofrides,
    SEC_TO_TIME(ABS((AVG(TIMESTAMPDIFF(SECOND,
                        ended_at,
                        started_at))))) AS duration,
    member_casual
FROM
    bike_data
GROUP BY 1 , 4;

--5 Rider behaviour by weekday and weekend on an hourly basis
WITH CTE as (
SELECT 
	DISTINCT ride_id, 
    sec_to_time(TIMESTAMPDIFF(second,started_at,ended_at)) as trip_duration, 
    EXTRACT(hour from started_at) hour,
    WEEKDAY(started_at) AS weekindex,
    member_casual,
CASE
	WHEN WEEKDAY(started_at) = 6 THEN 'weekend' 
	WHEN WEEKDAY(started_at) = 5 THEN 'weekend'
	ELSE 'weekday'
END as daytype
FROM bike_data)

SELECT 
	count(DISTINCT RIDE_ID), 
	hour, 
	member_casual, 
	daytype
FROM CTE 
GROUP BY daytype, hour

--6 Popular ridable types by members
SELECT 
	rideable_type, 
    count(DISTINCT RIDE_ID) rides, 
    member_casual
FROM 
	bike_data
GROUP BY 
	rideable_type, 
    member_casual
ORDER BY 2 DESC;

--7 Rider Behaviour patterns by month 
SELECT 
	extract(month from started_at) as Month,
    count(distinct ride_id) as Number_of_rides
FROM 
    member_data
GROUP BY 1
ORDER BY 1;

--1 End stations 
SELECT DISTINCT 
	ROUND(avg(end_lat),5) as end_lat, 
	ROUND(avg(end_lng),5) as end_lng, 
	end_station_name, 
	end_station_id,
    member_casual,
	count(*)
FROM 
	bike_data1 --I used the original table with start lat and end lat here 
GROUP BY 3,4,5
ORDER BY 
	count(*) DESC
LIMIT 100;

--2 Start stations 
SELECT DISTINCT 
	ROUND(avg(start_lat),5) as start_lat, 
	ROUND(avg(start_lng),5) as start_lng, 
	start_station_name, 
	start_station_id,
  member_casual,
	count(*)
FROM 
	bike_data1 --I used the original table with start lat and end lat here
GROUP BY 3,4,5
ORDER BY 
	count(*) DESC
LIMIT 100;
