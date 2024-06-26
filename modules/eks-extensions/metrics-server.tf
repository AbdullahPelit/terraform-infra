resource "helm_release" "metricsserver" {
  count = "${var.metric_server == true ? 1 : 0}"

  name = "metricsserver"
  chart = "../modules/eks-extensions/metrics-server"
  verify = false
  namespace = "kube-system"
  dependency_update = true

}
