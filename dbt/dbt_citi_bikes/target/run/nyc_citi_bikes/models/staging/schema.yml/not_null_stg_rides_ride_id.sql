select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select ride_id
from `virtual-aileron-412616`.`nyc_citi_bike_rides`.`stg_rides`
where ride_id is null



      
    ) dbt_internal_test