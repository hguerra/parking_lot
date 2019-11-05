output "external_ip" {
  value = "${google_compute_instance.docker_host.network_interface.0.access_config.0.nat_ip}"
}
