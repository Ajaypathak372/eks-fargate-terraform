variable "node_group_name" {
    type = string
    description = "Name of the EKS Node Group"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "subnet_ids" {
    type = list(string)
    description = "List of all the Subnets"
}

variable "instance_types" {
    type = list(string)
    description = "List of instance types associated with the EKS Node Group"
}

variable "disk_size" {
    description = "Disk Size for Worker Nodes in GiB"
}

variable "desired_nodes" {
    description = "Desired number of worker nodes"
}

variable "max_nodes" {
    description = "Maximum number of worker nodes"
}

variable "min_nodes" {
    description = "Minimum number of worker nodes"
}

