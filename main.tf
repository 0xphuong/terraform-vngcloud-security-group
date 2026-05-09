locals {
  # Expand each rule into one entry per CIDR.
  # Key format: "<rule_name>|<cidr>" — stable when adding/removing CIDRs.
  expanded_rules = merge([
    for rule_name, rule in var.secgroup_rules : {
      for cidr in rule.remote_ip_prefix :
        "${rule_name}|${cidr}" => {
          description      = rule_name
          direction        = rule.direction
          ethertype        = rule.ethertype
          protocol         = rule.protocol
          port_range_min   = rule.port_range_min
          port_range_max   = rule.port_range_max
          remote_ip_prefix = cidr
        }
    }
  ]...)
}

resource "vngcloud_vserver_secgroup" "this" {
  project_id = var.project_id
  name       = var.name
}

resource "vngcloud_vserver_secgrouprule" "this" {
  for_each = local.expanded_rules

  project_id        = var.project_id
  security_group_id = vngcloud_vserver_secgroup.this.id
  description       = each.value.description

  direction        = coalesce(each.value.direction, var.default_direction)
  ethertype        = coalesce(each.value.ethertype, var.default_ethertype)
  protocol         = coalesce(each.value.protocol, var.default_protocol)
  port_range_min   = each.value.port_range_min
  port_range_max   = each.value.port_range_max
  remote_ip_prefix = each.value.remote_ip_prefix
}
