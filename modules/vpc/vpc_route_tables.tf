### Public
resource "aws_route_table" "public" {

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name        = local.rt_public_name
    CostCenter  = local.rt_public_name
  }

  vpc_id = aws_vpc.vpc.id
}

#### Private-a
resource "aws_route_table" "private-a" {

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1a.id
  }

  tags = {
    Name        = local.rt_private01_name
    CostCenter  = local.rt_private01_name
  }

  vpc_id = aws_vpc.vpc.id
}

#### Private-b
resource "aws_route_table" "private-b" {

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1b.id
  }

  tags = {
    Name        = local.rt_private02_name
    CostCenter  = local.rt_private02_name
  }

  vpc_id = aws_vpc.vpc.id
}


#### Private-c
resource "aws_route_table" "private-c" {

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1c.id
  }
  
  tags = {
    Name        = local.rt_private03_name
    CostCenter  = local.rt_private03_name
  }

  vpc_id = aws_vpc.vpc.id
}