resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region
  project  = var.project_id

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = var.master_version

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.auth_access
      content {
        display_name = cidr_blocks.key
        cidr_block   = cidr_blocks.value
      }
    }
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network    = var.network
  subnetwork = var.subnetwork
  # network_policy {
  #   enabled = "true"
  #   provider = "CALICO"
  # }

  # private_cluster_config {
  # }

  ip_allocation_policy {
    use_ip_aliases           = true
    cluster_ipv4_cidr_block  = ""
    node_ipv4_cidr_block     = ""
    services_ipv4_cidr_block = ""
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "dt65-node-pool"
  location   = var.region
  project    = var.project_id
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}
