output "vpc_id" {
  value = module.vpc.vpc_id
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}