
#CREATE FIREWALL RULE FOR NETWORK  (ALLOW HTTP, HTTPS, SSH)
resource "google_compute_firewall" "default-allow-http" {
name    = "${var.name}-allow-http-s"
network = google_compute_network.network.name
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = [ var.tags_firewall["http"] ]
}


resource "google_compute_firewall" "default-allow-kuber" {
name    = "${var.name}-allow-kuber"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["53", "68", "323", "6443", "44111", "2379-2381", "10248-10260", "10250", "30000-32767", "2376", "8472", "9099",  "2379-2380", "9100", "9090", "3000" ]
  #ports = ["0-65535"]  
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["kube"] ]
}

resource "google_compute_firewall" "default-allow-ssh" {
name    = "${var.name}-allow-ssh"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["22"]
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["ssh"] ]
}

resource "google_compute_firewall" "default-allow-grafana" {
name    = "${var.name}-allow-grafana"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["3000"]
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["grafana"] ]
}

resource "google_compute_firewall" "default-allow-prometheus" {
name    = "${var.name}-allow-prometheus"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["9090", "9100"]
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["prometheus"] ]
}
