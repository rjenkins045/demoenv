provider "aws" {
    region = var.region  
}

#VPC module (creates subnets across 3 AZs for redundancy)
module "vpc" {
    source             = "terraform-aws-modules/vpc/aws"
    version            = "5.1.1"
    name               = var.env
    cidr               = "10.0.0.0/16"
    azs                = ["$[var.region]a", "$[var.region]b"]
    private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
    enable_nat_gateway = false
}

module eks {
    source = "terraform-aws-modules/eks/aws"
    version = "20.8.4"
    cluster_name = var.cluster_name
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    eks_managed_node_groups = {
        demo = {
            desired_size    = 1
            min_size        = 1
            max_size        = 1
            instance_types  = ["tx.small"]
        }
    }
}
