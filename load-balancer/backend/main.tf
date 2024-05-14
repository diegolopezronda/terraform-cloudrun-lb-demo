provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  count                 = var.is_cloud_run == false ? 1 : 0
  name                  = "${var.service_id}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  app_engine {
    service = var.service_id
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  count                 = var.is_cloud_run == true ? 1 : 0
  name                  = "${var.service_id}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.service_id
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.service_id}-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTPS"
  backend {
    group = var.is_cloud_run == true ? google_compute_region_network_endpoint_group.cloudrun_neg[0].self_link : google_compute_region_network_endpoint_group.appengine_neg[0].self_link
  }
}
