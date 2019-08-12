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
  version     = "~> 2.12"
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

module "gke" {
  source       = "./gke"
  region       = var.region
  project_id   = var.project
  name         = "${var.project}-${terraform.workspace}-cluster"
  auth_access  = var.gke-allow-cidr[terraform.workspace]
  network      = module.vpc.self_link
  subnetwork   = module.subnet.subnet_name
  machine_type = "n1-standard-1"
  node_count   = 1
  preemptible  = true
}
