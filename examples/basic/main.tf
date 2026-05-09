module "sg_web" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id = var.project_id
  name       = "web"

  secgroup_rules = {
    allow-http = {
      port_range_min   = 80
      port_range_max   = 80
      remote_ip_prefix = ["0.0.0.0/0"]
    }
    allow-https = {
      port_range_min   = 443
      port_range_max   = 443
      remote_ip_prefix = ["0.0.0.0/0"]
    }
    allow-ssh-office = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = ["203.0.113.10/32"]
    }
  }
}

output "sg_id"   { value = module.sg_web.id }
output "sg_name" { value = module.sg_web.name }
