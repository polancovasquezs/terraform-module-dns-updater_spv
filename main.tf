/**
* # Terraform
*
* <Short TF module description>
*
*
* ## Usage
*
* ### Quick Example
*
* ```hcl
* module "dns_" {
*   source = ""
*   input1 = <>
*   input2 = <>
* } 
* ```
*
*/
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}

# Configure the DNS Provider
provider "dns" {
  update {
    server = "127.0.0.1"
  }
}

# ------------------------------------------
# Write your local resources here
# ------------------------------------------

locals {

  records = {
    for file in fileset("./input-json", "*.json") :
    trimsuffix(file, ".json")
    => jsondecode(file("./input-json/${file}"))
  }

}

# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "www" {
  for_each  = local.records
  name      = each.key
  zone      = each.value.zone
  addresses = each.value.addresses
  ttl       = each.value.ttl
}
