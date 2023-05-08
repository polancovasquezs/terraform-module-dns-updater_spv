# Configure the DNS Provider
provider "dns" {
  update {
    server = "127.0.0.1"
  }
}


locals {

  records = flatten(
    [for dns_record_file in fileset("./input-json", "*.json") :
      [for record_attribute in jsondecode(file("./input-json/${dns_record_file}")) :
        merge(record_attribute, {
          "name" = trimsuffix(dns_record_file, ".json")
        })
      ]
    ]
  )

#  dns_record_file = fileset("./input-json", "*.json")
#  dns_record_data = [for data in local.dns_record_file : jsondecode(file("./input-json/${data}"))]

}

module "dns_updater" {
  source = "../../."
  # ----------------------------------------
  # Write your Terraform module inputs here
  # ----------------------------------------

}

resource "dns_a_record_set" "www" {
  for_each  = local.records
  name      = each.value.name
  zone      = each.value.zone
  addresses = each.value.addresses
  ttl       = each.value.ttl
}

#resource "dns_a_record_set" "www" {
#  #for_each = { for record in flatten(local.dns_record_data) : name => record.zone }
#  #for_each  = flatten(local.dns_record_data)
#  for_each  = local.dns_record_data
#  zone      = each.value.zone
#  name      = each.value.name
#  addresses = each.value.addresses
#  ttl       = each.value.ttl
#}