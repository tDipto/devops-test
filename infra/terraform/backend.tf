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
    replicas = var.backend_replicas

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
          image             = var.backend_image
          image_pull_policy = "Never"

          port {
            container_port = var.backend_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  depends_on = [kubernetes_deployment.backend]

  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = var.backend_port
      target_port = var.backend_port
    }

    type = "ClusterIP"
  }
}