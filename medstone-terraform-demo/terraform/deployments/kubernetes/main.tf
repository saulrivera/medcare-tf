provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

locals {
  tags = {
    Terraform : true
  }
}

module "vpc" {
  source          = "./modules/vpc"
  cluster_name    = "${var.env}_medstone"
  region          = var.region
}

module "ecr" {
  source          = "./modules/ecr"
  deployment_name = "${var.env}_medstone"
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "${var.env}_medstone"
  deployment_name    = "${var.env}_medstone"
  vpc_id             = module.vpc.vpc_id
  tags               = local.tags
  region             = var.region
  intra_subnets      = module.vpc.intra_subnets
  private_subnets    = module.vpc.private_subnets
  profile            = var.aws_profile
  ecr_iam_policy_arn = module.ecr.ecr_iam_policy_arn
}


module "database" {
  source                      = "./modules/database"
  database_subnets            = module.vpc.database_subnets
  deployment_name             = "${var.env}-medstone"
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  vpc_id                      = module.vpc.vpc_id
  cluster_name                = "${var.env}_medstone"
  profile                     = var.aws_profile
}
