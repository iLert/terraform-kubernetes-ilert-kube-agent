resource "kubernetes_manifest" "incidents" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind"       = "CustomResourceDefinition"
    "metadata" = {
      "name" = "incidents.ilert.com"
    }
    "spec" = {
      "group" = "ilert.com"
      "scope" = "Namespaced"

      "versions" = {
        "name"    = "v1"
        "served"  = true
        "storage" = true
      }

      "names" = {
        "plural"   = "incidents"
        "singular" = "incident"
        "listKind" = "IncidentList"
        "kind"     = "Incident"
      }

      "validation" = {
        "openAPIV3Schema" = {
          "required" = ["id"]
          "properties" = {
            "spec" = {
              "id" = {
                "type"    = "integer"
                "minimum" = 0
              }
              "summary" = {
                "type" = "string"
              }
              "details" = {
                "type" = "string"
              }
              "type" = {
                "type" = "string"
              }
            }
          }
        }
      }
    }
  }
}
