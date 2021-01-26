variable "vpc_id" {
    type = string
    description = "EKS Cluster VPC ID"
}

variable "vpc_cidr" {
    type = string
    description = "VPC CIDR Block"
}

variable "rds_subnet_ids" {
    type = list(string)
    description = "Subnets ID's for RDS Subnet Groups"
}

variable "subnet_group_name" {
    type = string
    description = "RDS Subnet Group Name"
}

variable "identifier" {
    type = string
    description = "RDS Identifier must be unique and always start with small letter"
}

variable "allocated_storage" {
    type = string
    description = "Storage Size for RDS Database"
}

variable "engine" {
    type = string
    description = "RDS Database Engine Name"
}

variable "engine_version" {
    type = string
    description = "RDS Database Engine Version"
}

variable "instance_class" {
    type = string
    description = "RDS Database Instance type/class"
}

variable "parameter_group_name" {
    type = string
    description = "RDS Database Parameter Group Name"
}

variable "username" {
    type = string
    description = "RDS Database Username"
}

variable "password" {
    type = string
    description = "RDS Database Password"
}

variable "db_name" {
    type = string
    description = "RDS Database Name"
}