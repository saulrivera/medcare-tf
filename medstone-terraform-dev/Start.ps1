$ENV = "stage"
$REGION = "us-east-1"
$AWS_PROFILE = "medstone_stage"

$DIR_NAME = "kubernetes"

function Configure {
    aws s3 mb s3://medstone-$ENV-$REGION-terraform-state --region $REGION --profile $AWS_PROFILE
    aws dynamodb create-table --table-name medstone-${ENV}-terraform-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --profile $AWS_PROFILE
    aws iam create-service-linked-role --aws-service-name spot.amazonaws.com --profile $AWS_PROFILE
}

function TerraformInit {
    terraform init
}

function TerraformPlan {
    terraform plan -var="env=$ENV" -var="aws_profile=$AWS_PROFILE"
}

function TerraformApply {
    terraform apply -var="env=$ENV" -var="aws_profile=$AWS_PROFILE"
}

function TerraformDestroy {
    terraform destroy -var="env=$ENV" -var="aws_profile=$AWS_PROFILE"
}

function Build {
    (Get-Content .\terraform\backend\s3.tf).Replace("<state-key>", "$ENV-medstone.tfstate").Replace("<deployment-region>", "$REGION").Replace("<deployment-stage>", "$ENV").Replace("<aws-profile>", "$AWS_PROFILE") | Set-Content .\terraform\deployments\$DIR_NAME\backend.tf
    Set-Location .\terraform\deployments\$DIR_NAME
    TerraformInit
    TerraformPlan
    TerraformApply
    Set-Location ..\..\..
}

function Destroy {
    (Get-Content .\terraform\backend\s3.tf).Replace("<state-key>", "$ENV-medstone.tfstate").Replace("<deployment-region>", "$REGION").Replace("<deployment-stage>", "$ENV").Replace("<aws-profile>", "$AWS_PROFILE") | Set-Content .\terraform\deployments\$DIR_NAME\backend.tf
    Set-Location .\terraform\deployments\$DIR_NAME
    TerraformInit
    TerraformPlan
    TerraformDestroy
    Set-Location ..\..\..
}

if ($args.Count -eq 0) {
    Write-Output "No action provided (build/destroy)"
} elseif ($args[0] -eq "build") {
    Build
} elseif ($args[0] -eq "destroy") {
    Destroy
} elseif ($args[0] -eq "init") {
    Configure
}