if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import pandas as pd
import pyarrow as pa
import zipfile
import io
import pyarrow.parquet as pq
import urllib.request
from google.cloud import storage
from datetime import datetime, timedelta

@data_loader
def load_data(*args, **kwargs):
    execution_date = kwargs['execution_date']
    print(execution_date)
    yyyymm = execution_date.strftime("%Y%m")

    # Subtract one month
    if execution_date.month == 1:
        new_month = 12
        new_year = execution_date.year - 1
    else:
        new_month = execution_date.month - 1
        new_year = execution_date.year

    # Construct new datetime with subtracted month
    new_timestamp_str = f"{new_year:04d}{new_month:02d}"
    print(new_timestamp_str)
   
    zip_url = f"https://s3.amazonaws.com/tripdata/{new_timestamp_str}-citibike-tripdata.csv.zip"
    new_date =  f"{new_year:04d}{new_month:02d}01"
    
    bike_dtypes = {
        'ride_id' : str, 
        'rideable_type': str, 
       'start_station_name' :str, 
        'start_station_id': str,
        'end_station_name' : str,
       'end_station_id' : str, 
        'start_lat' : float ,
        'start_lng': float,
        'end_lat' : float, 
        'end_lng' :float,
       'member_casual' : str
    }

    parse_dates = ['started_at', 'ended_at']
   
    with urllib.request.urlopen(zip_url) as response:
        zip_content = io.BytesIO(response.read())

    with zipfile.ZipFile(zip_content, 'r') as zip_ref:
        for file_name in zip_ref.namelist():
            print(file_name)
            if file_name.startswith('__MACOSX/'):
                continue

            if file_name.endswith('.csv'):
                with zip_ref.open(file_name) as file:
                    csv_content = io.StringIO(file.read().decode('utf-8'))
                
                chunksize = 50000
                bucket_name = "sadiat_citi_bike_rides_bucket"
                root_path = f"{bucket_name}/{new_timestamp_str}"

                
                    
                df = pd.read_csv(csv_content, sep=',', chunksize=chunksize,dtype = bike_dtypes, parse_dates=parse_dates)
                
                for chunk in df:
                    chunk['date_part'] = pd.to_datetime(new_date, format='%Y%m%d')
                    table = pa.Table.from_pandas(chunk)
                    gcs = pa.fs.GcsFileSystem()
                    pq.write_to_dataset(table,
                            root_path = root_path,
                            coerce_timestamps='us',
                            allow_truncated_timestamps=True,
                            filesystem=gcs)
                    print(file_name)



               
                



   
    return {new_date}


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
