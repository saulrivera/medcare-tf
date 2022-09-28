### MANDATORY PARAMS ###
variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

### OPTIONAL PARAMS ###
variable "tags" {
  type = map(string)
  default = {}
}