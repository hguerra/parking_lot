resource "google_compute_instance" "docker_host" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_type}"
  zone         = "${var.instance_zone}"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "${var.instance_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    sshKeys = "${var.username}:${file(var.ssh_public_key_filepath)}"
  }

  metadata_startup_script = "${file("scripts/provision.sh")}"

  provisioner "file" {
    source      = "docker/docker-compose.yml"
    destination = "/tmp/docker-compose.yml"

    connection {
      type        = "ssh"
      host        = "${google_compute_instance.docker_host.network_interface.0.access_config.0.nat_ip}"
      user        = "${var.username}"
      private_key = "${file(var.ssh_private_key_filepath)}"
    }
  }

  provisioner "file" {
    source      = "nginx"
    destination = "/tmp/nginx"

    connection {
      type        = "ssh"
      host        = "${google_compute_instance.docker_host.network_interface.0.access_config.0.nat_ip}"
      user        = "${var.username}"
      private_key = "${file(var.ssh_private_key_filepath)}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/docker-compose.yml /app/docker-compose.yml",
      "sudo mv /tmp/nginx /app/nginx"
    ]

    connection {
      type        = "ssh"
      host        = "${google_compute_instance.docker_host.network_interface.0.access_config.0.nat_ip}"
      user        = "${var.username}"
      private_key = "${file(var.ssh_private_key_filepath)}"
    }
  }

}
