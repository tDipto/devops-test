resource "kubernetes_deployment" "backend" {
  depends_on = [kind_cluster.this, kubernetes_namespace.dev]

  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.dev.metadata[0].name

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "5000"
      "prometheus.io/path"   = "/metrics"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name              = "backend"
          image             = "backend:latest"
          image_pull_policy = "Never"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  depends_on = [kubernetes_deployment.backend]  # Ensures pods exist before service

  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}