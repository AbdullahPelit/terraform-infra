resource "aws_eks_node_group" "traffic" {
  cluster_name    = local.cluster_name
  node_group_name = var.nodegroup_name
  node_role_arn   = local.cluster_nodegroup_role_arn
  subnet_ids      = local.cluster_subnet_ids
  capacity_type   = var.capacity_type

  tags = {
     "karpenter.sh/discovery" = "${local.cluster_name}"
  }

  ami_type        = "CUSTOM"

  scaling_config {
    desired_size = var.min_size
    max_size     = var.max_size
    min_size     = var.min_size
  }  

  labels = var.labels

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "1"
  }

}