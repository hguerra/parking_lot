// Configure the Google Cloud provider
// https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform
// https://www.terraform.io/docs/providers/google/getting_started.html
// https://www.terraform.io/docs/providers/google/r/compute_instance.html

// Terraform Best Practices
// https://www.terraform-best-practices.com/naming
// https://blog.stigok.com/2018/04/13/terraform-staging-environment.html
// https://www.terraform.io/docs/configuration/variables.html
provider "google" {
  credentials = "${file(var.service_account_filepath)}"
  project     = "${var.project_id}"
  region      = "${var.project_region}"
}
