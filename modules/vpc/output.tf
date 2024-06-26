#### VPC ####
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "id of vpc"
}
output "vpc_cidr_block" {
  value       = "${var.vpc_cidr}"
}
output "aws_route_table_id" {
  value   = "${aws_route_table.public.id}"
}
output "aws_route_table_id_private_a" {
  value = "${aws_route_table.private-a.id}"
}
output "aws_route_table_id_private_b" {
  value = "${aws_route_table.private-b.id}"
}
output "aws_route_table_id_private_c" {
  value = "${aws_route_table.private-c.id}"
}

#### Subnet ####

#### Public
output "subnet_public-1a-xlb" {
  value       = aws_subnet.public-1a-xlb.id
  description = "id of subnet name -public-1a-xlb "
}
output "subnet_public-1b-xlb" {
  value       = aws_subnet.public-1b-xlb.id
  description = "id of subnet name public-1b-xlb "
}
output "subnet_public-1c-xlb" {
  value       = aws_subnet.public-1c-xlb.id
  description = "id of subnet name public-1c-xlb "
}

#### Private1
output "subnet_private-1a-containers" {
  value       = aws_subnet.private-1a-containers.id
  description = "id of subnet name private-1a-containers "
}
output "subnet_private-1b-containers" {
  value       = aws_subnet.private-1b-containers.id
  description = "id of subnet name private-1b-containers "
}
output "subnet_private-1c-containers" {
  value       = aws_subnet.private-1c-containers.id
  description = "id of subnet name private-1c-containers "
}

#### Private2
output "subnet_private-1a-database" {
  value       = aws_subnet.private-1a-database.id
  description = "id of subnet name private-1a-database"
}
output "subnet_private-1b-database" {
  value       = aws_subnet.private-1b-database.id
  description = "id of subnet name private-1b-database"
}
output "subnet_private-1c-database" {
  value       = aws_subnet.private-1c-database.id
  description = "id of subnet name private-1c-database"
}

#### Private3
output "subnet_private-1a-generic" {
  value       = aws_subnet.private-1a-generic.id
  description = "id of subnet name prod-1a-private-generic"
}
output "subnet_prod-1b-private-generic" {
  value       = aws_subnet.private-1b-generic.id
  description = "id of subnet name private-1b-generic"
}
output "subnet_private--1c-generic" {
  value       = aws_subnet.private-1c-generic.id
  description = "id of subnet name private-1c-generic"
}

#### Route Table ####

#### Public
output "route_table-public" {
  value       = aws_route_table.public.id
  description = "Route table name public"
}

#### Private
output "route_table-private-a" {
  value       = aws_route_table.private-a.id
  description = "Route table name private-a"
}
output "route_table-private-b" {
  value       = aws_route_table.private-b.id
  description = "Route table name private-b"
}
output "route_table-private-c" {
  value       = aws_route_table.private-c.id
  description = "Route table name private-c"
}

# ## Redis subnet group
# output "elasticache_subnet_group_name" {
#   value       = aws_elasticache_subnet_group.redis_subnet_group.name
#   description = "Elasticache subnet group name"
# }

# output "elasticache_security_group_id" {
#   value       = aws_security_group.elasticache_sg.id
#   description = "Elasticache security group id"
# }