locals {
  # resource_group might be a name or a full resource ID. If it's an ID, parse the name from the ID.
  # If we received a name, resolve it against the resource_groups object provided by ESLZ.
  resource_group_name = strcontains(var.capacity_reservation_group.resource_group, "/resourceGroups/") ? regex("[^/]+$", var.capacity_reservation_group.resource_group) : var.resource_groups[var.capacity_reservation_group.resource_group].name
}
