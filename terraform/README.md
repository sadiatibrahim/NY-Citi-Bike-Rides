# Steps to Provisioning Resources Using Terraform

## Create a Service Account in GCP 
1. Navigate to the Google cloud console and select IAM & Admin 

2. Click on  "Create Service Account" and add provide a name for your service account
3. Add the following IAM roles to your service account:
   
		BigQuery Admin
	 	Compute Admin
		Storage Admin
4. After creating the service account, click on the harmburger icon next to the service account, then select "Manage keys"
5. Click on "Add key", choose JSON format, and save the JSON file locally.

## Provision Resources to GCP

1. Add your GCP project id in variables.tf file.
   
		variable "project" {
		description = "NYC-Bike-Rides"
		default     = "your_project_id" #your project id	
		}
2. provide the path to the service account keys you downloaded in the previous step in variables.tf file
   
		variable "credentials" {
		description = "my-credentials"
		default     = "path to your service account"
	
		}

3. Change the name of the bucket and dataset to the name you want your bucket and dataset to be

   		variable "bq_dataset_name" {
		 description = "Big query dataset name"
		 default     = "nyc_citi_bike_rides"
		
		}
		
		variable "gcs_bucket_name" {
		description = "Storage bucket name"
		 default     = "sadiat_citi_bike_rides_bucket"
		
		}
3. Install terraform on your machine if you don't already have it
4. Run the following commands:

		terraform fmt  -> "This formats the .tf files"
		terraform init	-> This initializes the terraform configuration
		terraform apply

5. Deleting Resources

		terraform destroy

