resource "aws_iam_role" "ebs_csi_driver_role" {
  count = "${var.aws-ebs-csi-driver == true ? 1 : 0}"
  name = "AmazonEKS_EBS_CSI_DriverRole-${local.cluster_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${trim(local.cluster_issuer, "https://")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${trim(local.cluster_issuer, "https://")}:aud": "sts.amazonaws.com",
          "${trim(local.cluster_issuer, "https://")}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_default_policy_attachment" {
  count = "${var.aws-ebs-csi-driver == true ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver_role[0].name
}

data "tls_certificate" "eks_oidc" {
  url = local.cluster_issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = local.cluster_issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates.0.sha1_fingerprint]
  depends_on = [data.tls_certificate.eks_oidc]
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  count = "${var.aws-ebs-csi-driver == true ? 1 : 0}"
  cluster_name = local.cluster_name
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver_role[0].arn
}
