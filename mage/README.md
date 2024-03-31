# Deploying Mage to GCP

## Getting Started
To begin, clone this repository provided by Mage AI:
   
    git clone https://github.com/mage-ai/mage-ai-terraform-templates.git

Navigate to the GCP directory within the cloned repository:
  
    cd mage-ai-terraform-templates/gcp

Make sure to add your project ID in the "variables.tf" file.


  
Follow the instructions outlined in the Mage AI documentation to create a service account for Mage and mount your secrets key using Terraform.

    https://docs.mage.ai/production/deploying-to-cloud/gcp/setup


## ELT Pipeline Code

Within the repository, you'll find the data_loaders directory, which contains two essential files:

load_to_datalake: This Python script downloads CSV files in chunks, preprocesses them, and loads each chunk to Google Cloud Storage (GCS). The script is scheduled to run monthly, and it preprocesses the date to fetch data for the previous month before downloading the CSV files.

load_to_bigquery: This file contains SQL queries responsible for loading data incrementally into BigQuery tables. It executes after the initial job "load_to_datalake" has completed.

After the second step, a third step involving a DBT (Data Build Tool) job is executed to perform transformations in BigQuery. Navigate to the dbt folder to inspect the SQL queries and transformations applied. 
