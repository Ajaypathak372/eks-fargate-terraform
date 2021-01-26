variable "fargate_profile_name" {
    type = string
    description = "Name of the Fargate Profile"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "subnet_ids" {
    type = list(string)
    description = "List of all the Subnets"
}

variable "kubernetes_namespace" {
    type = string
    description = "Kubernetes namespace for selection"
}