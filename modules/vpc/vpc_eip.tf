## Elastic IP's for NAT GW
resource "aws_eip" "nat-1a" {
  domain = "vpc"

  tags = {
    Name = local.eip01_name
    CostCenter  = local.eip01_name
  }
}

resource "aws_eip" "nat-1b" {
  domain = "vpc"

  tags = {
    Name = local.eip02_name
    CostCenter  = local.eip02_name
  }
}

resource "aws_eip" "nat-1c" {
  domain = "vpc"

  tags = {
    Name = local.eip03_name
    CostCenter  = local.eip03_name
  }
}