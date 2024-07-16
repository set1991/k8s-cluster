variable "gcp_srv_key" {
  description = "JSON key-file from gcp"
}

variable "gcp_project" {
  description = "Project id from GSP"
  #default = "prod-421408"
  default = "prod-429618"
}

variable "gcp_region" {
  description = "Region"
  default = "europe-west2"
}
variable "gcp_zone1" {
  description = "Zone "
  default =  "europe-west2-a"
}

variable "name" {
  description = "name for project"
  default = "k8s"
}

variable "ip_subnetwork1" {
  description = "range ip adresses for subnet1"
  default = "10.0.200.0/24"
}


variable "state_bucket" {
  description = "bucket gcp for the state_file"
  default = "bucket-tfstate-aliferenko91"
  
}

variable "tags_firewall" {
  description = "tags firewall rules to compute instance"
  type = map(string)
  default = {
    http = "http-server"
    kube = "kuber"
    ssh = "ssh-server"
    grafana = "grafana"
    prometheus = "prometheus" 
  }
}


variable "ssh_user" {
  description = "name for project"
  #default = "set_gomel"
  default = "sasha_aliferenko91"
}
variable "ssh_pub_key" {
  description = "name for project"
  default = "/home/set/keys/terraform_ed25519.pub"
}

variable "ssh_private_key" {
  description = "name for project"
  default = "/home/set/keys/terraform_ed25519"
}
