resource "kubernetes_ingress_v1" "app" {
  depends_on = [helm_release.nginx_ingress, kubernetes_service.frontend, kubernetes_service.backend]

  metadata {
    name      = "app-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    ingress_class_name = " мальnginx"

    rule {
      host = var.frontend_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = var.frontend_port
              }
            }
          }
        }
      }
    }

    rule {
      host = var.backend_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.backend.metadata[0].name
              port {
                number = var.backend_port
              }
            }
          }
        }
      }
    }
  }
}