resource "hcloud_ssh_key" "ssh_keys" {
  for_each   = var.user_keys
  name       = each.key
  public_key = each.value
}

