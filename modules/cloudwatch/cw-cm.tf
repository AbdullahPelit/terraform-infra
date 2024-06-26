resource "kubernetes_config_map" "cloudwatch_agent_config" {
  metadata {
    name      = "cloudwatch-agent-config"
    namespace = "kube-system"
    labels = {
      app = "cloudwatch-agent"
    }
  }

  data = {
    "config.json" = <<EOF
{
  "logs": {
    "metrics_collected": {
      "kubernetes": {
        "cluster_name": "${local.cluster_name}",
        "metrics_collection_interval": 60
      }
    },
    "force_flush_interval": 5
  }
}
EOF
  }

}
