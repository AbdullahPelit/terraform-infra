####Public route associations
resource "aws_route_table_association" "public-xlb-a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-1a-xlb.id
}

resource "aws_route_table_association" "public-xlb-b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-1b-xlb.id
}

resource "aws_route_table_association" "public-xlb-c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-1c-xlb.id
}

####Private private-a associations####

resource "aws_route_table_association" "private-containers-a" {
  route_table_id = aws_route_table.private-a.id
  subnet_id      = aws_subnet.private-1a-containers.id
}
resource "aws_route_table_association" "private-database-a" {
  route_table_id = aws_route_table.private-a.id
  subnet_id      = aws_subnet.private-1a-database.id
}
resource "aws_route_table_association" "private-generic-a" {
  route_table_id = aws_route_table.private-a.id
  subnet_id      = aws_subnet.private-1a-generic.id
}

####Private private-b associations####

resource "aws_route_table_association" "private-containers-b" {
  route_table_id = aws_route_table.private-b.id
  subnet_id      = aws_subnet.private-1b-containers.id
}
resource "aws_route_table_association" "private-database-b" {
  route_table_id = aws_route_table.private-b.id
  subnet_id      = aws_subnet.private-1b-database.id
}
resource "aws_route_table_association" "private-generic-b" {
  route_table_id = aws_route_table.private-b.id
  subnet_id      = aws_subnet.private-1b-generic.id
}

####Private private-c associations####

resource "aws_route_table_association" "private-containers-c" {
  route_table_id = aws_route_table.private-c.id
  subnet_id      = aws_subnet.private-1c-containers.id
}
resource "aws_route_table_association" "private-database-c" {
  route_table_id = aws_route_table.private-c.id
  subnet_id      = aws_subnet.private-1c-database.id
}
resource "aws_route_table_association" "private-generic-c" {
  route_table_id = aws_route_table.private-c.id
  subnet_id      = aws_subnet.private-1c-generic.id
}