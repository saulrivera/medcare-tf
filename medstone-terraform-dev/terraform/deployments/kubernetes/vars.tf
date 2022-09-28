### MANDATORY PARAMS ###
variable "env" {
  type = string
}

### OPTIONAL PARAMS ###
variable "region" {
  type = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  default = "medstone_dev"
}
