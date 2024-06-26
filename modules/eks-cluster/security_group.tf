resource "aws_security_group" "node" {
    name    = format("eks-node-sg-%s", var.project_name)
    vpc_id  = data.aws_vpc.main.id
    tags    = {
        format("kubernetes.io/cluster/%s", var.project_name) = "owned",
        "Name" = format("eks-node-sg-%s", var.project_name),
        "karpenter.sh/discovery" = local.cluster_name
    }
}

resource "aws_security_group_rule" "node_to_node" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "-1"
    source_security_group_id = aws_security_group.node.id
    security_group_id        = aws_security_group.node.id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "control_to_node" {
    type                     = "ingress"
    from_port                = 1025
    to_port                  = 65535
    protocol                 = "tcp"
    source_security_group_id = local.cluster_security_group_id
    security_group_id        = aws_security_group.node.id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "control_to_node_api" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = local.cluster_security_group_id
    security_group_id        = aws_security_group.node.id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "node_egress" {
    type                     = "egress"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.node.id
    description              = "TF: outbound everywhere"

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "node_to_control_api" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.node.id
    security_group_id        = local.cluster_security_group_id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "egress_control_to_node_api" {
    type                     = "egress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.node.id
    security_group_id        = local.cluster_security_group_id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "ingress_control_to_private" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = local.cluster_security_group_id

    depends_on = [
        aws_security_group.node,
    ]
}

resource "aws_security_group_rule" "egress_control_to_node" {
    type                     = "egress"
    from_port                = 1025
    to_port                  = 65535
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.node.id
    security_group_id        = local.cluster_security_group_id

    depends_on = [
        aws_security_group.node,
    ]
}
