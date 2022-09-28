locals {
  repositories = [
    "web",
    "encounterconsenteventconsumer",
    "encountereventconsumer",
    "usereventconsumer",
    "chartmicroservice",
    "identitymicroservice",
    "patientmicroservice",
    "physicianmicroservice",
    "timermicroservice",
    "sessionmanager",
    "resourcemanager",
    "ordermicroservice",
    "pdfgenmicroservice"
  ]
}

resource "aws_ecr_repository" "ecr" {
  count = length(local.repositories)

  name = local.repositories[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge({ Name = local.repositories[count.index] }, var.tags)
}

resource "aws_iam_policy" "ecr_iam_policy" {
  name        = "ecr_iam_policy"
  description = "Allows pods to get ecr images"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}