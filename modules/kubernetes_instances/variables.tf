
variable "gcp_project" {
  description = "Project id from GSP"
  type = string
}
variable "gcp_region" {
  description = "Region"
  type = string
}
variable "gcp_zone1" {
  description = "Zone 1"
  type = string
}

variable "name" {
    description = "Name of the project"
    type = string
}
/*
variable "script-master" {
    description = "startup script for instances"
    type = string
}

variable "script-worked" {
    description = "startup script for instances"
    type = string
}
*/
variable "tags_firewall" {
  type = map(string)
}

variable "network" {
  
}
variable "subnetwork1" {
  
}
variable "ssh_user" {
    description = "Name of the project"
    type = string
}

variable "ssh_pub_key" {
    description = "startup script for instances"
    type = string
}
variable "ssh_private_key" {
    description = "startup script for instances"
    type = string
}


