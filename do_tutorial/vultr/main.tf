
#Variables
variable "VULTR_API_TOKEN" {
	type = string
}


variable "region_id" {
  type = string
  default = 1
}


variable "os_id" {
  type = string
  default = "270" # ubuntu 18
}
    # database

variable "database_server_count" {
  type = number
  default = 1
}
variable "database_plan_id" {
  type = string
  default = "400"
}
    # NODES

variable "node_server_count" {
  type = number
  default = 1
}
variable "node_plan_id" {
  type = string
  default = "400"
}


#providers
provider "vultr" {
  api_key = var.VULTR_API_TOKEN
}

#Data Sources


data "vultr_ssh_key" "ssh_key" {
  filter {
    name = "key"
    values = ["key"]
  }
}




#resources


resource "vultr_server" "database_web" {
  count = var.database_server_count
  region_id = var.region_id
  os_id = var.os_id
  plan_id = var.database_plan_id
  auto_backup = true

  ddos_protection = false
  hostname = "database_web-${var.region_id}-${count.index + 1}"
  ssh_key_ids = [data.vultr_ssh_key.ssh_key.id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "vultr_server" "node_web" {
  count = var.node_server_count
  region_id = var.region_id
  os_id = var.os_id
  plan_id = var.node_plan_id
  auto_backup = true

  ddos_protection = false
  hostname = "node_web-${var.region_id}-${count.index + 1}"
  ssh_key_ids = [data.vultr_ssh_key.ssh_key.id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "database_ips" {
  filename = "${path.module}/database_ips.txt"
  content = join("\n", "${vultr_server.database_web.*.main_ip}")

}

resource "local_file" "node_ips" {
  filename = "${path.module}/node_ips.txt"
  # content = join("\n", "${vultr_server.database_web.*.main_ip}\n${vultr_server.node_web.*.main_ip}")

}

#Outputs


  # database
output "database_price_monthly" {
  value = vultr_server.database_web.*.cost_per_month
}
output "database_server_ips" {
  value = vultr_server.database_web.*.main_ip
}

  # NODE
output "node_price_monthly" {
  value = vultr_server.node_web.*.cost_per_month
}

output "node_server_ip" {
  value = vultr_server.node_web.*.main_ip
}
