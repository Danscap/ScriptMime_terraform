terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    vultr = {
      source = "vultr/vultr"
    }
  }
  required_version = ">= 0.13"
}
