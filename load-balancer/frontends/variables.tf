variable "project_id" {
  description = "Google Cloud Platform project ID. Notice that this is different from the project name."
  type        = string
}

variable "ip_address" {
  description = "IP address for the forwarding rule"
  type        = string
}

variable "domain" {
  description = "Domain name to run the load balancer on (example: dummy.hapara.com)"
  type        = string
}

variable "default_service" {
  description = "ID of the backend service to route requests to."
  type        = string
}

variable "load_balancer_name" {
  description = "Name for load balancer and the prefix for associated resources"
  type        = string
}

variable "path_rules" {
  description = "List of path rules to add to the URL Map"
  type = list(object({
    paths   = list(string)
    service = string
  }))

}
