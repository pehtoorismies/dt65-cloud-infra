output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "node_config" {
  value = google_container_cluster.primary.node_config
}

output "node_pools" {
  value = google_container_cluster.primary.node_pool
}