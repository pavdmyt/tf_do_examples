variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "uname" {}

variable "node_count" {
  default = 1
}

variable "node_size" {
  default = "s-2vcpu-4gb"
}

variable "region" {
  default = "fra1"
}

variable "image" {
  default = "ubuntu-16-04-x64"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "devnode" {
  count  = "${var.node_count}"
  name   = "dev-node-${var.uname}-${count.index + 1}"
  size   = "${var.node_size}"
  region = "${var.region}"
  image  = "${var.image}"

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }
}

output "devnodes_ipv4" {
  value = ["${digitalocean_droplet.devnode.*.ipv4_address}"]
}
