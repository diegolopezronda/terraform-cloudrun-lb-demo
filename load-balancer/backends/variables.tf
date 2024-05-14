variable "project_id" {
  description = "Google Cloud Platform project ID. Notice that this is different from the project name."
  type        = string
}

variable "appengine_backends" {
  description = "Map of App Engine services to be used as backends for the load balancer."
  type = map(object({
    region = string
  }))
}

variable "cloudrun_backends" {
  description = "Map of Cloud Run services to be used as backends for the load balancer."
  type = map(object({
    region = string
  }))
}
