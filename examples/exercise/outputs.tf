# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------

output dns_record_file {
  description = "description"
  value   = local.records
}
