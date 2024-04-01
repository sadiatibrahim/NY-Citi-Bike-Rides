# NY-Citi-Bike-Rides

## Problem Description

This project aims to analyze the NYC Citi Bike Rides dataset to determine the total number of trips for each day of the week in a month. Additionally, it seeks to identify the busiest day of the week in a month and the total number of trips for each type of bike.

## Strategy

Batch Processing serves as the primary strategy for this project. Monthly jobs are scheduled using Mage as the workflow orchestrator. Terraform (Infrastructure as Code) provisions resources such as buckets, virtual machines, and datasets in Google BigQuery. Mage is utilized for orchestration within the Google Cloud Platform.

### Extraction

A Python script, triggered by Mage, is the initial job in the pipeline. This script retrieves monthly data from the NYC Citi Bikes dataset, available as a zipped file on the webpage https://s3.amazonaws.com/tripdata/index.html. Each zipped file contains multiple CSV files, each potentially containing up to a million records.

The script reads the data in chunks into memory and writes it to Google Cloud Storage as Parquet files. Notably, the data pulled corresponds to the previous month, as the NYC Citi Bikes dataset for a given month becomes available on the webpage in the subsequent month. For example, if the script is executed in April, it retrieves the dataset for March after preprocessing the execution date.

### Loading

Data is loaded into BigQuery from GCS by executing SQL queries. These scripts run after the Extraction job has completed, loading the data into three partitioned tables.

### Transformation

Data transformation is performed using DBT (Data Build Tool), triggered by Mage. This job executes transformations on the data, generating a Fact Table used for visualization reports.

## Prerequisites

    - terraform
    - GCP account
    - Visual studio or any IDE is fine
    - git

## Steps to Follow

## 1. Clone the Repository:
Run the command below to clone this repository:

    git clone https://github.com/sadiatibrahim/NY-Citi-Bike-Rides.git

## 2. Provision resources in GCP using terraform

Navigate to this README and follow the instructions: https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/blob/main/terraform/README.md

## 3. Deploy Mage to GCP

Create a service account and add the role "owner" This service account will be used in two different places

  1. Gives permission to your cloud VM to deploy Mage
  2. Gives Mage permission to Google cloud storage, big Query

Add the service account to your Cloud VM that was provisioned in step 2 or any existing instance you have by clicking on Compute Engine in your console, select the instance, click on the "EDIT", and scroll down to Identity and API access and select the service account, and click on save.

Add the Service Account to Secrets Manager:
  Generate a key for your service account and copy the JSON or download the JSON,
  Type Secret Manager on the search bar in your google cloud console, select "CREATE SECRET", provide the name of your secret as "mage_credentials" and for the "Secret value" section you can either paste the JSON you copied in the previous step in the "Secret value" section or upload the json file. either one works.

Run Terraform commands to deploy Mage:
  cd mage-ai-templates/gcp
  edit the variables.tf file by adding your project id
  Run these commands:

        terraform fmt
        terraform init
        terraform apply
  Note: there may be an error when you run terraform apply, due to some APIs not enabled. read the error, go to the link that was provided in the error and enable the API

  After Mage has been deployed, Navigate to Cloud Run from your console, you will see the deployed service which is Mage, click on it, go to the Networking Tab, and select "All" , then copy the url and load the webpage from your browser.


Add the path of your secrets key that was mounted:

  In the Mage page, go to the io._config.yaml file and add the path to your service account key as shown in the picture below:
  ![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/f788139a-58c1-46be-b3d4-7928d3df598e)
  Note: Make sure to comment out the rest of the fields under GOOGLE_SERVICE_ACC_KEY as seen in the image above



## 4. Run DDL commands in Big Query

Navigate to the ddl_queries/ folder in the repository and copy the DDL commands from queries.sql. Paste them into the BigQuery Editor to create empty partitioned tables.


## 5. Run the ELT scripts on Mage:

start by creating a new pipleline as shown in the image below, click on new to create a pipeline

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/78b0fbd0-de46-475e-b7f2-346643fa7b81)

Select Edit pipeline
Add a block by selecting "Data Loader" block as shown in the image
![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/0f2ccece-6c69-4a28-b44e-44bb814fbc2c)

Select Python -> Generic (no template)

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/3933801e-90b3-483d-80af-44a7532b1aac)

Then delete the code that was generated from selecting the generic template, and copy the extraction code from my repository you cloned by going to the /mage/data_loaders directory and copying the code in load_to_datalake.py file and paste the code in the block.

Add another Data Loader block and select SQL as the template as shown in the image below
![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/b9376039-ec26-4e65-96bb-25bbff7a28fc)

copy the Queries under mage/data_loaders/load_data_to_bigquery.sql

Add another block and select "DBT model" block and make sure the command is "dbt build" as shown in the image below
![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/b48ab6d1-0395-4050-ae88-5d8a51369c3d)

### Steps to follow before running your DBT block

Create a folder under dbt folder, this folder will contain all your dbt models, macros, seeds, yaml files.

Navigate to mage/dbt/ folder from my repository, and copy all the folders and files under mage/dbt/ to the dbt folder in mage. you can do that by creating the same folders and files in mage, and copy all the contents from those folders to the empty folders you created in mage

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/5e69c1db-0428-4994-8404-4dd140ff5e62)

make sure to the change the dataset name and project id in dbt_project.yml file to your dataset and project id


After creating all the three blocks, your graph should look like this:

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/9ab77fe4-304b-47a8-9800-a51ab9c46eac)

## 6. Schedule Jobs To Run Monthly

Go to Triggers as seen in the picture below, select New Trigger, select the Date you want it to start running,
select Frequency as monthly and save the changes. This trigger will make the jobs run on monthly basis.

![image](https://github.com/sadiatibrahim/NY-Citi-Bike-Rides/assets/57956925/cb04e8f5-ad8c-4041-9fcd-baec02910141)


## 7.  Visualization

Visualizations for the dataset have been created using Looker Studio. Follow the provided link to access the dashboard for the month of February 2024.
https://lookerstudio.google.com/reporting/a78b12b7-f392-40d1-b4c3-8dfabfb2c31f/page/IF0uD/edit
















  
