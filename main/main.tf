module "iam_roles" {
  source      = "../modules/ec2/ec2-iamrole"
  environment = var.environment
}

module "ec2_keypair" {
  source      = "../modules/ec2/ec2-keypair"
  environment = var.environment
}

module "vpc" {
  source       = "../modules/vpc"
  aws_region   = var.location   
  vpc_cidr     = "10.50.0.0/16"
  project_name = var.project_name
  environment  = var.environment

}

module "openvpn" {
  source        = "../modules/openvpn"
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = module.vpc.vpc_cidr_block
  name          = "${var.project_name}-openvpn"
  environment   = var.environment
  volume_size   = 30
  volume_type   = "gp3"
  instance_type = "t3a.micro"
  subnet_id     = module.vpc.subnet_public-1a-xlb
  instance_role = module.iam_roles.ssm_instance_profile
  ec2_keypair   = module.ec2_keypair.ec2_keypair
  public_ip     = true
  depends_on    = [module.vpc, module.ec2_keypair, module.iam_roles]
}


module "eks-cluster" {
  source            = "../modules/eks-cluster"
  vpc_module        = module.vpc
  aws_account_id    = var.account_id
  cluster_version   = "1.30" # EKS cluster version
  project_name      = var.project_name
  eks_public_access = false
  environment       = var.environment
  # permit_usergroup = [
  #   {
  #     arn       = "arn:aws:iam::${var.account_id}:user/baris.ozturk"
  #     user_name = "baris-ozturk"
  #     groups    = ["system:masters"]
  #   },
  #   {
  #     arn       = "arn:aws:iam::${var.account_id}:user/abdullah.pelit"
  #     user_name = "abdullah.pelit"
  #     groups    = ["system:masters"]
  #   }
  # ]
  # permit_rolegroup = [
  #   {
  #     arn           = "arn:aws:iam::${var.account_id}:role/${var.project_name}-${var.environment}-eks-nodegroup-role"
  #     user_name     = "system:node:{{EC2PrivateDNSName}}"
  #     groups        = [
  #                       "system:bootstrappers",
  #                       "system:nodes"
  #     ],
  #   },
  #   {
  #     arn           = "arn:aws:iam::${var.account_id}:role/KarpenterNodeRole-${var.project_name}-${var.environment}"
  #     user_name     = "system:node:{{EC2PrivateDNSName}}"
  #     groups        = [
  #                       "system:bootstrappers",
  #                       "system:nodes"
  #     ],
  #   },
  #   {
  #     arn           = "arn:aws:iam::${var.account_id}:role/${var.project_name}-${var.environment}-eks-user-access-role"
  #     user_name     = "${var.project_name}-${var.environment}-eks-user-access-role"
  #     groups    = ["system:masters"],
  #   },
  # ]
}

module "eks-nodegroup-ondemand" {
  source         = "../modules/eks-nodegroup"
  vpc_module     = module.vpc
  eks_module     = module.eks-cluster
  eks_worker_ami = "ami-066d744867bb80fce" # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
  nodegroup_name = "ondemand-node-group"   # Worker node group ismi verilmelidir.
  capacity_type  = "ON_DEMAND"
  instance_type  = "t3a.large" # Worker instance type'ı ifade eder.
  #instance_list = ["c5a.large"] # mixed instance true ise instance tipi listesi girilmesi gerekir.
  min_size    = "1"  # minimum kaç worker istiyoruz.
  max_size    = "5"  # maksimum kaç worker istiyoruz.
  volume_size = "80" # Worker nodelarda ebs alan boyutu.
  volume_type = "gp3"
  taint = {
    key    = "dedicated"
    value  = "traffic"
    effect = "NO_SCHEDULE"
  }
  labels = {
    dedicated = "traffic"
  }
  project_name = var.project_name
  environment  = var.environment
}



module "extensions" {
  source                       = "../modules/eks-extensions"
  aws_account_id               = var.account_id
  aws_region                   = var.location # Çalıştığımız AWS region bilgisi girilmelidir.
  vpc_module                   = module.vpc
  eks_module                   = module.eks-cluster
  internal_ingress_nginx       = false #Disabled
  external_ingress_nginx       = false #Disabled
  fluentbit                    = false #Disabled
  monitoring                   = false #Disabled - Geliştirilecek
  cluster_autoscaler           = false  #Disabled - Karpenter kurulumu yapılacak cluster autoscaler'a ihtiyaç yok
  aws_node_termination_handler = false #Disabled
  metric_server                = true
  cilium                       = false #Disabled
  grafana                      = false #Disabled - Geliştirilecek
  prometheus                   = false #Disabled - Geliştirilecek
  aws-ebs-csi-driver           = false
  loadbalancer_controller      = true
  eks_addons                   = false
}

# module "karpenter" {
#   source = "../modules/karpenter-roles"
#   aws_account_id                = var.account_id
#   aws_region                    = var.location # Çalıştığımız AWS region bilgisi girilmelidir.
#   vpc_module                    = module.vpc
#   eks_module                    = module.eks-cluster
#   enable_irsa                   = true
#   enable_pod_identity           = false
#   iam_role_use_name_prefix      = false
#   node_iam_role_use_name_prefix = false
#   project_name                  = var.project_name
#   environment                   = var.environment
  
#   cluster_name = var.cluster_name

#   create_node_iam_role = true
#   node_iam_role_additional_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   # Since the nodegroup role will already have an access entry
#   create_access_entry = false

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# module "karpenter-helm" {
#   source        = "../modules/eks-karpenter"
#   aws_account_id               = var.account_id
#   aws_region                   = var.location # Çalıştığımız AWS region bilgisi girilmelidir.
#   vpc_module                   = module.vpc
#   eks_module                   = module.eks-cluster
#   project_name                 = var.project_name
#   environment                  = var.environment

# }
# module "argocd-helm" {
#   source        = "../modules/argocd"
# }
# module "cw-agent" {
#   source        = "../modules/cloudwatch"
#   project_name                 = var.project_name
#   environment                  = var.environment
# }
module "rds-postgre" {
  source        = "../modules/rds"
  vpc_module    = module.vpc
  eks_module    = module.eks-cluster
  openvpn_module = module.openvpn
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = module.vpc.vpc_cidr_block
  aws_region    = var.location
  environment   = var.environment
  project_name  = var.project_name
}

