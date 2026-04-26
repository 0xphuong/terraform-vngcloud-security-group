variable "project_id"      { type = string }
variable "internal_cidr"   { type = string; default = "10.0.0.0/16" }
variable "app_subnet_cidr" { type = string; default = "10.0.235.0/24" }
variable "bastion_ip"      { type = string }
variable "devops_ip"       { type = string }
