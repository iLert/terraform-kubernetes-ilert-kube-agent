resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  spec {
    min_ready_seconds = 10
    replicas          = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = merge(
          {
            app = var.name
          },
          var.pod_labels
        )

        annotations = var.pod_annotations
      }

      spec {
        restart_policy                  = "Always"
        service_account_name            = kubernetes_service_account.this.metadata.0.name
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app"
                    operator = "In"
                    values   = [var.name]
                  }
                }

                topology_key = "failure-domain.beta.kubernetes.io/zone"
              }
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 20

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app"
                    operator = "In"
                    values   = [var.name]
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        container {
          name              = var.name
          image             = var.image
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/ilert-kube-agent"]

          args = [
            "--settings.apiKey=${var.api_key}",
            "--settings.port=${var.port}",
            "--config=/etc/${var.name}/config.yaml",
          ]

          env {
            name = "NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          dynamic "env" {
            for_each = var.envs
            content {
              name  = env.key
              value = env.value
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/${var.name}"
          }

          port {
            name           = "http-metrics"
            container_port = var.port
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = var.port
            }

            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = var.port
            }

            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }

            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
          }
        }

        volume {
          name = "config"

          config_map {
            name = kubernetes_config_map.this.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role.this,
    kubernetes_cluster_role_binding.this,
  ]
}
