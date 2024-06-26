locals {
  
  create_iam_role        = var.create && var.create_iam_role
  irsa_oidc_provider_url = replace(var.irsa_oidc_provider_arn, "/^(.*provider/)/", "")
  prefix = "${var.project_name}-${var.environment}"

  enable_spot_termination = var.create && var.enable_spot_termination

  queue_name = coalesce(var.queue_name, format("%s","${var.eks_module}".name))
  
 
  cluster_name = format("%s","${var.eks_module}".name) 
  cluster_issuer = format("%s","${var.eks_module}".issuer) 
  vpc_id = format("%s","${var.vpc_module}".vpc_id)  
  eks_token = format("%s","${var.eks_module}".token)
  eks_cluster_cert = format("%s","${var.eks_module}".kubeconfig-ca-data)
  eks_endpoint = format("%s","${var.eks_module}".endpoint)
  subnet_ids = [
                  format("%s", "${var.vpc_module}".subnet_public-1a-xlb),
                  format("%s", "${var.vpc_module}".subnet_public-1b-xlb),
                  format("%s", "${var.vpc_module}".subnet_public-1c-xlb),
                  format("%s", "${var.vpc_module}".subnet_private-1a-containers),
                  format("%s", "${var.vpc_module}".subnet_private-1b-containers),
                  format("%s", "${var.vpc_module}".subnet_private-1c-containers)
                ]


  events = {
    health_event = {
      name        = "HealthEvent"
      description = "Karpenter interrupt - AWS health event"
      event_pattern = {
        source      = ["aws.health"]
        detail-type = ["AWS Health Event"]
      }
    }
    spot_interrupt = {
      name        = "SpotInterrupt"
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Spot Instance Interruption Warning"]
      }
    }
    instance_rebalance = {
      name        = "InstanceRebalance"
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance Rebalance Recommendation"]
      }
    }
    instance_state_change = {
      name        = "InstanceStateChange"
      description = "Karpenter interrupt - EC2 instance state-change notification"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance State-change Notification"]
      }
    }
  }

  create_node_iam_role = var.create && var.create_node_iam_role

  node_iam_role_name          = coalesce(var.node_iam_role_name, "Karpenter-${var.cluster_name}")
  node_iam_role_policy_prefix = "arn:aws:iam::aws:policy"
  cni_policy                  = var.cluster_ip_family == "ipv6" ? "arn:aws:iam::${var.aws_account_id}:policy/AmazonEKS_CNI_IPv6_Policy" : "${local.node_iam_role_policy_prefix}/AmazonEKS_CNI_Policy"


  external_role_name = try(replace(var.node_iam_role_arn, "/^(.*role/)/", ""), null)

}