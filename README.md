# terraform-azurerm-caf-capacity-reservation

Creates an Azure Capacity Reservation Group and one or more Capacity Reservations within it, using the ESLZ CAF pattern.

## Usage

### ESLZ module block (`ESLZ/capacity-reservation.tf`)

```hcl
module "capacity_reservation" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-capacity-reservation?ref=v1.0.0"
  for_each = var.capacity_reservation

  name                       = each.key
  resource_groups            = var.resource_groups
  location                   = var.location
  tags                       = var.tags
  capacity_reservation_group = each.value
}
```

### ESLZ tfvars pattern (`ESLZ/capacity-reservation.tfvars`)

```hcl
capacity_reservation = {
  sqlCluster = {                    # Key defines the userDefinedString / base name for the group and its reservations
    resource_group = "Project"      # Required: Resource group name, or the resource group ID
    # zones        = ["1"]          # Optional: List of Availability Zones for the group
    # tags         = {}             # Optional: Tags applied only to the group

    reservations = {
      sql1 = {                      # Key defines the userDefinedString for this reservation within the group
        sku = {
          name     = "Standard_D2s_v3" # Required: VM SKU to reserve capacity for
          capacity = 1                 # Required: Number of instances to reserve
        }
        # zone = "1"                 # Optional: Availability Zone for this reservation
        # tags = {}                  # Optional: Tags applied only to this reservation
      }
    }
  }
}
```

## Naming

| Resource | Name pattern |
|---|---|
| `azurerm_capacity_reservation_group` | `{var.name}-crg` |
| `azurerm_capacity_reservation` | `{var.name}-{reservation key}-cr` |

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test, and tflint on every PR.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_capacity_reservation.cr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/capacity_reservation) | resource |
| [azurerm_capacity_reservation_group.crg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/capacity_reservation_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_reservation_group"></a> [capacity\_reservation\_group](#input\_capacity\_reservation\_group) | (Required) Capacity reservation group object. See README for the full schema, including the nested `reservations` map. | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location where the capacity reservation group will be located | `any` | `"canadacentral"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the capacity reservation group. Used as the base name for the group and every reservation it contains. | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Map of resource group objects | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the capacity reservation group and its reservations | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_capacity_reservation_group"></a> [capacity\_reservation\_group](#output\_capacity\_reservation\_group) | Returns the Capacity Reservation Group object |
| <a name="output_capacity_reservation_group_id"></a> [capacity\_reservation\_group\_id](#output\_capacity\_reservation\_group\_id) | Returns the ID of the Capacity Reservation Group |
| <a name="output_capacity_reservation_group_name"></a> [capacity\_reservation\_group\_name](#output\_capacity\_reservation\_group\_name) | Returns the name of the Capacity Reservation Group |
| <a name="output_capacity_reservation_ids"></a> [capacity\_reservation\_ids](#output\_capacity\_reservation\_ids) | Returns a map of Capacity Reservation IDs, keyed by the same key used in the `reservations` input |
| <a name="output_capacity_reservations"></a> [capacity\_reservations](#output\_capacity\_reservations) | Returns the map of Capacity Reservation objects, keyed by the same key used in the `reservations` input |
<!-- END_TF_DOCS -->
