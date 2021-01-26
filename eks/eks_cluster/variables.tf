variable "cluster_name" {
    type = string
    description = "Name of the EKS Cluster"
}

variable "public_subnets" {
    description = "List of all the Public Subnets"
}

variable "private_subnets" {
    description = "List of all the Private Subnets"
}