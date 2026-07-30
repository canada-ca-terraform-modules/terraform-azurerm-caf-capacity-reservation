variable "tags" {
  description = "Tags to be applied to the capacity reservation group and its reservations"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) Name of the capacity reservation group. Used as the base name for the group and every reservation it contains."
  type        = string
}

variable "resource_groups" {
  description = "(Required) Map of resource group objects"
  type        = any
  default     = {}
}

variable "location" {
  description = "Azure location where the capacity reservation group will be located"
  type        = any
  default     = "canadacentral"
}

variable "capacity_reservation_group" {
  description = "(Required) Capacity reservation group object. See README for the full schema, including the nested `reservations` map."
  type        = any
  default     = {}
}
