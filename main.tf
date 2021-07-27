locals {
  physical_domains   = [for dom in var.physical_domains : "uni/phys-${dom}"]
  routed_domains     = [for dom in var.routed_domains : "uni/l3dom-${dom}"]
  vmware_vmm_domains = [for dom in var.vmware_vmm_domains : "uni/vmmp-VMware/dom-${dom}"]
  domains            = concat(local.physical_domains, local.routed_domains, local.vmware_vmm_domains)
}

resource "aci_rest" "infraAttEntityP" {
  dn         = "uni/infra/attentp-${var.name}"
  class_name = "infraAttEntityP"
  content = {
    name = var.name
  }
}

resource "aci_rest" "infraRsDomP" {
  for_each   = toset(local.domains)
  dn         = "${aci_rest.infraAttEntityP.id}/rsdomP-[${each.value}]"
  class_name = "infraRsDomP"
  content = {
    tDn = each.value
  }
}

resource "aci_rest" "infraProvAcc" {
  count      = var.infra_vlan != 0 ? 1 : 0
  dn         = "${aci_rest.infraAttEntityP.id}/provacc"
  class_name = "infraProvAcc"
  content = {
    name = "provacc"
  }
}

resource "aci_rest" "infraRsFuncToEpg" {
  count      = var.infra_vlan != 0 ? 1 : 0
  dn         = "${aci_rest.infraProvAcc[0].id}/rsfuncToEpg-[uni/tn-infra/ap-access/epg-default]"
  class_name = "infraRsFuncToEpg"
  content = {
    encap        = "vlan-${var.infra_vlan}"
    instrImedcy  = "lazy"
    mode         = "regular"
    primaryEncap = "unknown"
    tDn          = "uni/tn-infra/ap-access/epg-default"
  }
}

resource "aci_rest" "dhcpInfraProvP" {
  count      = var.infra_vlan != 0 ? 1 : 0
  dn         = "${aci_rest.infraProvAcc[0].id}/infraprovp"
  class_name = "dhcpInfraProvP"
  content = {
    mode = "controller"
  }
}

