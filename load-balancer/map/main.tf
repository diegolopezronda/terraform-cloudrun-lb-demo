provider "google" {
  project = var.project_id
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.load_balancer_name}-url-map"
  default_service = var.default_service
  host_rule {
    hosts        = ["*"]
    path_matcher = "${var.load_balancer_name}-path-matcher"
  }
  path_matcher {
    name            = "${var.load_balancer_name}-path-matcher"
    default_service = var.default_service

    dynamic "path_rule" {
      for_each = var.path_rules
      content {
        paths   = path_rule.value.paths
        service = path_rule.value.service
      }
    }
  }
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  name = "${var.load_balancer_name}-ssl-certificate"
  managed {
    domains = [var.domain]
  }
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.load_balancer_name}-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.load_balancer_name}-https-proxy"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.self_link]
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "${var.load_balancer_name}-http-forwarding-rule"
  ip_address            = var.ip_address
  target                = google_compute_target_http_proxy.http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = "${var.load_balancer_name}-https-forwarding-rule"
  ip_address            = var.ip_address
  target                = google_compute_target_https_proxy.https_proxy.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
