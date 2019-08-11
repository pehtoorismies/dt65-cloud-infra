variable "project" {
  description = "Project id"
  default     = "downtown65graphql"
}

variable "region" {
  description = "google region"
  default     = "europe-north1"
}

# Network variables

variable "subnet_cidr" {
  default = {
    # prod = "10.128.0.0/16"
    prod = "10.10.0.0/24"
    dev  = "10.240.0.0/24"
  }

  description = "Subnet range"
}

# Cloud SQL variables

variable "availability_type" {
  default = {
    prod = "REGIONAL"
    dev  = "ZONAL"
  }

  description = "Availability type for HA"
}

variable "sql_instance_size" {
  default     = "db-f1-micro"
  description = "Size of Cloud SQL instances"
}


variable "databases" {
  type = list(object({
    name     = string
    username = string
    password = string
  }))
}
