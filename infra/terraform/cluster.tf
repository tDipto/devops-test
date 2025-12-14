resource "kind_cluster" "this" {
  name           = "kind-cluster-1"
  wait_for_ready = true

  node_image = "kindest/node:v1.29.8"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # Label for ingress controller to schedule
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      # OPTIONAL: If you want direct localhost:80/443 access, bind to 127.0.0.1 only (less conflict-prone)
      # extra_port_mappings {
      #   container_port = 80
      #   host_port      = 80
      #   listen_address = "127.0.0.1"
      #   protocol       = "TCP"
      # }
      # extra_port_mappings {
      #   container_port = 443
      #   host_port      = 443
      #   listen_address = "127.0.0.1"
      #   protocol       = "TCP"
      # }

    }
  }
}