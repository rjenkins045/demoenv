provider "aws" {
    region = var.region  
}

#VPC module (creates subnets across 3 AZs for redundancy)
module "VPC" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.1.1"

    name = "demo-vpc"
    cidr = "10.0.0.0/16"

    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true

    tags = {
        Environment = "demo"
    }
}

#EKS Module (provisions control plane + worker nodes)
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "20.8.4"

    cluster_name    = var.cluster_name
    cluster_version = "1.28"
    vpc_id          = module.vpc.vpc_id
    subnet_ids      = module.vpc.private_subnets

    eks_managed_node_groups = {
        demo_nodes = {
            desired_size    = 3
            min_size        = 2
            max_size        = 5
            instance_types  = ["t3.medium"]
            capacity_type   = "ON DEMAND"     
        }
    }

    tags = {
        Environment = "demo"
    }
}