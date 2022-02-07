# terraform-kubernetes-ilert-kube-agent

Terraform module for ilert-kube-agent. Our official documentation see [here](https://docs.ilert.com/integrations/kubernetes)

## Configure kubernetes provider

```tf
provider "kubernetes" {
  // ...
  experiments {
    manifest_resource = true
  }
}
```
