

module "network" {
source = "./modules/network"
gcp_project = var.gcp_project
gcp_region = var.gcp_region
name = var.name
tags_firewall = var.tags_firewall
ip_subnetwork1 = var.ip_subnetwork1

}


module "kubernetes_instances" {
source = "./modules/kubernetes_instances"
gcp_project = var.gcp_project
gcp_region = var.gcp_region
gcp_zone1 = var.gcp_zone1
name = var.name
tags_firewall = var.tags_firewall
depends_on = [ module.network ]
network = module.network.network
subnetwork1 = module.network.subnetwork1
ssh_user = var.ssh_user
ssh_pub_key = var.ssh_pub_key
ssh_private_key = var.ssh_private_key

}





