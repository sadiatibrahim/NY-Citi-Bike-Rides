DECLARE previous_month_date DATE;
DECLARE formatted_date STRING;
DECLARE previous_month_first_day_date DATE;
DECLARE execution_date STRING;
DECLARE timestamp_date TIMESTAMP;
DECLARE date_partition DATE;


SET execution_date = (SELECT '{{ execution_date }}') ;
SET timestamp_date = TIMESTAMP(execution_date);


SET previous_month_date = DATE_SUB(DATE_TRUNC(DATE(timestamp_date), MONTH), INTERVAL 1 MONTH);

-- Format the date as YYYYMM and set the day as 01
SET formatted_date = FORMAT_DATE('%Y%m', previous_month_date) || '01';

-- Convert the formatted string to a date
SET date_partition = PARSE_DATE('%Y%m%d', formatted_date);

INSERT INTO virtual-aileron-412616.nyc_citi_bike_rides.citi_bikes (
  ride_id,
  rideable_type, 
  started_at, 
  ended_at, 
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual,
  date_part
)

SELECT 
  ride_id,
  rideable_type, 
  started_at, 
  ended_at, 
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual,
  DATE(FORMAT_TIMESTAMP('%Y-%m-01', started_at)) AS date_part
FROM 
  virtual-aileron-412616.nyc_citi_bike_rides.citi_bike_external AS Source
WHERE 
  DATE(FORMAT_TIMESTAMP('%Y-%m-01', Source.started_at))  NOT IN  (
    SELECT 
      Target.date_part
    FROM 
      virtual-aileron-412616.nyc_citi_bike_rides.citi_bikes AS Target
  );




MERGE INTO nyc_citi_bike_rides.dim_station AS target
USING (
  SELECT DISTINCT
    station_id,
    station_name,
    date_part
  FROM (
    SELECT DISTINCT
      start_station_id AS station_id, 
      start_station_name AS station_name, 
      date_part
    FROM 
      nyc_citi_bike_rides.citi_bikes
    WHERE 
      date_part = date_partition

    UNION DISTINCT

    SELECT DISTINCT
      end_station_id AS station_id, 
      end_station_name AS station_name, 
      date_part
    FROM 
      nyc_citi_bike_rides.citi_bikes
    WHERE 
      date_part = date_partition
  ) AS combined_stations
 
) AS source
ON source.station_id = target.station_id
WHEN NOT MATCHED THEN
INSERT (station_id, station_name,  date_part)
VALUES (source.station_id, source.station_name, source.date_part);



MERGE INTO nyc_citi_bike_rides.rides AS target
USING(
  SELECT DISTINCT 
    ride_id, 
    CASE WHEN rideable_type = 'classic_bike' THEN 0 ELSE 1 END AS rideable_type_id,
    start_station_id, 
    end_station_id, 
    started_at, 
    ended_at, 
    CASE WHEN member_casual = 'member' THEN 0 ELSE 1 END AS member_casual_id,
    date_part
  FROM `nyc_citi_bike_rides.citi_bikes`
  WHERE date_part = date_partition
) as source
ON source.ride_id = target.ride_id

WHEN NOT MATCHED THEN
INSERT(ride_id, rideable_type_id, start_station_id, end_station_id, started_at, ended_at, member_casual_id, date_part)
VALUES(source.ride_id, source.rideable_type_id, source.start_station_id, source.end_station_id, source.started_at, source.ended_at, source.member_casual_id, source.date_part);
