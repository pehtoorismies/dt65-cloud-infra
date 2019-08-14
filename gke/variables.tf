variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources"
}

variable "name" {
  description = "The name of the Kubernetes resources"
  default     = "kubernetes-cluster"
}

variable "region" {
  description = "The region of the Kubernetes resources"
}


variable "master_version" {
  type    = string
  default = 1.13

}

variable "auth_access" {
  default = {
    "Mac pro Home" = "62.248.214.0/24"
  }
}

variable "machine_type" {
  default = "f1-micro"
}

variable "node_count" {
  default = 3
}

variable "network" {
  description = "VPC where k8s is attached to"
}

variable "subnetwork" {
  description = "Subnet work range"
}

variable "preemptible" {
  description = "Allow shortlived nodes for lower price"
}

