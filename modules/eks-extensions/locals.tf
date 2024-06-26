locals {
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
}