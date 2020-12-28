
#Variables
variable "hcloud_token" {
	type = string
}

variable "image" {
  type = string
}
variable "location" {
  type = string
}


    # database

variable "database_server_count" {
  type = number
  default = 1
}
variable "database_server_type" {
  type = string
}
variable "database_backups" {
  type = string
}

    # NODES

variable "node_server_count" {
  type = number
  default = 1
}

variable "node_server_type" {
  type = string
}
variable "node_backups" {
  type = string
}

variable "ssh_key_fingerprint" {
  type = string
}

#providers
provider "hcloud" {
  token = var.hcloud_token
}

#Data Sources


data "hcloud_ssh_key" "ssh_key" {
  fingerprint = var.ssh_key_fingerprint
}




#resources



  # servers
resource "hcloud_server" "database_web" {
  count = var.database_server_count
  server_type = var.database_server_type
  image = var.image
  location = var.location

  name = "databaseweb-${var.location}-${count.index + 1}"
  ssh_keys = [data.hcloud_ssh_key.ssh_key.id]
  backups = var.database_backups


  lifecycle {
    create_before_destroy = true
  }
}

resource "hcloud_server" "node_web" {
  count = var.node_server_count
  server_type = var.node_server_type
  image = var.image
  location = var.location

  name = "nodeweb-${var.location}-${count.index + 1}"
  ssh_keys = [data.hcloud_ssh_key.ssh_key.id]
  backups = var.node_backups


  lifecycle {
    create_before_destroy = true
  }
}

  # networks
resource "hcloud_network" "net" {
  name = "net"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "mysubnet" {
  network_id = hcloud_network.net.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "10.0.1.0/24"
}


resource "hcloud_server_network" "nodeservernetwork" {
  count = var.node_server_count
  server_id = hcloud_server.node_web[count.index].id
  network_id = hcloud_network_subnet.mysubnet.network_id
  # ip = "10.0.1.5"
}

resource "hcloud_server_network" "dbservernetwork" {
  count = var.database_server_count
  server_id = hcloud_server.database_web[count.index].id
  network_id = hcloud_network_subnet.mysubnet.network_id
  # ip = "10.0.1.5"
}


resource "local_file" "database_ips" {
  filename = "${path.module}/database_ips.txt"
  content = join("\n", "${hcloud_server.database_web.*.ipv4_address}")

}

resource "local_file" "node_ips" {
  filename = "${path.module}/node_ips.txt"
  content = join("\n", "${hcloud_server.node_web.*.ipv4_address}")

  # content = join("\n", "${hcloud_server.database_web.*.main_ip}\n${hcloud_server.node_web.*.main_ip}")

}

resource "local_file" "database_privateips" {
  filename = "${path.module}/database_privateips.txt"
  content = join("\n", "${hcloud_server_network.dbservernetwork.*.ip}")

}

resource "local_file" "node_privateips" {
  filename = "${path.module}/node_privateips.txt"
  content = join("\n", "${hcloud_server_network.nodeservernetwork.*.ip}")

  # content = join("\n", "${hcloud_server.database_web.*.main_ip}\n${hcloud_server.node_web.*.main_ip}")

}

#Outputs


  # database
output "database_servers_status" {
  value = hcloud_server.database_web.*.status
}
output "database_server_ips" {
  value = hcloud_server.database_web.*.ipv4_address
}

  # NODE
output "node_servers_status" {
  value = hcloud_server.node_web.*.status
}

output "node_server_ip" {
  value = hcloud_server.node_web.*.ipv4_address
}
