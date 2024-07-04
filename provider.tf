#GCP Provider
provider "google" {
    credentials = file(var.gcp_srv_key)
    project = var.gcp_project
    region = var.gcp_region

}

