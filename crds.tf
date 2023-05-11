resource "kubernetes_manifest" "incidents" {
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "incidents.ilert.com"
    }
    spec = {
      group = "ilert.com"
      scope = "Namespaced"

      versions = [{
        name    = "v1"
        served  = true
        storage = true
        schema = {
          openAPIV3Schema = {
            required = ["spec"]
            properties = {
              spec = {
                required = ["id"]
                properties = {
                  id = {
                    type    = "integer"
                    minimum = 0
                  }
                  summary = {
                    type = "string"
                  }
                  details = {
                    type = "string"
                  }
                  type = {
                    type = "string"
                  }
                }
              }
            }
          }
        }
      }]

      names = {
        plural   = "incidents"
        singular = "incident"
        listKind = "IncidentList"
        kind     = "Incident"
      }
    }
  }
}
