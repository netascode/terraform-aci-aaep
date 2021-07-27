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

  name = "AAEP1"
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
