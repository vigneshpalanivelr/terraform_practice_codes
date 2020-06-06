# CI/CD in AWS Cloud Automation
Building AWS Infrastructure using Jenkins-Terraform Automation

## Set-Up Global Variables 
| Variable File     | Variables                 | Values                    |
| ----------------- | ------------------------- | ------------------------- |
| Global            | aws_region_               | ap-south-1                |
| Global            | aws_iam_user              | aws_admin_                |
| Global            | assume_role_              | deployer_role_            |
| Global            | s3_backend_bucket         | terraform-tfstate-mumba-1 |
| EC2               | ec2_instance_profile      | ec2_instance_profile      |
| Lambda            | lambda_deployer_role      | lambda_deployer_role      |

## Pre-Requistics in AWS IAM Set-Up
Steps to follow
1) Create Policy : ```ec2_cw_kms_s3_sns_r53_rds_full_access```
2) Create User   : ```aws_admin```
3) Create Role   : ```ec2_instance_profile```
4) Create Role   : ```deployer_role```
5) Create Role   : ```lambda_deployer_role```


### 1) Create Policy : ec2_cw_kms_s3_sns_r53_rds_full_access and attach to deployer_role
```
{
"Version"	: "2012-10-17",
"Statement"	: [{
	"Sid"		: "VisualEditor0",
	"Effect"	: "Allow",
	"Action"	: ["ec2:*", "sns:*", "s3:*", "cloudwatch:*", "kms:*", "route53:*", "rds:*", "logs:*", "events:*", "lambda:*"],
	"Resource"	: "*"
	}]
}
```
### 2) Create User : aws_admin and Trust Relations
```
{
  "Version"	: "2012-10-17",
  "Statement"	: {
    "Effect"	: "Allow",
    "Action"	: "sts:AssumeRole",
    "Resource"	: "arn:aws:iam::210315133748:role/deployer_role"
  }
}
```
### 3) Create Role : ec2_instance_profile and Trust Relations
```
{
  "Version"	: "2012-10-17",
  "Statement"	: [{
    "Effect"	: "Allow",
    "Action"    : "sts:AssumeRole",
    "Principal"	: {
      "Service"	: "ec2.amazonaws.com",
      "AWS"	: "arn:aws:iam::210315133748:role/deployer_role"
      }
    }]
}
```
### 4) Create Role deployer_role and attch policy (1)
```
{
  "Version"	: "2012-10-17",
  "Action"	: "sts:AssumeRole"
  "Statement"	: [{
    "Effect"	: "Allow",
    "Principal"	: {
      "AWS"	: [
        "arn:aws:iam::210315133748:role/ec2_instance_profile",
        "arn:aws:iam::210315133748:user/aws_admin"
        ],
      "Service"	: "ec2.amazonaws.com"
      },
  }]
}
```
### 5) Create policy lambda_deployer_policy and attach to lambda_deployer_role
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeSnapshots",
                "ec2:DeleteSnapshot",
                "ec2:DescribeVolumes",
                "rds:DescribeDBSnapshots",
                "rds:DeleteDBSnapshot",
                "rds:ListTagsForResource",
                "rds:DescribeDBInstances",
                "rds:StopDBInstance",
                "rds:StartDBInstance"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
        }
    ]
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
| Role            | Policy to Attach                      | Uses                                       |
| --------------- | ------------------------------------- | ------------------------------------------ |
| role            | AmazonVPCReadOnlyAccess               | VPC RO `To create EC2 in VPC`              |
| role            | IAMReadOnlyAccess                     | IAM RO `To attach instance profile in EC2` |
| role            | AWSCloudFormationReadOnlyAccess       | CF  RO `SNS Creation using CloudFormation` |
| role            | AWSDataExchangeSubscriberFullAccess   | EC2 AMI Filter                             |
| role, profile   | AmazonEC2ContainerServiceFullAccess   | EC2 Creation                               |
| role, profile   |                                       | S3 Full access                             |
| role, profile   |                                       | SNS Full access                            |
| role, profile   |                                       | Route53 Full access                        |
| role, profile   |                                       | RDS Full access                            |
| role, profile   | CloudWatchAgentServerPolicy           | CW Custom metrics `Optional`               |
| role, profile   | AWSKeyManagementServicePowerUser      | KMS `Optional`                             |
| role            | AmazonEC2RoleforAWSCodeDeploy         | EC2 Creation `Optional`                    |


#### Terraform Commands
#####S3
- Create S3 Bucket terraform-tfstate-mumbai-1

#####SQS
```bash
terraform init -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/sqs/test_sqs_creation_1.tfstate'
terraform plan -out=tfplan -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply tfplan
```
#####KMS
```bash
terraform init  -backend=true -backend-config='bucket=main-s3-bucket-tfstate' -backend-config='key=simple/kms/test_kms_key_creation_1.tfstate'
terraform plan  -var-file=/root/terraform_practice_codes/global_vars.tfvars
terraform apply -var-file=/root/terraform_practice_codes/global_vars.tfvars
```

# Resources Implemented - Terraform
1) Route53 Zone
2) S3
3) SQS
4) KMS
5) Security Group
6) SNS
<br />

7) ENI
8) EBS
9) EC2
10) EBS Attachment
11) Cloud-Watch
12) Route53 C Record
<br />

13) RDS Master
14) RDS Slave
15) Route53 A record
<br />

16.1) Lambda - EC2 Stop<br />
16.2) Lambda - Snapshot Deletion
<br />

17) ALB
18) ASG
19) AMI
20) EFS