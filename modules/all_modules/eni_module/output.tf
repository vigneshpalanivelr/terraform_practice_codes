#Data Filter Details
output "security_groups" { value = "${split(",",join(",",data.aws_security_group.filter_sg.*.id))}"	}
output "subnet_id" { value = "${data.aws_subnet.filter_subnet.id}"		}

#ENI Details
output "eni_id" { value = "${module.ec2_network_interface.eni_id}"		}
output "description" { value = "${module.ec2_network_interface.eni_description}"}
