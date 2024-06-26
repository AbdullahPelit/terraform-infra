#### Public
resource "aws_subnet" "public-1a-xlb" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}", 8, 96) # 10.100.96.0/24 254 hosts
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = local.subnet_public01_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
    CostCenter  = local.subnet_public01_name
  }
}

resource "aws_subnet" "public-1b-xlb" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}", 8, 97) # 10.100.97.0/24 254 hosts
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = local.subnet_public02_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
    CostCenter  = local.subnet_public02_name
  }
}

resource "aws_subnet" "public-1c-xlb" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}", 8, 98) # 10.100.98.0/24 254 hosts
  availability_zone = "${var.aws_region}c"

  tags = {
    Name        = local.subnet_public03_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
    CostCenter  = local.subnet_public03_name
  }
}

#### Node

resource "aws_subnet" "private-1a-containers" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",3,0) # 10.100.0.0/19 8190 hosts
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = local.subnet_containers01_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "karpenter.sh/discovery" = "${local.prefix}-cluster"
    CostCenter  = local.subnet_containers01_name
  }
}

resource "aws_subnet" "private-1b-containers" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",3,1) # 10.100.32.0/19 8190 hosts
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = local.subnet_containers02_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "karpenter.sh/discovery" = "${local.prefix}-cluster"
    CostCenter  = local.subnet_containers02_name
  }
}

resource "aws_subnet" "private-1c-containers" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",3,2) # 10.100.64.0/19 8190 hosts
  availability_zone = "${var.aws_region}c"

  tags = {
    Name        = local.subnet_containers03_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "karpenter.sh/discovery" = "${local.prefix}-cluster"
    CostCenter  = local.subnet_containers03_name
  }
}

#### Intra

resource "aws_subnet" "private-1a-database" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",8,99) # 10.100.99.0/24 254 hosts
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = local.subnet_database01_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    CostCenter  = local.subnet_database01_name
  }
}

resource "aws_subnet" "private-1b-database" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",8,100) # 10.100.100.0/24 254 hosts
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = local.subnet_database02_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    CostCenter  = local.subnet_database02_name
  }
}

resource "aws_subnet" "private-1c-database" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",8,101) # 10.100.101.0/24 254 hosts
  availability_zone = "${var.aws_region}c"

  tags = {
    Name        = local.subnet_database03_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    CostCenter  = local.subnet_database03_name
  }
}

#### Private3

resource "aws_subnet" "private-1a-generic" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",5,13) # 10.100.104.0/21 2046 hosts
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = local.subnet_private_generic01_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    CostCenter  = local.subnet_private_generic01_name
  }
}

resource "aws_subnet" "private-1b-generic" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",5,14) # 10.100.112.0/21 2046 hosts
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = local.subnet_private_generic02_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    CostCenter  = local.subnet_private_generic02_name
  }
}

resource "aws_subnet" "private-1c-generic" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet("${var.vpc_cidr}",5,15) # 10.100.100.0/21 2046 hosts
  availability_zone = "${var.aws_region}c"

  tags = {
    Name        = local.subnet_private_generic03_name
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${local.prefix}-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    CostCenter  = local.subnet_private_generic03_name
  }
}