resource "kubernetes_ingress_v1" "app" {
  depends_on = [kind_cluster.this, kubernetes_namespace.dev,helm_release.nginx_ingress]
  metadata {
    name      = "app-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      
    }
  }

  spec {
    ingress_class_name = "nginx"  
    rule {
      host = "app.devops-test.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "api.devops-test.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.backend.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
