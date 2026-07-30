locals {
  resource_group_input = var.capacity_reservation_group.resource_group

  # resource_group might be a name or a full resource ID. If it's an ID, parse the name from the ID.
  # If we received a name, resolve it against the resource_groups object provided by ESLZ.
  resource_group_name = strcontains(lower(local.resource_group_input), "/resourcegroups/") ? regex("[^/]+$", local.resource_group_input) : var.resource_groups[local.resource_group_input].name
}
