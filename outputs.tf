# ------------------------------------------------------------------------------
# LOAD BALANCER IP ADDRESS OUTPUT
# ------------------------------------------------------------------------------
output "ip_master" {
  description = "IP address of the k8s Master"
  value       = module.kubernetes_instances.ip_master
}
output "ip_worker0" {
  description = "IP address of the Cloud Load Balancer"
  value       = module.kubernetes_instances.ip_worker0
}

output "ip_prometheus" {
  description = "IP address of the Cloud Load Balancer"
  value       = module.kubernetes_instances.ip_prometheus
}
output "ip_grafana" {
  description = "IP address of the Cloud Load Balancer"
  value       = module.kubernetes_instances.ip_grafana
}


