{{ config(materialized='view') }}

with bike_rides as 
(
    select *,
    row_number() over(partition by ride_id, started_at) as id
    from {{ source('staging', 'rides') }}
    where ride_id is not null and date_part = (SELECT MAX(date_part) FROM {{ source('staging', 'rides') }})
)

select
  {{ dbt.safe_cast("ride_id", api.Column.translate_type("string")) }} as ride_id,
  cast(rideable_type_id as integer) as rideable_type_id,
  {{ get_ride_type('rideable_type_id') }} as ride_type,
  cast(start_station_id as string) as start_station_id,
  cast(end_station_id as string) as end_station_id,
  cast(started_at as timestamp) as started_at,
  cast(ended_at as timestamp) as ended_at,
  cast(member_casual_id as integer) as member_casual_id,
  cast(date_part as date) as date_part,
  {{ get_member_type('member_casual_id') }} as member_type
  


from bike_rides

where id = 1


