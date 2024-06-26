locals {
  #general prefix
  prefix = "${var.project_name}-${var.environment}"

  vpc_name = "${local.prefix}-vpc"

  #subnet
  subnet_public01_name = "${local.prefix}-1a-public"
  subnet_public02_name = "${local.prefix}-1b-public"
  subnet_public03_name = "${local.prefix}-1c-public"

  subnet_containers01_name = "${local.prefix}-1a-containers"
  subnet_containers02_name = "${local.prefix}-1b-containers"
  subnet_containers03_name = "${local.prefix}-1c-containers"

  subnet_database01_name = "${local.prefix}-1a-database"
  subnet_database02_name = "${local.prefix}-1b-database"
  subnet_database03_name = "${local.prefix}-1c-database"

  subnet_private_generic01_name = "${local.prefix}-1a-private-generic"
  subnet_private_generic02_name = "${local.prefix}-1b-private-generic"
  subnet_private_generic03_name = "${local.prefix}-1c-private-generic"

  igw_name = "igw-${local.prefix}-vpc"

  rt_public_name = "rt-${local.prefix}-public"
  rt_private01_name = "rt-${local.prefix}-private-a"
  rt_private02_name = "rt-${local.prefix}-private-b"
  rt_private03_name = "rt-${local.prefix}-private-c"

  #nat
  nat01_name = "nat-gateway-${local.prefix}-vpc-public-1a"
  nat02_name = "nat-gateway-${local.prefix}-vpc-public-1b"
  nat03_name = "nat-gateway-${local.prefix}-vpc-public-1c"

  #eip
  eip01_name = "eip-${var.environment}-${var.project_name}-nat-1a"
  eip02_name = "eip-${var.environment}-${var.project_name}-nat-1b"
  eip03_name = "eip-${var.environment}-${var.project_name}-nat-1c"
}