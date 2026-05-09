# terraform-vngcloud-security-group

Terraform module to create a **Security Group** with multiple rules on [VNG Cloud](https://vngcloud.vn).

## Features

- Creates one security group with any number of rules in a single module call
- Per-rule override: each rule can specify its own `direction`, `ethertype`, `protocol` — falls back to module-level defaults via `coalesce()`
- Input validation: name length, direction/ethertype/protocol enum, port range bounds
- Outputs: security group ID, name, and map of rule IDs

## Usage

### Basic — web server

```hcl
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
```

### Multiple CIDRs per rule

```hcl
module "sg_app" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id        = var.project_id
  name              = "app"
  default_direction = "ingress"

  secgroup_rules = {
    # One rule listed → one secgrouprule created
    allow-http = {
      port_range_min   = 80
      port_range_max   = 80
      remote_ip_prefix = ["0.0.0.0/0"]
    }
    # Three CIDRs listed → three secgrouprules created automatically
    allow-ssh = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = ["10.0.0.0/8", "192.168.1.0/24", "203.0.113.5/32"]
    }
  }
}
```

### Mixed protocols — override per rule

```hcl
module "sg_bastion" {
  source = "github.com/0xphuong/terraform-vngcloud-security-group?ref=v1.1.0"

  project_id       = var.project_id
  name             = "bastion"
  default_protocol = "TCP"

  secgroup_rules = {
    allow-ssh = {
      port_range_min   = 234
      port_range_max   = 234
      remote_ip_prefix = ["203.0.113.10/32", "10.0.0.0/8"]
      # inherits default_protocol = "TCP"
    }
    allow-icmp = {
      port_range_min   = 0
      port_range_max   = 0
      remote_ip_prefix = ["0.0.0.0/0"]
      protocol         = "ICMP"   # overrides default
    }
    allow-all-internal = {
      port_range_min   = 1
      port_range_max   = 65535
      remote_ip_prefix = ["10.0.0.0/16"]
      protocol         = "any"    # overrides default
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| vngcloud | >= 1.2.7 |

## Providers

| Name | Version |
|------|---------|
| vngcloud | >= 1.2.7 |

## Resources

| Name | Type |
|------|------|
| vngcloud_vserver_secgroup.this | resource |
| vngcloud_vserver_secgrouprule.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project\_id | VNG Cloud project ID | `string` | — | yes |
| name | Security group name (3–50 chars) | `string` | — | yes |
| default\_direction | Default direction for rules (`ingress` \| `egress`) | `string` | `"ingress"` | no |
| default\_ethertype | Default ethertype (`IPv4` \| `IPv6`) | `string` | `"IPv4"` | no |
| default\_protocol | Default protocol (`TCP` \| `UDP` \| `ICMP` \| `any`) | `string` | `"TCP"` | no |
| secgroup\_rules | Map of rules. Key becomes the rule description. | `map(object)` | `{}` | no |

### `secgroup_rules` map value

| Field | Type | Default | Required | Description |
|-------|------|---------|----------|-------------|
| `port_range_min` | `number` | — | **yes** | Start port (0–65535) |
| `port_range_max` | `number` | — | **yes** | End port (>= min, <= 65535) |
| `remote_ip_prefix` | `list(string)` | — | **yes** | One or more CIDRs. One rule is created per CIDR. |
| `direction` | `string` | `null` | no | Override direction for this rule (`ingress` \| `egress`) |
| `ethertype` | `string` | `null` | no | Override ethertype for this rule (`IPv4` \| `IPv6`) |
| `protocol` | `string` | `null` | no | Override protocol for this rule (`TCP` \| `UDP` \| `ICMP` \| `any`) |

> `direction`, `ethertype`, `protocol` default to `null` — module uses `default_direction`, `default_ethertype`, `default_protocol` via `coalesce()`.

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the security group |
| name | The name of the security group |
| rule\_ids | Map of rule description => rule ID |
<!-- END_TF_DOCS -->

## Examples

- [Basic](./examples/basic) — web server with HTTP/HTTPS/SSH rules
- [Complete](./examples/complete) — multi-tier: app, database, bastion security groups

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## Changelog

See [CHANGELOG.md](./CHANGELOG.md).

## License

[MIT](./LICENSE)
