terraform {
  required_version = ">= 1.9"
}

variable "capacity_reservation" {
  description = "Map of capacity reservation group configuration objects"
  type        = any
  default     = {}
}

variable "resource_groups" {
  description = "Map of resource group objects"
  type        = any
  default     = {}
}

variable "location" {
  description = "Azure location for the capacity reservation group"
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

module "capacity_reservation" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-capacity-reservation?ref=v1.0.0"
  for_each = var.capacity_reservation

  name                       = each.key
  resource_groups            = var.resource_groups
  location                   = var.location
  tags                       = var.tags
  capacity_reservation_group = each.value
}
