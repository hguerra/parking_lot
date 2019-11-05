variable "ssh_public_key_filepath" {
  description = "Filepath for the ssh public key"
  type        = "string"

  default = ""
}

variable "ssh_private_key_filepath" {
  description = "Filepath for the ssh private key"
  type        = "string"

  default = ""
}

variable "service_account_filepath" {
  description = "Filepath for the GCP service account"
  type        = "string"

  default = "config/credentials_dev.json"
}

variable "project_id" {
  description = "GCP project id"
  type        = "string"

  default = ""
}

variable "project_region" {
  description = "GCP project region"
  type        = "string"

  default = ""
}

variable "username" {
  default = "dev"
}

variable "instance_name" {
  default = "server"
}

variable "instance_type" {
  default = "n1-standard-1"
}

variable "instance_zone" {
  default = "us-east1-c"
}

variable "instance_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
