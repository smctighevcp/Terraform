#Tag categories
##################################################################
resource "vsphere_tag_category" "category-environment" {
  name        = "environment"
  description = "Managed by Terraform"
  cardinality = "SINGLE"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}
resource "vsphere_tag_category" "category-billing-code" {
  name        = "billing-code"
  description = "Managed by Terraform"
  cardinality = "MULTIPLE"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}
resource "vsphere_tag_category" "category-project" {
  name        = "project"
  description = "Managed by Terraform"
  cardinality = "SINGLE"

  associable_types = [
    "VirtualMachine",
  ]
}
resource "vsphere_tag_category" "category-nsx-tier" {
  name        = "nsx-tier"
  description = "Managed by Terraform"
  cardinality = "SINGLE"

  associable_types = [
    "VirtualMachine",
  ]
}
#Common Tags
##################################################################

resource "vsphere_tag" "environment-tags" {
  for_each    = toset(var.common_environment_tags)
  name        = each.key
  category_id = vsphere_tag_category.category-environment.id
  description = "Managed by Terraform"
}

resource "vsphere_tag" "nsx-tier-tags" {
  for_each    = toset(var.common_nsx_tier_tags)
  name        = each.key
  category_id = vsphere_tag_category.category-nsx-tier.id
  description = "Managed by Terraform"
}
