# Steps to provisioning resources using terraform

## Create a Service Account in GCP by following these steps:
1. Navigate to your Google cloud console and select IAM & Admin 

2. Select Create Service Account and add the following permissions to your service account
   
		BigQuery Admin
	 	Compute Admin
		Storage Admin
3. Click on the Harmburger ico next to the service account, select manage keys, click on add key, choose Json format and copy the json to a file in your local.


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
				 		
3. Install terraform on your machine if you don't already have it
4. Run the following commands:

		terraform fmt  -> "This formats the .tf files"
		terraform init
		terraform apply

5. if you want to delete all the resources you have provisioned, run this command:

		terraform destroy

