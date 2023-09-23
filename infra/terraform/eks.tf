provider "aws" {
  region = "ap-southeast-1 "  # Set your desired AWS region
}

module "eks_cluster" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = "hris-cluster-sg"
  cluster_version  = "1.24"  # Change to your desired EKS version
  subnets          = ["subnet-12345678", "subnet-23456789"]  # Replace with your subnet IDs
  vpc_id           = "vpc-01234567"  # Replace with your VPC ID
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.medium"  # Change to your desired EC2 instance type
      key_name      = "my-keypair"  # Change to your key pair name
    }
  }
}
