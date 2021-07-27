variable "name" {
  description = "AAEP name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "infra_vlan" {
  description = "Infrastructure vlan ID. A vlan ID of `0` disables the infrastructure vlan."
  type        = number
  default     = 0

  validation {
    condition = anytrue([
      var.infra_vlan >= 0,
      var.infra_vlan <= 4096
    ])
    error_message = "Minimum value: 0, Maximum value: 4096."
  }
}

variable "physical_domains" {
  description = "Physical domains"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for pd in var.physical_domains : can(regex("^[a-zA-Z0-9_.-]{0,64}$", pd))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "routed_domains" {
  description = "Routed Ddomains"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for rd in var.routed_domains : can(regex("^[a-zA-Z0-9_.-]{0,64}$", rd))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vmware_vmm_domains" {
  description = "VMware VMM domains"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for vmwd in var.vmware_vmm_domains : can(regex("^[a-zA-Z0-9_.-]{0,64}$", vmwd))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
