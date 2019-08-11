resource "google_compute_global_address" "db" {
  name          = "db-private-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc
}

resource "google_service_networking_connection" "db_vpc_connection" {
  network                 = var.vpc
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db.name]
}


resource "google_sql_database_instance" "default" {
  project          = var.project_id
  name             = var.name
  database_version = var.database_version
  region           = var.region

  depends_on = [
    "google_service_networking_connection.db_vpc_connection"
  ]

  settings {
    tier                        = var.tier
    activation_policy           = var.activation_policy
    authorized_gae_applications = var.authorized_gae_applications
    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "00:00"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc
    }

    disk_autoresize = var.disk_autoresize

    disk_size = var.disk_size
    disk_type = var.disk_type

    user_labels = var.user_labels
    # TODO
    # database_flags = [var.database_flags]

    location_preference {
      zone = "${var.region}-${var.zone}"
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}

resource "google_sql_database" "db" {
  count = length(var.databases)

  name       = lookup(var.databases[count.index], "name")
  project    = var.project_id
  instance   = google_sql_database_instance.default.name
  charset    = var.db_charset
  collation  = var.db_collation
  depends_on = ["google_sql_database_instance.default"]
}

resource "random_id" "user-password" {
  keepers = {
    name = google_sql_database_instance.default.name
  }
  byte_length = 8
  depends_on  = ["google_sql_database_instance.default"]
}

resource "google_sql_user" "user" {
  count = length(var.databases)

  name     = lookup(var.databases[count.index], "username")
  project  = var.project_id
  instance = google_sql_database_instance.default.name
  # host       = var.user_host
  password   = lookup(var.databases[count.index], "password") == "" ? random_id.user-password.hex : lookup(var.databases[count.index], "password")
  depends_on = ["google_sql_database_instance.default"]
}
