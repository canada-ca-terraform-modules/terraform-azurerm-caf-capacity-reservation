capacity_reservation = {
  sqlCluster = {               # Key defines the userDefinedString / base name for the group and its reservations
    resource_group = "Project" # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
    # zones        = ["1"]          # Optional: List of Availability Zones for the group. Changing this forces a new resource.
    # tags         = {}             # Optional: Tags applied only to the group (merged with the module-level tags)

    reservations = {
      sql1 = { # Key defines the userDefinedString for this reservation within the group
        sku = {
          name     = "Standard_D2s_v3" # Required: VM SKU to reserve capacity for
          capacity = 1                 # Required: Number of instances to reserve
        }
        # zone = "1"                 # Optional: Availability Zone for this reservation. Changing this forces a new resource.
        # tags = {}                  # Optional: Tags applied only to this reservation (merged with the module-level tags)
      }

      # sql2 = {
      #   sku = {
      #     name     = "Standard_D4s_v3"
      #     capacity = 2
      #   }
      # }
    }
  }
}
