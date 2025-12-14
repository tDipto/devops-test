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

      

    }
  }
}