variable "project_id" {
  description = "VNG Cloud project ID"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 50
    error_message = "Security group name must be between 3 and 50 characters."
  }
}

variable "default_direction" {
  description = "Default direction for rules that do not specify one (ingress or egress)"
  type        = string
  default     = "ingress"

  validation {
    condition     = contains(["ingress", "egress"], var.default_direction)
    error_message = "default_direction must be 'ingress' or 'egress'."
  }
}

variable "default_ethertype" {
  description = "Default ethertype for rules that do not specify one (IPv4 or IPv6)"
  type        = string
  default     = "IPv4"

  validation {
    condition     = contains(["IPv4", "IPv6"], var.default_ethertype)
    error_message = "default_ethertype must be 'IPv4' or 'IPv6'."
  }
}

variable "default_protocol" {
  description = "Default protocol for rules that do not specify one (TCP, UDP, ICMP, any)"
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP", "ICMP", "any"], var.default_protocol)
    error_message = "default_protocol must be one of: TCP, UDP, ICMP, any."
  }
}

variable "secgroup_rules" {
  description = "Map of security group rules. Key is used as the rule description. remote_ip_prefix accepts one or more CIDRs — one rule is created per CIDR."
  type = map(object({
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = list(string)
    direction        = optional(string, null)
    ethertype        = optional(string, null)
    protocol         = optional(string, null)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.secgroup_rules :
      v.port_range_min >= 0 && v.port_range_max <= 65535 && v.port_range_min <= v.port_range_max
    ])
    error_message = "port_range_min must be >= 0, port_range_max <= 65535, and min <= max."
  }
  validation {
    condition = alltrue([
      for k, v in var.secgroup_rules :
      v.direction == null ? true : contains(["ingress", "egress"], v.direction)
    ])
    error_message = "Rule direction must be 'ingress', 'egress', or null (uses default)."
  }
  validation {
    condition = alltrue([
      for k, v in var.secgroup_rules : length(v.remote_ip_prefix) > 0
    ])
    error_message = "remote_ip_prefix must contain at least one CIDR."
  }
}
