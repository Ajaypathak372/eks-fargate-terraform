/*
data "aws_eks_cluster" "aws_eks" {
  name = var.eks_cluster_name
}*/

data "aws_eks_cluster_auth" "eks_auth" {
  name = var.eks_cluster_name
}
 
provider "kubernetes" {
  host                      = var.eks_cluster_endpoint
  cluster_ca_certificate    = base64decode(var.eks_ca_certificate)
  token                     = data.aws_eks_cluster_auth.eks_auth.token
  #load_config_file          = false
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks_auth.token
    cluster_ca_certificate = base64decode(var.eks_ca_certificate)
  }
}