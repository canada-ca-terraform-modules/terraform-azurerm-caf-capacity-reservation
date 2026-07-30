mock_provider "azurerm" {
  mock_resource "azurerm_capacity_reservation_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/capacityReservationGroups/mock-crg"
    }
  }
}

variables {
  resource_groups = {
    rg-test = { name = "rg-test", location = "canadacentral" }
  }
  name     = "sqlCluster"
  location = "canadacentral"
  tags     = {}
}

run "default_values" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      reservations = {
        sql1 = {
          sku = {
            name     = "Standard_D2s_v3"
            capacity = 1
          }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.name == "sqlCluster-crg"
    error_message = "Group name must be {var.name}-crg"
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.zones == null
    error_message = "zones must default to null when not set"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].name == "sqlCluster-sql1-cr"
    error_message = "Reservation name must be {var.name}-{key}-cr"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].zone == null
    error_message = "zone must default to null when not set"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].sku[0].name == "Standard_D2s_v3"
    error_message = "sku.name must be passed through from the reservation object"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].sku[0].capacity == 1
    error_message = "sku.capacity must be passed through from the reservation object"
  }
}

run "multiple_reservations" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
        sql2 = {
          sku = { name = "Standard_D4s_v3", capacity = 2 }
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_capacity_reservation.cr) == 2
    error_message = "Both reservations in the map must produce a capacity reservation resource"
  }
}

run "zones_and_zone" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      zones          = ["1"]
      reservations = {
        sql1 = {
          zone = "1"
          sku  = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = contains(azurerm_capacity_reservation_group.crg.zones, "1")
    error_message = "Group zones must be passed through when set"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].zone == "1"
    error_message = "Reservation zone must be passed through when set"
  }
}

run "tags_merged" {
  command = plan
  variables {
    tags = { environment = "test" }
    capacity_reservation_group = {
      resource_group = "rg-test"
      tags           = { owner = "team-a" }
      reservations = {
        sql1 = {
          tags = { workload = "sql" }
          sku  = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.tags["environment"] == "test" && azurerm_capacity_reservation_group.crg.tags["owner"] == "team-a"
    error_message = "Group tags must merge module-level tags with the group's own tags"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].tags["environment"] == "test" && azurerm_capacity_reservation.cr["sql1"].tags["workload"] == "sql"
    error_message = "Reservation tags must merge module-level tags with the reservation's own tags"
  }
}

run "rg_provided_as_id" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.resource_group_name == "rg-test"
    error_message = "resource_group_name must be parsed correctly from a full resource group ID"
  }
}

run "rg_provided_as_id_case_insensitive" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.resource_group_name == "rg-test"
    error_message = "resource_group_name must be parsed correctly from a full resource group ID regardless of case"
  }
}

run "no_reservations" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
    }
  }

  assert {
    condition     = length(azurerm_capacity_reservation.cr) == 0
    error_message = "No capacity reservations should be created when reservations is unset"
  }
}
