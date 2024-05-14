variable "project_id" {
  description = "Google Cloud Platform project ID. Notice that this is different from the project name."
  type        = string
}

variable "region" {
  description = "Location for load balancer and Cloud Run resources"
  type        = string
}

variable "service_id" {
  description = "ID of the service to point on the Network Endpoint Group (it must already exist on GCP)."
  type        = string

}

variable "is_cloud_run" {
  description = "True when the service is a Cloud Run service, false when it is an App Engine service."
  type        = bool
}
