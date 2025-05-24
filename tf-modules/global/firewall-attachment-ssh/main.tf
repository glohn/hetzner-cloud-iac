#locals {
#  # Define a map of server types to their corresponding list of server IDs
#  # If a type is not used (null), assign an empty list
#  server_map = {
#    elasticsearch = var.server_type_elasticearch != null ? var.server_id_elasticsearch : []
#    rabbitmq      = var.server_type_rabbitmq != null ? var.server_id_rabbitmq : []
#    rds           = var.server_type_rds != null ? var.server_id_rds : []
#    redis         = var.server_type_redis != null ? var.server_id_redis : []
#  }
#
#  # Flatten the nested maps into one single map using unique keys ("type-id")
#  # merge(...): merges multiple maps into one
#  # [ ... ]: list of maps generated dynamically with nested for loops
#  # ... (splat operator): unpacks the list so merge() receives individual maps
#  server_ids_map = merge([
#    for server_type, id_list in local.server_map : {
#      for id in id_list : "${server_type}-${id}" => id
#    }
#  ]...)
#}
#
#resource "hcloud_firewall_attachment" "fw-services-ssh" {
#  # Iterate over the flattened map to create one attachment per server
#  for_each = local.server_ids_map
#
#  # Use the provided firewall ID
#  firewall_id = var.firewall_id_services_ssh
#
#  # Attach the firewall to the specific server (each.value holds the server ID)
#  server_ids = [each.value]
#}

resource "hcloud_firewall_attachment" "fw-services-ssh" {
  for_each    = var.server_ids
  firewall_id = var.firewall_id_services_ssh
  server_ids  = [each.value] # each.value is the actual server ID
}

