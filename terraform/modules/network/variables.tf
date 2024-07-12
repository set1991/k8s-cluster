variable "gcp_project" {
  description = "Project id from GSP"
  type = string
}
variable "gcp_region" {
  description = "Region"
  type = string
}

variable "name" {
    description = "Name of the project"
    type = string
  
}
variable "ip_subnetwork1" {
    description = "Name of the project"
    type = string
  
}


variable "tags_firewall" {
  type = map(string)
}
