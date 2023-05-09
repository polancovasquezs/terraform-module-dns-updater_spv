# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------

output "dns_records" {
  description = "description"
  value       = [(values(dns_a_record_set.www).*.name), (values(dns_a_record_set.www).*.zone), (values(dns_a_record_set.www).*.addresses), (values(dns_a_record_set.www).*.ttl)]
}

#output "dns_record_created" {
#  description = "description"
#  value       = values(dns_a_record_set.www).*.name
#}
#
#output "dns_record_zones" {
#  description = "description"
#  value       = values(dns_a_record_set.www).*.zone
#}
#
#output "dns_record_addresses" {
#  description = "description"
#  value       = values(dns_a_record_set.www).*.addresses
#}
#
#output "dns_record_ttls" {
#  description = "description"
#  value       = values(dns_a_record_set.www).*.ttl
#}
