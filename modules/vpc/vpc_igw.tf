## Internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = local.igw_name
    Environment = "${var.environment}"
    CostCenter  = local.igw_name
  }
}