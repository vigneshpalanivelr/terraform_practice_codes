# CI/CD in AWS Cloud Automation
Building AWS Infrastructure using Terraform

# Instruction to re-generate the lb-app server infrastructure
## Pre-Requisites
```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y yum-utils wget unzip ansible git
sudo wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip
sudo unzip terraform_0.12.2_linux_amd64.zip -d /usr/local/bin/
```

## Clone the repository
```
git clone https://github.com/vigneshpalanivelr/terraform_practice_codes.git
git checout demo_ld_app_server
cd terraform_practice_codes/modules/all_modules/demo_ld_app_server/
```

## Assumptiomns
1) Use default VPC (because it has connection to outside world)
2) If you are using custome VPC, please consider using IGW and necessory ports enabled in NACLs
3) In terraform am using assume role(not using Access keys)

## Verify TF_VAR file
Verify the TF vars according to your AWS environment setup (modify if anything required)
```
terraform_practice_codes/variables/global_vars.tfvars
terraform_practice_codes/variables/ec2_instance_vars.tfvars
```

## Run terraform command
There is no configuration for TF-STATE backend(like S3)
```
terrafom init
terrafom plan  -var-file=../../../variables/global_vars.tfvars -var-file=../../../variables/ec2_instance_vars.tfvars
terraform apply -var-file=../../../variables/global_vars.tfvars -var-file=../../../variables/ec2_instance_vars.tfvars
```

Please provide input
example: 
```
var.ec2_instance_name : demo-instance
var.root_passwd       : password
var.root_user         : root_user
provider.aws.region   : us-east-2
```

FYI:
1) This will create a Security Group with all ports open(for demo purpose only)
2) Also creates 3 EC2 instances (according to the AMI you given)
3) 1st EC2 : haproxy
4) 2,3 EC2 : httpd
5) It will install haproxy and tomcat to the above servers
6) Ansible will use above username password to connect to the instance and install

## Checks
use curl command to the verify