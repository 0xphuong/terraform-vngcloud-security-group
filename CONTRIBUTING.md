# Contributing

## Development Setup

```bash
brew install terraform tflint terraform-docs
git clone git@github-0xphuong:0xphuong/terraform-vngcloud-security-group.git
cd terraform-vngcloud-security-group
```

## Making Changes

1. Create a branch: `git checkout -b feature/your-feature`
2. Make changes and run checks:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
tflint --recursive
```

3. Update `CHANGELOG.md` under `[Unreleased]`
4. Open a Pull Request against `main`

## Security Note

Do not commit real IP addresses or internal CIDRs in examples.
Use placeholder ranges like `203.0.113.0/24` (TEST-NET-3, RFC 5737).

## Release Process

1. Update `CHANGELOG.md` — move `[Unreleased]` to new version section
2. Merge PR to `main`
3. Tag: `git tag v1.1.0 && git push origin v1.1.0`
