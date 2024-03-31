

  create or replace view `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_rides`
  OPTIONS()
  as 

with bike_rides as 
(
    select *,
    row_number() over(partition by ride_id, started_at) as id
    from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`rides`
    where ride_id is not null and date_part = (SELECT MAX(date_part) FROM `virtual-aileron-412616`.`nyc_citi_bike_rides`.`rides`)
)

select
  
    safe_cast(ride_id as string)
 as ride_id,
  cast(rideable_type_id as integer) as rideable_type_id,
  case 
    safe_cast(rideable_type_id as INT64)
  
        when 0 then 'Classic' 
        when 1 then 'Electric'
        else 'EMPTY'
    end as ride_type,
  cast(start_station_id as string) as start_station_id,
  cast(end_station_id as string) as end_station_id,
  cast(started_at as timestamp) as started_at,
  cast(ended_at as timestamp) as ended_at,
  cast(member_casual_id as integer) as member_casual_id,
  cast(date_part as date) as date_part,
  case 
    safe_cast(member_casual_id as INT64)
  
        when 0 then 'Member'
        when 1 then 'Casual'
        else 'EMPTY'
    end as member_type
  


from bike_rides

where id = 1;

