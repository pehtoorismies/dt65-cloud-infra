/**
 * google cloud
 */
provider "google" {
  credentials = "${file("credentials.json")}"
  region      = var.region
  project     = var.project
  version     = "~> 2.12"
}

provider "google-beta" {
  credentials = "${file("credentials.json")}"
  project     = var.project
  region      = var.region
  version = "~> 2.12"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "name" {
  byte_length = 2
}

module "vpc" {
  source = "./backend/vpc"
}

module "subnet" {
  source      = "./backend/subnet"
  region      = var.region
  vpc_network = module.vpc.self_link
  subnet_cidr = var.subnet_cidr
}


module "firewall" {
  source        = "./backend/firewall"
  vpc_name      = module.vpc.vpc_name
  ip_cidr_range = module.subnet.ip_cidr_range
}

module "mysql-db" {
  source           = "./cloudsql"
  name             = "dt65-master-${random_id.name.hex}"
  region           = var.region
  database_version = "MYSQL_5_7"
  project_id       = var.project
  zone             = "c"
  tier             = var.sql_instance_size
  db_charset       = "utf8mb4"
  db_collation     = "utf8mb4_unicode_ci"
  vpc              = module.vpc.self_link
  databases        = var.databases
  # subnet_ip_cidr_range = module.subnet.ip_cidr_range

  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]
}

# module "private-service-access" {
#   source      = "github.com/GoogleCloudPlatform/terraform-google-sql-db/modules/private_service_access"
#   project_id  = var.project
#   vpc_network = "${module.vpc.vpc_name}"
# }




# module "cloudsql" {
#   source                     = "./cloudsql"
#   region                     = "${var.region}"
#   availability_type          = "${var.availability_type}"
#   sql_instance_size          = "${var.sql_instance_size}"
#   sql_disk_type              = "${var.sql_disk_type}"
#   sql_disk_size              = "${var.sql_disk_size}"
#   sql_require_ssl            = "${var.sql_require_ssl}"
#   sql_master_zone            = "${var.sql_master_zone}"
#   sql_connect_retry_interval = "${var.sql_connect_retry_interval}"
#   sql_replica_zone           = "${var.sql_replica_zone}"
#   sql_user                   = "${var.sql_user}"
#   sql_pass                   = "${var.sql_pass}"
# }

# resource "google_compute_global_address" "private_ip_address" {
#   name          = "private-ip-address"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 16
#   network       = "${google_compute_network.vpc_network.self_link}"
# }

# resource "google_sql_database_instance" "master" {
#    depends_on = [
#     "google_service_networking_connection.private_vpc_connection"
#   ]

#   name             = "dt65-db"
#   database_version = "MYSQL_5_7"
#   region           = var.region
#   settings {
#     tier = "db-f1-micro"
#     ip_configuration {
#       ipv4_enabled    = "false"
#       private_network = "${google_compute_network.private_network.self_link}"
#     }
#   }

# }




#   network_interface {
#     network = "${google_compute_network.vpc_network.name}"

#     access_config {
#       // Ephemeral IP
#     }
#   }

