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
  pg_rds = {
    protocol    = "tcp"
    port        = "5432"
    description = "RDS PostgreSQL Port Open for - "
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
  public_access_ipv4 = ["0.0.0.0/0"]
}
