
    
    

with dbt_test__target as (

  select station_id as unique_field
  from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_dim_station`
  where station_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


