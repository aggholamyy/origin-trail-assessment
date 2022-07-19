variable "api_token" {}

provider "digitalocean" {
  token = "${var.api_token}"
}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
resource "digitalocean_ssh_key" "default" {
  name = "Amir Abbas Gholami"
  public_key = file("${path.module}/id_phinix.pub")
  
}
resource "digitalocean_droplet" "origin-agh" {
  name               = "origin-agh${count.index+1}"
  count              = 5
  image              = "ubuntu-20-04-x64"
  region             = var.region_names[count.index % 5]
  size               = "s-1vcpu-512mb-10gb"
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}

output "ipv4_address" {
  value = "${digitalocean_droplet.origin-agh[*].ipv4_address}"
  description = "Retriving The Floating IP assighed to the created droplet"
}