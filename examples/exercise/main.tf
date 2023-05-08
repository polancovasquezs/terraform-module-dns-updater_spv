# Configure the DNS Provider
provider "dns" {
  update {
    server = "127.0.0.1"
  }
}

#locals {
#
#  dns_record_file = fileset("./input-json", "*.json")
#  dns_record_data  = [for data in local.dns_records_files : jsondecode(file("./input-json/${data}"))]
#}

locals {
  records = flatten(
    [for dns_record_file in fileset("./input-json", "*.json") :
      [for attribute in jsondecode(file("./input-json/${dns_record_file}")) :
        merge(attribute, {
          name = trimsuffix(dns_record_file, ".json")
        })
      ]
    ]
  )
}

variable "name" {
  type = map(string)
  default = {
  }

}

variable "records" {
  type = map(string)
  default = {
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
  name      = each.value.name
  zone      = each.value.zone
  addresses = each.value.addresses
  ttl       = each.value.ttl
}
