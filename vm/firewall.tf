resource "google_compute_firewall" "allow_http" {
  name    = "tf-${var.instance_name}-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http", "https"]
}
