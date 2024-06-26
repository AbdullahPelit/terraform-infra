output "name" {
    value = aws_eks_cluster.cluster.name
}

output "issuer" {
    value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "vpc_id" {
    value = aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

output "subnet_ids" {
    value = aws_eks_cluster.cluster.vpc_config[0].subnet_ids
}

output "node_instance_profile_name" {
    value = aws_iam_instance_profile.node.name
}

output "endpoint" {
    value = aws_eks_cluster.cluster.endpoint
}

output "token" {
    value = data.aws_eks_cluster_auth.auth.token
}

output "kubeconfig-ca-data" {
    value = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "node_role_arn" {
    value = data.aws_iam_role.node.arn
}

output "node_security_group_id" {
    value = aws_security_group.node.id
}