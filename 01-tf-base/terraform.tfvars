cidr_block = "10.0.0.0/16"
domainname = "example.com"
user_keys = {
  "user" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxM2...Kp7X user@example.com"
}
allowed_ssh_ips = [
  "192.168.1.1/32",
  "192.168.1.2/32"
]
default_image             = "debian-12"
volume_size_nfs           = 10
volume_size_rds           = 10
server_type_elasticsearch = null
server_type_nfs           = null
server_type_observability = null
server_type_rabbitmq      = null
server_type_rds           = null
server_type_redis         = null

