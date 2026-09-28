module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "storage" {
  source  = "codectl/sa/azure"
  version = "~> 1.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    tables = {
      tb1 = {
        acl = {
          acl1 = {
            access_policy = {
              permissions = "r"
              start       = "2025-07-02T09:38:21Z"
              expiry      = "2026-07-02T10:38:21Z"
            }
          }
          acl2 = {
            access_policy = {
              permissions = "raud" #Read, Add, Update, Delete
              start       = "2025-08-01T09:38:21Z"
              expiry      = "2026-08-01T10:38:21Z"
            }
          }
        }
      }
    }
  }
}
