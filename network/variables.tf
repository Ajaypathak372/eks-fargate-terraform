variable "vpc_name" {
    description = "Name of VPC"
}

variable "vpc_cidr" {
    description = "CIDR Block of the VPC"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "cidr_block_igw" {
    description = "CIDR Block for Internet and NAT Gateways "
}