output "firewall_id_ssh" {
  description = "ID of the firewall rule for ssh"
  value       = hcloud_firewall.fw-ssh.id
}

#output "firewall_id_elasticsearch" {
#  description = "ID of the firewall rule for ElasticSearch"
#  value       = hcloud_firewall.fw-elasticsearch.id
#}

output "firewall_id_http" {
  description = "ID of the firewall rule for HTTP"
  value       = hcloud_firewall.fw-http.id
}

#output "firewall_id_rds" {
#  description = "ID of the firewall rule for RDS"
#  value       = hcloud_firewall.fw-rds.id
#}
#
#output "firewall_id_redis" {
#  description = "ID of the firewall rule for Redis"
#  value       = hcloud_firewall.fw-redis.id
#}

