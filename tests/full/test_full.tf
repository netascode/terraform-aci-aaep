terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name               = "AAEP1"
  infra_vlan         = 4
  physical_domains   = ["PD1"]
  routed_domains     = ["RD1"]
  vmware_vmm_domains = ["VMM1"]
  endpoint_groups = [
    {
      tenant              = "TF"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      vlan                = "10"
      primary_vlan        = "10"
      mode                = "untagged"
    }
  ]
}

locals {
  domains = ["uni/phys-PD1", "uni/l3dom-RD1", "uni/vmmp-VMware/dom-VMM1"]
}

data "aci_rest" "infraAttEntityP" {
  dn = "uni/infra/attentp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAttEntityP" {
  component = "infraAttEntityP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraAttEntityP.content.name
    want        = module.main.name
  }
}

data "aci_rest" "infraRsDomP" {
  for_each = toset(local.domains)
  dn       = "${data.aci_rest.infraAttEntityP.id}/rsdomP-[${each.value}]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsDomP" {
  for_each  = toset(local.domains)
  component = "infraRsDomP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.infraRsDomP[each.value].content.tDn
    want        = each.value
  }
}

data "aci_rest" "infraProvAcc" {
  dn = "${data.aci_rest.infraAttEntityP.id}/provacc"

  depends_on = [module.main]
}

resource "test_assertions" "infraProvAcc" {
  component = "infraProvAcc"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraProvAcc.content.name
    want        = "provacc"
  }
}

data "aci_rest" "infraRsFuncToEpg" {
  dn = "${data.aci_rest.infraProvAcc.id}/rsfuncToEpg-[uni/tn-infra/ap-access/epg-default]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsFuncToEpg" {
  component = "infraRsFuncToEpg"

  equal "encap" {
    description = "encap"
    got         = data.aci_rest.infraRsFuncToEpg.content.encap
    want        = "vlan-4"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest.infraRsFuncToEpg.content.instrImedcy
    want        = "lazy"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest.infraRsFuncToEpg.content.mode
    want        = "regular"
  }

  equal "primaryEncap" {
    description = "primaryEncap"
    got         = data.aci_rest.infraRsFuncToEpg.content.primaryEncap
    want        = "unknown"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.infraRsFuncToEpg.content.tDn
    want        = "uni/tn-infra/ap-access/epg-default"
  }
}

data "aci_rest" "dhcpInfraProvP" {
  dn = "${data.aci_rest.infraProvAcc.id}/infraprovp"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpInfraProvP" {
  component = "dhcpInfraProvP"

  equal "mode" {
    description = "mode"
    got         = data.aci_rest.dhcpInfraProvP.content.mode
    want        = "controller"
  }
}

data "aci_rest" "infraGeneric" {
  dn = "${data.aci_rest.infraAttEntityP.id}/gen-default"

  depends_on = [module.main]
}

resource "test_assertions" "infraGeneric" {
  component = "infraGeneric"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraGeneric.content.name
    want        = "default"
  }
}

data "aci_rest" "infraGeneric-infraRsFuncToEpg" {
  dn = "${data.aci_rest.infraGeneric.id}/rsfuncToEpg-[uni/tn-TF/ap-AP1/epg-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "infraGeneric-infraRsFuncToEpg" {
  component = "infraGeneric-infraRsFuncToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.infraGeneric-infraRsFuncToEpg.content.tDn
    want        = "uni/tn-TF/ap-AP1/epg-EPG1"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest.infraGeneric-infraRsFuncToEpg.content.encap
    want        = "vlan-10"
  }

  equal "primaryEncap" {
    description = "primaryEncap"
    got         = data.aci_rest.infraGeneric-infraRsFuncToEpg.content.primaryEncap
    want        = "vlan-10"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest.infraGeneric-infraRsFuncToEpg.content.mode
    want        = "untagged"
  }
}
