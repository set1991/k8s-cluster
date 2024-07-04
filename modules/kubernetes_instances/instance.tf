
#CREATE TWO COMPUTE_INSTANCE 
resource "google_compute_instance" "kubernetes_master" {
    name = "${var.name}-master"
    machine_type = "e2-small"
    project = var.gcp_project
    zone = var.gcp_zone1
   
     # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
    tags = [var.tags_firewall["http"], var.tags_firewall["kube"], var.tags_firewall["ssh"]]
    #metadata_startup_script = file(var.script-master)
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
    metadata_startup_script = <<-EOT
    wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
 tar -xvf node_exporter-1.8.1.linux-amd64.tar.gz
 sudo cp node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
 sudo useradd -rs /bin/false nodeusr
 sudo chown nodeusr:nodeusr /usr/local/bin/node_exporter

    # create node_exporter service
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'

#start node_exporter service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter
    
EOT
    
}

#CREATE TWO COMPUTE_INSTANCE 

resource "google_compute_instance" "kubernetes_worker" {
    count=1
    name = "${var.name}-worked${count.index}"
    machine_type = "e2-small"
    project = var.gcp_project
    zone = var.gcp_zone1
   
     # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
    tags = [var.tags_firewall["http"], var.tags_firewall["kube"], var.tags_firewall["ssh"]]

    #metadata_startup_script = file(var.script-worked)
    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
      #join_command = data.local_file.join_command.content
      
    }

    boot_disk {
      initialize_params {
        image = "ubuntu-2204-jammy-v20240614"
      }
    }
    
    network_interface{
        network = var.network
        subnetwork = var.subnetwork1
        access_config {
      // Ephemeral public IP
      }
      
    }
    metadata_startup_script = <<-EOT
    wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
 tar -xvf node_exporter-1.8.1.linux-amd64.tar.gz
 sudo cp node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
 sudo useradd -rs /bin/false nodeusr
 sudo chown nodeusr:nodeusr /usr/local/bin/node_exporter

    # create node_exporter service
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'

#start node_exporter service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter
    
EOT

    
    #depends_on = [ google_compute_instance.kubernetes_master ]
}


resource "local_file" "config_ansible" {
 filename = "./ansible_project/ansible.cfg"
 content = <<EOF
[defaults]
remote_user = ${var.ssh_user}
private_key_file = ${var.ssh_private_key}
inventory         =./hosts.ini
host_key_checking = False
EOF
}

resource "local_file" "inventory_run_ansible" {
 filename = "./ansible_project/hosts.ini"
 content = <<EOF
[master]
${google_compute_instance.kubernetes_master.name}   ansible_host=${google_compute_instance.kubernetes_master.network_interface.0.access_config.0.nat_ip}
[workers]
${google_compute_instance.kubernetes_worker[0].name}   ansible_host=${google_compute_instance.kubernetes_worker[0].network_interface.0.access_config.0.nat_ip}
EOF

provisioner "remote-exec" {
    inline = ["echo 'login successful on master'"]

    connection {
      host = google_compute_instance.kubernetes_master.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
provisioner "remote-exec" {
    inline = ["echo 'login successful on worker'"]

    connection {
      host = google_compute_instance.kubernetes_worker[0].network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
provisioner "local-exec" {


    working_dir = "./ansible_project/"
    command     = "ansible-playbook playbook.yml"
    
}

}







  


