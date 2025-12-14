resource "kubernetes_namespace" "dev" {
  metadata {
    name = "devops-dev"
  }

  depends_on = [kind_cluster.this]
}