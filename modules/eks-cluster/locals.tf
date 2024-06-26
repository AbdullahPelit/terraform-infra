locals {
  #general prefix
  prefix = "${var.project_name}-${var.environment}"
  nodegroup_role = "${data.aws_iam_role.node.arn}"
  

  iam_role_cluster_name = "${local.prefix}-eks-cluster-role"
  iam_role_node_name    = "${local.prefix}-eks-nodegroup-role"
  cluster_name          = "${local.prefix}-cluster"


  cluster_security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  vpc_id = format("%s", "${var.vpc_module}".vpc_id)
  subnet_ids = [
                format("%s", "${var.vpc_module}".subnet_public-1a-xlb),
                format("%s", "${var.vpc_module}".subnet_public-1b-xlb),
                format("%s", "${var.vpc_module}".subnet_public-1c-xlb),
                format("%s", "${var.vpc_module}".subnet_private-1a-containers),
                format("%s", "${var.vpc_module}".subnet_private-1b-containers),
                format("%s", "${var.vpc_module}".subnet_private-1c-containers)
              ]
}
