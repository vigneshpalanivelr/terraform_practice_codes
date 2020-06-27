port_details = {
  ssh = {
    protocol    = "tcp"
    port        = "22"
    description = "SSH Port Open for - "
  }
  jenkins = {
    protocol    = "tcp"
    port        = "8080"
    description = "Jenkins Port Open for - "
  }
  artifactory = {
    protocol    = "tcp"
    port        = "8081"
    description = "Artifactory Port Open for - "
  }
  pg_rds = {
    protocol    = "tcp"
    port        = "5432"
    description = "RDS PostgreSQL Port Open for - "
  }
  all_subnet_default = {
    protocol    = "tcp"
	from_port   = "0"
	to_port     = "65535"
    description = "All Default Subnets for All Ports"
  }
  pingv4 = {
    protocol    = "icmp"
    port        = "-1"
    description = "IPv4 Ping Check Open for - "
  }
  pingv6 = {
    protocol    = "icmpv6"
    port        = "-1"
    description = "IPv6 Ping Check Open for - "
  }
}

cidr_block = {
  public_access_ipv4 = {
    ip_range  = "0.0.0.0/0"
	from_port = "0"
	to_port   = "65535"
  }
  all_subnet_default = {
    ip_range  = "172.31.0.0/18"
    protocol  = "tcp"
	from_port = "0"
	to_port   = "65535"
  }
}
