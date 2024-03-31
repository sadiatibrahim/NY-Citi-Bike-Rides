
variable "credentials" {
  description = "my-credentials"
  default     = "path to your service account"

}

variable "project" {
  description = "NYC-Bike-Rides"
  default     = "your_project_id" #your project id

}

variable "region" {
  description = "Region"
  default     = "us-central1"

}

variable "zone" {
  description = "zone"
  default     = "us-central1-a"

}

variable "location" {
  description = "project-location"
  default     = "US"

}

variable "bq_dataset_name" {
  description = "Big query dataset name"
  default     = "nyc_citi_bike_rides"

}

variable "gcs_bucket_name" {
  description = "Storage bucket name"
  default     = "sadiat_citi_bike_rides_bucket"

}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"

}

variable "instance_name" {
  description = "name of compute engine instance"
  default     = "instance-1"

}


variable "machine_type" {
  description = "type of compute engine"
  default     = "e2-standard-4"

}

variable "image" {
  description = "VM image"
  default     = "ubuntu-2004-focal-v20240125"

}

variable "size" {
  description = "storage size for my vm instance"
  default     = "30"

}

variable "network" {
  description = "my instance network"
  default     = "default"

}
