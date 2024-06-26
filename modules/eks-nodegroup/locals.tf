locals {
  #general prefix
  prefix = "${var.project_name}-${var.environment}"
  autoscaling_group_name = "${local.prefix}-${var.nodegroup_name}"

  cluster_name = format("%s","${var.eks_module}".name)

  eks_worker_ami = var.eks_worker_ami
  
  kubelet-extra-args = format("--node-labels=nodegroup=%s", var.nodegroup_name)

  vpc_id = format("%s","${var.vpc_module}".vpc_id)
  cluster_subnet_ids = [
                format("%s","${var.vpc_module}".subnet_private-1a-containers),
                format("%s","${var.vpc_module}".subnet_private-1b-containers),
                format("%s","${var.vpc_module}".subnet_private-1c-containers)
              ]
  cluster_node_instance_profile_name = format("%s","${var.eks_module}".node_instance_profile_name)
  cluster_node_security_group_id = format("%s","${var.eks_module}".node_security_group_id)
  cluster_nodegroup_role_arn = format("%s","${var.eks_module}".node_role_arn)
  
  eks_token = format("%s","${var.eks_module}".token)
  eks_cluster_cert = format("%s","${var.eks_module}".kubeconfig-ca-data)
  eks_endpoint = format("%s","${var.eks_module}".endpoint)
}
