resource "kubernetes_config_map" "this" {
  metadata {
    name      = var.name
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    "config.yaml" = yamlencode(var.config)
  }
}
