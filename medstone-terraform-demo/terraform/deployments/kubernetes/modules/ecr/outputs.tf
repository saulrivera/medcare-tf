output "ecr_arn_list" {
  value = aws_ecr_repository.ecr.*.arn
}

output "ecr_iam_policy_arn" {
  value = aws_iam_policy.ecr_iam_policy.arn
}