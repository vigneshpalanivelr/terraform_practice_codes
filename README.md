# CI/CD in AWS Cloud Automation
Building AWS Infrastructure using Jenkins-Terraform Automation

## Set-Up Global Variables 
| Variable File     | Variables                 | Values                    |
| ----------------- | ------------------------- | ------------------------- |
| Global            | aws_region                | ap-south-1                |
| Global            | aws_iam_user              | aws_admin                 |
| Global            | assume_role               | deployer_role             |
| Global            | s3_backend_bucket         | terraform-tfstate-mumba-1 |
| EC2               | ec2_instance_profile_name | ec2_instance_profile      |

## Pre-Requistics in AWS IAM Set-Up
Steps to follow
1) Create Policy : ```ec2_cw_kms_s3_sns_r53_rds_full_access```
2) Create User : ```aws_admin```
3) Create Role : ```ec2_instance_profile``` (Add in Trust Relations)
4) Create Role : ```deployer_role```        (Add in Trust Relations)


### 1) Create Policy : ec2_cw_kms_s3_sns_r53_rds_full_access
```
{
  "Version"		: "2012-10-17",
  "Statement"	: [{
    "Sid"		: "ec2_cw_kms_s3_sns_r53_rds_full_access",
    "Effect"	: "Allow",
    "Action"	: ["ec2:*", "sns:*", "s3:*", "cloudwatch:*", "kms:*", "route53:*", "rds:*" ],
    "Resource"	: "*"
  }]
}
```
### 2) Create User : aws_admin
```
{
  "Version"		: "2012-10-17",
  "Statement"	: {
    "Effect"	: "Allow",
    "Action"	: "sts:AssumeRole",
    "Resource"	: "arn:aws:iam::210315133748:role/deployer_role"
  }
}
```
### 3) Create Role : ec2_instance_profile
```
{
  "Version"		: "2012-10-17",
  "Statement"	: [{
    "Effect"	: "Allow",
    "Action"    : "sts:AssumeRole",
    "Principal"	: {
      "Service"	: "ec2.amazonaws.com",
      "AWS"		: "arn:aws:iam::210315133748:role/deployer_role"
      }
    }]
}
```
### 4) Create Role deployer_role
```
{
  "Version"		: "2012-10-17",
  "Action"		: "sts:AssumeRole"
  "Statement"	: [{
    "Effect"	: "Allow",
    "Principal"	: {
      "AWS"	    : [
        "arn:aws:iam::210315133748:role/ec2_instance_profile",
        "arn:aws:iam::210315133748:user/aws_admin"
        ],
      "Service"	: "ec2.amazonaws.com"
      },
  }]
}
```

## Pre-Requistics for Terraform Set-Up
- Create S3 Bucket terraform-tfstate-mumbai-1

## How to configure AWS Credentials and Role
~/.aws/credentials
```
[deployer_role]
aws_access_key_id = <AWS_ACCESS_KEY>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>
region = ap-south-1
```
~/.aws/config
```
[deployer_role]
region = ap-south-1
output = text
role_arn = arn:aws:iam::161047494551:role/deployer_role
source_profile = deployer_role
```

### Policy and its uses
| Role                                  | Policy to Attach                      | Uses                          |
| ------------------------------------- | ------------------------------------- | ----------------------------- |
| deployer_role                         | AmazonVPCReadOnlyAccess               | VPC RO `To create EC2 in VPC` |
| deployer_role                         | IAMReadOnlyAccess                     | IAM RO `To attach instance profile in EC2` |
| deployer_role                         | AWSCloudFormationReadOnlyAccess       | CF  RO `SNS Creation using CloudFormation` |
| deployer_role                         | AWSDataExchangeSubscriberFullAccess   | EC2 AMI Filter                |
| deployer_role, ec2_instance_profile   | AmazonEC2ContainerServiceFullAccess   | EC2 Creation                  |
| deployer_role, ec2_instance_profile   |                                       | S3 Full access                |
| deployer_role, ec2_instance_profile   |                                       | SNS Full access               |
| deployer_role, ec2_instance_profile   |                                       | Route53 Full access           |
| deployer_role, ec2_instance_profile   |                                       | RDS Full access               |
| deployer_role, ec2_instance_profile   | CloudWatchAgentServerPolicy           | CW Custom metrics `Optional`  |
| deployer_role, ec2_instance_profile   | AWSKeyManagementServicePowerUser      | KMS `Optional`                |
| deployer_role                         | AmazonEC2RoleforAWSCodeDeploy         | EC2 Creation `Optional`       |

### Terraform Example Commands

```
terraform init    -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/s3/main-1-s3-bucket-tfstate.tfstate'
terraform plan    -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply   -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform plan    -destroy -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform destroy -var-file=/root/terraform_practice_codes/global_vars.tfvars
```