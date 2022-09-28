module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "${var.cluster_name}_vpc"
  cidr = "10.0.0.0/16"

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true

  enable_flow_log                      = false

  public_subnet_tags = {
    "Name" = "${var.cluster_name}_publicsubnet"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "karpenter.sh/discovery" = var.cluster_name
  }
}