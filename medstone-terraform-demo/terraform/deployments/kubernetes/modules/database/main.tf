terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "13.6"
}

module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name              = "${var.deployment_name}-aurora-postgres"
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true

  vpc_id                = var.vpc_id
  subnets               = var.database_subnets
  create_security_group = true
  allowed_cidr_blocks   = var.private_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 2
    max_capacity = 2
  }

  db_parameter_group_name         = aws_db_parameter_group.postgresql13.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql13.id

  instance_class = "db.serverless"

  instances = {
    one = {}
    two = {}
  }
}

resource "aws_db_parameter_group" "postgresql13" {
  name        = "${var.deployment_name}-aurora-db-postgresql13-parameter-group"
  family      = "aurora-postgresql13"
  description = "${var.deployment_name}-aurora-db-postgresql13-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "postgresql13" {
  name        = "${var.deployment_name}-aurora-postgresql13-cluster-parameter-group"
  family      = "aurora-postgresql13"
  description = "${var.deployment_name}-aurora-postgresql13-cluster-parameter-group"
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", var.profile]
  }
}

resource "kubectl_manifest" "postgres_domain" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  type: ExternalName
  externalName: ${module.cluster.cluster_endpoint}
  ports:
    - port: 5432
      protocol: TCP
      targetPort: 5432
  sessionAffinity: None
YAML
}
