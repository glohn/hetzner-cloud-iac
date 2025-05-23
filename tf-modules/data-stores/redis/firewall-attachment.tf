locals {
  redis_server_ids = var.server_type_redis != null ? [hcloud_server.vm-redis[0].id] : []
}

resource "hcloud_firewall_attachment" "fw-redis" {
  firewall_id = var.firewall_id_redis
  server_ids  = local.redis_server_ids
}

