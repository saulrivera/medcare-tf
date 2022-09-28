### MANDATORY PARAMS ###
variable "deployment_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "intra_subnets" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "ecr_iam_policy_arn" {
  type = string
}

### OPTIONAL PARAMS ###
variable "tags" {
  type = map(string)
  default = {}
}
