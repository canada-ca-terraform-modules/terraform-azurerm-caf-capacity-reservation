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

# Step 1: simulate the initially deployed state
run "baseline_apply" {
  command = apply
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.name == "sqlCluster-crg"
    error_message = "Baseline apply: unexpected group name"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].name == "sqlCluster-sql1-cr"
    error_message = "Baseline apply: unexpected reservation name"
  }
}

# Step 2: plan the same config again against that state — must produce no changes/replacement
run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation_group.crg.name == "sqlCluster-crg"
    error_message = "Group name must be unchanged when re-planning identical config"
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].name == "sqlCluster-sql1-cr"
    error_message = "Reservation name must be unchanged when re-planning identical config"
  }
}

# Step 3: adding an additional reservation to the group must not affect the existing one
run "add_reservation_no_replacement" {
  command = plan
  variables {
    capacity_reservation_group = {
      resource_group = "rg-test"
      reservations = {
        sql1 = {
          sku = { name = "Standard_D2s_v3", capacity = 1 }
        }
        sql2 = {
          sku = { name = "Standard_D4s_v3", capacity = 1 }
        }
      }
    }
  }

  assert {
    condition     = azurerm_capacity_reservation.cr["sql1"].name == "sqlCluster-sql1-cr"
    error_message = "Existing reservation must be unaffected when a new one is added to the map"
  }

  assert {
    condition     = length(azurerm_capacity_reservation.cr) == 2
    error_message = "New reservation must be added alongside the existing one"
  }
}
