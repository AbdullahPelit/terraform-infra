resource "helm_release" "grafana" {
  count = "${var.grafana == true ? 1 : 0}"

  name = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  namespace = "monitoring"
  version    = "7.2.1"
  create_namespace = true

  description = "Grafana Helm Chart"

  values = [
    <<-EOT
        tolerations:
        - key: "dedicated"
          operator: "Equal"
          value: "traffic"
          effect: "NoSchedule"
        persistence:
          enabled: true
          type: pvc
          size: 30Gi
          storageClassName: gp3
        resources:
          requests:
            cpu: 250m
            memory: 750Mi
          limits:
            cpu: 1000m
            memory: 1500Mi
        datasources:
          datasources.yaml:
            apiVersion: 1
            datasources:
            - name: Prometheus
              type: prometheus
              url: http://prometheus-server.monitoring.svc.cluster.local
        dashboardProviders:
          dashboardproviders.yaml:
            apiVersion: 1
            providers:
            - name: 'default'
              orgId: 1
              folder: 'default'
              type: file
              disableDeletion: true
              editable: true
              options:
                path: /var/lib/grafana/dashboards/default
        dashboards:
          default:
            k8s:
              gnetId: 315
              datasource: Prometheus
    EOT
  ]
}
