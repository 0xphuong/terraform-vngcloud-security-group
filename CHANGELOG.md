# Changelog

All notable changes to this module will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-04-29

### Changed
- `remote_ip_prefix` type: `string` → `list(string)` — **breaking change**, wrap existing values in `[]`
- `main.tf`: added `locals.expanded_rules` — one rule per CIDR, key format `"<rule_name>|<cidr>"`

### Added
- Validation: `remote_ip_prefix` must contain at least one CIDR
- Support for multiple CIDRs per rule without duplicating rule blocks

### Migration from v1.0.0

```hcl
# Before
allow-ssh = {
  remote_ip_prefix = "10.0.0.0/8"
}

# After
allow-ssh = {
  remote_ip_prefix = ["10.0.0.0/8"]
}
```

## [1.0.0] - 2026-04-26

### Added
- Initial release
- `vngcloud_vserver_secgroup` resource for security group creation
- `vngcloud_vserver_secgrouprule` with `for_each` for multi-rule provisioning
- `coalesce()` pattern: per-rule overrides fall back to module-level defaults
- Input validation: name length, direction/ethertype/protocol enum, port range
- Outputs: `id`, `name`, `rule_ids`
- Examples: `basic` (web SG), `complete` (app/db/bastion tiers)
- GitHub Actions CI: fmt, validate, tflint, docs check

### Changed
- `required_providers.tf` renamed to `versions.tf`, added `required_version = ">= 1.3.0"`
- Variables `direction/ethertype/protocol` renamed to `default_*` for clarity
- `optional(string)` updated to `optional(string, null)` for explicitness
- `outputs.tf` added descriptions and new `rule_ids` output
- Formatting unified (spaces, alignment)
