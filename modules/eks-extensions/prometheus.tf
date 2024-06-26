resource "helm_release" "prometheus" {
  count = "${var.prometheus == true ? 1 : 0}"

  name = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus"
  namespace = "monitoring"
  version    = "25.7.0"
  create_namespace = true

  description = "prometheus Helm Chart"

  values = [
    <<-EOT
        alertmanagerSpec:
          tolerations:
          - key: "dedicated"
            operator: "Equal"
            value: "traffic"
            effect: "NoSchedule"
        PrometheusSpec:
          storageSpec:
            spec:
              storageClassName: gp3
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 50Gi
          containers:
            args:
              --web.listen-address=0.0.0.0:9090
              --config.file=/etc/prometheus/prometheus.yaml
              --storage.tsdb.path=/var/lib/prometheus
              --storage.tsdb.retention.time=2d
              --storage.tsdb.retention.size=5GiB
              --storage.tsdb.min-block-duration=2h
              --storage.tsdb.max-block-duration=2h
          tolerations:
          - key: "dedicated"
            operator: "Equal"
            value: "traffic"
            effect: "NoSchedule"
        prometheusOperator:
          admissionWebhooks:
            patch:
              tolerations:
              - key: "dedicated"
                operator: "Equal"
                value: "traffic"
                effect: "NoSchedule"
    EOT
  ]
}
