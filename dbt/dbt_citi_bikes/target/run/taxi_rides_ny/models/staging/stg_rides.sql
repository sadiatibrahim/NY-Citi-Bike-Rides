

  create or replace view `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_rides`
  OPTIONS()
  as 

with bike_rides as 
(
    select *,
    row_number() over(partition by ride_id, started_at) as id
    from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`rides`
    where ride_id is not null and date_part = (SELECT MAX(date_part) FROM { { source('staging', 'citi_bikes') }})
)

select

    safe_cast(ride_id as INT64)
 as ride_id,
case 
    safe_cast(rideable_type as string)
  
        when 'classic_bike' then 1
        when 'electric_bike' then 2
        else 0
    end as ride_type,
cast(start_station_id as float) as start_station_id,
cast(end_station_id as float) as end_station_id,
cast(started_at as timestamp) as started_at,
cast(ended_at as timestamp) as ended_at,
case 
    safe_cast(member_casual as String)
  
        when 'member' then 1
        when 'casual' then 2
        else 0
    end as member_type
cast(date_part as date) as date_part


from bike_rides

where id = 1


dbt build --select <model.sql> --vars '{'is_test_run: false}'


  limit 100

;

