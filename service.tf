resource "kubernetes_service" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      name        = "http"
      port        = var.port
      protocol    = "TCP"
      target_port = var.port
    }

    type = "ClusterIP"
  }

}
