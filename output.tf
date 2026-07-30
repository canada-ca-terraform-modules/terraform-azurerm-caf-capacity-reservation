output "capacity_reservation_group" {
  description = "Returns the Capacity Reservation Group object"
  value       = azurerm_capacity_reservation_group.crg
  sensitive   = true
}

output "capacity_reservation_group_id" {
  description = "Returns the ID of the Capacity Reservation Group"
  value       = azurerm_capacity_reservation_group.crg.id
}

output "capacity_reservation_group_name" {
  description = "Returns the name of the Capacity Reservation Group"
  value       = azurerm_capacity_reservation_group.crg.name
}

output "capacity_reservations" {
  description = "Returns the map of Capacity Reservation objects, keyed by the same key used in the `reservations` input"
  value       = azurerm_capacity_reservation.cr
  sensitive   = true
}

output "capacity_reservation_ids" {
  description = "Returns a map of Capacity Reservation IDs, keyed by the same key used in the `reservations` input"
  value       = { for k, v in azurerm_capacity_reservation.cr : k => v.id }
}
