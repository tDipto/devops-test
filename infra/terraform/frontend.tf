resource "kubernetes_deployment" "frontend" {
  depends_on = [kind_cluster.this, kubernetes_namespace.dev]

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name              = "frontend"
          image             = "frontend:latest"
          image_pull_policy = "Never"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  depends_on = [kubernetes_deployment.frontend]  # Ensures pods exist before service

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}