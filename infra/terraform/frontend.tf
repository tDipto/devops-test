resource "kubernetes_deployment" "frontend" {
  depends_on = [kind_cluster.this, kubernetes_namespace.dev]

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    replicas = var.frontend_replicas

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
          image             = var.frontend_image
          image_pull_policy = "Never"

          port {
            container_port = var.frontend_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  depends_on = [kubernetes_deployment.frontend]

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = var.frontend_port
      target_port = var.frontend_port
    }

    type = "ClusterIP"
  }
}