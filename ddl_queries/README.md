# Details About Tables in Big Query

ER-Diagram

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/7fd7ef1d-ed16-496e-970f-34bbb1a90d64)


## Table Details
### citi_bikes (Partitioned Table)
#### Description: The citi_bikes table serves as the main repository for all monthly datasets from cloud storage.
#### Partitioning: Partitioned by month to efficiently manage and query large volumes of data.
#### Purpose: Acts as the primary source for data related to bike rides.

### dim_station
#### Description: The dim_station table contains information about bike stations, uniquely identified by station_id.

### rides
#### Description: The rides table stores records of all bike rides made in each month.
#### Partitioning: Partitioned by month to optimize querying and management of historical ride data.
#### Purpose: Holds transactional data about individual bike rides.


### Fact Table(fact_rides)
#### Description: The fact table is generated from both the dim_station and rides tables, containing data from the latest partitioned date dataset.
#### Purpose: Consolidates data from dim_station and rides to provide a comprehensive view of bike ride information, including station details and ride records for the most recent month.


