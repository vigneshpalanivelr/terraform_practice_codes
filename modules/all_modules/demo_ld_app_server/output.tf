#EC2 Details
output "ec2_id"          { value = module.aws_ec2_module.ec2_id                             }
output "ec2_arn"         { value = module.aws_ec2_module.ec2_arn                            }
output "ec2_az"          { value = module.aws_ec2_module.ec2_availability_zone              }
output "ec2_public_ip"   { value = module.aws_ec2_module.ec2_public_ip                      }
output "ec2_eni_id"          { value = module.aws_ec2_module.ec2_primary_network_interface_id   }
output "ec2_private_dns" { value = module.aws_ec2_module.ec2_private_dns                    }
output "ec2_private_ip"  { value = module.aws_ec2_module.ec2_private_ip                     }
output "ec2_vpc_sg_id"   { value = module.aws_ec2_module.ec2_vpc_security_group_ids         }
output "ec2_subnet_id"   { value = module.aws_ec2_module.ec2_subnet_id                      }
output "ec2_state"       { value = module.aws_ec2_module.ec2_instance_state                 }

# Creating ANSIBLE inventory file
### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  lb-ip = module.aws_ec2_module.ec2_private_ip[0],
  lb-id = module.aws_ec2_module.ec2_id[0],
  private-ip-1  = module.aws_ec2_module.ec2_private_ip[1],
  private-id-1  = module.aws_ec2_module.ec2_id[1],
  private-ip-2  = module.aws_ec2_module.ec2_private_ip[2],
  private-id-2  = module.aws_ec2_module.ec2_id[2],
 }
 )
 filename = "ansible/inventory"
}
