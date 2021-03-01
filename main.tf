terraform {
  required_version = ">= 0.12"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = ">= 0.2.1"
    }
  }
}
