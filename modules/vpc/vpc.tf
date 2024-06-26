resource "aws_vpc" "vpc" {

  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name        = local.vpc_name
    CostCenter  = local.vpc_name
    ClusterName = "${var.project_name}-${var.environment}-cluster"
  }
}