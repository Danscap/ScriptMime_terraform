
#Variables
variable "DIGITALOCEAN_TOKEN" {
	type = string
}

variable "region" {
  type = string
}

variable "droplet_count" {
  type = number
  default = 1
}

variable "droplet_size" {
  type = string
  default = "s-1vcpu-1gb"
}

#providers
provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}

#Data Sources

data "digitalocean_account" "account_info"{}

data "digitalocean_ssh_key" "key" {
  name = "key"
  # public_key = file("/home/danscap/.ssh/id_rsa.pub")
}

# data "digitalocean_ssh_key" "work" {
#   name = "Home Desktop"
# }




#resources


resource "digitalocean_droplet" "web" {
  count = var.droplet_count
  image = "ubuntu-18-04-x64"
  name = "web-${var.region}-${count.index + 1}"
  region = var.region
  size = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.key.fingerprint]


  lifecycle {
    create_before_destroy = true
  }
}


#Outputs


output "droplet_limit" {
  value = data.digitalocean_account.account_info.droplet_limit
}

output "price_monthly" {
  value = digitalocean_droplet.web.*.price_monthly
}

output "server_ip" {
  value = digitalocean_droplet.web.*.ipv4_address
}