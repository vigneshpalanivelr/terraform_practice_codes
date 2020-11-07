# Account Variables
aws_account_num                 = "495710143902"
aws_region                      = "us-east-2"
aws_iam_user                    = "deployer"
assume_role                     = "deployer_role"
ec2_az                          = "us-east-2b"

# VPC Details
aws_vpc_name                    = "default-vpc"
vpc_subnet_name 				= "default-subnet-2"
az_count                        = "3"
ec2_disable_api_termination     = "true"

tags = {
  Owner = "Vignesh Palanivel"
  DL    = "Vignesh_Palanivel@aws.com"
  Team  = "terraform-services-india"
  CCPC  = "123456789"
}