provider "google" {
  project = var.project_id
}

resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  for_each              = var.appengine_backends
  name                  = "${each.key}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = each.value.region
  app_engine {
    service = each.key
  }
}

resource "google_compute_backend_service" "appengine_backend_service" {
  for_each              = var.appengine_backends
  name                  = "${each.key}-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTPS"
  backend {
    group = google_compute_region_network_endpoint_group.appengine_neg[each.key].self_link
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  for_each              = var.cloudrun_backends
  name                  = "${each.key}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = each.value.region
  app_engine {
    service = each.key
  }
}

resource "google_compute_backend_service" "cloudrun_backend_service" {
  for_each              = var.cloudrun_backends
  name                  = "${each.key}-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTPS"
  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg[each.key].self_link
  }
}
