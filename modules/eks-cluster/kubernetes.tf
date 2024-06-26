# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.auth.token
# }

# resource "kubernetes_config_map" "aws_auth" {
#   depends_on = [aws_eks_cluster.cluster]
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       for role in var.permit_rolegroup : {
#         rolearn  = role.arn
#         username = role.user_name
#         groups   = role.groups
#       }
#     ])

#     mapUsers = yamlencode([
#       for user in var.permit_usergroup : {
#         userarn  = user.arn
#         username = user.user_name
#         groups   = user.groups
#       }
#     ])

#   }
# }

# resource "kubernetes_storage_class_v1" "gp3" {
#   metadata {
#     name = "gp3"

#     annotations = {
#       # Annotation to set gp3 as default storage class
#       "storageclass.kubernetes.io/is-default-class" = "true"
#     }
#   }

#   storage_provisioner    = "ebs.csi.aws.com"
#   allow_volume_expansion = true
#   reclaim_policy         = "Delete"
#   volume_binding_mode    = "WaitForFirstConsumer"

#   parameters = {
#     encrypted = true
#     fsType    = "ext4"
#     type      = "gp3"
#   }

#   depends_on = [
#     aws_eks_cluster.cluster
#   ]
# }
