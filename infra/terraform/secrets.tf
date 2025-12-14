# Backend secret (empty, same as YAML)
resource "kubernetes_secret" "backend" {
  metadata {
    name      = "backend-secrets"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  type = "Opaque"
  data = {}
  depends_on = [kind_cluster.this, kubernetes_namespace.dev]
}

# Postgres secret
resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  type = "Opaque"

  data = {
    POSTGRES_USER     = base64encode("postgres")
    POSTGRES_PASSWORD = base64encode("postgres-pass")
    POSTGRES_DB       = base64encode("sampledb")
  }
  depends_on = [kind_cluster.this, kubernetes_namespace.dev]
}

