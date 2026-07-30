# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-30

### Added

- Initial release of `terraform-azurerm-caf-capacity-reservation`
- `azurerm_capacity_reservation_group` resource, one per module instance, supporting `zones` and `tags`
- `azurerm_capacity_reservation` resource, `for_each` over a `reservations` map nested in the `capacity_reservation_group` object, supporting `sku` (`name`, `capacity`), `zone`, and `tags`
- Resource group name resolution supporting both plain names (looked up in `resource_groups`) and full resource IDs
- `providers.tf` pinned to `azurerm ~> 4.0`
- `.tflint.hcl` using `call_module_type = "local"`
- `.gitignore` and `.gitattributes` (LF line endings)
- GitHub Actions CI (`terraform-ci.yml`) and documentation (`documentation.yml`) workflows
- `tests/capacity_reservation.tftest.hcl` and `tests/upgrade_compat.tftest.hcl`
- ESLZ module block (`ESLZ/capacity-reservation.tf`) and example tfvars (`ESLZ/capacity-reservation.tfvars`)

### Notes

- Schema verified against the [azurerm provider `capacity_reservation`](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/capacity_reservation) and [`capacity_reservation_group`](https://registry.terraform.io/providers/hashicorp/azurerm/4.81.0/docs/resources/capacity_reservation_group) docs (v4.81.0). `providers.tf` is pinned to `~> 4.0` to track that target version.
