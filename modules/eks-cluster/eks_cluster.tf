resource "aws_iam_role" "cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = data.aws_iam_role.cluster.name

  depends_on = [aws_iam_role.cluster]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = data.aws_iam_role.cluster.name

  depends_on = [aws_iam_role.cluster]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = data.aws_iam_role.cluster.name

  depends_on = [aws_iam_role.cluster]
}

resource "aws_iam_role" "eks_user_access_role" {
  name = "${var.project_name}-${var.environment}-eks-user-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Principal: {
          AWS: "arn:aws:iam::${var.aws_account_id}:root"
        },
        Action: "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_user_policy_attachment" {
  role       = aws_iam_role.eks_user_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_eks_cluster" "cluster" {
    name           = local.cluster_name
    version        = var.cluster_version
    role_arn       = aws_iam_role.cluster.arn

    vpc_config {
        subnet_ids = local.subnet_ids
        endpoint_private_access = true
        endpoint_public_access = var.eks_public_access == true ? true : false
        public_access_cidrs    = [
          "0.0.0.0/0"
        ]
    }

    tags = {
        Name = local.cluster_name
        CostCenter  = local.cluster_name
        "karpenter.sh/discovery" = local.cluster_name
    }

    depends_on = [
        aws_iam_role.cluster,
        aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
        aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    ]
}

resource "aws_iam_role" "node" {
  name = "${var.project_name}-${var.environment}-eks-nodegroup-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": [
                "sts:AssumeRole"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "AutoScaling" {
  name = "${var.project_name}-${var.environment}-autoscaling"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_role.node]
}

resource "aws_iam_role_policy_attachment" "AutoScaling" {
  policy_arn = aws_iam_policy.AutoScaling.arn
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_policy.AutoScaling]
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_role.node]
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_role.node]
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_role.node]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceControllerWorker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = data.aws_iam_role.node.name

  depends_on = [aws_iam_role.node]
}

resource "aws_iam_instance_profile" "node" {
    name_prefix = format("%s", aws_eks_cluster.cluster.name)
    role        = data.aws_iam_role.node.name

    depends_on = [
        aws_iam_role.node,
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
        aws_iam_role_policy_attachment.AmazonEKSVPCResourceControllerWorker,
  ]
}  