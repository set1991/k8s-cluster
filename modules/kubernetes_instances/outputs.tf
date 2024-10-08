#  Output ip k8s master worker prometheus grafana.

output "ip_master" {
  value =  google_compute_instance.kubernetes_master.network_interface.0.access_config.0.nat_ip
}

output "ip_worker0" {
  value =  google_compute_instance.kubernetes_worker[0].network_interface.0.access_config.0.nat_ip
}

output "ip_prometheus" {
  value =  google_compute_instance.prometheus.network_interface.0.access_config.0.nat_ip
}
output "ip_grafana" {
  value =  google_compute_instance.grafana.network_interface.0.access_config.0.nat_ip
}

