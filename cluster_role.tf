resource "kubernetes_cluster_role" "this" {
  metadata {
    name = var.name
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["nodes", "pods"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/logs"]
    verbs      = ["get"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }

  rule {
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    verbs          = ["get", "update"]
    resource_names = [var.name]
  }

  rule {
    api_groups = ["ilert.com"]
    resources  = ["incidents"]
    verbs      = ["create", "get", "list", "update", "watch", "delete"]
  }
}
