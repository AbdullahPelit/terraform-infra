locals {
  #general prefix
  prefix = "${var.project_name}-${var.environment}"

  openvpn_sg_id = format("%s","${var.openvpn_module}".ovpn_security_group_id)

  vpc_id = format("%s", "${var.vpc_module}".vpc_id)
  subnet_ids = [
                format("%s", "${var.vpc_module}".subnet_private-1a-database),
                format("%s", "${var.vpc_module}".subnet_private-1b-database)
              ]
  cluster_node_security_group_id = format("%s","${var.eks_module}".node_security_group_id)

  # db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string)
}