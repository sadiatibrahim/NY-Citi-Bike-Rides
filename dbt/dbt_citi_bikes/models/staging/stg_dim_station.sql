{{ config(materialized='view') }}






with stations as 
(
    select *
    from {{ source('staging', 'dim_station') }}
    where station_id is not null and date_part = (SELECT MAX(date_part) FROM {{ source('staging', 'rides') }})
)


select 
cast(station_id as string) as station_id, 
cast(station_name as string) as station_name,
cast(date_part as date) as date_part

from stations