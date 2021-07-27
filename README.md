<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-aaep/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-aaep/actions/workflows/test.yml)

# Terraform ACI AAEP Module

Description

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Global` » `Attachable Access Entity Profiles`

## Examples

```hcl
module "aci_aaep" {
  source = "netascode/aaep/aci"

  name               = "AAEP1"
  infra_vlan         = 10
  physical_domains   = ["PD1"]
  routed_domains     = ["RD1"]
  vmware_vmm_domains = ["VMM1"]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | AAEP name | `string` | n/a | yes |
| <a name="input_infra_vlan"></a> [infra\_vlan](#input\_infra\_vlan) | Infrastructure vlan ID. A vlan ID of `0` disables the infrastructure vlan. | `number` | `0` | no |
| <a name="input_physical_domains"></a> [physical\_domains](#input\_physical\_domains) | Physical domains | `list(string)` | `[]` | no |
| <a name="input_routed_domains"></a> [routed\_domains](#input\_routed\_domains) | Routed Ddomains | `list(string)` | `[]` | no |
| <a name="input_vmware_vmm_domains"></a> [vmware\_vmm\_domains](#input\_vmware\_vmm\_domains) | VMware VMM domains | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraAttEntityP` object |
| <a name="output_name"></a> [name](#output\_name) | AAEP name |

## Resources

| Name | Type |
|------|------|
| [aci_rest.dhcpInfraProvP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraAttEntityP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraProvAcc](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraRsDomP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraRsFuncToEpg](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->