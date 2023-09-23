variable "region" {
  type = string
  description = "The AWS region where the infrastructure will be deployed."
  default = "ap-southeast-1"
}

variable "project" {
  type = string
  description = "The name of the project."
  default = "hris-api"
}

variable "environment" {
  type = string
  description = "The environment where the infrastructure will be deployed."
  default = "staging"
}

variable "vpc_cidr_block" {
  type = string
  description = "The CIDR block for the VPC."
  default = "172.31.0.0/16"
}

variable "subnet_count" {
  type = number
  description = "The number of subnets to create in the VPC."
  default = 2
}

variable "instance_type" {
  type = string
  description = "The EC2 instance type to use for the worker nodes."
  default = "t3.small"
}

variable "db_instance_type" {
  type = string
  description = "The RDS instance type to use for the database."
  default = "db.t2.micro"
}

variable "key_name" {
  type = string
  description = "The name of the SSH key pair to use for the EC2 instances."
  default = "aws-jenkins-key"
  # Override
  # Key name for EC2 instances
  # Can find the existent key names from `aws ec2 describe-key-pairs`
}

variable "db_username" {
  type = string
  description = "The username for the RDS database."
  # Override
  # RDS db username
  default = "postgres"
}

variable "db_password" {
  type = string
  description = "The password for the RDS database."
  sensitive = true
}

variable "asg_desired_capacity" {
  type = number
  description = "The desired capacity for the autoscaling group."
  default = 2
}

variable "asg_max_size" {
  type = number
  description = "The maximum size for the autoscaling group."
  default = 2
}

variable "asg_min_size" {
  type = number
  description = "The minimum size for the autoscaling group."
  default = 2
}

locals {
  base_tags = {
    Project = var.project
    ManagedBy = "Terraform"
    Environment = var.environment
  }

  cluster_base_tags = merge(local.base_tags, tomap({
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }))
  base_name = "${var.project}-${var.environment}"
  cluster_name = "${local.base_name}-cluster"
  cluster_version = "1.24"
}

module "eks" {
  source = "hashicorp/aws/eks"
  version = "~> 4.0"

  cluster = local.cluster_name
  cluster_version = local.cluster_version

  vpc_cidr = var.vpc_cidr_block

  node_groups = [
    {
      name = "${local.base_name}-node-group"
      instance_type = var.instance_type
      desired_capacity = var.asg_desired_capacity
      max_size = var.asg_max_size
      min_size = var.asg_min_size
    }
  ]

  tags = local.cluster_base_tags
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}