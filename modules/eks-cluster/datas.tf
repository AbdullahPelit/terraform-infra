data "aws_vpc" "main" {
    id = local.vpc_id
}

data "aws_iam_role" "cluster" {
    depends_on = [aws_iam_role.cluster]
    name = local.iam_role_cluster_name
}

data "aws_iam_role" "node" {
    depends_on = [aws_iam_role.node]
    name = local.iam_role_node_name
}

data "aws_eks_cluster" "this" {
    name = aws_eks_cluster.cluster.name
    depends_on = [aws_eks_cluster.cluster]
}

data "aws_eks_cluster_auth" "auth" {
    name  = aws_eks_cluster.cluster.name
    depends_on = [aws_eks_cluster.cluster]
}
