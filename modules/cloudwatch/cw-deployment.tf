resource "kubernetes_service_account" "cloudwatch_agent" {
  metadata {
    name      = "cloudwatch-agent"
    namespace = "kube-system"
  }
}

resource "kubernetes_daemonset" "cloudwatch_agent" {
  metadata {
    name      = "cloudwatch-agent"
    namespace = "kube-system"
    labels = {
      app = "cloudwatch-agent"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "cloudwatch-agent"
      }
    }

    template {
      metadata {
        labels = {
          name = "cloudwatch-agent"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.cloudwatch_agent.metadata[0].name

        container {
          name  = "cloudwatch-agent"
          image = "amazon/cloudwatch-agent:latest"

          resources {
            limits = {
              memory = "200Mi"
              cpu    = "200m"
            }

            requests = {
              memory = "200Mi"
              cpu    = "200m"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/cloudwatch-config"
          }

          volume_mount {
            name       = "var-log"
            mount_path = "/var/log"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.cloudwatch_agent_config.metadata[0].name
          }
        }

        volume {
          name = "var-log"

          host_path {
            path = "/var/log"
          }
        }
      }
    }
  }
}
