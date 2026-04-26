resource "vngcloud_vserver_secgroup" "this" {
  project_id = var.project_id
  name       = var.name
}

resource "vngcloud_vserver_secgrouprule" "this" {
  for_each = var.secgroup_rules

  project_id        = var.project_id
  security_group_id = vngcloud_vserver_secgroup.this.id
  description       = each.key

  direction        = coalesce(each.value.direction, var.default_direction)
  ethertype        = coalesce(each.value.ethertype, var.default_ethertype)
  protocol         = coalesce(each.value.protocol, var.default_protocol)
  port_range_min   = each.value.port_range_min
  port_range_max   = each.value.port_range_max
  remote_ip_prefix = each.value.remote_ip_prefix
}
