resource "azurerm_capacity_reservation_group" "crg" {
  name                = "${var.name}-crg"
  resource_group_name = local.resource_group_name
  location            = var.location
  zones               = try(var.capacity_reservation_group.zones, null)
  tags                = merge(var.tags, try(var.capacity_reservation_group.tags, {}))
}

resource "azurerm_capacity_reservation" "cr" {
  for_each = try(var.capacity_reservation_group.reservations, {})

  name                          = "${var.name}-${each.key}-cr"
  capacity_reservation_group_id = azurerm_capacity_reservation_group.crg.id
  zone                          = try(each.value.zone, null)
  tags                          = merge(var.tags, try(each.value.tags, {}))

  sku {
    name     = each.value.sku.name
    capacity = each.value.sku.capacity
  }
}
