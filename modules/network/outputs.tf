
# Output vars VPC and two subnetwork to module backend_service

output "network" {
  description = "VPC network"
  value = google_compute_network.network.id
}

output "subnetwork1" {
  description = "subnetwork1 to compute instance 1"
  value = google_compute_subnetwork.subnetwork1.id
}