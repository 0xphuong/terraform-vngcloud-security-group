# App tier — only allows traffic from load balancer SG
module "sg_app" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id        = var.project_id
  name              = "app"
  default_direction = "ingress"
  default_ethertype = "IPv4"
  default_protocol  = "TCP"

  secgroup_rules = {
    allow-app-port = {
      port_range_min   = 8080
      port_range_max   = 8080
      remote_ip_prefix = [var.internal_cidr]
    }
    # Multiple CIDRs: creates one rule per CIDR automatically
    allow-ssh-bastion = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = [var.bastion_ip, var.vpn_cidr]
    }
  }
}

# Database tier — only allows traffic from app tier
module "sg_db" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id = var.project_id
  name       = "database"

  secgroup_rules = {
    allow-mysql = {
      port_range_min   = 3306
      port_range_max   = 3306
      remote_ip_prefix = [var.app_subnet_cidr]
    }
    allow-mongodb = {
      port_range_min   = 27017
      port_range_max   = 27017
      remote_ip_prefix = [var.app_subnet_cidr]
    }
    # SSH from multiple admin sources
    allow-ssh-bastion = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = [var.bastion_ip, var.vpn_cidr, var.office_cidr]
    }
  }
}

# Bastion — SSH from multiple admin IPs
module "sg_bastion" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id = var.project_id
  name       = "bastion"

  secgroup_rules = {
    allow-devops = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = [var.devops_ip, var.vpn_cidr, var.office_cidr]
    }
    allow-all-icmp = {
      port_range_min   = 0
      port_range_max   = 0
      remote_ip_prefix = ["0.0.0.0/0"]
      protocol         = "ICMP"
    }
  }
}

output "sg_app_id"     { value = module.sg_app.id }
output "sg_db_id"      { value = module.sg_db.id }
output "sg_bastion_id" { value = module.sg_bastion.id }
