locals {
  server_ids = compact(concat(
    var.server_type_elasticearch != null ? var.server_id_elasticsearch : [],
    var.server_type_rabbitmq != null ? var.server_id_rabbitmq : [],
    var.server_type_rds != null ? var.server_id_rds : [],
    var.server_type_redis != null ? var.server_id_redis : []
  ))
}

resource "hcloud_firewall_attachment" "fw-services-ssh" {
  count       = length(local.server_ids) > 0 ? 1 : 0
  firewall_id = var.firewall_id_services_ssh
  server_ids  = local.server_ids
}

