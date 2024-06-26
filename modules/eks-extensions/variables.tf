variable "external_ingress_nginx" {}
variable "internal_ingress_nginx" {}
variable "cilium" {}
variable "grafana" {}
variable "fluentbit" {}
variable "prometheus" {}
variable "aws_region" {}
variable "vpc_module" {}
variable "eks_module" {}
variable "monitoring" {}
variable "cluster_autoscaler" {}
variable "aws_node_termination_handler" {}
variable "metric_server" {}
variable "aws-ebs-csi-driver" {}
variable "aws_account_id" {}
variable "loadbalancer_controller" {}
variable "eks_addons" {}
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.30.0-eksbuild.3"
    },
    {
      name    = "vpc-cni"
      version = "v1.16.2-eksbuild.1"
    }
  ]
}
