variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "kind-cluster-1"
}

variable "kubernetes_version" {
  description = "Kubernetes version for Kind node image"
  type        = string
  default     = "v1.29.8"
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "devops-dev"
}

variable "frontend_image" {
  description = "Docker image for frontend"
  type        = string
  default     = "frontend:latest"
}

variable "backend_image" {
  description = "Docker image for backend"
  type        = string
  default     = "backend:latest"
}

variable "frontend_port" {
  description = "Port exposed by frontend container"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port exposed by backend container"
  type        = number
  default     = 5000
}

variable "frontend_host" {
  description = "Ingress host for frontend"
  type        = string
  default     = "app.devops-test.local"
}

variable "backend_host" {
  description = "Ingress host for backend API"
  type        = string
  default     = "api.devops-test.local"
}

variable "frontend_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 1
}

variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 1
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "postgres-pass"
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "sampledb"
}