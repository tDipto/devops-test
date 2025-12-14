# DevOps Local Kubernetes Architecture

## Local Machine

Browser accesses services using hostnames mapped to the Minikube IP.

```
192.168.49.2  *.devops-test.local
```

## Architecture Diagram

```mermaid
graph TD
    subgraph "Local Machine"
        Browser["Browser accesses via hostnames"]
        Hosts["/etc/hosts → 192.168.49.2 *.devops-test.local"]
    end

    subgraph "minikube-cluster-1 (IP: 192.168.49.2)"
        direction TB

        subgraph devops_dev["Namespace: devops-dev"]
            IngressApp["Ingress NGINX → app (80) & api (5000)"]
            Frontend["Frontend Pods (container port 80)"]
            Backend["Backend Pods (container port 5000, exposes /metrics)"]
            Postgres["PostgreSQL + pgvector (5432, 5Gi PVC)"]
        end

        subgraph devops_monitoring["Namespace: devops-dev-monitoring"]
            IngressGrafana["Ingress → grafana.devops-test.local"]
            Grafana["Grafana (3000, NodePort 32000)"]
            Prometheus["Prometheus (9090, NodePort 30909)"]
            Loki["Loki (3100, ClusterIP only)"]
            FluentBit["Fluent Bit DaemonSet → Loki"]
        end

        HPA["HPA → Backend"]
        RateLimit["Ingress Rate Limiting (429)"]
    end

    subgraph "minikube-cluster-redis (IP: 192.168.50.2)"
        subgraph redis_default["Namespace: default"]
            Redis["Redis (6379 → NodePort 30079)"]
        end
    end

    subgraph "minikube-cluster-rabbitmq (IP: 192.168.51.2)"
        subgraph rabbitmq_default["Namespace: default"]
            RabbitMQ["RabbitMQ (5672 → 30672, UI 15672 → 31672)"]
        end
    end

    Hosts --> Browser
    Browser --> IngressApp
    Browser --> IngressGrafana

    IngressApp --> Frontend
    IngressApp --> Backend
    IngressGrafana --> Grafana

    Backend --> Postgres
    Backend -.->|"NodePort 30079"| Redis
    Backend -.->|"AMQP 30672"| RabbitMQ

    Prometheus -->|"Scrapes /metrics"| Backend
    FluentBit --> Loki
    Grafana --> Prometheus
    Grafana --> Loki
    HPA --> Backend
```

## Namespaces

### devops-dev

- Frontend application
- Backend API with metrics
- PostgreSQL with pgvector
- Ingress NGINX
- HPA enabled
- Rate limiting

### devops-dev-monitoring

- Prometheus
- Grafana
- Loki
- Fluent Bit

## External Services

| Service  | Access                   |
| -------- | ------------------------ |
| Redis    | NodePort 30079           |
| RabbitMQ | 30672 (AMQP), 31672 (UI) |

## URLs

| Service  | URL                              |
| -------- | -------------------------------- |
| Frontend | http://app.devops-test.local     |
| Backend  | http://api.devops-test.local     |
| Grafana  | http://grafana.devops-test.local |







## 📸 Screenshots Overview

- **DevOps Cluster Overview**  
  All Minikube clusters running together.  
  ![DevOps Cluster](screenshots/all_cluster.png)

- **DevOps Pods**  
  Backend and Frontend pods in `devops-dev` namespace.  
  ![DevOps Pods](screenshots/get_devops_pods.png)

- **Seed Data in Backend Pod**  
  Seed data applied inside backend pod.  
  ![Seed Data](screenshots/seed_data_backend_pod.png)

- **Redis Cluster Overview**  
  Redis running with NodePort.  
  ![Redis Cluster](screenshots/redis_cluster.png)

- **Ping Redis from DevOps Cluster**  
  Connectivity test from backend pod to Redis.  
  ![Redis Ping](screenshots/redis_ping_from_cluster_1.png)

- **RabbitMQ Cluster Overview**  
  RabbitMQ service running with NodePort.  
  ![RabbitMQ Cluster](screenshots/rabbimq_cluster.png)

- **Ping RabbitMQ from DevOps Cluster**  
  Connectivity test from backend pod to RabbitMQ.  
  ![RabbitMQ Ping](screenshots/rabbitmq_ping_from_cluster_1.png)

- **Grafana Logs & Metrics**  
  Grafana showing logs and metrics dashboards.  
  ![Grafana](screenshots/grafana_log.png)
