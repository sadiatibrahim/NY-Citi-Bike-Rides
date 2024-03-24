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


@data_loader
def load_data(*args, **kwargs):
    # execution_date = kwargs['execution_date'].strftime("%Y%m")
    execution_date = '202401'
    zip_url = f"https://s3.amazonaws.com/tripdata/{execution_date}-citibike-tripdata.csv.zip"
    
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
        print(zip_ref.namelist())
        for file_name in zip_ref.namelist():
            print(file_name)
            if file_name.startswith('__MACOSX/'):
                continue

            if file_name.endswith('.csv'):
                with zip_ref.open(file_name) as file:
                    csv_content = io.StringIO(file.read().decode('utf-8'))
                
                df = pd.read_csv(csv_content, sep=',', dtype = bike_dtypes, parse_dates=parse_dates)
                print(file_name)
                bucket_name = "sadiat_citi_bike_rides_bucket"
                root_path = f"{bucket_name}/citi-{execution_date}"

                table = pa.Table.from_pandas(df)
                gcs = pa.fs.GcsFileSystem()
                pq.write_to_dataset(table,
                        root_path = root_path,
                        filesystem=gcs)
                print(file_name)


   
    return {}


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
