# Create Subnet

resource "google_compute_subnetwork" "subnet" {
  name          = var.name
  ip_cidr_range = var.subnet_cidr
  network       = var.vpc_network
  region        = var.region
}