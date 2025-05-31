resource "hcloud_firewall_attachment" "fw-services-ssh" {
  firewall_id     = var.firewall_id_services_ssh
  label_selectors = ["service-type in (elasticsearch,nfs,rabbitmq,rds,redis)"]
}

