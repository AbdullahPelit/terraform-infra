resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-${local.prefix}-sg"

  vpc_id = local.vpc_id

}

resource "aws_security_group_rule" "allow_from_openvpn" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = local.openvpn_sg_id
}

resource "aws_security_group_rule" "allow_from_cluster_nodes" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = local.cluster_node_security_group_id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = local.subnet_ids

  tags = {
    Name = "Subnet Group"
  }
}