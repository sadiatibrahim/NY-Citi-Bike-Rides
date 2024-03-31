CREATE OR REPLACE EXTERNAL TABLE virtual-aileron-412616.nyc_citi_bike_rides.citi_bike_external(
  ride_id STRING,
  rideable_type STRING,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  start_station_name STRING,
  start_station_id STRING,
  end_station_name STRING,
  end_station_id STRING,
  start_lat FLOAT64,
  start_lng FLOAT64,
  end_lat FLOAT64,
  end_lng FLOAT64,
  member_casual STRING,
  date Int64 
)
OPTIONS(
  format = 'PARQUET',
  uris = ['gs://sadiat_citi_bike_rides_bucket/*']
);


CREATE OR REPLACE TABLE virtual-aileron-412616.nyc_citi_bike_rides.citi_bikes (
  ride_id STRING,
  rideable_type STRING,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  start_station_name STRING,
  start_station_id STRING,
  end_station_name STRING,
  end_station_id STRING,
  start_lat FLOAT64,
  start_lng FLOAT64,
  end_lat FLOAT64,
  end_lng FLOAT64,
  member_casual STRING,
  date_part DATE
)
PARTITION BY date_part;

CREATE OR REPLACE TABLE virtual-aileron-412616.nyc_citi_bike_rides.dim_station(
  station_id STRING,
  station_name STRING,
  station_lat FLOAT64,
  station_lng FLOAT64

);


CREATE OR REPLACE TABLE virtual-aileron-412616.nyc_citi_bike_rides.rides(
  ride_id STRING,
  rideable_type_id INT64,
  start_station_id STRING,
  end_station_id STRING,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  member_casual_id INT64,
  date_part DATE
);
