provider "kubernetes" {
  host                   = local.eks_endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster_cert)
  token                  = local.eks_token
}

resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy-${local.cluster_name}"
  policy = file("${path.module}/lb-controller-policy.json") # policy.json dosyasında AWS Load Balancer Controller için gerekli policy tanımlanmalıdır.
}

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  name = "AmazonEKSLoadBalancerControllerRole-${local.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${trim(local.cluster_issuer, "https://")}"
        },
        Condition = {
          StringEquals = {
            "${trim(local.cluster_issuer, "https://")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller",
            "${trim(local.cluster_issuer, "https://")}:aud": "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attachment" {
  role       = aws_iam_role.aws_load_balancer_controller_role.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller_policy.arn
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller_role.arn
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
    count = "${var.loadbalancer_controller == true ? 1 : 0}"
  name       = "aws-load-balancer-controller"
  chart      = "../modules/eks-extensions/aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "${local.cluster_name}"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "region"
    value = "${var.aws_region}"
  }

  set {
    name  = "vpcId"
    value = "${local.vpc_id}"
  }
}
