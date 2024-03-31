
  
    

    create or replace table `virtual-aileron-412616`.`nyc_citi_bike_rides`.`fact_rides`
      
    
    

    OPTIONS()
    as (
      


with rides as 
(
    select *
    from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_rides`
),

stations as 
(
    select *
    from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_dim_station`
)

select rides.ride_id,
rides.ride_type,
rides.start_station_id,
rides.end_station_id,
rides.started_at,
rides.ended_at,
rides.member_type,
start_station.station_name as start_station_name,
end_station.station_name as end_station_name,

FROM rides 
INNER JOIN stations start_station ON rides.start_station_id = start_station.station_id
INNER JOIN stations end_station ON rides.end_station_id = end_station.station_id
    );
  