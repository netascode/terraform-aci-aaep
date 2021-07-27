output "dn" {
  value       = aci_rest.infraAttEntityP.id
  description = "Distinguished name of `infraAttEntityP` object"
}

output "name" {
  value       = aci_rest.infraAttEntityP.content.name
  description = "AAEP name"
}
