#CREATE TWO PRIVATE SUBNETS 

resource "google_compute_subnetwork" "subnetwork1" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = var.ip_subnetwork1
  region        = var.gcp_region
  network       = google_compute_network.network.id
  
}
