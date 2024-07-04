#CREATE A NEW VPS NETWORK 
resource "google_compute_network" "network" {
  project                 = var.gcp_project
  name                    = "${var.name}-network"
  auto_create_subnetworks = false
}



