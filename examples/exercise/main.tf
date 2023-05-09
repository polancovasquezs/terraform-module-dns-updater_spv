# Configure the DNS Provider
provider "dns" {
  update {
    server = "127.0.0.1"
  }
}

locals {

  records = {
    for file in fileset("./input-json", "*.json") :
    trimsuffix(file, ".json")
    => jsondecode(file("./input-json/${file}"))
  }

}

module "dns_updater" {
  source = "../../."
  # ----------------------------------------
  # Write your Terraform module inputs here
  # ----------------------------------------

}

resource "dns_a_record_set" "www" {
  for_each  = local.records
  name      = each.key
  zone      = each.value.zone
  addresses = each.value.addresses
  ttl       = each.value.ttl
}
