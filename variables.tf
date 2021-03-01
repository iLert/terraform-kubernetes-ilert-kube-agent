variable "api_key" {
  description = "The iLert alert source api key"
  type        = string
}

variable "name" {
  description = "Kubernetes name."
  type        = string
  default     = "ilert-kube-agent"
}

variable "namespace" {
  description = "Kubernetes namespace."
  type        = string
  default     = "kube-system"
}

variable "replicas" {
  description = "Amount of replicas to be created."
  type        = number
  default     = 1
}

variable "port" {
  description = "The http port for health check and metrics."
  type        = number
  default     = 9092
}

variable "image" {
  description = "The ilert-kube-agent image to use. See https://github.com/iLert/ilert-kube-agent/releases for available versions"
  type        = string
  default     = "ilert/ilert-kube-agent:v1.4.3"
}

variable "pod_annotations" {
  description = "Additional annotations to be added to the pods."
  type        = map(string)
  default = {
    "prometheus.io/scrape" = "true"
    "prometheus.io/port"   = 9092
  }
}

variable "pod_labels" {
  description = "Additional labels to be added to the pods."
  type        = map(string)
  default     = {}
}

variable "pod_envs" {
  description = "Additional envs to be added to the pods."
  type        = map(string)
  default     = {}
  # default = {
  #   "LOG_LEVEL" = "info"
  # }
}

variable "cpu_request" {
  description = "The pod CPU resource request."
  type        = string
  default     = "20m"
}

variable "cpu_limit" {
  description = "The pod CPU resource limit."
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "The pod memory resource request."
  type        = string
  default     = "32Mi"
}

variable "memory_limit" {
  description = "The pod memory resource limit."
  type        = string
  default     = "128Mi"
}

variable "config" {
  description = "The ilert-kube-agent config. See https://github.com/iLert/ilert-kube-agent/blob/master/config.yaml for available options"
  type = object({
    settings = object({
      electionID    = string
      checkInterval = string
      log = object({
        level = string
        json  = bool
      })
    })

    alarms = object({
      pods = object({
        enabled = bool
        terminate = object({
          enabled  = bool
          priority = string
        })
        waiting = object({
          enabled  = bool
          priority = string
        })
        restarts = object({
          enabled   = bool
          priority  = string
          threshold = number
        })
        resources = object({
          enabled   = bool
          priority  = string
          threshold = number
        })
      })
      nodes = object({
        enabled = bool
        terminate = object({
          enabled  = bool
          priority = string
        })
        resources = object({
          enabled   = bool
          priority  = string
          threshold = number
        })
      })
    })
  })

  default = {
    settings = {
      electionID    = "ilert-kube-agent"
      checkInterval = "30s"
      log = {
        level = "info"
        json  = false
      }
    }

    alarms = {
      pods = {
        enabled = false
        terminate = {
          enabled  = true
          priority = "HIGH"
        }

        waiting = {
          enabled  = true
          priority = "LOW"
        }

        restarts = {
          enabled   = true
          priority  = "LOW"
          threshold = 10
        }

        resources = {
          enabled   = true
          priority  = "LOW"
          threshold = 90
        }
      }

      nodes = {
        enabled = true

        terminate = {
          enabled  = true
          priority = "HIGH"
        }

        resources = {
          enabled   = true
          priority  = "LOW"
          threshold = 90
        }
      }
    }
  }
}
