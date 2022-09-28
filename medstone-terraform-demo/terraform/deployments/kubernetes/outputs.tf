output "database_password" {
  value     = module.database.cluster_master_password
  sensitive = true
}
