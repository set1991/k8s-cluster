#CREATE CLOUD ROUTER 
/*
resource "google_compute_router" "router" {
  project = var.gcp_project
  name    = "${var.name}-router"
  network = google_compute_network.network.name
  region  = var.gcp_region
}
*/