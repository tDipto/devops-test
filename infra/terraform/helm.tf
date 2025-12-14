resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.watchIngressWithoutClass"
    value = "true"
    type  = "string"  # Important for booleans
  }

  set {
    name  = "controller.nodeSelector.ingress-ready"
    value = "true"
    type  = "string"  # This fixes the unmarshal error!
  }

  # Tolerations (array of maps) - these need dotted notation for each field
  set {
    name  = "controller.tolerations[0].key"
    value = "node-role.kubernetes.io/control-plane"
  }
  set {
    name  = "controller.tolerations[0].operator"
    value = "Exists"
  }
  set {
    name  = "controller.tolerations[0].effect"
    value = "NoSchedule"
  }

  depends_on = [kind_cluster.this]
}