resource "hcloud_network" "private-network" {
  name     = "${var.project}-vpc"
  ip_range = var.cidr_block

  labels = {
    Name = "${var.project}-vpc"
  }
}

resource "hcloud_network_subnet" "private-subnet" {
  count        = var.subnet_count
  network_id   = hcloud_network.private-network.id
  type         = "cloud"
  network_zone = contains(["nbg1", "fsn1", "hel1"], var.location) ? "eu-central" : "other-zone"
  ip_range     = cidrsubnet(var.cidr_block, 8, count.index)
}

