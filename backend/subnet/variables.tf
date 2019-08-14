# Subnet variables

variable "region" {
  description = "Region of resources"
}

variable "vpc_network" {
  description = "VPC Network"
}

variable "name" {
  type        = "string"
  description = "Subnet name"
}

variable "subnet_cidr" {
  type        = "string"
  description = "Subnet range"
}

