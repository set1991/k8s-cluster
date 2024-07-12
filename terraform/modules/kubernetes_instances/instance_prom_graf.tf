

resource "local_file" "config_prometheus" {
 filename = "./prometheus.yml"
 content = <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "k8s nodes"
    static_configs:
      - targets:
        - ${google_compute_instance.kubernetes_master.network_interface.0.network_ip}:9100
        - ${google_compute_instance.kubernetes_worker[0].network_interface.0.network_ip}:9100
EOF
}

#CREATE prometheus instance
resource "google_compute_instance" "prometheus" {
    name = "${var.name}-prometheus"
    machine_type = "e2-small"
    project = var.gcp_project
    zone = var.gcp_zone1
   
     # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
    tags = [var.tags_firewall["http"], var.tags_firewall["ssh"], var.tags_firewall["prometheus"]]
    
    boot_disk {
      initialize_params {
        image = "ubuntu-2204-jammy-v20240614"
      }
    }
    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
    } 
    network_interface{
        network = var.network
        subnetwork = var.subnetwork1
       access_config {
      // Ephemeral public IP
      }
     
    }
  
  provisioner "file" {
    source = "./prometheus.yml"
    destination = "/tmp/prometheus.yml"

    connection {
      host = google_compute_instance.prometheus.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
}

    metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    # Run Prometheus container
    sudo docker run -d --name prometheus -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml  prom/prometheus
  EOT
  depends_on = [ local_file.config_prometheus ]
 #-v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml 
}

resource "local_file" "config_grafana" {
 filename = "./grafana.yml"
 content = <<EOF
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    url: http://${google_compute_instance.prometheus.network_interface.0.network_ip}:9090/
EOF
}



#CREATE grafana instance
resource "google_compute_instance" "grafana" {
    name = "${var.name}-grafana"
    machine_type = "e2-small"
    project = var.gcp_project
    zone = var.gcp_zone1
   
     # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
    tags = [var.tags_firewall["http"], var.tags_firewall["grafana"], var.tags_firewall["ssh"]]
    
    
  
    boot_disk {
      initialize_params {
        image = "ubuntu-2204-jammy-v20240614"
      }
    }
    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
     } 
    network_interface{
        network = var.network
        subnetwork = var.subnetwork1
        access_config {
      // Ephemeral public IP
      }
      
    }
    provisioner "file" {
    source = "./grafana.yml"
    destination = "/tmp/grafana.yml"

    connection {
      host = google_compute_instance.grafana.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
}

    metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    # Run Prometheus container
    sudo docker run -d --name grafana -p 3000:3000 -v /tmp/grafana.yml:/etc/grafana/provisioning/datasources/prometheus.yaml  grafana/grafana
  EOT
  depends_on = [ local_file.config_grafana ]
    
    
}

