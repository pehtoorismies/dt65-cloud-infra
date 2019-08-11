variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources"
}

variable "name" {
  description = "The name of the Cloud SQL resources"
}

// required
variable "database_version" {
  description = "The database version to use"
}

// required
variable "region" {
  description = "The region of the Cloud SQL resources"
}

// Master
variable "tier" {
  description = "The tier for the master instance."
  default     = "db-f1-micro"
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `a`, `c`."
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "authorized_gae_applications" {
  description = "The list of authorized App Engine project names"
  default     = []
  type        = list(string)
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance"
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  default     = "PD_SSD"
}


variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "canary"
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  default     = []
}

variable "user_labels" {
  default     = {}
  description = "The key/value labels for the master instances."
}

variable "vpc" {
  description = "VPC reference for private IP"
  type        = string
}

variable "backup_configuration" {
  type = object({
    binary_log_enabled = bool
    enabled            = bool
    start_time         = string
  })


  default = {
    binary_log_enabled = true
    enabled            = true
    start_time         = "00:00"
  }
}

variable "databases" {

  type = list(object({
    name     = string
    username = string
    password = string
  }))
}


#   description = <<EOF
# The backup configuration block of the Cloud SQL resources
# This argument will be passed through the master instance directly.
# See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html).
# EOF
# }

variable "ip_configuration" {
  description = "The ip configuration for the master instance."

  default = {
    ipv4_enabled = "true"
  }
}

variable "db_name_events" {
  description = "The name of the default database to create"
  default     = "default"
}

variable "db_charset" {
  description = "The charset for the default database"
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'utf8_general_ci'"
  default     = ""
}

variable "user_name" {
  description = "The name of the default user"
  default     = "default"
}

variable "user_host" {
  description = "The host for the default user"
  default     = "%"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = ""
}

variable "additional_users" {
  description = "A list of users to be created in your cluster"
  default     = []
}

variable create_timeout {
  description = "The optional timout that is applied to limit long database creates."
  default     = "10m"
}

variable update_timeout {
  description = "The optional timout that is applied to limit long database updates."
  default     = "10m"
}

variable delete_timeout {
  description = "The optional timout that is applied to limit long database deletes."
  default     = "10m"
}
