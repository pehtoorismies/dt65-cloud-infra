# Subnet variables

variable "region" {
  description = "Region of resources"
}

variable "vpc_network" {
  description = "VPC Network"
}

variable "subnet_cidr" {
  type        = "map"
  description = "Subnet range"
}