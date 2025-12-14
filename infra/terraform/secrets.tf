resource "kubernetes_secret" "backend" {
  metadata {
    name      = "backend-secrets"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  type       = "Opaque"
  data       = {}
  depends_on = [kubernetes_namespace.dev]
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  type = "Opaque"
  data = {
    POSTGRES_USER     = base64encode(var.postgres_user)
    POSTGRES_PASSWORD = base64encode(var.postgres_password)
    POSTGRES_DB       = base64encode(var.postgres_db)
  }
  depends_on = [kubernetes_namespace.dev]
}