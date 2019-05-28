#Terraform Variable
variable file	= global_vars.tfvars

#Terraform Command
#S3

```bash
terraform init  -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/s3/main-1-s3-bucket-tfstate.tfstate'
terraform plan  -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply -var-file=/root/terraform_practice_codes/global_vars.tfvars
```

#SQS
```bash
terraform init -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/sqs/test_sqs_creation_1.tfstate'
terraform plan -out=tfplan -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply tfplan
```
#KMS
```bash
terraform init  -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/kms/test_kms_key_creation_1.tfstate'
terraform plan  -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply -var-file=/root/terraform_practice_codes/global_vars.tfvars
```
