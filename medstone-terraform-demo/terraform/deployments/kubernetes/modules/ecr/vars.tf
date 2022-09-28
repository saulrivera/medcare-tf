### MANDATORY PARAMS ###
variable "deployment_name" {
  type = string
}

### OPTIONAL PARAMS ###
variable "tags" {
  type = map(string)
  default = {}
}