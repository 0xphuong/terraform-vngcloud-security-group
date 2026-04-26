output "id" {
  description = "The ID of the security group"
  value       = vngcloud_vserver_secgroup.this.id
}

output "name" {
  description = "The name of the security group"
  value       = vngcloud_vserver_secgroup.this.name
}

output "rule_ids" {
  description = "Map of rule description => rule ID"
  value       = { for k, v in vngcloud_vserver_secgrouprule.this : k => v.id }
}
