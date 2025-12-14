resource "kubernetes_namespace" "dev" {
  metadata {
    name = var.namespace
  }

  depends_on = [kind_cluster.this]
}