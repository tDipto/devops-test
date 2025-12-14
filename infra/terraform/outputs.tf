output "namespace" {
  description = "Application namespace"
  value       = kubernetes_namespace.dev.metadata[0].name
}

output "frontend_host" {
  description = "Frontend ingress host"
  value       = var.frontend_host
}

output "backend_host" {
  description = "Backend API ingress host"
  value       = var.backend_host
}