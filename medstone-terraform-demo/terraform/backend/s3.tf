terraform {
  backend "s3" {
    bucket = "medstone-<deployment-stage>-<deployment-region>-terraform-state"
    key = "<state-key>"
    region = "<deployment-region>"
    dynamodb_table = "medstone-<deployment-stage>-terraform-lock"
    profile = "<aws-profile>"
  }
}