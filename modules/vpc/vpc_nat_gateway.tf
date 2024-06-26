resource "aws_nat_gateway" "nat-1a" {
  allocation_id = aws_eip.nat-1a.id
  subnet_id     = aws_subnet.public-1a-xlb.id

  tags = {
    Name        = local.nat01_name
    Environment = "${var.environment}"
    CostCenter  = local.nat01_name
  }
}

resource "aws_nat_gateway" "nat-1b" {
  allocation_id = aws_eip.nat-1b.id
  subnet_id     = aws_subnet.public-1b-xlb.id
  
  tags = {
    Name        = local.nat02_name
    Environment = "${var.environment}"
    CostCenter  = local.nat02_name
  }
}

resource "aws_nat_gateway" "nat-1c" {
  allocation_id = aws_eip.nat-1c.id
  subnet_id     = aws_subnet.public-1c-xlb.id
  
  tags = {
    Name        = local.nat03_name
    Environment = "${var.environment}"
    CostCenter  = local.nat03_name
  }
}